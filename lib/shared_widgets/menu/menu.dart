import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomMenu<T> extends StatefulWidget {
  final T? initValue;
  final List<DropdownMenuEntry<T>> items;
  final void Function(T newValue) onChanged;
  final bool isScrollable;
  final bool locked;
  const CustomMenu({
    super.key,
    required this.items,
    this.initValue,
    required this.onChanged,
    this.isScrollable = false,
    this.locked = false,
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

  _buildScrollableMenu() {
    return SizedBox(
      height: 30,
      width: double.infinity,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final item = widget.items[index];
          return GestureDetector(
            onTap: () {
              if (widget.locked) {
                return;
              }
              setState(() {
                currentValue = item.value;
                widget.onChanged(item.value);
              });
            },
            child: Container(
              // constraints: const BoxConstraints(minHeight: 20, maxHeight: 40),
              decoration: BoxDecoration(
                color: currentValue == item.value ? CupertinoColors.activeBlue : Colors.blue.shade100,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    item.label,
                    style: TextStyle(color: currentValue == item.value ? Colors.white : Colors.black),
                  ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, _) => const SizedBox(width: 6.0),
        itemCount: widget.items.length,
      ),
    );
  }

  _buildUnscrollableMenu() {
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
                if (widget.locked) {
                  return;
                }
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

  @override
  Widget build(BuildContext context) {
    return widget.isScrollable ? _buildScrollableMenu() : _buildUnscrollableMenu();
  }
}
