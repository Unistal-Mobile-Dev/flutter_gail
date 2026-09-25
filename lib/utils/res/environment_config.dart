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
      case EnvironmentFlavours.productionIglCng:
        return "https://upims.gail.co.in:8000/";
      case EnvironmentFlavours.developmentIglCng:
        return "http://115.241.54.252:8000/";
    }
  }

  String get generalGailUrlBaseOnFlavour {
    switch (flavours) {
      case EnvironmentFlavours.productionIglCng:
        return "https://gailgis.gail.co.in/";
      case EnvironmentFlavours.developmentIglCng:
        // return "http://115.241.54.252:8000/";
        return "https://gailgis.gail.co.in/";
    }
  }

  Color get primaryTheme {
    switch (flavours) {
      case EnvironmentFlavours.productionIglCng:
        return Color(0xFFE63746);
      case EnvironmentFlavours.developmentIglCng:
        return Color(0xFFE63746);
    }
  }

  Color get secondaryTheme {
    switch (flavours) {
      case EnvironmentFlavours.productionIglCng:
        return Color(0xFFE74957);
      case EnvironmentFlavours.developmentIglCng:
        return Color(0xFFE74957);
    }
  }
}

enum EnvironmentFlavours { productionIglCng, developmentIglCng }
