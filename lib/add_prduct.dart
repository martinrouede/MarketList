import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddProduct extends StatelessWidget {
  AddProduct({Key key, this.addItem, this.controller, this.clearList})
      : super(key: key);

  final addItem;
  final controller;
  final clearList;

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: AppLocalizations.of(context).productName,
          ),
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: ElevatedButton(
                  child: Text(AppLocalizations.of(context).add),
                  onPressed: () {
                    addItem();
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: ElevatedButton(
                  child: Text(AppLocalizations.of(context).clearList),
                  onPressed: () {
                    clearList();
                  },
                ),
              ),
            ])
      ],
    );
  }
}
