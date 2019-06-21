import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final btcController = TextEditingController();

  //constroi os TextField
  Widget _buildTextField(String label, String prefix,
      TextEditingController controller, Function func) {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.amber),
          border: OutlineInputBorder(),
          prefixText: prefix),
      style: TextStyle(color: Colors.amber, fontSize: 25.0),
      controller: controller,
      onChanged: func,
    );
  }

  void _realChange(String text) {
    double real = text != '' ? double.parse(text) : 0;
    dolarController.text = (real / this.dolar).toStringAsFixed(2);
    btcController.text = (real / this.btc).toStringAsFixed(8);
  }

  void _dolarChange(String text) {
    double dolar = text != '' ? double.parse(text) : 0;

    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    btcController.text = (dolar * this.dolar / btc).toStringAsFixed(8);
  }

  void _btcChange(String text) {
    double btc = text != '' ? double.parse(text) : 0;

    realController.text = (btc * this.btc).toStringAsFixed(2);
    dolarController.text = (btc * this.btc / this.dolar).toStringAsFixed(2);
  }

  void _refresh() {
    realController.text = '';
    btcController.text = '';
    dolarController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(
            'Conversor Bitcoin',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.amber,
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                _refresh();
              },
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
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(FontAwesomeIcons.bitcoin,
                            size: 150, color: Colors.amber),
                        Divider(),
                        _buildTextField(
                            'Real', 'R\$ ', realController, _realChange),
                        Divider(), //cria um espaçamento entre os textFields
                        _buildTextField(
                            'Dólar', 'US\$ ', dolarController, _dolarChange),
                        Divider(),
                        _buildTextField(
                            'Bitcoin', 'BTC ', btcController, _btcChange)
                      ],
                    ),
                  );
                }
            }
          },
        ));
  }
}
