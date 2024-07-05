import 'package:hive_flutter/adapters.dart';
import 'package:myfinplan/external/storage/hive/custom_adapters.dart';

class HiveStorageService {
  Future<void> initialize() async {
    await Hive.initFlutter();
    for (final adapter in adapters) {
      adapter.register();
    }
    for (final adapter in adapters) {
      await adapter.openBox();
    }
  }

  void close() async {
    await Hive.close();
  }
}
