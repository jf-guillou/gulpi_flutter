import 'package:flutter/material.dart';
import 'package:gulpi/models/searchcriteria_model.dart';
import 'package:gulpi/utilities/item_types.dart';

class SearchCriterionListTile extends StatefulWidget {
  const SearchCriterionListTile({super.key});

  @override
  State<SearchCriterionListTile> createState() =>
      _SearchCriterionListTileState();
}

class _SearchCriterionListTileState extends State<SearchCriterionListTile> {
  // FIXME: Generic ItemType
  final SearchCriteria _c = SearchCriteria(ItemType.computer)
      .uid("Computer.name")
      .searchType("contains");

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Row(
      children: [
        Text(_c.field?.toString() ?? ""),
        Text(_c.searchtype ?? ""),
        const Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Enter a search term',
            ),
          ),
        )
      ],
    ));
  }
}
