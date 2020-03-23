import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider_firestore/models/ability_model.dart';

class FirestoreService {

  static final FirestoreService _firestoreService = FirestoreService._internal();
  Firestore _db = Firestore.instance;
  FirestoreService._internal();

  factory FirestoreService() {
    return _firestoreService;
  }

//////////////// GET DATA 
  Stream<List<MyData>> getData() {
    return _db
          .collection('Abilities')
          //.where('name', isEqualTo: ? )
          .snapshots().map(
          (snapshot) => snapshot.documents.map( (doc) => MyData.fromMap(doc.data, doc.documentID),
          ).toList(),
        );
  }
  
////////////////// ADD DATA
  Future<void> addMyData(MyData myData) {
    return _db
    .collection('Abilities').add(myData.toMap());
  }

///////////////// DELETE DATA
  Future<void> deleteMyData(String id) {
    return _db.collection('Abilities').document(id).delete();
  }

//////////////////// UPDATE DATA
  Future<void> updateMyData(MyData myData) {
    return _db.collection('Abilities').document(myData.id).updateData(myData.toMap());
  }

}