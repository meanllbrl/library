import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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

  void multipleCreate({required List<CreateModel> tables}) async {
    await _init().then((db) async {
      var batch = _DATABASE!.batch();
      tables.forEach((table) {
        tableIsEmpty(table.tableName, _DATABASE, () async {
          batch.execute(
            """ 
        CREATE TABLE ${table.tableName} 
        (${table.parameters})
        """,
          );
        });
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

class CreateModel {
  final String tableName;
  final String parameters;
  CreateModel({required this.parameters, required this.tableName});
}

class FirebaseInfos {
  final String collectionName;
  final String compParam;

  FirebaseInfos({required this.collectionName, required this.compParam});
}

class UpdateModel {
  final String fbDocId;
  final String localTableId;
  final String localCompParam;
  final String fbCompParam;
  final Function(List docs) insertDataWithFBDocs;

  UpdateModel(
      {required this.insertDataWithFBDocs,
      required this.fbDocId,
      required this.localTableId,
      this.localCompParam = "id",
      this.fbCompParam = "id"});
}

class LocalInfos {
  final String tableName;
  final String compParam;
  //if update model is not null and there is any updated doc, this function will be triggered
  LocalInfos({required this.tableName, required this.compParam});
}

class FetchLocalFF {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  LocalDBService _local = LocalDBService(name: "batch.db");
  //this LocalInfos is the atr which will be used to compare local db and firebase
  final LocalInfos localDatabase;
  //this param is the atr which will be used to compare firebase and local
  final FirebaseInfos fbDatabase;
  final bool isItDate;
  //this param is for enabling looking for updated values on db
  final UpdateModel? updateModel;
  //the function will be triggered when process ok
  final Future<void> Function(QuerySnapshot<Map<String, dynamic>> value)
      onFinished;

  FetchLocalFF(
      {required this.isItDate,
      this.updateModel,
      required this.localDatabase,
      required this.fbDatabase,
      required this.onFinished});

  //this class for fetching local database from firebase
  //it returns to functionality of getting missing data on local database
  Future<void> fetch() async {
    //comparisio element to use it on firebase query
    dynamic comparisionElement = isItDate ? DateTime(2000) : 0;
    //look to local database if any doc exists
    int localDocCount = await _getCount();
    //if any doc exist get the latest or biggest doc
    if (localDocCount != 0) {
      comparisionElement = await _getBiggest();
      if (isItDate) {
        try {
          comparisionElement =
              Timestamp.fromMillisecondsSinceEpoch(comparisionElement + 1);
        } catch (e) {
          throw ErrorDescription(
              "Are You Sure That Is A Date(Frommilliseconseachpo...)");
        }
      }
    }

    //firebase query
    await _db
        .collection(fbDatabase.collectionName)
        .where(fbDatabase.compParam, isGreaterThan: comparisionElement)
        .get()
        .then((value) async {
      //returned the values which hosted database has and local hasn't
      await onFinished(value);  /* .then((value) async {
     Logger.warning("the databases have to have updateDate param");
        try {
          //if update model is not null
          if (updateModel != null) {
            //local datas
            print("*****UPDATE CONTROL: BEGINS");
            List theData = await _local.read(
                parameters:
                    "${updateModel!.localCompParam} AS comp,${updateModel!.localTableId} AS id",
                tableName: localDatabase.tableName);
            //for each local data
            theData[0].forEach((element) async {
              //we get date of updating of the data
              DateTime localDate =
                  DateTime.fromMillisecondsSinceEpoch(element["comp"]);
              //We ask firebase if there is new data
              await _db
                  .collection(fbDatabase.collectionName)
                  .where(updateModel!.fbCompParam, isGreaterThan: localDate)
                  .get()
                  .then((updatedDocs) {
                print(
                    "*****UPDATE CONTROL: UPDATED DOCUMENTS HAS RETURNED (${updatedDocs.docs.length})");
                //the updated docs is here
                updatedDocs.docs.forEach((updatedDoc) {
                  print("*****UPDATE CONTROL: DELETING FROM LOCAL");
                  _local.delete(
                      tableName: localDatabase.tableName,
                      whereStatement:
                          "WHERE '${element["id"]}'='${updatedDoc[updateModel!.fbDocId]}'");
                });
                print("*****UPDATE CONTROL: REINSERTING TO LOCAL");
                updateModel!.insertDataWithFBDocs(updatedDocs.docs);
              });
            });
          }
        } catch (e) {}
      });*/
    });
  }

  Future<dynamic> _getBiggest() async {
    try {
      List theData = await _local.read(
          parameters: localDatabase.compParam,
          tableName: localDatabase.tableName,
          lastStatement: "ORDER BY ${localDatabase.compParam} DESC LIMIT 1");
      return theData[0][0][localDatabase.compParam];
    } catch (e) {
      Logger.bigError(e.toString());
      throw ErrorDescription("Local Database _getBiggest crashed!!!");
    }
  }

  Future<int> _getCount() async {
    try {
      List theData = await _local.read(
          parameters: "COUNT(*) AS total", tableName: localDatabase.tableName);
      return theData[0][0]["total"];
    } catch (e) {
      Logger.bigError(e.toString());
      throw ErrorDescription("Local Database get count crashed!!!");
    }
  }
}
