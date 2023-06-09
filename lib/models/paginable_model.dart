import 'package:gulpi/models/searchitem_model.dart';

typedef Itemizer<S> = S Function(Map<String, dynamic> item);

class Paginable<T extends SearchItem> {
  late int totalcount;
  late int count;
  late String sort;
  late String order;
  late String range;
  late List<T> items;

  Paginable() {
    totalcount = 0;
    count = 0;
    sort = "";
    order = "";
    range = "";
    items = [];
  }

  Paginable.fromJson(Map<String, dynamic> json, Itemizer<T> itemizer)
      : super() {
    totalcount = json['totalcount'];
    count = json['count'];
    sort = json['sort'][0];
    order = json['order'][0];
    range = json['content-range'];
    items = [];

    if (json['data'] != null) {
      for (var item in json['data']) {
        items.add(itemizer(item));
      }
    }
  }

  // T? getById(String? id) {}

  Paginable<T> mergeWith(Paginable<T> p) {
    totalcount = p.totalcount;
    count = count + p.count;
    items.addAll(p.items);

    return this;
  }
}
