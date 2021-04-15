import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Market List',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Market List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

Future<List<Contact>> getContacts() async {
  List<Contact> someContacts = <Contact>[];
  var contacts = await ContactsService.getContacts(withThumbnails: false);

  var i = 0;
  for (var contact in contacts) {
    var aContact = new Contact();
    aContact.displayName = contact.displayName;
    for (var phone in contact.phones) {
      var phoneFormatted;
      if (phone.value.contains("+54"))
        phoneFormatted = phone.value;
      else
        phoneFormatted = '+549' + phone.value;
      aContact.phone = phoneFormatted;
    }
    someContacts.insert(i, aContact);
    i++;
  }

  return someContacts;
}

void launchURL(phone, text) async {
  var url = 'https://api.whatsapp.com/send?phone=${phone}&text=${text}';
  await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Product> someProducts = <Product>[];

  TextEditingController nameController = TextEditingController();

  TextEditingController listController = TextEditingController();

  void addItemToList() {
    setState(() {
      var aProduct = new Product();
      aProduct.name = nameController.text;
      aProduct.isSelected = false;
      someProducts.insert(0, aProduct);
      nameController.text = '';
    });
  }

  void clearList() {
    setState(() {
      someProducts.clear();
    });
  }

  void importList() {
    setState(() {
      someProducts.clear();

      var products = jsonDecode(listController.text);
      for (var product in products) {
        var aProduct = new Product();
        aProduct.name = product['name'];
        aProduct.isSelected = false;
        someProducts.insert(0, aProduct);
      }
      nameController.text = '';
      listController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Market List'),
        ),
        body: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Product name',
              ),
            ),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(20),
                  child: ElevatedButton(
                    child: Text('Add'),
                    onPressed: () {
                      addItemToList();
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: ElevatedButton(
                    child: Text('Clear List'),
                    onPressed: () {
                      clearList();
                    },
                  ),
                ),
              ]),
          Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: someProducts.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                        onTap: () {
                          setState(() {
                            if (someProducts[index].isSelected)
                              someProducts[index].isSelected = false;
                            else
                              someProducts[index].isSelected = true;
                          });
                        },
                        child: Container(
                          height: 50,
                          margin: EdgeInsets.all(2),
                          color: someProducts[index].isSelected
                              ? Colors.red
                              : Colors.blue,
                          child: Center(
                              child: Text(
                            '${someProducts[index].name}',
                            style: TextStyle(fontSize: 20),
                          )),
                        ));
                  })),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(20),
                  child: ElevatedButton(
                    child: Text('Send'),
                    onPressed: () async {
                      var contacts = await getContacts();
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                title: Text("Select a contact"),
                                content: Container(
                                    height: 500.0,
                                    width: 300.0,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.all(2),
                                        itemCount: contacts.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return InkWell(
                                              onTap: () {
                                                setState(() {
                                                  var jsonProcuts = '''[''';
                                                  var notSelected = false;
                                                  for (var i = 0;
                                                      i < someProducts.length;
                                                      i++) {
                                                    jsonProcuts +=
                                                        '{"name": "${someProducts[i].name}", "isSelected": $notSelected},';
                                                  }
                                                  jsonProcuts =
                                                      jsonProcuts.substring(
                                                          0,
                                                          jsonProcuts.length -
                                                              1);
                                                  jsonProcuts += ''']''';

                                                  launchURL(
                                                      contacts[index].phone,
                                                      jsonProcuts);
                                                });
                                              },
                                              child: Container(
                                                height: 40,
                                                margin: EdgeInsets.all(10),
                                                child: Center(
                                                    child: Text(
                                                  '${contacts[index].displayName}',
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                )),
                                              ));
                                        })),
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: Text('Volver'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              ));
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: ElevatedButton(
                      child: Text('Import List'),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text("Insert list"),
                            content: Container(
                              height: 500.0,
                              width: 300.0,
                              child: TextField(
                                controller: listController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Products List',
                                ),
                              ),
                            ),
                            actions: <Widget>[
                              ElevatedButton(
                                child: Text('Guardar'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  importList();
                                },
                              )
                            ],
                          ),
                        );
                      }),
                ),
              ]),
        ]));
  }
}

class Product {
  String name;
  bool isSelected;
}

class Contact {
  String displayName;
  String phone;
}
