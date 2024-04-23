import 'package:flutter/material.dart';

class FnbMainPage extends StatefulWidget {
  const FnbMainPage({super.key});

  @override
  State<FnbMainPage> createState() => _FnbMainPageState();
}

class _FnbMainPageState extends State<FnbMainPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemBuilder: itemBuilder),
    );
  }
}