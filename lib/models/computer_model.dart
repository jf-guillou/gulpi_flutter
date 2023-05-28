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

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "serial": serial,
      "otherserial": assetTag,
      "states_id": state,
    };
  }

  Computer clone() {
    return Computer.fromJson(toJson());
  }

  Map<String, dynamic> diff(Computer c) {
    Map<String, dynamic> f = {};
    if (name != c.name) f['name'] = name;
    if (serial != c.serial) f['serial'] = serial;
    if (assetTag != c.assetTag) f['otherserial'] = assetTag;
    if (state != c.state) f['states_id'] = state;
    return f;
  }
}
