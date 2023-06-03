import 'package:gulpi/models/base_model.dart';

abstract class Item extends BaseModel {
  late int id;
  late String name;
  late String comment;
  late DateTime createdAt;
  late DateTime modifiedAt;

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    comment = json['comment'];
    createdAt = DateTime.parse(json['date_creation']);
    modifiedAt = DateTime.parse(json['date_mod']);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "comment": comment,
      "date_creation": createdAt.toIso8601String(),
      "date_mod": modifiedAt.toIso8601String()
    };
  }
}
