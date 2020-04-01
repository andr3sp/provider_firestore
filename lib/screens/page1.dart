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
                    return Card(color: Colors.white54,
                            child: ListTile(
                              leading: Icon(Icons.account_circle, size: 40.0,),
                              title: Text(snapshot.data[index].data['name']),
                              trailing: Text(snapshot.data[index].data['publisher']),
                                ///////// SEND DATA
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