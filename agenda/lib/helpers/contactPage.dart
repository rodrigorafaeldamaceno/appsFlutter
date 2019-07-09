import 'dart:io';

import 'package:agenda/helpers/contacts.dart';
import 'package:flutter/material.dart';
import "package:image_picker/image_picker.dart";

class ContactPage extends StatefulWidget {
  final Contact contact;
  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Contact _editedContact;
  bool _userEdit = false;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  final _focusName = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //transformando o contato em um mapa e criando um novo contato com esse map

    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());

      _nameController.text = _editedContact.name;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_editedContact.name ?? 'Novo contato'),
          centerTitle: true,
          backgroundColor: Colors.purple,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editedContact.name.isNotEmpty && _editedContact.name != null) {
              //voltando pra homepage
              Navigator.pop(context, _editedContact);
            } else {
              FocusScope.of(context).requestFocus(_focusName);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.purple,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: _editedContact.img != null
                            ? FileImage(File(_editedContact.img))
                            : AssetImage('images/person.png'),
                        fit: BoxFit.cover),
                  ),
                ),
                onTap: () {
                  ImagePicker.pickImage(source: ImageSource.gallery)
                      .then((file) {
                    if (file == null) {
                      return;
                    } else {
                      _userEdit = true;
                      setState(() {
                        _editedContact.img = file.path;
                      });
                    }
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Nome'),
                onChanged: (text) {
                  _userEdit = true;
                  setState(() {
                    _editedContact.name = text;
                  });
                },
                controller: _nameController,
                focusNode: _focusName,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Email'),
                onChanged: (text) {
                  _userEdit = true;
                  _editedContact.email = text;
                },
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Phone'),
                onChanged: (text) {
                  _userEdit = true;
                  _editedContact.phone = text;
                },
                keyboardType: TextInputType.number,
                controller: _phoneController,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop() {
    if (_userEdit) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar alterações?"),
              content: Text("Se sair as alterações serão eprdidas"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Sim"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
