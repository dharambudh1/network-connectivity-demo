import 'package:flutter/material.dart';

class NavigatorService {
  static final NavigatorService _singleton = NavigatorService._internal();

  factory NavigatorService() {
    return _singleton;
  }

  NavigatorService._internal();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}


