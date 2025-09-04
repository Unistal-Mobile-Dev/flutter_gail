import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

typedef SuggestionsCallback<T> = FutureOr<List<T>?> Function(String search);

class TypeaheadFieldWidget<T> extends StatelessWidget {
  final TextEditingController? controller;
  final SuggestionsCallback<T> suggestionsCallback;
  final void Function(T)? onSelected;
  final String label;
  final Widget? suffix;
  final bool? enabled;

  const TypeaheadFieldWidget({
    super.key,
    required this.suggestionsCallback,
    this.onSelected,
    this.label = 'Search',
    this.controller,
    this.suffix,
    this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<T>(
      controller: controller,
      suggestionsCallback: suggestionsCallback,
      itemBuilder: (context, suggestion) {
        return ListTile(
            tileColor: Colors.white,

            selectedTileColor: Colors.blue[100],
            title: Text(suggestion.toString()));
      },
      onSelected: onSelected,
      decorationBuilder: (context, child) {
        return Material(
          color: Colors.white,
          elevation: 4,
          borderRadius: BorderRadius.circular(8),
          child: child,
        );
      },

      builder: (context, controller, focusNode) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: label,
            suffixIcon: suffix,
            fillColor: Colors.white,
            enabled: enabled ?? true,
            filled: true,
            border: OutlineInputBorder(),
          ),
        );
      },
    );
  }
}
