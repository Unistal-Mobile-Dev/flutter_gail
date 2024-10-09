import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';

class DropdownWidget extends StatelessWidget {
  final dynamic dropdownValue;
  final String hint;
  final ValueChanged<dynamic>? onChanged;
  final List<DropdownMenuItem<dynamic>>? items;
  final bool? isRequired;

  const DropdownWidget({
    super.key,
    required this.dropdownValue,
    required this.onChanged,
    required this.items,
    required this.hint,
    this.isRequired,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: AppColor.grey, style: BorderStyle.solid, width: 0.80),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          dropdownValue != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 2, bottom: 2),
                  child: Text.rich(TextSpan(children: [
                    TextSpan(
                        text: hint,
                        style: TextStyle(
                          color: AppColor.themeColor,
                          fontSize: AppFont.font_14,
                        )),
                    TextSpan(
                        text: isRequired == false ? "" : ' *',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: AppFont.font_14,
                        )),
                  ])),
                )
              : const SizedBox.shrink(),
          DropdownButton<dynamic>(
            hint: Text.rich(TextSpan(children: [
              TextSpan(
                  text: hint,
                  style: TextStyle(
                    color: AppColor.themeColor,
                    fontSize: AppFont.font_14,
                  )),
              TextSpan(
                  text: isRequired == true ? " *" : '',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: AppFont.font_14,
                  )),
            ])),
            underline: const SizedBox(),
            isExpanded: true,
            value: dropdownValue,
            items: items,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
