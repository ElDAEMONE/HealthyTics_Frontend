import 'package:flutter/cupertino.dart';

class CustomSwitchButton extends StatelessWidget {
  Function(bool)? onChanged;
  bool switchValue;

  CustomSwitchButton({Key? key, this.onChanged, this.switchValue = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.8, // Change this value to adjust the size
      child: CupertinoSwitch(
        value: switchValue,
        onChanged: onChanged,
      ),
    );
  }
}
