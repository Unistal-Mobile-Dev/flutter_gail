import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';

class DropDownSearchMultiSelectWidget extends StatelessWidget {
  final List<dynamic> items;
  final ValueChanged<dynamic> onChanged;
  final DropdownSearchItemAsString<dynamic>? itemAsString;
  final String hint;
  final List<dynamic>? selectedItem;

  const DropDownSearchMultiSelectWidget({
    super.key,
    required this.items,
    required this.onChanged,
    required this.itemAsString,
    required this.hint,
    this.selectedItem,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      /*  height: MediaQuery.of(context).size.height * 0.07,*/
      child: DropdownSearch<dynamic>.multiSelection(
        selectedItems: selectedItem ?? [],
        compareFn: (i, s) => i.isEqual(s),
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
