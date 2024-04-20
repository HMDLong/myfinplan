import 'package:flutter/material.dart';

class TransactionTypeMenu<T> extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final void Function(T type) onTypeChanged;
  final T? initType;

  const TransactionTypeMenu({
    super.key,
    required this.items,
    required this.onTypeChanged,
    this.initType,
  });

  @override
  State<TransactionTypeMenu> createState() => _TransactionTypeMenuState<T>();
}

class _TransactionTypeMenuState<T> extends State<TransactionTypeMenu<T>> {
  late T _currentType;

  @override
  void initState() {
    super.initState();
    _currentType = widget.initType ?? widget.items[0]["value"];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(width: 0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: widget.items.map((e) {
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _currentType = e["value"];
                  widget.onTypeChanged(e["value"] as T);
                });
              },
              child: Container(
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: e["value"] == _currentType ? Colors.blue : Colors.white,
                ),
                child: Text(
                  e["name"],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _currentType == e["value"] ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
