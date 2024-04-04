import 'package:hive_flutter/adapters.dart';
import 'package:myfinplan/services/storage/hive/custom_adapters.dart';

class HiveStorageService {
  Future<void> init() async {
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
