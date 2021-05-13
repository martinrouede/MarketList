import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'theme_changer.dart';
import 'add_prduct.dart';
import 'list_prducts.dart';
import 'send_load_list.dart';
import 'product.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      defaultBrightness: Brightness.dark,
      builder: (context, _brightness) {
        return MaterialApp(
          title: 'Market List',
          localizationsDelegates: [
            AppLocalizations.delegate, // Add this line
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en', ''), // English, no country code
            const Locale('es', ''), // Spanish, no country code
          ],
          theme: ThemeData(primarySwatch: Colors.blue, brightness: _brightness),
          home: MyHomePage(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Product> _someProducts = <Product>[];

  TextEditingController _newProductController = TextEditingController();

  TextEditingController _listController = TextEditingController();

  void _addItemToList() {
    setState(() {
      if (_newProductController.text.isNotEmpty) {
        var aProduct = new Product();
        aProduct.name = _newProductController.text;
        aProduct.isSelected = false;
        _someProducts.insert(0, aProduct);
        _newProductController.text = '';
      }
    });
  }

  void _importList() {
    setState(() {
      _someProducts.clear();

      var products = jsonDecode(_listController.text);
      for (var product in products) {
        var aProduct = new Product();
        aProduct.name = product['name'];
        aProduct.isSelected = false;
        _someProducts.insert(0, aProduct);
      }
      _newProductController.text = '';
      _listController.text = '';
    });
  }

  void _selectItem(index) {
    setState(() {
      if (_someProducts[index].isSelected)
        _someProducts[index].isSelected = false;
      else
        _someProducts[index].isSelected = true;
    });
  }

  void _removeItem(index) {
    setState(() {
      _someProducts.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(AppLocalizations.of(context).marketList),
            actions: <Widget>[
              if (ThemeBuilder.of(context).getCurrentTheme() == Brightness.dark)
                IconButton(
                    icon: FaIcon(FontAwesomeIcons.moon),
                    onPressed: () {
                      ThemeBuilder.of(context).changeTheme();
                    })
              else
                IconButton(
                    icon: FaIcon(FontAwesomeIcons.sun),
                    onPressed: () {
                      ThemeBuilder.of(context).changeTheme();
                    }),
            ]),
        body: Padding(
            padding: EdgeInsets.all(20),
            child: Column(children: <Widget>[
              AddProduct(
                  addItem: _addItemToList, controller: _newProductController),
              ListProducts(
                  products: _someProducts,
                  selectItem: _selectItem,
                  removeItem: _removeItem),
              SendLoadList(
                  products: _someProducts,
                  controller: _listController,
                  importList: _importList),
            ])));
  }
}
