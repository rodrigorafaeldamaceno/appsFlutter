import 'dart:convert';
import 'package:buscador_gif/ui/GifPage.dart';
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

  Future<Map> _getGifs() async {
    http.Response response;

    if (_search == null || _search.isEmpty) {
      _gifSearch =
          'https://api.giphy.com/v1/gifs/trending?api_key=R90RJFr48097DIwu8AmbB2aCVi0CaSxW&limit=19&rating=G';
      _stickerSeacrh =
          'https://api.giphy.com/v1/stickers/trending?api_key=R90RJFr48097DIwu8AmbB2aCVi0CaSxW&limit=25&rating=G';

      response = await http.get(_gifSearch);
    } else {
      _gifSearch =
          'https://api.giphy.com/v1/gifs/search?api_key=R90RJFr48097DIwu8AmbB2aCVi0CaSxW&q=$_search&limit=19&offset=$_offSet&rating=G&lang=pt';
      _stickerSeacrh =
          'https://api.giphy.com/v1/stickers/search?api_key=R90RJFr48097DIwu8AmbB2aCVi0CaSxW&q=$_search&limit=19&offset=$_offSet&rating=G&lang=en';

      response = await http.get(_gifSearch);
    }
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    _getGifs().then((map) {
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            'https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif'),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          //dar espaço pra appBar
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                  labelText: 'Pesquise Aqui',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder()),
              style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.center,
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                  _offSet = 0;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        //animação totalmente parada do tipo cor
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5.0,
                      ),
                    );
                    break;
                  default:
                    if (snapshot.hasError)
                      return Container();
                    else
                      return _createGifTable(context, snapshot);
                }
              },
            ),
          )
        ],
      ),
    );
  }

  //retorna o numero de resultados
  int _getCount(List data) => _search == null ? data.length : data.length + 1;

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
      itemCount: _getCount(snapshot.data['data']),
      itemBuilder: (context, index) {
        if (_search == null || index < snapshot.data['data'].length) {
          return GestureDetector(
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: snapshot.data['data'][index]['images']['fixed_height']
                  ['url'],
              height: 300,
              fit: BoxFit.cover,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          GifPage(snapshot.data["data"][index])));
            },
            onLongPress: () {
              Share.share(snapshot.data['data'][index]['images']['fixed_height']
                  ['url']);
            },
          );
        } else {
          return Container(
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 100,
                  ),
                  Text(
                    'Carregar mais...',
                    style: TextStyle(color: Colors.white, fontSize: 22.0),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  _offSet += 19;
                });
              },
            ),
          );
        }
      },
    );
  }
}
