import 'dart:io';

import 'package:biblioteca_desafio/features/home/components/card_books_widget.dart';
import 'package:biblioteca_desafio/models/book_model.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';

class ListBooksWidget extends StatefulWidget {
  const ListBooksWidget({
    Key? key,
    required this.books,
  }) : super(key: key);

  final List<BookModel> books;

  @override
  State<ListBooksWidget> createState() => _ListBooksState();
}

class _ListBooksState extends State<ListBooksWidget> {
  bool loading = false;
  Dio dio = Dio();
  String filePath = "";
  List<String> listEpub = [];
  List<String> listEpubFav = [];
  Directory? appDocDir;
  late SharedPreferences _prefs;

  @override
  void initState() {
    getAppDocDir();
    _init();
    super.initState();
  }

  _init() async {
    _prefs = await SharedPreferences.getInstance();
    var bookFavLocal = _prefs.getStringList('booksFav');
    _prefs.getStringList('booksFav') == null
        ? await _prefs.setStringList('booksFav', <String>[])
        : bookFavLocal?.forEach((element) {
            listEpubFav.add(element);
          });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!loading) {
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 10,
          childAspectRatio: 3 / 4,
        ),
        itemCount: widget.books.length,
        itemBuilder: ((context, index) {
          final book = widget.books[index];

          return GestureDetector(
              onTap: () async {
                if (!loading) {
                  verifyEpub(book.linkDownload, book.id);
                }
              },
              child: CardBooksWidget(
                nome: book.titulo,
                autor: book.autor,
                imagem: book.imagem,
                onTapFav: () => _onTapFav(book),
                isFavorited: _isFav(book.id),
              ));
        }),
      );
    } else {
      return const Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text("Baixando"),
          ),
          CircularProgressIndicator(),
        ],
      ));
    }
  }

  void _onTapFav(BookModel book) async {
    {
      if (listEpubFav.contains(book.id)) {
        setState(() {
          listEpubFav.remove(book.id);
        });
        await _prefs.setStringList('booksFav', listEpubFav);
      } else {
        setState(() {
          listEpubFav.add(book.id);
        });
        await _prefs.setStringList('booksFav', listEpubFav);
      }
    }
  }

  Future<void> download(String linkDowload, String idBook) async {
    if (Platform.isAndroid || Platform.isIOS) {
      String? firstPart;
      final deviceInfoPlugin = DeviceInfoPlugin();
      final deviceInfo = await deviceInfoPlugin.deviceInfo;
      final allInfo = deviceInfo.data;
      if (allInfo['version']["release"].toString().contains(".")) {
        int indexOfFirstDot = allInfo['version']["release"].indexOf(".");
        firstPart = allInfo['version']["release"].substring(0, indexOfFirstDot);
      } else {
        firstPart = allInfo['version']["release"];
      }
      int intValue = int.parse(firstPart!);
      if (intValue >= 13) {
        await startDownload(linkDowload, idBook);
      } else {
        if (await Permission.storage.isGranted) {
          await Permission.storage.request();
          await startDownload(linkDowload, idBook);
        } else {
          await startDownload(linkDowload, idBook);
        }
      }
    } else {
      loading = false;
    }
  }

  Future<void> startDownload(String linkDowload, String idBook) async {
    String path = '${appDocDir!.path}/$idBook.epub';
    File file = File(path);

    if (!File(path).existsSync()) {
      await file.create();
      await dio.download(
        linkDowload,
        path,
        deleteOnError: true,
        onReceiveProgress: (receivedBytes, totalBytes) {
          setState(() {
            loading = true;
          });
        },
      ).whenComplete(() {
        setState(() {
          loading = false;
          filePath = path;
        });
      });
    } else {
      setState(() {
        loading = false;
        filePath = path;
      });
    }
  }

  void verifyEpub(String filePath, String idBook) {
    if (listEpub.isNotEmpty && (idBook.isEmpty || listEpub.contains(idBook))) {
      loading = true;
      openEpub(idBook);
      loading = false;
    } else {
      loading = true;
      download(filePath, idBook);
      listEpub.add(idBook);
      loading = false;
    }
  }

  void openEpub(String idBook) {
    VocsyEpub.setConfig(
      themeColor: Theme.of(context).primaryColor,
      identifier: "iosBook",
      scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
      allowSharing: true,
      enableTts: true,
      nightMode: true,
    );

    VocsyEpub.open(
      '${appDocDir!.path}/$idBook.epub',
      lastLocation: EpubLocator.fromJson({
        "bookId": "2239",
        "href": "/OEBPS/ch06.xhtml",
        "created": 1539934158390,
        "locations": {"cfi": "epubcfi(/0!/4/4[simple_book]/2/2/6)"}
      }),
    );
  }

  Future<void> getAppDocDir() async {
    appDocDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
  }

  bool _isFav(String bookId) {
    if (listEpubFav.contains(bookId)) {
      return true;
    }
    return false;
  }
}
