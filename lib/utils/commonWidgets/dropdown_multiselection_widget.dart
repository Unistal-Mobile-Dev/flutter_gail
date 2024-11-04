import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';

class DropDownSearchMultiSelectWidget extends StatelessWidget {
  final List<dynamic> items;
  final ValueChanged<dynamic> onChanged;
  final DropdownSearchItemAsString<dynamic>? itemAsString;
  final DropdownSearchCompareFn<dynamic>? compareFn;
  final String hint;
  final List<dynamic>? selectedItem;
  final OnItemAdded<dynamic>? onItemAdded;
  final OnItemAdded<dynamic>? onItemRemoved;
  final bool? showSearchBox;


  const DropDownSearchMultiSelectWidget({
    super.key,
    required this.items,
    required this.onChanged,
    required this.itemAsString,
    required this.hint,
    required this.compareFn,
    this.selectedItem,
    this.onItemAdded,
    this.onItemRemoved,
    this.showSearchBox,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      /*  height: MediaQuery.of(context).size.height * 0.07,*/
      child: DropdownSearch<dynamic>.multiSelection(
        selectedItems: selectedItem ?? [],
        compareFn: compareFn,
        decoratorProps: DropDownDecoratorProps(
          textAlign: TextAlign.start,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                width: 1,
                style: BorderStyle.none,
              ),
            ),
            hintStyle: TextStyle(
                fontSize: AppFont.font_14, color: AppColor.themeColor),
            contentPadding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.018,
              left: MediaQuery.of(context).size.height * 0.01,
            ),
            hintText: hint,
            filled: false,
          ),
        ),
        items: (filter, infiniteScrollProps) => items,
        itemAsString: itemAsString,
        onChanged: onChanged,
        popupProps: PopupPropsMultiSelection.dialog(
          onItemAdded: onItemAdded,
          onItemRemoved: onItemRemoved,
          searchFieldProps: TextFieldProps(
            style: TextStyle(fontSize: AppFont.font_13),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(fontSize: AppFont.font_13),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  width: 1,
                  style: BorderStyle.none,
                ),
              ),
            ),
          ),
          showSearchBox: showSearchBox ?? false,
          validationBuilder: (ctx, selectedItems) {
            return Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.30,
                  child: ButtonWidget(
                    onPressed: () {
                      onChanged.call(selectedItems);
                      Navigator.pop(context);
                    },
                    text: AppString.ok,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
