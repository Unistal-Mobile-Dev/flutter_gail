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
        return "https://oil-pims-prod.oilindia.in/";
      case EnvironmentFlavours.developmentIglCng:
        // return "https://tpimso.smartgasnet.com/";
        return "https://tpimsdev.smartgasnet.com/";
    }
  }
}

enum EnvironmentFlavours { productionIglCng, developmentIglCng }
