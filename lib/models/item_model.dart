import 'package:gulpi/models/base_model.dart';

abstract class Item extends BaseModel {
  late int id;
  late String name;

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
    };
  }
}
