import 'package:flutter/material.dart';

class ProfileMenuItemWidget extends StatelessWidget {
  final IconData icon;
  final String title;


  const ProfileMenuItemWidget({
    super.key,
    required this.icon,
    required this.title,
  });



  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle( fontSize: 15, fontWeight: FontWeight.w500),
      ),
      dense: true,
      onTap: () {

      },
    );
  }
}