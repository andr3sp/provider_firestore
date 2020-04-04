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
  String avatar;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post.data["name"]),  //// Viene de la Pagina 1
        ), 
      body: SafeArea(
        child: Center(
          child: _lista(),),
          ),

        floatingActionButton: FloatingActionButton.extended(
          label: Text('New', style: TextStyle(fontSize: 21)),
          icon: Icon(Icons.add),

          onPressed: () { addDialog(context);},   
        
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
                  leading: CircleAvatar(backgroundImage: NetworkImage(document['avatar'])),
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


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Future<bool> addDialog(BuildContext context) async {
  return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Add Data', style: TextStyle(fontSize: 18.0)),
            content: Container(
                height: 300.0,
                width: 200.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  
                  FindDropdown<HeroModel>(
                  label: "Abilities",
                  onFind: (String filter) => getData(filter),
                  onChanged: (HeroModel data) {
                    print(data);
                    charPoder = data.name;
                    avatar = data.avatar;                         //// Poder
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
                              title: Text("Choose one"),
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
                  .collection('habilidades').add( 
                    { 
                      'poder'   : charPoder,
                      'avatar'  : avatar,
                       });
                  print(widget.post.data);
             
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


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Future<bool> editDialog(context) async {
  return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Edit Data', style: TextStyle(fontSize: 18.0)),
            content: Container(
                height: 160.0,
                width: 180.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[




                  FindDropdown<HeroModel>(
                  label: "Abilities",
                  onFind: (String filter) => getData(filter),
                  onChanged: (HeroModel data) {
                    print(data);
                    charPoder = data.name;
                    avatar = data.avatar;                         //// Poder
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
                              title: Text("Choose one"),
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
                child: Text('Save'),
                textColor: Colors.blue,
                onPressed: () {


                  Navigator.of(context).pop();

                  Firestore.instance.collection('characters').document(widget.post.documentID)
                  .collection('habilidades').add( 
                    { 
                      'poder'   : charPoder,
                      'avatar'  : avatar,
                       });
                  print(widget.post.data);

                },
              )
            ],
          );
        });
  }

////////////////////////////////////////// A  P  I //////////////////////////

Future<List<HeroModel>> getData(filter) async {
    var response = await Dio().get(
      "http://5da0f76a525b79001448a23b.mockapi.io/poder",
      queryParameters: {"filter": filter},
    );

    var models = HeroModel.fromJsonList(response.data);
    return models;
  }




}
