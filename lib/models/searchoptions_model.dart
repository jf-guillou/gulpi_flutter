import 'package:gulpi/models/searchoption_model.dart';

class SearchOptions {
  List<SearchOption> arr = [];

  SearchOptions.readJson(Map<String, dynamic> json) : super() {
    String? currentCat;
    json.forEach((key, value) {
      int? intKey = int.tryParse(key);
      if (intKey != null) {
        SearchOption opt = SearchOption.readJson(value);
        opt.id = intKey;
        opt.cat = currentCat;
        arr.add(opt);
      } else {
        currentCat = key;
      }
    });
  }
}
