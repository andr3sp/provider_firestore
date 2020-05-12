import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider_firestore/screens/page2.dart';

 class HomePage extends StatefulWidget {
   @override
   _HomePageState createState() => _HomePageState();
 }
 
 class _HomePageState extends State<HomePage> {
   
  Future _data;
  Future getPosts() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection('characters').getDocuments();
      return qn.documents;
  }
  
  Future<int> countHoras(String empleadoId) async {
    final query = await Firestore.instance
        .collection('characters')
        .document(empleadoId)
        .collection('habilidades')
        .getDocuments();

    final total = query.documents
        .map((doc) => int.parse(doc.data['horas']))
        .fold(0, (previous, element) => previous + element);

    return total;
  }



/*   
  Future<int> countHoras(String empleadoId) async {
    final query = await Firestore.instance
        .collection('characters')
        .document(empleadoId)
        .collection('habilidades')
        .getDocuments();

    final total = query.documents
        .map((doc) => doc.data['horas'] as int)
        .fold(0, (previous, element) => previous + element);

    return total;
  } */


  navigateToDetail(DocumentSnapshot post){
  Navigator.push(context, MaterialPageRoute(builder: (context) => SecondPage(post: post,)));///////////////////
  }

  @override
  void initState(){
    super.initState();
    _data = getPosts();
  }

    @override
   Widget build(BuildContext context) {

     return Scaffold(
          appBar: AppBar(backgroundColor: Colors.blueGrey,
          title: Text('Heroes', style: TextStyle(fontSize: 32,)), ),    
          body:Container(
             child: FutureBuilder(
             future: _data,
             builder: (_, snapshot){ 
             if (snapshot.connectionState == ConnectionState.waiting) {
               return Center(
                 child: Column( mainAxisAlignment: MainAxisAlignment.center,
                   children: <Widget>[CircularProgressIndicator(), Text('Please wait...'),],),
               );
               
             } else {
              return ListView.builder(
                 itemCount: snapshot.data.length,
                 itemBuilder: (_, index){
                    return Card(
                        color: Colors.white54,
                        child: ListTile(
                          leading: Icon(
                            Icons.account_circle,
                            size: 40.0,
                          ),
                          title: Text(snapshot.data[index].data['name']),
                          trailing: FutureBuilder(
                            future: countHoras(snapshot.data[index].documentID),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else {
                                if (snapshot.hasData) {
                                  return Text("Total horas:${snapshot.data}");
                                }
                                return null;
                              }
                            },
                          ),
                          //   SEND DATA
                          onTap: () => navigateToDetail(snapshot.data[index]),
                        ),
                      );
                


               });
             }
           }),
    ),
       );
   }
 }