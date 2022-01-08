import 'package:flutter_test/flutter_test.dart';
import 'package:mean_lib/local_database_helper.dart';

void main() {
  test('adds one to input values', () {
     LocalDbHelper db = LocalDbHelper();
  db.create("""test (
      id INTEGER NOT NULL,
      PRIMARY KEY,
      name TEXT NOT NULL
      """);
  db.insertData(
    insertInto: """
  test (name)
  """,
    dataToInsert: ["MEHMET","sedat"],
  );
  db.read(
    """ 
    SELECT * FROM test
    """
  );
    
  });
}