import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:widget/config.dart';
import 'package:widget/src/data/todo_list.dart';

import '../types/json.dart';

const noSuchFileOrDirectoryError = 2;

class TaskData {
  static Future<String> get _path async =>
      "${(await getApplicationDocumentsDirectory()).path}/${Config.savedTasksPath}";

  static Future<List<dynamic>> getTasksFromFile() async {
    //Aqui pegamos a localização da pasta do aplicativo em appData.

    try {
      final path = await _path;

      final file = File(path);

      return jsonDecode(await file.readAsString());
    } on FileSystemException catch (e) {
      if (e.osError?.errorCode == noSuchFileOrDirectoryError) {
        return <Json>[];
      }

      rethrow;
    } on JsonUnsupportedObjectError {
      debugPrint(
          "[TaskData] Wrong json format. Please check the method \"saveTasks\" in TaskData class.");

      exit(1);
    } on Exception {
      rethrow;
    }
  }

  static Future<void> saveTasks({required TodoList list}) async {
    try {
      final path = await TaskData._path;

      final file = File(path);

      await (await file.create(recursive: true)).writeAsString(list.toJson());
    } on Exception {
      rethrow;
    }
  }
}
