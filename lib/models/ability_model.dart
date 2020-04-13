import 'package:cloud_firestore/cloud_firestore.dart';

class Ability {
  String _id;
  String _poder;
  String _avatar;

  String get id => _id;

  String get poder => _poder;

  String get avatar => _avatar;

  Ability.fromSnapshot(DocumentSnapshot snapshot) {
    _id = snapshot.documentID;
    _poder = snapshot.data['poder'] ?? null;
    _avatar = snapshot.data['avatar'] ?? null;
  }
}