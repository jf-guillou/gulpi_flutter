import 'package:gulpi/models/base_model.dart';

class SearchItem extends BaseModel {
  late String id;
  late String name;

  SearchItem.fromJson(Map<String, dynamic> json) : super() {
    id = json['2'] is int ? json['2'].toString() : json['2'];
    name = json['1'];
  }

  Map toJson() {
    return {};
  }
}
