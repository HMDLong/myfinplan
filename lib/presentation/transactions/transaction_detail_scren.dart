import 'package:flutter/material.dart';
import 'package:myfinplan/utils/styles.dart';

class TransactDetailScreen extends StatefulWidget {
  const TransactDetailScreen({super.key});

  @override
  State<TransactDetailScreen> createState() => _TransactDetailScreenState();
}

class _TransactDetailScreenState extends State<TransactDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultStyledAppBar(
        title: "Thông tin",
        onBackPressed: () => Navigator.pop(context),
        trailings: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.edit_document)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
        ],
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
