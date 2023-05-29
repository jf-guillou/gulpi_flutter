import 'package:gulpi/models/item_model.dart';

class ItemState extends Item {
  ItemState.fromJson(Map<String, dynamic> json) : super.fromJson(json) {}

  @override
  Map<String, dynamic> toJson() {
    return {...super.toJson()};
  }
}
