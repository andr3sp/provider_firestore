import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_dropdown/find_dropdown.dart';
import 'package:provider_firestore/models/hero_model.dart';

class SecondPage extends StatefulWidget {

final DocumentSnapshot post;
  SecondPage({this.post});

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  String charPoder;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post.data["name"]),),      //// Viene de la Pagina 1
      body: SafeArea(
        child: Center(
          child: _lista(),),
          ),

        floatingActionButton: FloatingActionButton.extended(
        label: Text('New', style: TextStyle(fontSize: 21)),
        icon: Icon(Icons.add),

        onPressed: () { addDialog(context);  },   
        
        /* onPressed: () {
            Firestore.instance.collection('characters').document(post.documentID).collection('habilidades').add(
            {
              'poder': 'Volar',
            },
          );
        }, */
      ),


    );
  }



  Widget _lista(){
        return Container(
       child: StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('characters').document(widget.post.documentID).collection('habilidades').snapshots(),
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
                        onPressed: () { editDialog(context);  },
                        /* onPressed: () {
                          document.reference.updateData({'poder': 'Fuerza'}); ////////// EDITAR
                        } */
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

Future<bool> addDialog(BuildContext context) async {
  return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Add Data', style: TextStyle(fontSize: 15.0)),
            content: Container(
                height: 300.0,
                width: 200.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  /* TextField(
                    decoration: InputDecoration(hintText: 'Enter Name'),
                    onChanged: (value) {
                      this.charPoder = value;
                    }), */

                  
              FindDropdown<HeroModel>(
              label: "Personagem",
              onFind: (String filter) => getData(filter),
              onChanged: (HeroModel data) {
                print(data);
              },
              dropdownBuilder: (BuildContext context, HeroModel item) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child: (item?.avatar == null)
                      ? ListTile(
                          leading: CircleAvatar(),
                          title: Text("No item selected"),
                        )
                      : ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(item.avatar),
                          ),
                          title: Text(item.name),
                          subtitle: Text(item.createdAt.toString()),
                        ),
                );
              },
              dropdownItemBuilder:
                  (BuildContext context, HeroModel item, bool isSelected) {
                return Container(
                  decoration: !isSelected
                      ? null
                      : BoxDecoration(
                          border:
                              Border.all(color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                  child: ListTile(
                    selected: isSelected,
                    title: Text(item.name),
                    subtitle: Text(item.createdAt.toString()),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(item.avatar),
                    ),
                  ),
                );
              },
            ),






                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Add'),
                textColor: Colors.blue,
                onPressed: () {

                  Navigator.of(context).pop();

                  Firestore.instance.collection('characters').document(widget.post.documentID)
                  .collection('habilidades').add( { 'poder': 'test', });
             
                 /*  Firestore.instance
                  .collection('characters').document(widget.post.documentID)
                  .collection('habilidades')
                  .add(
                      { 'poder': 'Volar' });
                   */
                },
              )
            ],
          );
        });
  }

Future<List<HeroModel>> getData(filter) async {
    var response = await Dio().get(
      "http://5d85ccfb1e61af001471bf60.mockapi.io/user",
      queryParameters: {"filter": filter},
    );

    var models = HeroModel.fromJsonList(response.data);
    return models;
  }





Future<bool> editDialog(context) async {
  return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Edit Data', style: TextStyle(fontSize: 15.0)),
            content: Container(
                height: 125.0,
                width: 150.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(hintText: 'Update Name'),
                    onChanged: (value) {
                      this.charPoder = value;
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Save'),
                textColor: Colors.blue,
                onPressed: () {

                  //Navigator.of(context).pop();

                  
                  Navigator.of(context).pop();

                  //document.reference.updateData({'poder': 'Fuerza'});

                  


                },
              )
            ],
          );
        });
  }







}
