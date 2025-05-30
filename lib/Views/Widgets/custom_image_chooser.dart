import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:healthytics/Models/Utils/Colors.dart';
import 'package:healthytics/Models/Utils/Common.dart';
import 'package:healthytics/Views/Widgets/custom_button.dart';

// ignore: must_be_immutable
class CustomImageChooser extends StatelessWidget {
  double height = 5.0;
  Color backgroundColor;
  String addButtonText;
  List<Uint8List> images;
  int maxImagesCount;
  String? label;
  dynamic onItemRemove;
  dynamic onItemAdded;

  CustomImageChooser(
      {super.key,
      this.label,
      required this.onItemRemove,
      required this.onItemAdded,
      required this.maxImagesCount,
      required this.addButtonText,
      required this.height,
      required this.backgroundColor,
      required this.images});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (label != null)
            ? Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Text(
                  label!,
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: color11),
                ),
              )
            : const SizedBox.shrink(),
        Container(
            decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(5.0)),
            padding: EdgeInsets.symmetric(vertical: height),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: getContents(context),
            ))
      ],
    );
  }

  getContents(context) {
    List<Widget> widgetList = [];

    for (var i = 0; i < images.length; i++) {
      Uint8List image = images[i];

      widgetList.add(Card(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  flex: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: SizedBox(
                      height: displaySize.width * 0.2,
                      width: displaySize.width * 0.2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.memory(
                          image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: Text(
                      "${(image.lengthInBytes / 1000000).toStringAsFixed(2)} MB")),
              Expanded(
                  flex: 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: GestureDetector(
                          onTap: () {
                            onItemRemove(i);
                          },
                          child: Icon(Icons.close, color: color13),
                        ),
                      )
                    ],
                  ))
            ],
          ),
        ),
      ));
    }

    if (maxImagesCount > images.length) {
      widgetList.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: CustomButton(
            buttonText: addButtonText,
            textColor: colorDarkBg,
            backgroundColor: color8.withValues(alpha: 0.3),
            isBorder: false,
            borderColor: color6,
            onclickFunction: () {
              onItemAdded();
            }),
      ));
    }

    return widgetList;
  }
}
