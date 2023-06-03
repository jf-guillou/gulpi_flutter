import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TextFieldPopup extends StatefulWidget {
  final String? header;
  final String? hint;
  final String? value;
  final Function onchange;
  const TextFieldPopup(this.onchange,
      {this.header, this.hint, this.value, Key? key})
      : super(key: key);

  @override
  State<TextFieldPopup> createState() => TextFieldPopupState();
}

class TextFieldPopupState extends State<TextFieldPopup> {
  String? textFieldValue;
  @override
  void initState() {
    textFieldValue = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(widget.header ?? ""),
      content: TextFormField(
        initialValue: widget.value,
        onChanged: (value) {
          textFieldValue = value;
        },
        decoration: InputDecoration(hintText: widget.hint),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(l10n.cancel.toUpperCase()),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text(l10n.ok.toUpperCase()),
          onPressed: () {
            widget.onchange(textFieldValue);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
