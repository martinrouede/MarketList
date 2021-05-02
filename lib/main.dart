import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Product> _someProducts = <Product>[];

  TextEditingController _newProductController = TextEditingController();

  TextEditingController _listController = TextEditingController();

  void _addItemToList() {
    setState(() {
      var aProduct = new Product();
      aProduct.name = _newProductController.text;
      aProduct.isSelected = false;
      _someProducts.insert(0, aProduct);
      _newProductController.text = '';
    });
  }

  void _clearList() {
    setState(() {
      _someProducts.clear();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).marketList),
        ),
        body: Padding(
            padding: EdgeInsets.all(20),
            child: Column(children: <Widget>[
              AddProduct(
                  addItem: _addItemToList,
                  controller: _newProductController,
                  clearList: _clearList),
              ListProducts(products: _someProducts, selectItem: _selectItem),
              SendLoadList(
                  products: _someProducts,
                  controller: _listController,
                  importList: _importList),
            ])));
  }
}
