library item_picker;

import 'dart:async';

import 'package:flutter/material.dart';

typedef OnItemPicked<T> = void Function(T item);
typedef OnItemsPicked<T> = void Function(List<T> items);
typedef ItemFilter<T> = bool Function(T item, String filter);
typedef ItemBuilder<T> = Widget Function(BuildContext context, T item);
typedef CheckboxItemBuilder<T> = Widget Function(
    BuildContext context, T item, bool checked);

Future<T?> showItemPicker<T>({
  required BuildContext context,
  List<T> items = const [],
  OnItemPicked<T>? onItemPicked,
  ItemFilter<T>? itemFilter,
  ItemBuilder<T>? itemBuilder,
}) {
  return showDialog(
      context: context,
      builder: (context) => Dialog(
            child: ItemPicker<T>(
              items: items,
              onItemPicked: onItemPicked,
              itemFilter: itemFilter,
              itemBuilder: itemBuilder,
            ),
          ));
}

class ItemPicker<T> extends StatefulWidget {
  const ItemPicker(
      {super.key,
      this.items = const [],
      this.onItemPicked,
      this.itemFilter,
      this.itemBuilder});

  final List<T> items;
  final OnItemPicked<T>? onItemPicked;
  final ItemFilter<T>? itemFilter;
  final ItemBuilder<T>? itemBuilder;

  @override
  State<ItemPicker<T>> createState() => _ItemPickerState<T>();
}

class _ItemPickerState<T> extends State<ItemPicker<T>> {
  String filterString = '';

  Timer? timer;

  List<T> get items => widget.items
      .where(
          (element) => widget.itemFilter?.call(element, filterString) ?? true)
      .toList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.itemFilter != null)
          TextField(
            onChanged: (value) {
              /// Debounce the filter
              timer?.cancel();
              timer = Timer(const Duration(milliseconds: 500), () {
                setState(() {
                  filterString = value;
                });
              });
            },
            decoration: const InputDecoration(
              hintText: 'Search',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return InkWell(
                  onTap: () {
                    if (widget.onItemPicked == null) {
                      return Navigator.pop(context, item);
                    }
                    widget.onItemPicked?.call(item);
                  },
                  child: widget.itemBuilder?.call(context, item) ??
                      ListTile(
                        title: Text(item.toString()),
                      ));
            },
          ),
        ),
      ],
    );
  }
}

Future<List<T>?> showItemsPicker<T>({
  required BuildContext context,
  List<T> items = const [],
  List<T>? initialItems,
  OnItemsPicked<T>? onItemsPicked,
  ItemFilter<T>? itemFilter,
  CheckboxItemBuilder<T>? itemBuilder,
}) {
  return showDialog(
      context: context,
      builder: (context) => ItemsPicker<T>(
            items: items,
            initialItems: initialItems,
            onItemsPicked: onItemsPicked,
            itemFilter: itemFilter,
            itemBuilder: itemBuilder,
          ));
}

class ItemsPicker<T> extends StatefulWidget {
  const ItemsPicker(
      {super.key,
      this.items,
      this.itemFilter,
      this.initialItems,
      this.onItemsPicked,
      this.itemBuilder});

  final List<T>? items;
  final ItemFilter<T>? itemFilter;
  final List<T>? initialItems;
  final OnItemsPicked<T>? onItemsPicked;
  final CheckboxItemBuilder<T>? itemBuilder;

  @override
  State<ItemsPicker<T>> createState() => _ItemsPickerState<T>();
}

class _ItemsPickerState<T> extends State<ItemsPicker<T>> {
  late var pickedItems = widget.initialItems ?? [];

  String filterString = '';

  List<T> get items =>
      widget.items
          ?.where((item) => widget.itemFilter?.call(item, filterString) ?? true)
          .toList() ??
      [];

  Timer? timer;

  check(T item) => pickedItems.contains(item);

  set(T item) {
    setState(() {
      if (check(item)) {
        pickedItems.add(item);
      } else {
        pickedItems.remove(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: const Text('Pick Items'),
          actions: [
            TextButton(
                onPressed: () {
                  widget.onItemsPicked?.call(pickedItems);
                  Navigator.pop(context, widget.initialItems);
                },
                child: const Text('Done'))
          ],
        ),
        if (widget.itemFilter != null)
          TextField(
            onChanged: (value) {
              /// Debounce the filter
              timer?.cancel();
              timer = Timer(const Duration(milliseconds: 500), () {
                setState(() {
                  filterString = value;
                });
              });
            },
            decoration: const InputDecoration(
              hintText: 'Search',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return InkWell(
                  onTap: () => set(item),
                  child: widget.itemBuilder?.call(context, item, check(item)) ??
                      CheckboxListTile.adaptive(
                          value: check(item),
                          onChanged: (value) => set(item),
                          title: Text(item.toString())));
            },
          ),
        ),
      ],
    );
  }
}
