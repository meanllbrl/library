<body><article id="c3dfabdb-83e7-4749-a21f-07c029c91741" class="page sans"><header><h1 class="page-title">Library Doc</h1></header><div class="page-body"><p id="564bcd98-8368-4193-b4dd-ccbf29fd5f56" class="">This is a Flutter library which is created by me for personal usage. The library has number of classes that each one of them has different kind of specializations.</p><p id="6df8a793-2dcd-4141-88d7-a56315266b7e" class="">
</p><ul id="46ea57e0-4139-401f-86e9-473eac28630e" class="toggle"><li><details open=""><summary>alerts.dart/AlertHandler Class</summary><p id="d13c63f9-870c-4239-9e3c-b3a971eb15d1" class="">ℹ️&nbsp;This class is for easing the proccess of creating fancy alert dialogs. It has two types...</p><ol type="1" id="1968856e-693c-4af3-9853-a351b42ee2db" class="numbered-list" start="1"><li>Top Icon Alert<h3 id="74286c46-d0e0-4882-a52c-3178a22400ac" class="">USAGE</h3><pre id="9a84405a-76f1-47f7-acab-be927a5cf627" class="code"><code>AlertHandler.showTopIconDialog(
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
  );</code></pre><h3 id="4ba11595-cfb0-445f-b700-d2818539c701" class="">CONCLUSION</h3><figure id="52fb4de8-56d5-4380-9c79-587082f956a8" class="image"><a href="Library%20Do%2052fb4/Screen_Shot_2022-03-18_at_15.33.31.png"><img style="width:592px" src="Library%20Do%2052fb4/Screen_Shot_2022-03-18_at_15.33.31.png"></a></figure></li></ol><ol type="1" id="830a61cb-0e66-42f1-9faf-b9d7052b7403" class="numbered-list" start="2"><li>Simple Alert<h3 id="98455da8-ebfa-4a46-afe2-be6febb6b374" class="">USAGE</h3><pre id="c044e9b2-2ff4-4a14-9e8d-d9257e52efc3" class="code"><code>AlertHandler.simpleAlert(
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
  );</code></pre><h3 id="f7670e38-f158-456d-9957-9dc894a76d6b" class="">CONCLUSION</h3><figure id="31535878-9480-4a64-83f1-4e94d1720f78" class="image"><a href="Library%20Do%2052fb4/Screen_Shot_2022-03-18_at_15.41.29.png"><img style="width:590px" src="Library%20Do%2052fb4/Screen_Shot_2022-03-18_at_15.41.29.png"></a></figure><p id="0ad485d5-3f81-474e-b3b8-bce9b28c8c1b" class="">
</p></li></ol></details></li></ul><ul id="fb830d82-5c79-4f7f-b097-60355c587497" class="toggle"><li><details open=""><summary>complex_button.dart/ComplexButton Class</summary><p id="3499fe2e-f618-4512-a6d8-c824439585ef" class="">ℹ️&nbsp;This class is for easing creating buttons with feedbacks and precreated designs.</p><h3 id="e9fe38e6-7fb8-46bc-b029-1cab67d9f002" class="">USAGE</h3><pre id="69e1f442-70f7-4ad8-90a0-1d5467338900" class="code"><code>ComplexButton(
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
    );</code></pre><h3 id="a8b4f06c-af36-4fd3-8354-22c28cf7fc80" class="">CONCLUSION</h3><figure id="d1b9a3a3-d85f-4554-a311-0752bac2634e" class="image"><a href="Library%20Do%2052fb4/Screen_Recording_2022-03-18_at_16.09.50.gif"><img style="width:416px" src="Library%20Do%2052fb4/Screen_Recording_2022-03-18_at_16.09.50.gif"></a></figure></details></li></ul><ul id="8cd02fed-7d2c-46c5-84f3-3e34b1494236" class="toggle"><li><details open=""><summary>data_magician.dart/DataMagicianProvider - DataMaigicanFuture Classes</summary><p id="714a3a4a-fc44-4d56-8519-cdf725384ea8" class="">ℹ️&nbsp;This class provides huge ease of data getting proccesses. There are two type of data magicians...</p><ol type="1" id="c08ab234-da73-4c31-a78a-94e202323b00" class="numbered-list" start="1"><li>DataMagicianProvider<h3 id="8555167c-c3be-4b06-9c83-5d560cb82322" class="">Usage</h3><pre id="5f5497db-b781-4bb1-8ac5-77d38ee7b10e" class="code"><code>DataMagicianProvider(
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
)</code></pre></li></ol><p id="b3eec76b-32ec-476d-9813-ba148bdfd543" class="">
</p></details></li></ul><ul id="cd1d7a86-c99d-4fb6-afd3-f950f427c932" class="toggle"><li><details open=""><summary>file_processor.dart/FileProccessor Class</summary><p id="4f871a39-4b5a-465e-8472-1256bd984ae1" class="">ℹ️&nbsp;This class is for easing getting files from users and loading them to Firebase Storage.</p><h3 id="b43b7604-d9de-42bf-a872-116771f39430" class="">Usage</h3><p id="b2c845ea-c2d4-4249-8043-61f5e2268287" class="">Creating object</p><pre id="b0843f36-159b-46c5-bc5c-edf5df154714" class="code"><code>//image service obj for image proccesses
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
        started: () =&gt; loading=true,
				//ended
        ended: (url) {
          loading =false;
					//url is the file url which is on FS.
        },
      );</code></pre><p id="ab742cb9-b03b-451c-9e0b-e1cb22f95fd4" class="">Get From Local</p><pre id="eb65b89b-9d3a-43e0-b6e4-89d2497ee2ce" class="code"><code>//get file from local
await imageService.getFile().then((value) {
							//value is a File Object
              _imageFile = value;
            });</code></pre><p id="60e98b26-c3a1-41b9-88b9-41e9d24b8528" class="">Upload File To Firebase</p><pre id="e0daca93-5b79-4c1d-b531-b58c39ddfed7" class="code"><code>//upload and return url
String url = await imageService.uploadFiletoFirebase(_imageFile);</code></pre></details></li></ul><ul id="6a9b4c2d-efb6-47ee-814f-9249c9be8f42" class="toggle"><li><details open=""><summary>helpers.dart/NavigationHelper Class - inAppMessage Method</summary><p id="b108a647-cf24-42de-8548-147d2446980b" class="">ℹ️&nbsp;Some helpers, mostly navigation...</p><h3 id="4c8fc045-d47c-45e4-878b-0edc532ed9bc" class="">NavigationHelper</h3><ul id="47d4bc2c-d8f8-4aef-bb5b-7842f7113445" class="bulleted-list"><li style="list-style-type:disc">go another page<pre id="ec996434-8490-4177-b2b5-a627406fe59d" class="code"><code>NavigationHelper.goPage(
			context,
			//go to...
			path:Class(),
			//animation of transition
			transitionType:...
)</code></pre></li></ul><ul id="ae8d3e19-d5d3-4189-9113-7af1a5bc1d98" class="bulleted-list"><li style="list-style-type:disc">go another page with route name<pre id="79169b7f-feae-4f00-a155-2954884f4fef" class="code"><code>NavigationHelper.goPageNamed(
			context,
			//go to...
			path:"class_id",
)</code></pre></li></ul><ul id="23e57d71-9341-43b2-875d-81d60667a989" class="bulleted-list"><li style="list-style-type:disc">go page and replace with old one<pre id="6e700026-e79a-48c6-9830-a67e17d5ef8b" class="code"><code>NavigationHelper.goPageReplace(
			context,
			//go to...
			path:Class(),
			//animation of transition
			transitionType:...
)</code></pre></li></ul><ul id="d41d8d5e-0c5b-4f8e-857e-dd06219242d8" class="bulleted-list"><li style="list-style-type:disc">go page and replace with old one with route name<pre id="f4ac90b6-40bd-4aaa-9c68-8deb903efece" class="code"><code>NavigationHelper.goPageReplaceNamed(
			context,
			//go to...
			path:"class_id",
)</code></pre></li></ul><ul id="e0ef3123-3881-42b4-838d-e545562be2d0" class="bulleted-list"><li style="list-style-type:disc">go page and remove other paths<pre id="7c75956a-11c8-4a4f-8076-c332eee28783" class="code"><code>NavigationHelper.goAndRemove(
			context,
			//go to...
			path:Class(),
			//animation of transition
			transitionType:...
)</code></pre></li></ul><ul id="ba2dc212-3bfc-4d74-8b93-ef24e89d71c8" class="bulleted-list"><li style="list-style-type:disc">go page and remove other paths with route name<pre id="d661e5bf-c662-4659-84f2-a2b96cce1621" class="code"><code>NavigationHelper.goAndRemoveNamed(
			context,
			//go to...
			path:"class_id",
)</code></pre></li></ul></details></li></ul><ul id="56cfc70e-00ef-4a3c-8665-cf99d5789206" class="toggle"><li><details open=""><summary>local_db_helper.dart/LocalDBService Class</summary><p id="c4820d1a-25f4-45d5-922d-38799437b45a" class="">ℹ️&nbsp;LocalDBService is designed to improve communication between developers and SQL Lite Database systems.</p><h3 id="5c6966c8-dafa-4379-996a-b5f7b60055e6" class="">Features</h3><ol type="1" id="c94a4788-14e7-4f72-98a9-9618c27e3623" class="numbered-list" start="1"><li>CREATE single table with the "create" function</li></ol><ol type="1" id="c7029262-61c3-49f8-b6c4-46eb9758d731" class="numbered-list" start="2"><li>CREATE multiple tables with the "multipleCreate" function</li></ol><ol type="1" id="c3ea9a7f-b260-4c7d-90b2-ecb3436e732a" class="numbered-list" start="3"><li>INSERT to the table with singular or multiple arrays</li></ol><ol type="1" id="9c3d2990-6429-4ef6-8790-75cba1863f91" class="numbered-list" start="4"><li>READ from tables with easy usage of "read" function</li></ol><ol type="1" id="48cb4ec6-7d48-4f0a-9b7b-675f7730f760" class="numbered-list" start="5"><li>You can also UPDATE and DELETE</li></ol><h3 id="004071a1-98af-4d14-b51f-2bfd407eef1c" class="">Getting Started</h3><ul id="c0efcb98-43ad-45e6-9e41-3ece8d3c6464" class="bulleted-list"><li style="list-style-type:disc">The dbService object need to be created before usages.</li></ul><ul id="6d2ed6d3-ddb6-4f74-8aea-ef1445a086ab" class="bulleted-list"><li style="list-style-type:disc">The database should be closed after the needed processes.</li></ul><h3 id="e3ee6a7d-e264-4093-a356-f47d84941225" class="">Usage</h3><p id="39d241c0-31db-425f-b84b-59b2e26c2819" class="">Firstly the object</p><pre id="50612881-0bd0-43b8-9d1d-dce1f9c73ea2" class="code"><code>LocalDBService dbService = LocalDBService(name: "batch.db");</code></pre><p id="3294e40f-5253-4afb-b827-db5fdf41bfe2" class="">CREATE SINGLE TABLE</p><pre id="16532054-b38b-4769-b1ad-4fee2e9136ce" class="code"><code>dbService.create(
                  tableName: "table",
                  parameters: "name TEXT,surname TEXT");</code></pre><p id="d4d11b65-f37d-47e8-81ea-efe9fa8bfb5c" class="">CREATE MULTIPLE TABLES</p><pre id="e771d799-6b4a-47e7-9843-45a242e475fe" class="code"><code>dbService.multipleCreate(
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
      );</code></pre><p id="2fc0a648-663d-4492-9b14-a5e9db0c350e" class="">INSERT SINGLE DATA TO A TABLE</p><pre id="7f5dfe86-2b4b-4c95-b8f3-3b9c55e9de68" class="code"><code>dbService.insert(
              tableName: "table",
              parameters: "name,surname",
              values: ["NAME", "SURNAME"]);</code></pre><p id="3742a861-622e-48ab-9f00-f763ae592d99" class="">INSERT MULTIPLE DATA TO A TABLE</p><pre id="c60b78ce-d00f-478e-99d0-c502cb614600" class="code"><code>dbService.insert(
              tableName: "test2",
              parameters: "name,surname",
              //multiple must be true
              multiple:true,
              values: [ ["NAME1", "SURNAME1"],
                        ["NAME2", "SURNAME2"]
                      ]);</code></pre><p id="8aff7cc6-f2b0-4d78-abb5-3db6145189d5" class="">READ DATA FROM A TABLE</p><pre id="5362ba1b-76c8-4138-b9d6-574cdf17c097" class="code"><code>dbService.read(
              //the params which will be red
              parameters: "*",
              tableName: "table",
              where: "name='NAME' AND 'surname'='SURNAME' ",
              //if prints true the data will be printed on terminal
              prints: true
              );</code></pre><p id="88b84b4f-63a4-4de5-b329-bce64642369a" class="">UPDATE DATA</p><pre id="2d50ddb6-a2d6-4937-8f25-da7f7ddec66e" class="code"><code>dbService.update(
        sqlState: """
                      UPDATE table 
                      SET name = 'UPDATED NAME' 
                      WHERE name = 'NAME1'
                  """,
);</code></pre><p id="faef8cd2-4b46-4ce4-930b-da8e93bda2a7" class="">DELETE DATA</p><pre id="f8f6811d-84a7-4fe0-adb1-e8c8a6cec324" class="code"><code>dbService.delete(
              tableName: "test2",
              whereStatement: "WHERE name = 'NAME'");</code></pre></details></li></ul><ul id="89208892-a4e4-48bb-9c09-ed9855a8ab44" class="toggle"><li><details open=""><summary>logger.dart/Logger Class</summary><p id="63f833ee-cb7c-4391-98f9-14fe4b14f887" class="">ℹ️&nbsp;Logger class for developers to log situations.</p><h3 id="4a515b3e-da0d-45b6-80d5-06496d9d793b" class="">Usage</h3><p id="88e91710-1b0b-4b77-b37f-a2fe1e8c2fe2" class="">success-error-warning-bigError-log-debug</p><pre id="b4abf4d9-7482-432f-87e5-526927938e15" class="code"><code>Logger.success("Great!");</code></pre></details></li></ul><ul id="b56f894f-3986-417f-985d-22fd82867c47" class="toggle"><li><details open=""><summary>open_container_animation.dart/AnimatedWidget Class</summary><p id="4a8352d1-e47a-4102-a584-6933b9d24303" class="">ℹ️&nbsp;Custom made widget transition</p><h3 id="b0361a87-657c-4c9e-98fc-c9b54b7b030e" class="">Usage</h3><pre id="7130b353-7372-449f-9d1f-91050e097fa2" class="code"><code>AnimatedWidget(
							//the ui which is based
							from:Container(),
							//it will be gone to when from widget is pressed
							to:Container(),
							//duration:...
							...
)</code></pre><h3 id="340f0044-de83-4b4d-b94b-68cb8f8c0a50" class="">Concluison</h3><figure id="f4b0d3ac-8ca3-4f92-a00d-7ac11ad5746b" class="image"><a href="Library%20Do%2052fb4/Screen_Recording_2022-03-18_at_17.02.17.gif"><img style="width:580px" src="Library%20Do%2052fb4/Screen_Recording_2022-03-18_at_17.02.17.gif"></a></figure><p id="9a96dfdd-98f1-449a-bce7-5e7d2f2e3001" class="">
</p></details></li></ul></div></article></body>
