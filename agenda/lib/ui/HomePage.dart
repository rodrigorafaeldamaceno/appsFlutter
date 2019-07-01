import 'package:agenda/helpers/contacts.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();
  /*
  @override
  void initState() {
    super.initState();
    /*
    Contact c = Contact();
    c.name = 'Thiago';
    c.email = 'thiago@frimesa.com.br';
    c.phone = '45997897492';
    c.img = 'imgteste';

    helper.saveContact(c);
    */
    //helper.deleteContact(1);
    helper.getAllContacts().then((list) {
      print(list);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
  */
}
