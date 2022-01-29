import 'dart:io';
import 'package:mean_lib/logger.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

/*
NESNE 
LocalDBService dbService = LocalDBService(name: "batch.db");
CREAE
dbService.create(
              tableName: "test2", 
              parameters: "name TEXT,surname TEXT");
INSERT
dbService.insert(
              tableName: "test2",
              parameters: "name,surname",
              values: ["asdsad", "asdasd"]);
              
MULTIPLE INSERT
dbService.insert(
              tableName: "test2",
              parameters: "name,surname",
              multiple:true,
              values: [["asdsad", "asdasd"],["asdsad", "asdasd"]]);
READ
dbService.read(
              parameters: "*", 
              tableName: "test2", 
              prints: true);
UPDATE          
dbService.update(
            sqlState: """
            UPDATE test2 SET name = 'wewe' WHERE name = 'asdsad'
            """,
          );
DELETE
dbService.delete(
              tableName: "test2", 
              whereStatement: """WHERE name = 'asdsad'""");
     */
Database? _DATABASE;

class LocalDBService {
  final String name;

  LocalDBService({required this.name});

  /// Batch test page.
  Future<void> _init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, name);
    if (_DATABASE == null) {
      _DATABASE = await openDatabase(path);
    } else {
      if (!_DATABASE!.isOpen) {
        _DATABASE = await openDatabase(path);
      }
    }
  }

  Future<void> close() async {
    if (_DATABASE != null) {
      if (_DATABASE!.isOpen) {
        Logger.success("Database Kapatılıyor");
        await _DATABASE!.close();
      }
    }
  }

  void create({required String tableName, required String parameters}) async {
    await _init().then((db) async {
      var batch = _DATABASE!.batch();
      tableIsEmpty(tableName, _DATABASE, () async {
        batch.execute(
          """ 
        CREATE TABLE $tableName 
        ($parameters)
        """,
        );
      });

      await batch.commit();
    });
  }

  void insert(
      {required String tableName,
      required String parameters,
      required List values,
      bool multipleInsert = false}) async {
    await _init().then((db) async {
      var batch = _DATABASE!.batch();
      String nValues = "";
      for (var i = 0;
          i < (multipleInsert ? values[0].length : values.length);
          i++) {
        nValues = nValues + (i == 0 ? "" : ",") + "?";
      }

      if (multipleInsert) {
        values.forEach((element) {
          batch.rawInsert("""
        INSERT INTO ${tableName.replaceAll(",", ",")}
        ($parameters) VALUES($nValues)
        """, element);
        });
      } else {
        batch.rawInsert("""
        INSERT INTO ${tableName.replaceAll(",", ",")}
        ($parameters) VALUES($nValues)
        """, values);
      }

      await batch.commit();
    });
  }

  Future<List<dynamic?>> read(
      {required String parameters,
      required String tableName,
      String? lastStatement = "",
      String where = "",
      bool prints = false}) async {
    return await _init().then((db) async {
      var batch = _DATABASE!.batch();
      batch.rawQuery(
        """
        SELECT $parameters 
        FROM $tableName
        WHERE ${where.isEmpty ? true : where}
        $lastStatement
        """,
      );
      List result = await batch.commit();
      if (prints) {
        result.forEach((element) {
          print(element);
        });
      }
      return result;
    });
  }

  void delete(
      {required String tableName, required String whereStatement}) async {
    await _init().then((db) async {
      var batch = _DATABASE!.batch();
      batch.rawQuery(
        """
      DELETE FROM $tableName 
      $whereStatement
        """,
      );

      await batch.commit();
    });
  }

  void update({required String sqlState}) async {
    await _init().then((db) async {
      var batch = _DATABASE!.batch();
      batch.rawQuery(
        sqlState,
      );

      await batch.commit();
    });
  }

  void tableIsEmpty(String tableName, db, Function ifNotExist) async {
    try {
      int? count = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM $tableName'));
    } catch (e) {
      ifNotExist();
    }
  }
}
