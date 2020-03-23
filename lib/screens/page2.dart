import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class SecondPage extends StatelessWidget {

final DocumentSnapshot post;
  SecondPage({this.post});

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text(post.data["name"]),),      //// Viene de Pagina 1
      body: SafeArea(
        child: Center(child: _lista(),),),

    );
  }

  Widget _lista(){
        return Container(
       child: StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('characters').document(post.documentID).collection('habilidades').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default:
            return new ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                return new ListTile(
                  title: new Text(document.documentID),
                  //subtitle: new Text(document['poder']),
                );
              }).toList(),
            );
        }
      },
      ),
        );
  }
}