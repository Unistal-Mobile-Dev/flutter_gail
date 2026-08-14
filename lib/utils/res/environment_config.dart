import 'package:flutter/material.dart';

@immutable
class EnvironmentConfig extends InheritedWidget {
  final EnvironmentFlavours flavours;

  const EnvironmentConfig({
    super.key,
    required this.flavours,
    required super.child,
  });

  static EnvironmentConfig? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType();
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    throw false;
  }

  String get generalUrlBaseOnFlavour {
    switch (flavours) {
      case EnvironmentFlavours.prodHPOIL:
       // return "https://hpoil.smartgasnet.com/";
        return "http://gis.hpoilgas.in/";
      case EnvironmentFlavours.prodHPCL:
        return "https://hpcl.smartgasnet.com/";
    }
  }

  String get generalGailUrlBaseOnFlavour {
    switch (flavours) {
      case EnvironmentFlavours.prodHPOIL:
        // return "http://115.241.54.252:8000/";
      //  return "https://gailgis.gail.co.in/";
        return "http://gis.hpoilgas.in/";
      case EnvironmentFlavours.prodHPCL:
        return "https://hpcl.smartgasnet.com/";
    }
  }

  Color get primaryTheme {
    switch (flavours) {
      case EnvironmentFlavours.prodHPOIL:
        return Color(0xFF2E8B3A);
      case EnvironmentFlavours.prodHPCL:
        return Color(0xFF1A237E);
    }
  }

  Color get secondaryTheme {
    switch (flavours) {
      case EnvironmentFlavours.prodHPOIL:
        return Color(0xFF1A3A8C);
      case EnvironmentFlavours.prodHPCL:
        return Color(0xFFC62828);
    }
  }
}

enum EnvironmentFlavours { prodHPOIL, prodHPCL}
