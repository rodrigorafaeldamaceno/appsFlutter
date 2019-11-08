import 'dart:io';

import 'package:agenda/helpers/contactPage.dart';
import 'package:agenda/helpers/contacts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:url_launcher/url_launcher.dart";

enum OrderOptions { orderaz, orderza }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();

  List<Contact> contacts = List();

  @override
  void initState() {
    super.initState();
    //helper.deleteContact(1);
    _getAllcontacts();
    //helper.deleteContact(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        backgroundColor: Colors.purple,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar de A-Z"),
                value: OrderOptions.orderaz,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar de Z-A"),
                value: OrderOptions.orderza,
              ),
            ],
            onSelected: _orderList,
          )
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactsPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.purple,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return _contactCard(context, index);
        },
      ),
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: contacts[index].img != null
                        ? FileImage(File(contacts[index].img))
                        : AssetImage('images/person.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      contacts[index].name ?? "",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      contacts[index].email ?? "",
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      contacts[index].phone ?? "",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        _showOptions(context, index);
        //_showContactsPage(contact: contacts[index]);
      },
    );
  }

  void _showOptions(BuildContext context, int index) {
    showBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  //ira ocupar o menor espaço possivel
                  mainAxisSize: MainAxisSize.min,

                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: FlatButton(
                        child: Text(
                          "Ligar",
                          style: TextStyle(color: Colors.purple, fontSize: 20),
                        ),
                        onPressed: () {
                          if (contacts[index].phone != null ||
                              contacts[index].phone.isNotEmpty) {
                            launch("tel:${contacts[index].phone}");
                          }
                          /*else {
                            showDialog(
                                context: context,
                                
                                builder: (context) {
                                  AlertDialog(
                                    title: Text("Contato não possui numero"),
                                    content: Text("ok"),
                                    actions: <Widget>[
                                      FlatButton(
                                          child: Text("Ok"),
                                          onPressed: () {
                                            return Navigator.pop(context);
                                          })
                                    ],
                                  );
                                });
                          }*/

                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: FlatButton(
                        child: Text(
                          "Editar",
                          style: TextStyle(color: Colors.purple, fontSize: 20),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _showContactsPage(contact: contacts[index]);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: FlatButton(
                        child: Text(
                          "Excluir",
                          style: TextStyle(color: Colors.purple, fontSize: 20),
                        ),
                        onPressed: () {
                          helper.deleteContact(contacts[index].id);
                          setState(() {
                            contacts.removeAt(index);
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  Future _showContactsPage({Contact contact}) async {
    final retContact = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ContactPage(
                  contact: contact,
                )));
    if (retContact != null) {
      if (contact != null) {
        await helper.updateContact(retContact);
      } else {
        await helper.saveContact(retContact);
      }
      await _getAllcontacts();
    }
  }

  void _getAllcontacts() {
    helper.getAllContacts().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        contacts.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        contacts.sort((a, b) {
          return b.name.toLowerCase().compareTo((a.name.toLowerCase()));
        });
        break;
    }

    setState(() {});
  }
}
