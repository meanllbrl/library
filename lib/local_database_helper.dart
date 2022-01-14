import 'dart:io';
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

class LocalDBService {
  final String name;

  LocalDBService({required this.name});

  /// Batch test page.
  Future<Database> _init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, name);
    return await openDatabase(path);
  }

  void create({required String tableName, required String parameters}) async {
    await _init().then((db) async {
      var batch = db.batch();
      tableIsEmpty(tableName, db, () async {
        batch.execute(
          """ 
        CREATE TABLE $tableName 
        ($parameters)
        """,
        );
      });

      await batch.commit().then((value) async => await db.close());
    });
  }

  void insert(
      {required String tableName,
      required String parameters,
      required List values,
      bool multipleInsert = false}) async {
    await _init().then((db) async {
      var batch = db.batch();
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

      await batch.commit().then((value) async => await db.close());
    });
  }

  Future<List<dynamic?>> read(
      {required String parameters,
      required String tableName,
      String? lastStatement = "",
      bool prints = false}) async {
    return await _init().then((db) async {
      var batch = db.batch();
      batch.rawQuery(
        """
        SELECT $parameters 
        FROM $tableName
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
      await db.close();
    });
  }

  void delete(
      {required String tableName, required String whereStatement}) async {
    await _init().then((db) async {
      var batch = db.batch();
      batch.rawQuery(
        """
      DELETE FROM $tableName 
      $whereStatement
        """,
      );

      await batch.commit().then((value) async => await db.close());
    });
  }

  void update({required String sqlState}) async {
    await _init().then((db) async {
      var batch = db.batch();
      batch.rawQuery(
        sqlState,
      );

      await batch.commit().then((value) async => await db.close());
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
