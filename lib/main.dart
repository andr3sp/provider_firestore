import 'package:flutter/material.dart';
import 'package:provider_firestore/screens/page1.dart';
import 'package:provider/provider.dart';
import 'providers/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider( 
      create: (context)=>MyProvider(),
      child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Provider + Firestore',
      theme: ThemeData(primarySwatch: Colors.blueGrey,),
      home: HomePage(),
    ),
    );
  }
}

