class ItemState {
  late int id;
  late String name;

  ItemState.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map toJson() {
    return {
      "id": id,
      "name": name,
    };
  }
}
