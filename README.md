# Library Doc

This is a Flutter library which is created by me for personal usage. The library has number of classes that each one of them has different kind of specializations.

- alerts.dart/AlertHandler Class
    
    ℹ️ This class is for easing the proccess of creating fancy alert dialogs. It has two types...
    
    1. Top Icon Alert
        
        ### USAGE
        
        ```dart
        AlertHandler.showTopIconDialog(
            context: context,
            //title of alert
            title: "Title Of Dialog",
            //description of alert
            desc: "A Description can be provided here.",
            //icon which will be top of the alert
            icon: Icon(Icons.warning, color: Colors.deepOrangeAccent, size: 45),
            //icon's background color
            iconBackgroundColor: Colors.white,
            //button style elements
            button1Style: ComplexButtonStyle(
                textStyle: TextStyle(color: Colors.white),
                backgroundColor: Colors.deepOrange,
                borderColor: Colors.deepOrange,
                borderRadius: 20),
            //if dialog can pop or not
            popScope: true,
            //if dialog has only one button
            singleButton: false,
            //button 1 text
            but1: "Button 1",
            onTapFirst: () {
              Navigator.of(context).pop();
            },
            //button 2 text
            but2: "Button 2",
            onTapSecond: () {},
          );
        ```
        
        ### CONCLUSION
        
        <img width="296" alt="Screen_Shot_2022-03-18_at_15 33 31" src="https://user-images.githubusercontent.com/83311854/164552378-ac73692d-807a-4500-aeab-30d0f5b2851f.png">

        
    2. Simple Alert
        
        ### USAGE
        
        ```dart
        AlertHandler.simpleAlert(
            context,
            //title of alert
            title: "Alert Title",
            //desc of the alert
            desc: "A Description can be provided here", 
            //if the close button should exist
            isCloseButton: true,
            //title style
            titleStyle: TextStyle(),
            //Desc style
            descStyle: TextStyle(),
            //if the dialog will pop
            onWillPop: true,
            //alertType: ,
            //animationType: ,
            //elevation: ,
            //backgroundColor: ,
            //buttons: 
          );
        ```
        
        ### CONCLUSION
        <img width="295" alt="Screen_Shot_2022-03-18_at_15 41 29" src="https://user-images.githubusercontent.com/83311854/164552429-36710b60-7ddc-4ecf-a344-737a244608d3.png">

        
        
- complex_button.dart/ComplexButton Class
    
    ℹ️ This class is for easing creating buttons with feedbacks and precreated designs.
    
    ### USAGE
    
    ```dart
    ComplexButton(
         //on pressed
          onPressed: () {},
          //border radius
          radius: 60,
          //width of button
          width: 150,
          //height of button
          height: 44,
          //background color of button
          backgroundColor: Colors.deepPurpleAccent,
          //feedback color of button
          feedbackColor: Colors.white,
          //button text
          text: "Button Text",
          //button text style
          textStyle: TextStyle(color: Colors.white),
          //border: , BORDER CAN BE PROVIDED
          //elevation: , ELEVATION CAN BE PROVIDED
          //gradient: , GRADIENT CAN BE USED INSTEAD OF COLOR
          //margin: , MARGIN CAN BE PROVIDED
          //shadow: , SHADOW CAN BE PROVIDED
          //textColor: , IF TEXTSTYLE IS NULL THIS COLOR WILL BE USED
          //textSize: , IF TEXTSYLE IS NULL THIS SIZE WILL BE USED
          //textWidget: , INSTEAD OF STRING WIDGET CAN BE GIVEN
        );
    ```
    
    ### CONCLUSION
    ![Screen_Recording_2022-03-18_at_16 09 50](https://user-images.githubusercontent.com/83311854/164552508-40dc8f56-81a4-4d94-a5ec-4941cc9ac226.gif)

    
    
- data_magician.dart/DataMagicianProvider - DataMaigicanFuture Classes
    
    ℹ️ This class provides huge ease of data getting proccesses. There are two type of data magicians...
    
    1. DataMagicianProvider
        
        ### Usage
        
        ```dart
        DataMagicianProvider(
        	 //It will be triggered when an error occures
        	 onError:(){} 
        	 //this is where data should be requested
        	 loadDataFunction:(){} 
        	 //triggerCondition should be true when data writed on provider
        	 triggerCondition: false
        	 //when triggerCondition is true ui will be displayed
        	 ui: Container() 
        	 //loading widget can be provided
        	 placeHolder: CircularProgressIndicator(),
        	 //error widget will be displayed when any error occured
        	 errorWidget: Container(),
        )
        ```
        
    
- file_processor.dart/FileProccessor Class
    
    ℹ️ This class is for easing getting files from users and loading them to Firebase Storage.
    
    ### Usage
    
    Creating object
    
    ```dart
    //image service obj for image proccesses
          FileProccessor imageService = FileProccessor(
    				//file name
            photoName: "file_name",
    				//firebase storage path
            retFromUrl: "...,
    				//compress photo
            compress: true,
    				//file type
            fileType: IPtype.image,
    				//compress quailty(0-100)
            compressQuality: 5,
    				//max size border
            maxSizeAsMB: 5,
    				//started function
            started: () => loading=true,
    				//ended
            ended: (url) {
              loading =false;
    					//url is the file url which is on FS.
            },
          );
    ```
    
    Get From Local
    
    ```dart
    //get file from local
    await imageService.getFile().then((value) {
    							//value is a File Object
                  _imageFile = value;
                });
    ```
    
    Upload File To Firebase
    
    ```dart
    //upload and return url
    String url = await imageService.uploadFiletoFirebase(_imageFile);
    ```
    
- helpers.dart/NavigationHelper Class - inAppMessage Method
    
    ℹ️ Some helpers, mostly navigation...
    
    ### NavigationHelper
    
    - go another page
        
        ```dart
        NavigationHelper.goPage(
        			context,
        			//go to...
        			path:Class(),
        			//animation of transition
        			transitionType:...
        )
        ```
        
    - go another page with route name
        
        ```dart
        NavigationHelper.goPageNamed(
        			context,
        			//go to...
        			path:"class_id",
        )
        ```
        
    - go page and replace with old one
        
        ```dart
        NavigationHelper.goPageReplace(
        			context,
        			//go to...
        			path:Class(),
        			//animation of transition
        			transitionType:...
        )
        ```
        
    - go page and replace with old one with route name
        
        ```dart
        NavigationHelper.goPageReplaceNamed(
        			context,
        			//go to...
        			path:"class_id",
        )
        ```
        
    - go page and remove other paths
        
        ```dart
        NavigationHelper.goAndRemove(
        			context,
        			//go to...
        			path:Class(),
        			//animation of transition
        			transitionType:...
        )
        ```
        
    - go page and remove other paths with route name
        
        ```dart
        NavigationHelper.goAndRemoveNamed(
        			context,
        			//go to...
        			path:"class_id",
        )
        ```
        
- local_db_helper.dart/LocalDBService Class
    
    ℹ️ LocalDBService is designed to improve communication between developers and SQL Lite Database systems.
    
    ### Features
    
    1. CREATE single table with the "create" function
    2. CREATE multiple tables with the "multipleCreate" function
    3. INSERT to the table with singular or multiple arrays
    4. READ from tables with easy usage of "read" function
    5. You can also UPDATE and DELETE
    
    ### Getting Started
    
    - The dbService object need to be created before usages.
    - The database should be closed after the needed processes.
    
    ### Usage
    
    Firstly the object
    
    ```dart
    LocalDBService dbService = LocalDBService(name: "batch.db");
    ```
    
    CREATE SINGLE TABLE
    
    ```dart
    dbService.create(
                      tableName: "table",
                      parameters: "name TEXT,surname TEXT");
    ```
    
    CREATE MULTIPLE TABLES
    
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
    
    INSERT SINGLE DATA TO A TABLE
    
    ```dart
    dbService.insert(
                  tableName: "table",
                  parameters: "name,surname",
                  values: ["NAME", "SURNAME"]);
    ```
    
    INSERT MULTIPLE DATA TO A TABLE
    
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
    
    READ DATA FROM A TABLE
    
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
    
    UPDATE DATA
    
    ```dart
    dbService.update(
            sqlState: """
                          UPDATE table 
                          SET name = 'UPDATED NAME' 
                          WHERE name = 'NAME1'
                      """,
    );
    ```
    
    DELETE DATA
    
    ```dart
    dbService.delete(
                  tableName: "test2",
                  whereStatement: "WHERE name = 'NAME'");
    ```
    
- logger.dart/Logger Class
    
    ℹ️ Logger class for developers to log situations.
    
    ### Usage
    
    success-error-warning-bigError-log-debug
    
    ```dart
    Logger.success("Great!");
    ```
    
- open_container_animation.dart/AnimatedWidget Class
    
    ℹ️ Custom made widget transition
    
    ### Usage
    
    ```dart
    AnimatedWidget(
    							//the ui which is based
    							from:Container(),
    							//it will be gone to when from widget is pressed
    							to:Container(),
    							//duration:...
    							...
    )
    ```
    
    ### Concluison
    ![Screen_Recording_2022-03-18_at_17 02 17](https://user-images.githubusercontent.com/83311854/164552591-7998171a-ed22-475b-98ed-dcb2340188d1.gif)

    
