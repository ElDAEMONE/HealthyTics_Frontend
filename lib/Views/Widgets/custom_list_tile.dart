import 'package:flutter/material.dart';
import 'package:healthytics/Models/Utils/Colors.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Function()? onTap;

  const CustomListTile(
      {required this.title,
      required this.subtitle,
      required this.icon,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Adds shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners
        side: BorderSide(color: colorPrimary, width: 0.5), // Border color
      ),
      child: ListTile(
        leading: Icon(icon, color: colorSecondary),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
