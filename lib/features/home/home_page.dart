import 'package:biblioteca_desafio/features/home/components/list_books_widget.dart';
import 'package:biblioteca_desafio/models/book_model.dart';
import 'package:biblioteca_desafio/repository/list_books_repository.dart';
import 'package:biblioteca_desafio/shared/app_bar_custom_widget/app_bar_custom.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Future<List<BookModel>>? listBooks;
  bool isFavList = false;
  late SharedPreferences _prefs;
  List<String>? booksFav;
  bool isFav = false;
  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() async {
    _prefs = await SharedPreferences.getInstance();
    booksFav = _prefs.getStringList('booksFav');

    listBooks = getBooks();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarCustom(),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.blueGrey[700] ?? Colors.blueGrey,
                      Colors.blueGrey[800] ?? Colors.blueGrey,
                      Colors.blueGrey[900] ?? Colors.blueGrey,
                    ],
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isFavList = false;
                        });
                      },
                      icon: Icon(
                        Icons.home,
                        color: isFavList ? Colors.white : Colors.red,
                        size: 30,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.bookmark_rounded,
                        color: !isFavList ? Colors.white : Colors.red,
                        size: 30,
                      ),
                      onPressed: () {
                        setState(() {
                          isFavList = true;
                          booksFav = _prefs.getStringList('booksFav');
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: !isFavList
                  ? FutureBuilder(
                      future: listBooks,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final books = snapshot.data;
                          return ListBooksWidget(books: books ?? []);
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              snapshot.error.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    )
                  : FutureBuilder(
                      future: listBooks,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final List<BookModel>? books = snapshot.data
                              ?.where(
                                  (element) => booksFav!.contains(element.id))
                              .toList();

                          return ListBooksWidget(books: books ?? []);
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              snapshot.error.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
            ),
          ],
        )));
  }
}
