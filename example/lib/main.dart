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
        theme: ThemeData.dark(useMaterial3: true), home: const Home());
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

  Widget itemsBuilder(BuildContext context, Item item, bool selected) =>
      CheckboxListTile.adaptive(
          value: selected, onChanged: (value) {}, title: Text(item.name));

  @override
  Widget build(BuildContext context) {
    if (isItems) {
      return Scaffold(
        body: ItemsPicker<Item>(
          items: items,
          itemFilter: itemFilter,
          itemTitleBuilder: (context, item) => Text(item.name),
          initialItems: [items[0], items[1]],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Picked Item: ${pickedItem?.name ?? 'None'}'),
        actions: [
          IconButton(
              onPressed: () => setState(() => isItems = !isItems),
              icon: Icon(isItems ? Icons.list : Icons.grid_view))
        ],
      ),
      body: ItemPicker(
          autofocus: true,
          items: items,
          // itemFilter: itemFilter,
          itemBuilder: itemBuilder,
          onItemPicked: (item) => setState(() => pickedItem = item)),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () => showAsyncItemPicker(
                  autofocus: true,
                  context: context,
                  future:
                      Future.delayed(const Duration(seconds: 1), () => items),
                  itemFilter: itemFilter,
                  itemBuilder: itemBuilder)
              .then((value) => setState(() => pickedItem = value)),
          label: const Text('Pick Item')),
    );
  }
}
