import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_firestore/models/ability_model.dart';
import 'package:provider_firestore/providers/provider.dart';
import 'package:provider_firestore/services/firestore_service.dart';


class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var myProvider = Provider.of<MyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Abilities'),),
      body: SafeArea(
        child: Center(child: _lista(),),),

      floatingActionButton: FloatingActionButton.extended(
        label: Text(myProvider.nombre, style: TextStyle(fontSize: 21)),
        icon: Icon(Icons.add),
        onPressed: (){},
      ),

    );
  }

/////////////////////////////////////////////////////////////////////////////
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
                trailing: Text("${myData.abilities}"),
                //leading: Text(myProvider.nombre),
              );
           },
          );
        },
      ),
      );
  }
}