import 'package:flutter/material.dart';
import 'package:item_picker/item_picker.dart';

void main() {
  runApp(const MainApp());
}

class Item {
  const Item(this.name);

  final String name;
}

final items = List.generate(100, (index) => Item('Item $index'));

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: ItemsPicker(
        items: items,
        onItemsPicked: (items) {},
      ),
    ));
  }
}
