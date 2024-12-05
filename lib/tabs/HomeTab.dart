import 'package:cnmat/screens/AppScaffold.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
        title: 'Home',
        body: Center(
          child: Text('Home'),
        ));
  }
}
