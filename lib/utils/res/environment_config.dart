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
        return "http://192.168.10.200:8000/";
      case EnvironmentFlavours.developmentIglCng:
        return "http://192.168.10.200:8000/";
    }
  }
}

enum EnvironmentFlavours { productionIglCng, developmentIglCng }
