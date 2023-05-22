class Item {
  late String id;
  String? assetTag;
  String? name;
  String? status;

  Item.readJson(Map<String, dynamic> json) : super() {
    id = json['id'] is int ? json['id'].toString() : json['id'];
  }
}
