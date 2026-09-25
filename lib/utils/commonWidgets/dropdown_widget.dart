import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/utils/res/environment_config.dart';

class DropdownWidget extends StatelessWidget {
  final dynamic dropdownValue;
  final String hint;
  final ValueChanged<dynamic>? onChanged;
  final List<DropdownMenuItem<dynamic>>? items;
  final bool? isRequired;
  final bool? isBoardRemoved;

  const DropdownWidget({
    super.key,
    required this.dropdownValue,
    required this.onChanged,
    required this.items,
    required this.hint,
    this.isRequired,
    this.isBoardRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: isBoardRemoved == true ? null
          :  BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: AppColor.grey, style: BorderStyle.solid, width: 0.80),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          dropdownValue != null
              ? hint.isNotEmpty ?
              Padding(
                  padding: const EdgeInsets.only(top: 2, bottom: 2),
                  child: Text.rich(TextSpan(children: [
                    TextSpan(
                        text: hint,
                        style: TextStyle(
                          color: EnvironmentConfig.of(context)!.primaryTheme,
                          fontSize: AppFont.font_14,
                        )),
                    TextSpan(
                        text: isRequired == false ? "" : ' *',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: AppFont.font_14,
                        )),
                  ])),
                ) : const SizedBox.shrink()
              : const SizedBox.shrink(),
          DropdownButton<dynamic>(
            hint: hint.isNotEmpty ?
            Text.rich(TextSpan(children: [
              TextSpan(
                  text: hint,
                  style: TextStyle(
                    color: EnvironmentConfig.of(context)!.primaryTheme,
                    fontSize: AppFont.font_14,
                  )),
              TextSpan(
                  text: isRequired == true ? " *" : '',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: AppFont.font_14,
                  )),
            ])) : null,
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
