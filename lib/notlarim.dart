import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class notlarim extends StatefulWidget {
  const notlarim({Key? key}) : super(key: key);

  @override
  _notlarimState createState() => _notlarimState();
}

class _notlarimState extends State<notlarim> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference noteRef = firestore.collection('notelist');

    return Scaffold(
        body: FutureBuilder(
      future: _initialization,
      builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('beklenilmeyen bir hata oluştu'),
          );
        } else if (snapshot.hasData) {
          return Center(
              child: Column(
            children: [
              StreamBuilder(
                  stream: noteRef.snapshots(),
                  builder: (BuildContext context, AsyncSnapshot asyncsnapshot) {
                    List my_snapshot_list = asyncsnapshot.data.docs;
                    return Flexible(
                      child: ListView.builder(
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                  title: Text(
                                      '${my_snapshot_list[index].data()['title']}'),
                                  subtitle: Text(
                                      '${my_snapshot_list[index].data()['note']}'),
                                  trailing: GestureDetector(
                                      onTap: () {
                                        print('tıklandı');
                                        setState(() async {
                                          await my_snapshot_list[index]
                                              .reference
                                              .delete();
                                        });
                                      },
                                      child: Icon(Icons.delete))),
                            );
                          },
                          itemCount: my_snapshot_list.length),
                    );
                  }),
            ],
          ));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    ));
  }
}
