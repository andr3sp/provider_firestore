import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_firestore/models/ability_model.dart';
import 'package:provider_firestore/providers/provider.dart';
import 'package:provider_firestore/services/firestore_service.dart';


class SecondPage extends StatelessWidget {

final DocumentSnapshot post;
  SecondPage({this.post});

  @override
  Widget build(BuildContext context) {

    var myProvider = Provider.of<MyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(post.data["name"]),),      //////// Viene de Pagina 1
      body: SafeArea(
        child: Center(child: _lista(),),),

      floatingActionButton: FloatingActionButton.extended(
        label: Text(myProvider.nombre, style: TextStyle(fontSize: 21)),           //// Test nombre provider  //
        icon: Icon(Icons.add),
        onPressed: (){},
      ),

    );
  }

/////////////////////////////////////////////////////////////////////////////
///
///
////* 
///  db.collection('heroes').document(id).collection('habilidades').get()
/// */
  Widget _lista(){
        return Container(
       child: StreamBuilder(

        stream: FirestoreService().getData(),
        builder: (BuildContext context, AsyncSnapshot<List<MyData>> snapshot){
          if(snapshot.hasError || !snapshot.hasData)
            return CircularProgressIndicator();
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              MyData myData = snapshot.data[index];
              return ListTile(
                title: Text("${myData.name}"),
                trailing: Text("poder?"),
              );
           },
          );
        },
      ),
      );
  }
}