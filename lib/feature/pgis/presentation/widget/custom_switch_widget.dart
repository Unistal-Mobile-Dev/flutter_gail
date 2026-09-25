import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/utils/res/environment_config.dart';

class CustomSwitch extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(
          color: EnvironmentConfig.of(context)!.secondaryTheme,
          fontWeight: FontWeight.bold
        ),),
        GestureDetector(
          onTap: () => onChanged(!value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 230),
            width: 52,
            height: 31,
            padding: const EdgeInsets.all(2.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: value
                  ? EnvironmentConfig.of(context)!.secondaryTheme
                  : const Color(0xFFE5E5EA),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 230),
              alignment:
              value ? Alignment.centerRight : Alignment.centerLeft,
              curve: Curves.easeInOut,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.22),
                      blurRadius: 4,
                      offset: const Offset(0, 1.5),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
