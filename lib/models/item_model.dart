class Item {
  late String id;

  Item.readJson(Map<String, dynamic> json) : super() {
    id = json['id'] is int ? json['id'].toString() : json['id'];
  }
}
