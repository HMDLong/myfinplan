import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomMenu<T> extends StatefulWidget {
  final T? initValue;
  final List<DropdownMenuEntry<T>> items;
  final void Function(T newValue) onChanged;
  const CustomMenu({
    super.key,
    required this.items,
    this.initValue,
    required this.onChanged,
  });

  @override
  State<CustomMenu<T>> createState() => _CustomMenuState<T>();
}

class _CustomMenuState<T> extends State<CustomMenu<T>> {
  late T currentValue;

  @override
  void initState() {
    currentValue = widget.initValue ?? widget.items.first.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: widget.items.map((e) {
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  currentValue = e.value;
                  widget.onChanged(e.value);
                });
              },
              child: Container(
                constraints: const BoxConstraints(minHeight: 20),
                decoration: BoxDecoration(
                  color: currentValue == e.value ? CupertinoColors.activeBlue : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    e.label,
                    style: TextStyle(color: currentValue == e.value ? Colors.white : Colors.black),
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
