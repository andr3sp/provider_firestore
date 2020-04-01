//Created on http://app.quicktype.io/

class HeroModel {
  final String id;
  final DateTime createdAt;
  final String name;
  final String avatar;

  HeroModel({this.id, this.createdAt, this.name, this.avatar});

  factory HeroModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return HeroModel(
      id: json["id"],
      createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      name: json["name"],
      avatar: json["avatar"],
    );
  }

  static List<HeroModel> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => HeroModel.fromJson(item)).toList();
  }


  @override
  String toString() => name;

  @override
  operator ==(o) => o is HeroModel && o.id == id;

  @override
  int get hashCode => id.hashCode^name.hashCode^createdAt.hashCode;

}