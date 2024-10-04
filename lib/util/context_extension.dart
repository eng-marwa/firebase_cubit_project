import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  void navigateTo(String routeName, {Object? args}) {
    print(args);
    Future.microtask(
        () => Navigator.pushNamed(this, routeName, arguments: args));
  }

  void showSnackBar(String message) {
    final messenger = ScaffoldMessenger.of(this);
    messenger.hideCurrentSnackBar();
    Future.microtask(
        () => messenger.showSnackBar(SnackBar(content: Text(message))));
  }
}
