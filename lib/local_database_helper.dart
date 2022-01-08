import 'package:sqlite3/sqlite3.dart';
import 'dart:core';

class LocalDbHelper {
  var db;
  void init() => db = sqlite3.openInMemory();
  void create(String createTable) {
    try {
      db.execute("CREATE TABLE $createTable");
    } catch (e) {
      print("Eklemede hata!!!");
      print(e.toString());
    }
  }

  void insertData({required dataToInsert, required String insertInto}) {
    final stmt = db.prepare('INSERT INTO $insertInto VALUES(?)');
    dataToInsert.forEach((element) {
      stmt..execute([element]);
    });
    stmt.dispose();
  }

  ResultSet read(String selectStatement, {bool prints = false}) {
    final resultSet = db.select(selectStatement);
    if (prints) {
      resultSet.forEach((element) {
        print(element);
      });
    }

    return resultSet;
  }

  void dispose() => db.dispose();
}
