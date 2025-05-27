import 'package:flutter/material.dart';
import 'package:healthytics/Models/Utils/Colors.dart';

class CustomDropDown extends StatelessWidget {
  final String dropdownValue; // Changed to final and camelCase
  final String? label; // Made nullable with proper type
  final String leadingImage; // Changed to camelCase
  final IconData? leadingIcon; // Added proper type and made nullable
  final Color? leadingIconColor; // Added proper type and made nullable
  final Color actionIconColor;
  final Color textColor; // Changed to camelCase
  final Color backgroundColor; // Changed to camelCase
  final Color underlineColor; // Changed to camelCase
  final void Function(String?) onChanged; // Proper function type
  final List<DropdownMenuItem<String>> items;

  const CustomDropDown({
    super.key, // Added key parameter
    required this.dropdownValue,
    this.label,
    this.leadingImage = '', // Default value
    this.leadingIcon,
    this.leadingIconColor,
    required this.actionIconColor,
    required this.textColor,
    required this.backgroundColor,
    required this.underlineColor,
    required this.onChanged, // Renamed from function to onChanged
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        if (label != null) // Using if instead of ternary for cleaner code
          Padding(
            padding: const EdgeInsets.only(
                bottom: 5.0), // 'custom' seems incorrect, maybe meant 'bottom'?
            child: Text(
              label!,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                color: color11,
              ),
            ),
          )
        else
          const SizedBox.shrink(),
        Container(
          decoration: BoxDecoration(
              color: backgroundColor, borderRadius: BorderRadius.circular(5.0)),
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child: Row(
            children: [
              if (leadingImage.isNotEmpty) // Better empty check
                Image.asset(leadingImage)
              else
                const SizedBox.shrink(),
              if (leadingIcon != null)
                Icon(
                  leadingIcon,
                  color: leadingIconColor,
                )
              else
                const SizedBox.shrink(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: dropdownValue,
                    dropdownColor: color6,
                    elevation: 5,
                    style: TextStyle(
                        color: textColor), // Changed to use textColor parameter
                    underline: Container(
                      height: 2,
                      color: underlineColor,
                    ),
                    onChanged: onChanged,
                    items: items,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
