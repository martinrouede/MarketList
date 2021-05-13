import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddProduct extends StatelessWidget {
  AddProduct({Key key, this.addItem, this.controller}) : super(key: key);

  final addItem;
  final controller;

  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(children: <Widget>[
          Expanded(
              flex: 8,
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: AppLocalizations.of(context).productName,
                ),
              )),
          Expanded(
              flex: 2,
              child: IconButton(
                  iconSize: 40,
                  icon: FaIcon(FontAwesomeIcons.plusCircle),
                  onPressed: () {
                    addItem();
                  }))
        ]));
  }
}
