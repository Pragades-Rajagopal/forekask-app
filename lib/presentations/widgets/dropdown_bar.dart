import 'package:flutter/material.dart';

class DropdownBar extends StatelessWidget {
  final String selectedValue;
  final List<String> items;
  final Function(String?)? onChanged;
  const DropdownBar({
    super.key,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      elevation: 2,
      style: TextStyle(
        fontSize: 18.0,
        color: Theme.of(context).colorScheme.primary,
      ),
      dropdownColor: Theme.of(context).colorScheme.secondaryContainer,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 4),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
      ),
      value: selectedValue,
      onChanged: onChanged,
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      icon: Icon(
        Icons.arrow_drop_down_sharp,
        color: Theme.of(context).colorScheme.primary,
        size: 28.0,
      ),
    );
  }
}
