import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  static const nameRoute = '/profile';
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder(
      child: Text('Profile Page'),
    );
  }
}