import 'package:gulpi/models/base_model.dart';

typedef Itemizer<S> = S Function(Map<String, dynamic>? item);

class Paginable<T extends BaseModel> {
  late int totalcount;
  late int count;
  late String sort;
  late String order;
  late String range;
  late List<T> items;

  Paginable.readJson(Map<String, dynamic> json, Itemizer<T> itemizer)
      : super() {
    totalcount = json['totalcount'];
    count = json['count'];
    sort = json['sort'][0];
    order = json['pages'][0];
    range = json['content-range'];
    items = [];

    for (var item in json['data']) {
      items.add(itemizer(item));
    }
  }

  // T? getElementById(String? id) {}

  Paginable<T> mergeWith(Paginable<T> p) {
    totalcount = p.totalcount;
    count = count + p.count;
    items.addAll(p.items);

    return this;
  }
}
