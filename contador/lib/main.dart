import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Contador de pessoas',
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _countPeople = 0;

  void _changePeople(int delta) {
    setState(() {
      _countPeople += delta;
    });
  }

  String _situcao() => _countPeople < 0 ? 'Valor negativo' : 'Pode entrar!';

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset("images/fundo.jpg", fit: BoxFit.cover, height: 1000.0),
        Column(
          mainAxisAlignment:
              MainAxisAlignment.center, //alinhamento do eixo principal central
          children: <Widget>[
            Text('Pessoas: $_countPeople',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: FlatButton(
                    child: Text('+1',
                        style: TextStyle(fontSize: 40.0, color: Colors.white)),
                    onPressed: () {
                      _changePeople(1);
                      debugPrint('+1');
                    }),
              ),
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: FlatButton(
                      child: Text('-1',
                          style:
                              TextStyle(fontSize: 40.0, color: Colors.white)),
                      onPressed: () {
                        _changePeople(-1);
                        debugPrint('-1');
                      }))
            ]),
            Text(_situcao(),
                style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontSize: 30.0))
          ],
        )
      ],
    );
  }
}
