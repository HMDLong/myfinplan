import 'package:flutter/material.dart';

class OnFutureBuilder<T> extends StatelessWidget {
  final Future<T> future;
  final Widget Function(T? data) data;
  final Widget Function() error;
  final Widget Function() loading;

  const OnFutureBuilder({
    super.key,
    required this.future,
    required this.data,
    required this.error,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loading();
          }
          if (snapshot.hasError) {
            return error();
          }
          return data(snapshot.data);
        });
  }
}
