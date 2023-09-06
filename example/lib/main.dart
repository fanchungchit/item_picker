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
    return const MaterialApp(home: Home());
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isItems = false;

  Item? pickedItem;

  bool itemFilter(Item item, String filter) =>
      item.name.toLowerCase().contains(filter.toLowerCase());

  Widget itemBuilder(BuildContext context, Item item) =>
      ListTile(title: Text(item.name));

  @override
  Widget build(BuildContext context) {
    if (isItems) {}

    return Scaffold(
      appBar: AppBar(
        title: Text('Picked Item: ${pickedItem?.name ?? 'None'}'),
      ),
      body: ItemPicker(
          autofocus: true,
          items: items,
          itemFilter: itemFilter,
          itemBuilder: itemBuilder,
          onItemPicked: (item) => setState(() => pickedItem = item)),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () => showAsyncItemPicker(
                  autofocus: true,
                  context: context,
                  builder: (context) async {
                    await Future.delayed(const Duration(seconds: 1));
                    return items;
                  },
                  itemFilter: itemFilter,
                  itemBuilder: itemBuilder)
              .then((value) => setState(() => pickedItem = value)),
          label: const Text('Pick Item')),
    );
  }
}
