import 'dart:convert';

import 'package:pets/models/pet.dart';
import 'package:http/http.dart' as http;

class PetService {
  Future<List<Pet>> getAll() async {
    final response = await http.get('http://192.168.0.103:45455/pets');

    if (response.statusCode == 200) {
      print(response.body);

      Iterable decoded = jsonDecode(response.body);

      List<Pet> result = decoded.map((x) => Pet.fromJson(x)).toList();

      return result;
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<Pet> add(Pet pet) async {
    final response = await http.post('http://192.168.0.103:45455/pets',
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(pet.toJson()));

    print(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      Pet result = Pet.fromJson(jsonDecode(response.body));

      return result;

    } else {
      throw Exception('Erro');
    }
  }
  
  Future<Pet> update(Pet pet) async {
    var id = pet.id;
    final response = await http.put('http://192.168.0.103:45455/pets/$id',
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(pet.toJson()));

    if (response.statusCode == 200 || response.statusCode == 204) {
      Pet result = Pet.fromJson(jsonDecode(response.body));

      return result;

    } else {
      throw Exception('Erro');
    }
  }
  
  Future<bool> delete(String petId) async {
    final response = await http.delete('http://192.168.0.103:45455/pets/$petId');

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
