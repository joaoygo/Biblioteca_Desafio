import 'package:flutter/material.dart';

class AppBarCustom extends PreferredSize {
  AppBarCustom()
      : super(
          preferredSize: const Size.fromHeight(kToolbarHeight + 18.0),
          child: AppBar(
            elevation: 0,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.blueGrey[900] ?? Colors.blueGrey,
                    Colors.blueGrey[800] ?? Colors.blueGrey,
                    Colors.blueGrey[700] ?? Colors.blueGrey,
                  ],
                ),
              ),
            ),
            title: const Text(
              'Minha Biblioteca',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        );
}
