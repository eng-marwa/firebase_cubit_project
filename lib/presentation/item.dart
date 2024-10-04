import 'package:flutter/material.dart';

class Item extends StatelessWidget {
  const Item({super.key});

  @override
  Widget build(BuildContext context) {
    String _data = ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
      body: Center(
        child: Text('data $_data'),
      ),
    );
  }
}
