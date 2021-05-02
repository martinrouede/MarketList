import 'package:flutter/material.dart';
import 'product.dart';

class ListProducts extends StatelessWidget {
  ListProducts({Key key, this.products, this.selectItem}) : super(key: key);

  final List<Product> products;
  final ValueChanged<int> selectItem;

  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
            padding: const EdgeInsets.all(8),
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
                    child: Center(
                        child: Text(
                      '${products[index].name}',
                      style: TextStyle(fontSize: 20),
                    )),
                  ));
            }));
  }
}
