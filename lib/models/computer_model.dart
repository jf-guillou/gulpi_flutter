import 'package:gulpi/models/item_model.dart';

class Computer extends Item {
  late String name;
  late String serial;
  late String assetTag;
  late int state;

  Computer.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    name = json['name'];
    serial = json['serial'];
    assetTag = json['otherserial'];
    state = json['states_id'];
  }

  Map toJson() {
    return {
      "name": name,
      "serial": serial,
      "otherserial": assetTag,
      "states_id": state,
    };
  }
}
