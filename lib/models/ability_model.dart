class MyData {
  final String id;
  final String name;
  final String abilities;


  MyData( {this.id, this.name, this.abilities, });

  MyData.fromMap(Map<String,dynamic> data, String id):
    id=id,
    name=data['name'],
    abilities=data['abilities'];

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "abilities": abilities,
    };
  }

}
