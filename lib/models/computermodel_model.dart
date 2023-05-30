import 'package:gulpi/models/item_model.dart';

class ComputerModel extends Item {
  ComputerModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {}

  @override
  Map<String, dynamic> toJson() {
    return {...super.toJson()};
  }
}
