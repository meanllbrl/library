# mean_lib

Mean Software Library

## Getting Started

<details>
<summary>Local Database Helper</summary>
* LocalDBService is designed to improve communication between developers and SQL Lite Database systems.

## Features
1. CREATE single table with the "create" function
2. CREATE multiple tables with the "multipleCreate" function
3. INSERT to the table with singular or multiple arrays
4. READ from tables with easy usage of "read" function
5. You can also UPDATE and DELETE

## Getting started

* The dbService object need to be created before usages.
* The database should be closed after the needed processes.

## Usage
!Firstly the object
```dart
LocalDBService dbService = LocalDBService(name: "batch.db");
```

**CREATE SINGLE TABLE
```dart
dbService.create(
                  tableName: "table",
                  parameters: "name TEXT,surname TEXT");
```

**CREATE MULTIPLE TABLES
```dart
    dbService.multipleCreate(
    tables: [
      //TABLE 1
      CreateModel(
        tableName: "table1",
        parameters: """ 
                        id VARCHAR(255) PRIMARY KEY,
                        ...
                    """,
                  ),
      //TABLE 2
      CreateModel(
        tableName: "table2",
        parameters: """ 
                        id VARCHAR(255) PRIMARY KEY,
                        ...
                    """,
                  ),
      );
```

**INSERT SINGLE DATA TO A TABLE
```dart
dbService.insert(
              tableName: "table",
              parameters: "name,surname",
              values: ["NAME", "SURNAME"]);
```

**INSERT MULTIPLE DATA TO A TABLE
```dart
dbService.insert(
              tableName: "test2",
              parameters: "name,surname",
              //multiple must be true
              multiple:true,
              values: [ ["NAME1", "SURNAME1"],
                        ["NAME2", "SURNAME2"]
                      ]);
```

**READ DATA FROM A TABLE
```dart
dbService.read(
              //the params which will be red
              parameters: "*",
              tableName: "table",
              where: "name='NAME' AND 'surname'='SURNAME' ",
              //if prints true the data will be printed on terminal
              prints: true
              );
```

**UPDATE DATA 
```dart
dbService.update(
        sqlState: """
                      UPDATE table 
                      SET name = 'UPDATED NAME' 
                      WHERE name = 'NAME1'
                  """,
);
```

**DELETE DATA
```dart
dbService.delete(
              tableName: "test2",
              whereStatement: "WHERE name = 'NAME'");
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to 
contribute to the package, how to file issues, what response they can expect 
from the package authors, and more.


</details>
