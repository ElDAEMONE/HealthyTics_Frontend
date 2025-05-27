import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:healthytics/Models/Utils/Colors.dart';
import 'package:healthytics/Models/Utils/Common.dart';
import 'package:healthytics/Models/Utils/FirebaseStructure.dart';
import 'package:healthytics/Models/Utils/Routes.dart';
import 'package:healthytics/Models/Utils/Utils.dart';
import 'package:healthytics/Views/Widgets/graph_view.dart';
import 'package:intl/intl.dart';
import '../../Widgets/custom_text_datetime_chooser.dart';

class QuestionnairePredictionHistory extends StatefulWidget {
  const QuestionnairePredictionHistory({super.key});

  @override
  State<QuestionnairePredictionHistory> createState() =>
      _QuestionnairePredictionHistoryState();
}

class _QuestionnairePredictionHistoryState
    extends State<QuestionnairePredictionHistory> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  List<dynamic> list = [];
  Map<String, List> recommondations = {};

  TextEditingController start = TextEditingController();
  TextEditingController end = TextEditingController();
  bool useFilters = false;
  bool showFilters = false;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: colorPrimary,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: colorPrimary,
        statusBarIconBrightness: Brightness.dark));

    Future.delayed(Duration.zero, () {
      getRecommondations();
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
                                "Questionnaire Prediction History",
                                style: TextStyle(fontSize: 16.0, color: color7),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    showFilters = !showFilters;
                                  });
                                },
                                child: Icon(
                                  (showFilters) ? Icons.menu_open : Icons.menu,
                                  color: colorWhite,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                  (showFilters)
                      ? Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Filter",
                                  style: TextStyle(
                                      fontSize: 16.0, color: colorBlack),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: CustomTextDateTimeChooser(
                                      height: 5.0,
                                      controller: start,
                                      backgroundColor: color7,
                                      iconColor: colorPrimary,
                                      isIconAvailable: true,
                                      hint: 'Start',
                                      icon: Icons.calendar_month,
                                      textInputType: TextInputType.text,
                                      validation: (value) {
                                        return null;
                                      },
                                      obscureText: false),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: CustomTextDateTimeChooser(
                                      height: 5.0,
                                      controller: end,
                                      backgroundColor: color7,
                                      iconColor: colorPrimary,
                                      isIconAvailable: true,
                                      hint: 'End',
                                      icon: Icons.calendar_month,
                                      textInputType: TextInputType.text,
                                      validation: (value) {
                                        return null;
                                      },
                                      obscureText: false),
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                SizedBox(
                                    width: double.infinity,
                                    height: 50.0,
                                    child: TextButton(
                                      style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                colorWhite),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                colorPrimary),
                                      ),
                                      onPressed: () async {
                                        useFilters = true;
                                        getData();
                                      },
                                      child: const Text(
                                        "Filter Records",
                                        style: TextStyle(),
                                      ),
                                    )),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                SizedBox(
                                    width: double.infinity,
                                    height: 50.0,
                                    child: TextButton(
                                      style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                colorWhite),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                colorPrimary),
                                      ),
                                      onPressed: () async {
                                        useFilters = true;
                                        getData();
                                        viewGraph();
                                      },
                                      child: const Text(
                                        "Graph View",
                                        style: TextStyle(),
                                      ),
                                    )),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                SizedBox(
                                    width: double.infinity,
                                    height: 50.0,
                                    child: TextButton(
                                        style: ButtonStyle(
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  colorWhite),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  colorBlack),
                                        ),
                                        onPressed: () async {
                                          useFilters = false;
                                          start.clear();
                                          end.clear();
                                          getData();
                                        },
                                        child: const Text(
                                          "Reset Filter",
                                          style: TextStyle(),
                                        ))),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  for (var rec in list)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 1.0),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0, vertical: 5.0),
                                        child: ExpandedTile(
                                          theme: ExpandedTileThemeData(
                                            headerPadding:
                                                const EdgeInsets.all(24.0),
                                            headerSplashColor:
                                                colorSecondary.withOpacity(0.1),
                                            contentBackgroundColor: color7,
                                            contentPadding:
                                                const EdgeInsets.all(24.0),
                                          ),
                                          leading: Icon(
                                            Icons.electrical_services,
                                            color: colorPrimary,
                                            size: 35.0,
                                          ),
                                          title: Wrap(
                                            direction: Axis.vertical,
                                            children: [
                                              Text(
                                                rec['value']['prediction'] ??
                                                    'Healthy', // Use the prediction as the card title
                                                style: TextStyle(
                                                  color: color4,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                              Text(
                                                getDateTime(int.parse(rec[
                                                        'value']['timestamp']
                                                    .toString())), // Date and time as subtitle
                                                style: TextStyle(
                                                  color: color4,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12.0,
                                                ),
                                              )
                                            ],
                                          ),
                                          content: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              getRecommondationWidget(
                                                  rec['value']['probability']),
                                              getCard(
                                                Icons.settings_accessibility,
                                                'Probability',
                                                rec['value']['probability'] ??
                                                    '',
                                              ),
                                              getCard(
                                                Icons.percent_outlined,
                                                'Probability Value',
                                                rec['value']
                                                        ['probability_value'] ??
                                                    '',
                                              ),
                                            ],
                                          ),
                                          controller: ExpandedTileController(
                                              isExpanded: false),
                                        ),
                                      ),
                                    )
                                ]),
                          ))),
                    ),
                  ),
                ],
              )),
        ));
  }

  getRecommondationWidget(String data) {
    print(data);
    if (recommondations[data.toLowerCase().capitalize()] == null) {
      return SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.only(top: 20.0, bottom: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recommondations',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          for (String recommondation
              in recommondations[data.toLowerCase().capitalize()]!)
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                recommondation,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w200),
              ),
            )
        ],
      ),
    );
  }

  Future<void> viewGraph() async {
    if (list.isNotEmpty) {
      final List<ChartData> chartData1 = [];

      for (var element in list) {
        chartData1.add(ChartData(
            getDateTime(int.parse(element['value']['timestamp'].toString())),
            double.parse(element['value']['probability_value'].toString())));
      }

      showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return GraphView(chartData1: chartData1, label1: 'Probability');
          });
    } else {
      CustomUtils.showToast("No data found to create graph");
    }
  }

  getCard(IconData icon, String title, String param,
      {String? symbol, bool isSwitch = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              flex: 1,
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: colorSecondary,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      title,
                      style: TextStyle(
                          color: color15,
                          fontWeight: FontWeight.w400,
                          fontSize: 15.0),
                    ),
                  ),
                ],
              )),
          if (!isSwitch)
            Expanded(
                flex: 0,
                child: Row(
                  children: [
                    Text(
                      param,
                      style: TextStyle(
                          color: color15,
                          fontWeight: FontWeight.w400,
                          fontSize: 15.0),
                    ),
                    if (symbol != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(
                          symbol,
                          style: TextStyle(
                              color: color15,
                              fontWeight: FontWeight.w400,
                              fontSize: 15.0),
                        ),
                      ),
                  ],
                ))
        ],
      ),
    );
  }

  String getDateTime(int mills) {
    return DateFormat('yyyy/MM/dd hh:mm a')
        .format(DateTime.fromMillisecondsSinceEpoch(mills));
  }

  Future<void> getRecommondations() async {
    _databaseReference
        .child(FirebaseStructure.recommondations)
        .once()
        .then((DatabaseEvent data) {
      for (DataSnapshot element in data.snapshot.children) {
        dynamic data = element.value;
        recommondations[data['name']] = data['recommondations'];
      }
      getData();
    });
  }

  Future<void> getData() async {
    _databaseReference
        .child(FirebaseStructure.questionnairePredictionHistory)
        .once()
        .then((DatabaseEvent data) {
      list.clear();
      for (DataSnapshot element in data.snapshot.children) {
        dynamic valueRecord = element.value;
        if (useFilters == true) {
          bool add = true;

          DateTime currentDateTime = DateTime.fromMillisecondsSinceEpoch(
              int.parse(valueRecord['timestamp'].toString()));

          if (add &&
              start.text.isNotEmpty &&
              currentDateTime.isBefore(
                  DateFormat("yyyy/MM/dd hh:mm a").parse(start.text))) {
            add = false;
          }

          if (add &&
              end.text.isNotEmpty &&
              currentDateTime
                  .isAfter(DateFormat("yyyy/MM/dd hh:mm a").parse(end.text))) {
            add = false;
          }

          if (add) {
            list.add({'key': element.key, 'value': element.value});
          }
        } else {
          list.add({'key': element.key, 'value': element.value});
        }
      }

      setState(() {
        useFilters = false;
      });
    });
  }
}
