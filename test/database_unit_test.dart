import 'dart:developer';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_dog_app_final/services/hive_service.dart';
import 'package:my_dog_app_final/services/log_service.dart';


void main() async {
  Hive.init("assets/test");
  await Hive.openBox(HiveService.dbName);

  group("Test: HiveService", () {

    test("save string data", () async {
      await HiveService.setData(StorageKey.language, "EN");
    });

    test("read string data", () {
      String data = HiveService.readData<String>(StorageKey.language, defaultValue: "UZ");
      LogService.wtf(data);
      expect(data == "UZ" || data == "EN", true);
    });

    test("remove string data", () async {
      await HiveService.removeData(StorageKey.language);
    });
  });
}