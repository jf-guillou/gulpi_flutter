import 'package:gulpi/models/searchcriteria_model.dart';

class SearchCriterion {
  final List<SearchCriteria> _arr = [];

  void add(SearchCriteria c) {
    _arr.add(c);
  }

  Map<String, String> toUrlQuery() {
    int i = 0;
    Map<String, String> qs = {};
    for (SearchCriteria sc in _arr) {
      sc.toJson().forEach((key, value) {
        if (value == null) {
          return;
        }

        qs["criteria[$i][$key]"] = value.toString();
      });
      i++;
    }

    return qs;
  }
}
