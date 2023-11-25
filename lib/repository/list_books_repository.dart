import 'dart:convert';

import 'package:biblioteca_desafio/models/book_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<List<BookModel>> getBooks() async {
  final response = await http.get(Uri.parse('https://escribo.com/books.json'));

  final json = jsonDecode(response.body);

  return List<BookModel>.from(
    json.map(
      (elemento) {
        return BookModel.fromJson(elemento);
      },
    ),
  );
}

Future<SharedPreferences> getPrefs() async {
  return await SharedPreferences.getInstance();
}
