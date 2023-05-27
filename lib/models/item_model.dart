class Item {
  late String id;
  String? assetTag;
  String? name;
  String? status;

  Item.fromJson(Map<String, dynamic> json) : super() {
    id = json['id'] is int ? json['id'].toString() : json['id'];
  }

  Map toJson() {
    return {
      "id": id,
    };
  }
}
