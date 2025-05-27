import 'dart:convert';

import 'package:delta_to_html/delta_to_html.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:healthytics/Models/Utils/Colors.dart';
import 'package:healthytics/Models/Utils/Common.dart';
import 'package:healthytics/Models/Utils/FirebaseStructure.dart';
import 'package:healthytics/Models/Utils/Routes.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';

class Plan extends StatefulWidget {
  const Plan({super.key});

  @override
  State<Plan> createState() => _PlanState();
}

class _PlanState extends State<Plan> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  double cCount = 0.0;

  List exercisePlans = [];
  List mealPlans = [];

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: colorPrimary,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: colorPrimary,
        statusBarIconBrightness: Brightness.dark));

    Future.delayed(Duration.zero, () {
      getData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: color7,
      body: SafeArea(
        child: SizedBox(
          width: displaySize.width,
          height: displaySize.height,
          child: Column(
            children: [
              Expanded(
                flex: 0,
                child: Container(
                  decoration: BoxDecoration(
                      color: colorPrimary,
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0))),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 18.0, bottom: 18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Routes(context: context).back();
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: colorWhite,
                          ),
                        ),
                        Text(
                          "Suggested Exercise & Meal Plan",
                          style: TextStyle(fontSize: 16.0, color: color7),
                        ),
                        GestureDetector(
                          onTap: () async {
                            getData();
                          },
                          child: Icon(
                            Icons.refresh_outlined,
                            color: colorWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  color: colorWhite,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: 5.0, left: 5.0, right: 5.0),
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Exercise Plan Section
                            if (exercisePlans.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.only(top: 20.0, left: 20.0),
                                child: Text("Suggested Exercise Plans",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ),
                            for (dynamic exercisePlan in exercisePlans)
                              SizedBox(
                                width: double.infinity,
                                child: Card(
                                  margin: EdgeInsets.all(10.0),
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.only(bottom: 20.0),
                                          child: Text(
                                              "Exercise Plan: ${exercisePlan['name']}",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        HtmlWidget(DeltaToHTML.encodeJson(
                                            jsonDecode(
                                                exercisePlan['description']))),
                                        Text(
                                            "Duration: ${exercisePlan['minD']} to ${exercisePlan['maxD']} min"),
                                        Text(
                                            "Frequency: ${exercisePlan['minF']} to ${exercisePlan['maxF']} times per week"),
                                        for (String url
                                            in exercisePlan['images'])
                                          Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 20.0),
                                              child: SizedBox(
                                                  width:
                                                      displaySize.width * 0.4,
                                                  child: Image.network(url))),
                                        GestureDetector(
                                          onTap: () async {
                                            if (await canLaunch(
                                                exercisePlan['video'])) {
                                              await launch(
                                                  exercisePlan['video']);
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'Could not launch video')),
                                              );
                                            }
                                          },
                                          child: Text("Watch Video",
                                              style: TextStyle(
                                                  color: colorPrimary)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            // Meal Plan Section
                            if (mealPlans.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.only(top: 20.0, left: 20.0),
                                child: Text("Suggested Meal Plans",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ),
                            for (dynamic mealPlan in mealPlans)
                              SizedBox(
                                width: double.infinity,
                                child: Card(
                                  margin: EdgeInsets.all(10.0),
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.only(bottom: 20.0),
                                          child: Text(
                                              "Exercise Plan: ${mealPlan['name']}",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        HtmlWidget(DeltaToHTML.encodeJson(
                                            jsonDecode(
                                                mealPlan['description']))),
                                        for (String url in mealPlan['images'])
                                          Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 20.0),
                                              child: SizedBox(
                                                  width:
                                                      displaySize.width * 0.4,
                                                  child: Image.network(url))),
                                        for (String link
                                            in mealPlan['videos'] ?? [])
                                          GestureDetector(
                                            onTap: () async {
                                              if (await canLaunch(link)) {
                                                await launch(link);
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                      content: Text(
                                                          'Could not launch video')),
                                                );
                                              }
                                            },
                                            child: Text(
                                                "Watch Video ${mealPlan['videos'].indexOf(link) + 1}",
                                                style: TextStyle(
                                                    color: colorPrimary)),
                                          ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              bottom: 20.0, top: 30.0),
                                          child: Text(
                                              "Total Calories: ${mealPlan['total'] ?? '0.0'}",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold)),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getData() async {
    _databaseReference
        .child(FirebaseStructure.dailyCaloriesPredictionHistory)
        .orderByKey()
        .limitToLast(1)
        .once()
        .then((DatabaseEvent data) async {
      dynamic dd = data.snapshot.value;
      cCount = double.parse(dd.values.first['predicted_calories'] ?? '0.0');
      await loadExercises();
      await loadMeals();
    }).whenComplete(() {
      setState(() {});
    });
  }

  Future<void> loadExercises() async {
    await _databaseReference
        .child(FirebaseStructure.exercises)
        .once()
        .then((DatabaseEvent data) {
      exercisePlans.clear();
      for (DataSnapshot element in data.snapshot.children) {
        dynamic val = element.value;
        if (double.parse(val['min']) < cCount &&
            double.parse(val['max']) >= cCount) {
          exercisePlans.add(val);
        }
      }
    });
  }

  Future<void> loadMeals() async {
    await _databaseReference
        .child(FirebaseStructure.meals)
        .once()
        .then((DatabaseEvent data) {
      mealPlans.clear();
      for (DataSnapshot element in data.snapshot.children) {
        dynamic val = element.value;
        if (double.parse(val['min']) < cCount &&
            double.parse(val['max']) >= cCount) {
          mealPlans.add(val);
        }
      }
    });
  }
}
