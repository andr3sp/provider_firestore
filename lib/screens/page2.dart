import 'package:flutter/material.dart';
import 'package:flutter_fluid_slider/flutter_fluid_slider.dart';
import 'package:intl/intl.dart';
import 'package:provider_firestore/models/ability_model.dart';
import 'package:provider_firestore/models/hero_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:find_dropdown/find_dropdown.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

class SecondPage extends StatefulWidget {
  final DocumentSnapshot post;
  SecondPage({this.post});

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {


  DateTime _timeStamp = DateTime.now();
  String charPoder;
  String avatar;
  DatePickerController _controller = DatePickerController();
  DateTime _selectedValue = DateTime.now();

  double _value1 = 0.0;
  


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.post.data["name"]),),
      body: SafeArea(
        child: Center(
          child: _lista(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('New', style: TextStyle(fontSize: 30.0)),
        icon: Icon(Icons.add),
        onPressed: () { addDialog(context); },
      ),
    );
  }

  Widget _lista() {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('characters').document(widget.post.documentID)
            .collection('habilidades')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...');
            default:
              return ListView(
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                  return ListTile(
                    title: Text(document['poder']),
                    subtitle: Text( document['timestamp'], style: TextStyle(fontSize: 6.0)), 
                    leading: CircleAvatar(backgroundImage: NetworkImage(document['avatar'])),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[

                        Text(DateFormat.MMMd('es_ES').format(document['fecha'].toDate())),        //////// Lista registros x TimeStamp
                        
                        IconButton(
                          color: Colors.blue,
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            final ability = Ability.fromSnapshot(document);
                            editDialog(context, ability);    ///// EDITAR
                          },
                          ),

                        IconButton(
                          color: Colors.red,
                          icon: Icon(Icons.delete),
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
              height: 800.0,
              width: 500.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //////////////////////////////////////////////
                  Container(
                    child: DatePicker(
                      DateTime.now().add(Duration(days: -3)),
                      width: 65,
                      height: 85,
                      controller: _controller,
                      initialSelectedDate: DateTime.now(),
                      selectionColor: Colors.blueGrey,
                      selectedTextColor: Colors.white,
                      onDateChange: (date) {
                        // New date selected
                        setState(() {
                          _selectedValue = date;
                          print(_selectedValue);
                          });
                      },
                    ),
                  ),
                  /////////////////////////////////////////////
                  Divider(color: Colors.transparent, height: 30.0,),


                  FindDropdown<HeroModel>(
                    //label: "Abilities",
                    onFind: (String filter) => getData(filter),
                    onChanged: (HeroModel data) {
                      
                      print(data);

                        charPoder = data.name;
                        avatar = data.avatar;

                       },
                    dropdownBuilder: (BuildContext context, HeroModel item) {
                      return Container(
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Theme.of(context).dividerColor),
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        child: (item?.avatar == null)
                            ? ListTile(
                                leading: CircleAvatar(),
                                title: Text("Choose Abilitie"),
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
                    dropdownItemBuilder: (BuildContext context, HeroModel item,
                        bool isSelected) {
                      return Container(
                        decoration: !isSelected
                            ? null
                            : BoxDecoration(
                                border: Border.all(
                                    color: Theme.of(context).primaryColor),
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

                  /////////////////////////////////////////////
                  Divider(color: Colors.transparent, height: 30.0,),


                  FluidSlider(
              value: _value1,
              onChanged: (double newValue) {
                setState(() {
                  _value1 = newValue;
                });
              },
              min: 0.0,
              max: 10.0,
            ),







                
                
                
                ],
              ),
            ),
            
            
            actions: <Widget>[
              FlatButton(
                color: Colors.blueGrey,
                padding: EdgeInsets.all(15.0),
                child: Text('Add Data', style: TextStyle(fontSize: 21.0)),
                textColor: Colors.white,
                onPressed: () {
                  Navigator.of(context).pop();

                  Firestore.instance
                      .collection('characters')
                      .document(widget.post.documentID)
                      .collection('habilidades')
                      .add({
                        
                            'timestamp'  :   _timeStamp.toIso8601String(),
                            'poder'      :   charPoder,
                            'avatar'     :   avatar,
                            'fecha'      :   _selectedValue,
                    
                  });
                },
              )
            ],
          );
        });
  }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Future<bool> editDialog(context, Ability itemSelected) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Edit Data', style: TextStyle(fontSize: 18.0)),
            content: Container(
              height: 500.0,
              width: 400.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[


                  //////////////////////////////////////////////
                  Container(
                    child: DatePicker(
                      DateTime.now().add(Duration(days: -3)),
                      width: 65,
                      height: 85,
                      controller: _controller,
                      initialSelectedDate: _selectedValue,
                      //initialSelectedDate: DateTime.now(),
                      selectionColor: Colors.blueGrey,
                      selectedTextColor: Colors.white,
                      onDateChange: (date) {
                        // New date selected
                        setState(() {

                          _selectedValue = date;

                          print(_selectedValue);
                          
                          });
                      },
                    ),
                  ),
                  /////////////////////////////////////////////
                  Divider(color: Colors.transparent, height: 30.0,),


                  FindDropdown<HeroModel>(
                    label: "Abilities",
                    onFind: (String filter) => getData(filter),
                    onChanged: (HeroModel data) {
                      print(data);
                      charPoder = data.name;
                      avatar = data.avatar; 
                    },
                    dropdownBuilder: (BuildContext context, HeroModel item) {
                      return Container(
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Theme.of(context).dividerColor),
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        child: (item == null)
                            ? ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(itemSelected.avatar),
                                ),
                                title: Text(itemSelected.poder),
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
                    dropdownItemBuilder: (BuildContext context, HeroModel item,
                        bool isSelected) {
                      return Container(
                        decoration: !isSelected
                            ? null
                            : BoxDecoration(
                                border: Border.all(
                                    color: Theme.of(context).primaryColor),
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

                  Firestore.instance
                      .collection('characters')
                      .document(widget.post.documentID)
                      .collection('habilidades')
                      .document(itemSelected.id)
                      .updateData({
                        
                                'poder': charPoder,
                                'avatar': avatar,
                                'fecha'      :   _selectedValue,

                                                    });
                  

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
