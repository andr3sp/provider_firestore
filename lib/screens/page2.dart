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
        child: Center(
          child: _lista(),),
          ),

        floatingActionButton: FloatingActionButton.extended(
        label: Text('Nuevo Poder', style: TextStyle(fontSize: 21)),
        icon: Icon(Icons.add),
        
        onPressed: () {
          
          Firestore.instance.collection('characters').document(post.documentID).collection('habilidades').add(
            {
              'poder': 'Volar',
            },
          );
        },
      ),


    );
  }

  Widget _lista(){
        return Container(
       child: StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('characters').document(post.documentID).collection('habilidades').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default:
            return ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document) {

                return ListTile(
                  title: Text(document['poder']),
                  //subtitle: Text(document['timestamp'].toString()),
                  trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[

                    IconButton(
                      color: Colors.blue, icon: Icon(Icons.edit),
                      onPressed: () {
                        document.reference.updateData({'poder': 'Fuerza'}); ////////// EDITAR
                      }
                    ),
                    IconButton(
                      color: Colors.red, icon: Icon(Icons.delete),
                      onPressed: () {
                        document.reference.delete(); ////// BORRAR
                      },          
                    ),
                  ],
                ),

                );
              }).toList(),
            );
        }
      },
      ),
        );
  }









}