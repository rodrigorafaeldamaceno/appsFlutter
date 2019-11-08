import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  dynamic _infotext = 'Informe os dados';
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _calcIMC() {
    double peso = double.parse(weightController.text);
    double altura = double.parse(heightController.text) / 100;
    double imc = peso / (altura * altura);
    setState(() {
      if (imc < 18.6) {
        _infotext = 'Abaixo do Peso: ${imc.toStringAsPrecision(3)}';
      } else if (imc < 24.9) {
        _infotext = 'Peso ideal: ${imc.toStringAsPrecision(3)}';
      } else if (imc < 29.9) {
        _infotext = 'Levemente acima do peso: ${imc.toStringAsPrecision(3)}';
      } else if (imc < 34.9) {
        _infotext = 'Obesidade Grau I: ${imc.toStringAsPrecision(3)}';
      } else if (imc < 39.9) {
        _infotext = 'Obesidade Grau II ${imc.toStringAsPrecision(3)}';
      } else {
        _infotext = 'Obesidade Grau III ${imc.toStringAsPrecision(3)}';
      }
    });
  }

  void _resetField() {
    heightController.text = '';
    weightController.text = '';
    setState(() {
      _infotext = 'Informe os dados';
      _formKey = GlobalKey<FormState>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Calculadora de IMC'),
          centerTitle: true,
          backgroundColor: Colors.green,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                _resetField();
              },
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            //pra poder rolar
            padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.stretch, //alonga o item para o maximo
                children: <Widget>[
                  Icon(
                    Icons.person_outline,
                    size: 120.0,
                    color: Colors.green,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: 'Peso (kg)',
                        labelStyle: TextStyle(color: Colors.green)),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.green, fontSize: 25.0),
                    controller: weightController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Insira o peso';
                      }
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: 'Altura (cm)',
                        labelStyle: TextStyle(color: Colors.green)),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.green, fontSize: 25.0),
                    controller: heightController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Insira a altura';
                      }
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Container(
                      height: 50.0,
                      child: RaisedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _calcIMC();
                          }
                        },
                        child: Text(
                          'Calcular',
                          style: TextStyle(color: Colors.white, fontSize: 25.0),
                        ),
                        color: Colors.green,
                      ),
                    ),
                  ),
                  Text('$_infotext',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.green, fontSize: 25.0))
                ],
              ),
            )));
  }
}
