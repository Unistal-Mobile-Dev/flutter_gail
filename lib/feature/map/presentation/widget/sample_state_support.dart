import 'package:flutter/material.dart';

mixin SampleStateSupport<T extends StatefulWidget> on State<T> {
  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }
}
