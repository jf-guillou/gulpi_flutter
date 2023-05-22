class SearchOption {
  late String uid;
  late String name;
  late String table;
  late String field;
  late String linkfield;
  late String datatype;

  SearchOption.readJson(Map<String, dynamic> json) : super() {
    uid = json['uid'] is int ? json['uid'].toString() : json['uid'];
    name = json['name'];
    table = json['table'];
    field = json['field'];
    linkfield = json['linkfield'];
    datatype = json['datatype'];
  }
}
