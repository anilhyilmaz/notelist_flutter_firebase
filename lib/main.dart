import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_notelist/notlarim.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: _initialization, builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
          if(snapshot.hasError){
            return Center(child: Text('beklenilmeyen bir hata oluştu'),);
          }
          else if(snapshot.hasData){
            return MyHomePage(title: "Flutter Demo home Page" );
          }
          else{
            return Center(child: CircularProgressIndicator());
          }
      },
      )
    );
  }
}

class MyHomePage extends StatefulWidget {
  final firestore = FirebaseFirestore.instance;
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final _controllertitle = TextEditingController();
  final _controllernote = TextEditingController();
  var val_title;
  var val_note;
  void _save_list() {
    setState(() {
      CollectionReference notelistRef = FirebaseFirestore.instance.collection('notelist');
      Map<String,dynamic> noteData = {'title':val_title,'note':val_note};
      notelistRef.add(noteData);
      _controllernote.clear();
      _controllertitle.clear();
      Center(child: AlertDialog(title: Text('Added Successfully'),));
      print('$val_title');
      print('$val_note');
      // notelistRef.add({'title':'$val_title'});
      // notelistRef.add({'note':'$val_note'});
      print('kaydedildi');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(child: Column(
        children: [
          Flexible(flex: 3,child: Container(color: Colors.green,)),
          Flexible(flex:4,child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: GestureDetector(onTap: (){
              print('Main Page tıklandı');
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage(title: 'Main Page')));
            },child: Text('Main Page',style: TextStyle(fontSize: 20),)),
          )),
          Flexible(flex:4,child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: GestureDetector(onTap: (){
              print('notlarım tıklandı');
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => notlarim()));
            },child: Text('Notlarım',style: TextStyle(fontSize: 20),)),
          ),),
        ],
      ),),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          TextField(maxLines: 1,controller: _controllertitle,onChanged: (val){
            val_title = _controllertitle.text.toString();
          },),
          TextField(maxLines: 6,controller: _controllernote,onChanged: (val){
            val_note = _controllernote.text.toString();
          },),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _save_list,
        tooltip: 'save',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
