import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const requestURL =
    'https://api.hgbrasil.com/finance/quotations?format=json&key=eec2a699';

//faz uma requisição futura na API e retorna um JSON com os dados
Future<Map> getData() async {
  http.Response response = await http.get(requestURL);
  return json.decode(response.body);
}

void main() async {
  runApp(MaterialApp(
    title: 'Conversor',
    home: Home(),
    theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.white),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double dolar;
  double euro;
  double btc;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Conversor',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.amber,
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {},
            )
          ],
        ),
        body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text(
                    'Carregando dados',
                    style: TextStyle(color: Colors.black, fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                );
              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Falha catastrofica ao carregar os dados',
                      style: TextStyle(color: Colors.amber, fontSize: 25),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  //print(snapshot.data);
                  dolar = snapshot.data['results']['currencies']['USD']['buy'];
                  euro = snapshot.data['results']['currencies']['EUR']['buy'];
                  btc = snapshot.data['results']['currencies']['BTC']['buy'];

                  print('Dolar: $dolar \nEuro: $euro \nBitcoin: $btc');
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.monetization_on,
                            size: 150, color: Colors.amber),
                        TextField(
                          decoration: InputDecoration(
                              labelText: 'Reais',
                              labelStyle: TextStyle(color: Colors.amber),
                              border: OutlineInputBorder(),
                              prefixText: 'R\$ '),
                          style: TextStyle(color: Colors.amber, fontSize: 25.0),
                        ),
                        TextField(
                            decoration: InputDecoration(
                                labelText: 'Dólar',
                                labelStyle: TextStyle(color: Colors.amber),
                                border: OutlineInputBorder(),
                                prefixText: '\$ '),
                            style:
                                TextStyle(color: Colors.amber, fontSize: 25.0)),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'BTC',
                            labelStyle: TextStyle(color: Colors.amber),
                            border: OutlineInputBorder(),
                            //prefixIcon: Icon( Icons.attach_money),
                          ),
                          style: TextStyle(color: Colors.amber, fontSize: 25.0),
                        )
                      ],
                    
                    ),


                  );
                }
            }
          },
        ));
  }
}
