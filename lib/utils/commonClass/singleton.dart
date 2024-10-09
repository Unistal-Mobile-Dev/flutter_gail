import 'package:flutter/cupertino.dart';

class Singleton {
  static final Singleton instance = Singleton._privateConstructor();

  factory Singleton() => instance;

  Singleton._privateConstructor();

  late BuildContext _context;

  BuildContext get context => _context;

  void setContext(BuildContext context) {
    _context = context;
  }
}
