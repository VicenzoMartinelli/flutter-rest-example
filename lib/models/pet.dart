class Pet {
  String id;
  String descricao;
  String nome;
  String raca;
  String dataEntrada;

  Pet({this.nome, this.descricao, this.raca});
  Pet.withId({this.id, this.nome, this.descricao, this.raca});

  Pet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    descricao = json['descricao'];
    raca = json['raca'];
    dataEntrada = json['dataEntrada'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['descricao'] = this.descricao;
    data['raca'] = this.raca;

    return data;
  }
}
