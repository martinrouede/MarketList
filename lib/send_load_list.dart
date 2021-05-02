import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'product.dart';
import 'contact.dart';

class SendLoadList extends StatelessWidget {
  SendLoadList({Key key, this.products, this.controller, this.importList})
      : super(key: key);

  final List<Product> products;
  final controller;
  final importList;

  void launchURL(phone, text) async {
    var url = 'https://api.whatsapp.com/send?phone=${phone}&text=${text}';
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  }

  Future<List<MyContact>> getContacts() async {
    List<MyContact> someContacts = <MyContact>[];
    var contacts = await ContactsService.getContacts(withThumbnails: false);

    var i = 0;
    for (var contact in contacts) {
      var aContact = new MyContact();
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

  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child: ElevatedButton(
              child: Text(AppLocalizations.of(context).send),
              onPressed: () async {
                var contacts = await getContacts();
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                          title:
                              Text(AppLocalizations.of(context).selectContact),
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
                                          var jsonProcuts = '''[''';
                                          var notSelected = false;
                                          for (var i = 0;
                                              i < products.length;
                                              i++) {
                                            jsonProcuts +=
                                                '{"name": "${products[i].name}", "isSelected": $notSelected},';
                                          }
                                          jsonProcuts = jsonProcuts.substring(
                                              0, jsonProcuts.length - 1);
                                          jsonProcuts += ''']''';

                                          launchURL(contacts[index].phone,
                                              jsonProcuts);
                                        },
                                        child: Container(
                                          height: 40,
                                          margin: EdgeInsets.all(10),
                                          child: Center(
                                              child: Text(
                                            '${contacts[index].displayName}',
                                            style: TextStyle(fontSize: 18),
                                          )),
                                        ));
                                  })),
                          actions: <Widget>[
                            ElevatedButton(
                              child: Text(AppLocalizations.of(context).back),
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
                child: Text(AppLocalizations.of(context).importList),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text(AppLocalizations.of(context).insertList),
                      content: Container(
                        height: 500.0,
                        width: 300.0,
                        child: TextField(
                          controller: controller,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText:
                                AppLocalizations.of(context).productsList,
                          ),
                        ),
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          child: Text(AppLocalizations.of(context).back),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        ElevatedButton(
                          child: Text(AppLocalizations.of(context).save),
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
        ]);
  }
}
