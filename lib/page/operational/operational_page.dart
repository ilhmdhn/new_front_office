import 'package:flutter/material.dart';

class OperationalPage extends StatefulWidget {
    static const nameRoute = '/operational';
  const OperationalPage({super.key});

  @override
  State<OperationalPage> createState() => _OperationalPageState();
}

class _OperationalPageState extends State<OperationalPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder(
      child: Text('Operational Page'),
    );
  }
}