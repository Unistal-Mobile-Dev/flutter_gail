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
      case EnvironmentFlavours.productionHPOIL:
       // return "https://upims.gail.co.in:8000/";
        return "https://hpoil.smartgasnet.com/";
      case EnvironmentFlavours.developmentHPOIL:
     //   return "https://tpimsdev.smartgasnet.com/";
        return "https://hpoil.smartgasnet.com/";
    }
  }

  String get generalGailUrlBaseOnFlavour {
    switch (flavours) {
      case EnvironmentFlavours.productionHPOIL:
        return "https://gailgis.gail.co.in/";
      case EnvironmentFlavours.developmentHPOIL:
        // return "http://115.241.54.252:8000/";
        return "https://gailgis.gail.co.in/";
    }
  }
}

enum EnvironmentFlavours { productionHPOIL, developmentHPOIL }
