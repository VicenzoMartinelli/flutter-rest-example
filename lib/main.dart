import 'package:flutter/material.dart';
import 'package:pets/services/pet_service.dart';
import 'package:toast/toast.dart';
import 'models/pet.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetsTop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Arial',
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  final pets = new List<Pet>();

  HomePage() {
    pets.clear();
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var service = new PetService();

  var nomeCtrl = new TextEditingController();
  var racaCtrl = new TextEditingController();
  var descricaoCtrl = new TextEditingController();

  void closeModal() {
    nomeCtrl.clear();
    racaCtrl.clear();
    descricaoCtrl.clear();
    Navigator.of(context).pop();
  }

  Future addNew() async {
    var pet = new Pet(
        nome: nomeCtrl.text,
        raca: racaCtrl.text,
        descricao: descricaoCtrl.text);

    try {
      var petSaved = await service.add(pet);

      setState(() {
        widget.pets.add(petSaved);
        closeModal();
      });

      Toast.show("Pet cadastrado com sucesso", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } catch (e) {
      Toast.show("Erro ao cadastrar", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  Future edit(String id, int index) async {
    var pet = new Pet.withId(
        id: id,
        nome: nomeCtrl.text,
        raca: racaCtrl.text,
        descricao: descricaoCtrl.text);

    try {
      var petSaved = await service.add(pet);

      setState(() {
        print(petSaved);
        widget.pets[index] = petSaved;
        closeModal();
      });
      Toast.show("Pet alterado com sucesso", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } catch (e) {
      Toast.show("Erro", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  Future remove(id, index) async {
    if (await service.delete(id)) {
      setState(() {
        widget.pets.removeAt(index);
      });
      Toast.show("Pet excluído com sucesso", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  Future loadData() async {
    try {
      var prefs = await service.getAll();

      if (prefs != null) {
        setState(() {
          widget.pets.clear();
          widget.pets.addAll(prefs);
        });
      }
    } catch (e) {
      Toast.show("Erro ao carregar", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  void openEdit(Pet editPet, {int index = 0}) {
    if (editPet != null) {
      nomeCtrl.text = editPet.nome;
      descricaoCtrl.text = editPet.descricao;
      racaCtrl.text = editPet.raca;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: new AlertDialog(
            title: new Text("Cadastro de pet"),
            content: new Form(
              child: new Column(
                children: [
                  new TextFormField(
                      decoration: new InputDecoration(labelText: 'Nome do Pet'),
                      controller: nomeCtrl),
                  new TextFormField(
                      decoration: new InputDecoration(labelText: 'Raça'),
                      controller: racaCtrl),
                  new TextFormField(
                    decoration: new InputDecoration(labelText: 'Descrição'),
                    controller: descricaoCtrl,
                    keyboardType: TextInputType.multiline,
                  ),
                  new RaisedButton(
                    onPressed: () {
                      if (editPet == null) {
                        addNew();
                      } else {
                        edit(editPet.id, index);
                      }
                    },
                    color: Colors.yellow,
                    child: new Text('Cadastrar'),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Fechar"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  _HomePageState() {
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro de pets"),
      ),
      body: ListView.builder(
        itemCount: widget.pets.length,
        itemBuilder: (BuildContext ctxt, int index) {
          var pet = widget.pets[index];

          return Dismissible(
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.pets),
                      title: Text(pet.nome + " - " + pet.raca),
                      subtitle: Container(
                        child: Text(pet.descricao),
                        margin: const EdgeInsets.only(top: 20.0),
                      )),
                  ButtonTheme.bar(
                    child: ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: Text('Editar'),
                          onPressed: () {
                            openEdit(pet, index: index);
                          },
                        ),
                        FlatButton(
                          child: Text('Excluir'),
                          onPressed: () {
                            remove(pet.id, index);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            key: Key(pet.id),
            onDismissed: (direction) {
              remove(pet.id, index);
            },
            background: Container(
              color: Theme.of(context).primaryColorLight,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openEdit(null);
        },
        child: Icon(Icons.pets),
        backgroundColor: Colors.green,
      ),
    );
  }
}
