import 'dart:io';
import 'package:mean_lib/logger.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

Database? _DATABASE;

class LocalDBService {
  //DATABASE NAEM
  final String name;
  //CONSTRUCTOR
  LocalDBService({required this.name});

  //INIT METHOD LOOKS IF DB OPEN, IF NOT OPENS
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

  //CLOSE THE DB
  Future<void> close() async {
    if (_DATABASE != null) {
      if (_DATABASE!.isOpen) {
        Logger.success("Database Kapatılıyor");
        await _DATABASE!.close();
      }
    }
  }

  //CREATE SINGLE TABLE
  void create({required String tableName, required String parameters}) async {
    await _init().then((db) async {
      var batch = _DATABASE!.batch();
       batch.execute(
          """ 
        CREATE TABLE IF NOT EXISTS $tableName 
        ($parameters)
        """,
        );
     /* _tableIsEmpty(tableName, _DATABASE, () async {
        batch.execute(
          """ 
        CREATE TABLE $tableName 
        ($parameters)
        """,
        );
      });*/

      await batch.commit();
    });
  }

  //CREATE MULTIPLE TABLES
  void multipleCreate({required List<CreateModel> tables}) async {
    await _init().then((db) async {
      var batch = _DATABASE!.batch();
      tables.forEach((table) {
        batch.execute(
            """ 
        CREATE TABLE IF NOT EXISTS ${table.tableName} 
        (${table.parameters})
        """,
          );
      /*  _tableIsEmpty(table.tableName, _DATABASE, () async {
          batch.execute(
            """ 
        CREATE TABLE ${table.tableName} 
        (${table.parameters})
        """,
          );
        });*/
      });

      await batch.commit();
    });
  }

  //INSERT DATA TO TABLE
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

  //READ DATA FROM TABLE
  Future<List<dynamic?>> read(
      {required String parameters,
      required String tableName,
      String? lastStatement = "",
      String where = "",
      bool prints = false}) async {
    return await _init().then((db) async {
      var batch = _DATABASE!.batch();
      if (where.isEmpty) {
        batch.rawQuery(
          """
        SELECT $parameters 
        FROM $tableName
        $lastStatement
        """,
        );
      } else {
        batch.rawQuery(
          """
        SELECT $parameters 
        FROM $tableName
        WHERE $where
        $lastStatement
        """,
        );
      }

      List result = await batch.commit();
      if (prints) {
        result.forEach((element) {
          print(element);
        });
      }
      return result;
    });
  }

  //DELETE DATA
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

  //UPDATE
  void update({required String sqlState}) async {
    await _init().then((db) async {
      var batch = _DATABASE!.batch();
      batch.rawQuery(
        sqlState,
      );

      await batch.commit();
    });
  }

  //LOOKS IF TABLE HAS ANY DATA
  void _tableIsEmpty(String tableName, db, Function ifNotExist) async {
    try {
      int? count = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM $tableName'));
    } catch (e) {
      ifNotExist();
    }
  }
}

//THIS MODEL FRO MULTIPLE CREATIONS
class CreateModel {
  //the table name which will be created
  final String tableName;
  //the parameters
  final String parameters;
  CreateModel({required this.parameters, required this.tableName});
}
