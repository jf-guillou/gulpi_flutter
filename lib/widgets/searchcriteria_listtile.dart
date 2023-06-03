import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gulpi/models/searchcriteria_model.dart';
import 'package:gulpi/services/cache_service.dart';
import 'package:gulpi/utilities/item_types.dart';

class SearchCriterionListTile extends StatefulWidget {
  final int position;
  const SearchCriterionListTile({required this.position, super.key});

  @override
  State<SearchCriterionListTile> createState() =>
      _SearchCriterionListTileState();
}

class _SearchCriterionListTileState extends State<SearchCriterionListTile> {
  // FIXME: Generic ItemType
  final SearchCriteria c = SearchCriteria(ItemType.computer)
      .uid("Computer.name")
      .searchType("contains");

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;
    return ListTile(
        title: Row(
      children: [
        widget.position > 0
            ? PopupMenuButton(
                onSelected: (v) {
                  setState(() {
                    c.link = v;
                  });
                },
                itemBuilder: (context) => SearchLink.all()
                    .map((e) => PopupMenuItem(value: e, child: Text(e.str())))
                    .toList(),
                child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(c.link.str())))
            : const SizedBox(),
        PopupMenuButton(
            onSelected: (v) {
              setState(() {
                c.field = v;
                c.searchtype = Cache()
                    .searchOptions[ItemType.computer]!
                    .getById(c.field!)!
                    .availableSearchtypes
                    .first;
              });
            },
            itemBuilder: (context) => Cache()
                .searchOptions[ItemType.computer]!
                .arr
                .map((e) => PopupMenuItem(value: e.id, child: Text(e.name)))
                .toList(),
            child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(Cache()
                    .searchOptions[ItemType.computer]!
                    .getById(c.field!)!
                    .name))),
        PopupMenuButton(
            onSelected: (v) {
              setState(() {
                c.searchtype = v;
              });
            },
            itemBuilder: (context) => c.field != null
                ? Cache()
                    .searchOptions[ItemType.computer]!
                    .getById(c.field!)!
                    .availableSearchtypes
                    .map((e) => PopupMenuItem(value: e, child: Text(e)))
                    .toList()
                : List<PopupMenuItem>.empty(),
            child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(c.searchtype ?? ""))),
        const Expanded(
            child: TextField(
                decoration: InputDecoration(enabledBorder: InputBorder.none)))
      ],
    ));
  }
}
