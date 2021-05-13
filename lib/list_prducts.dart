import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'product.dart';

class ListProducts extends StatelessWidget {
  ListProducts({Key key, this.products, this.selectItem, this.removeItem})
      : super(key: key);

  final List<Product> products;
  final ValueChanged<int> selectItem;
  final ValueChanged<int> removeItem;

  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                  onTap: () {
                    selectItem(index);
                  },
                  child: Container(
                    height: 50,
                    margin: EdgeInsets.all(2),
                    color:
                        products[index].isSelected ? Colors.red : Colors.blue,
                    child: Row(children: <Widget>[
                      Expanded(
                          flex: 8,
                          child: Center(
                              child: Text(
                            '${products[index].name}',
                            style: TextStyle(fontSize: 20),
                          ))),
                      Expanded(
                          flex: 2,
                          child: IconButton(
                              icon: FaIcon(FontAwesomeIcons.times),
                              onPressed: () {
                                removeItem(index);
                              }))
                    ]),
                  ));
            }));
  }
}
