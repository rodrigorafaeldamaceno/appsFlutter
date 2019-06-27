import 'dart:convert';
import 'package:buscador_gif/ui/GifPage.dart';
import 'package:buscador_gif/ui/Gif.dart';
import 'package:buscador_gif/ui/Sticker.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;
  int _offSet = 0;
  String _gifSearch;
  String _stickerSeacrh;
  String _tipo;
  TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: "Gifs",
              ),
              Tab(
                text: "Figuras",
              ),
            ],
          ),
          backgroundColor: Colors.black,
          title: Image.network(
              'https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif'),
          centerTitle: true,
        ),
        backgroundColor: Colors.black,
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            Gif(),
            Sticker(),
          ],
        ),
      ),
    );
  }
}
