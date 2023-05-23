class SearchOption {
  int? id;
  String? cat;
  late String uid;
  late String name;
  late String table;
  late String field;
  late String datatype;
  late bool nosearch;
  late bool nodisplay;
  late List<String> availableSearchtypes;

  SearchOption.readJson(Map<String, dynamic> json) : super() {
    uid = json['uid'] is int ? json['uid'].toString() : json['uid'];
    name = json['name'];
    table = json['table'];
    field = json['field'];
    datatype = json['datatype'];
    nosearch = json['nosearch'];
    nodisplay = json['nodisplay'];
    availableSearchtypes = json['availableSearchtypes'];
  }
}
