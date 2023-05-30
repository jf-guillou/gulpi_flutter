import 'package:gulpi/models/item_model.dart';
import 'package:gulpi/models/note_model.dart';

class Computer extends Item {
  late String serial;
  late String assetTag;
  late int state;
  late int model;
  late int manufacturer;
  List<Note>? notes;

  Computer.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    serial = json['serial'];
    assetTag = json['otherserial'];
    state = json['states_id'];
    model = json['computermodels_id'];
    manufacturer = json['manufacturers_id'];
    if (json['_notes'] != null) {
      notes = List.from(json['_notes'].map((e) => Note.fromJson(e)));
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      "serial": serial,
      "otherserial": assetTag,
      "states_id": state,
      "computermodels_id": model,
      "manufacturers_id": manufacturer,
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
    if (model != c.model) f['computermodels_id'] = model;
    if (manufacturer != c.manufacturer) f['manufacturers_id'] = manufacturer;
    return f;
  }
}
