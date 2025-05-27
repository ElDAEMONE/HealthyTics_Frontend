import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:form_validation/form_validation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthytics/Models/Strings/register_screen.dart';
import 'package:healthytics/Models/Utils/FirebaseStructure.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:healthytics/Models/Strings/app.dart';
import 'package:healthytics/Models/Utils/Colors.dart';
import 'package:healthytics/Models/Utils/Common.dart';
import 'package:healthytics/Models/Utils/Utils.dart';
import 'package:healthytics/Views/Contents/Home/drawer.dart';
import 'package:healthytics/Views/Widgets/custom_dropdown.dart';
import 'package:healthytics/Views/Widgets/custom_text_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  dynamic liveData;
  dynamic liveData2;
  int currentQuestionIndex = 0;
  Map<String, dynamic> answers = {};

  Map<String, Map<String, dynamic>> questions = {
    'What is your gender?': {
      'type': 'dropdown',
      'values': ['Male', 'Female']
    },
    'What is your age?': {
      'type': 'number',
    },
    'What is your education level?': {
      'type': 'dropdown',
      'values': [
        'Less than high school',
        'High school graduate',
        'Some college or vocational school',
        'College degree (Bachelor\'s or higher)',
      ]
    },
    'Do you currently smoke?': {
      'type': 'dropdown',
      'values': ['Yes', 'No']
    },
    'How many cigarettes do you smoke per day?': {
      'type': 'number',
    },
    'Are you on blood pressure medication?': {
      'type': 'dropdown',
      'values': ['Yes', 'No']
    },
    'Have you ever had a stroke?': {
      'type': 'dropdown',
      'values': ['Yes', 'No']
    },
    'Do you have high blood pressure?': {
      'type': 'dropdown',
      'values': ['Yes', 'No']
    },
    'Do you have diabetes?': {
      'type': 'dropdown',
      'values': ['Yes', 'No']
    },
    'Please enter your total cholesterol level.': {
      'type': 'number',
    },
    'Please enter your systolic blood pressure.': {
      'type': 'number',
    },
    'Please enter your blood pressure.': {
      'type': 'number',
    },
    'Please enter your BMI (Body Mass Index)': {
      'type': 'number',
    },
    'Please enter your average heart rate.': {
      'type': 'number',
    },
    'Please enter your glucose level.': {
      'type': 'number',
    },
  };

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      initNotifications();
      checkQuestionsinit();
      getData();
      getLastData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: colorPrimary,
      drawer: HomeDrawer(),
      body: SafeArea(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: BoxDecoration(color: colorWhite),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.02,
                ),
                decoration: BoxDecoration(
                  color: colorPrimary.withOpacity(0.9),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon:
                          Icon(Icons.menu_rounded, color: colorWhite, size: 25),
                      onPressed: () => _scaffoldKey.currentState!.openDrawer(),
                    ),
                    Text(
                      app_name,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: colorWhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.quickreply_outlined,
                          color: colorWhite, size: 25),
                      onPressed: () => _askQuestions(context),
                    ),
                  ],
                ),
              ),
              if (liveData2 != null)
                Expanded(
                    flex: 0,
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0)
                            .copyWith(top: 20.0),
                        child: Column(
                          children: [
                            Row(children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "Last Predicted Calories",
                                  style: GoogleFonts.nunitoSans(
                                    fontSize: 16.0,
                                    color: colorPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 0,
                                child: Text(
                                  liveData2['predicted_calories'],
                                  style: GoogleFonts.nunitoSans(
                                    fontSize: 25.0,
                                    color: colorBlack,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ]),
                            Row(children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "Condition",
                                  style: GoogleFonts.nunitoSans(
                                    fontSize: 16.0,
                                    color: colorPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 0,
                                child: Text(
                                  liveData2['ifHealthy'] == 'Healthy'
                                      ? 'Healthy'
                                      : 'Not Healthy',
                                  style: GoogleFonts.nunitoSans(
                                    fontSize: 25.0,
                                    color: colorBlack,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ]),
                            Row(children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "CHD",
                                  style: GoogleFonts.nunitoSans(
                                    fontSize: 16.0,
                                    color: colorPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 0,
                                child: Text(
                                  liveData2['tenYearCHD'],
                                  style: GoogleFonts.nunitoSans(
                                    fontSize: 25.0,
                                    color: colorBlack,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ])
                          ],
                        ))),
              Expanded(
                child: liveData != null
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.all(screenWidth * 0.02),
                          child: GridView.count(
                            crossAxisCount: screenWidth > 600 ? 3 : 2,
                            childAspectRatio: 1.0,
                            crossAxisSpacing: screenWidth * 0.01,
                            mainAxisSpacing: screenWidth * 0.01,
                            children: [
                              buildCard("Body Temp", liveData['body_temp'],
                                  "°C", Icons.thermostat, Colors.redAccent),
                              buildCard("Heart Rate", liveData['bpm'], "bpm",
                                  Icons.favorite, Colors.pinkAccent),
                              buildCard("Humidity", liveData['humy'], "%",
                                  Icons.water_drop, Colors.blueAccent),
                              buildCard("SPO2", liveData['spo2'], "%",
                                  Icons.opacity, Colors.purpleAccent),
                              buildCard("Temperature", liveData['temp'], "°C",
                                  Icons.wb_sunny, Colors.orangeAccent),
                              buildCard(
                                  "SOS",
                                  liveData['sos'] == 'true' ? 'Yes' : 'No',
                                  "",
                                  Icons.emergency,
                                  Colors.red),
                            ],
                          ),
                        ),
                      )
                    : Center(
                        child: CircularProgressIndicator(color: colorPrimary),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCard(String label, String value, String unit, IconData icon,
      Color accentColor) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [accentColor.withOpacity(0.1), Colors.white],
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.03),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: accentColor, size: screenWidth * 0.08),
              SizedBox(height: screenWidth * 0.02),
              Text(
                label,
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: screenWidth * 0.015),
              Text(
                '$value $unit',
                style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void initNotifications() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      } else {
        _databaseReference
            .child(FirebaseStructure.notification)
            .onValue
            .listen((DatabaseEvent data) async {
          dynamic noti = data.snapshot.value;
          if (noti['isNew'] == 'true') {
            AwesomeNotifications().createNotification(
                content: NotificationContent(
                    id: -1,
                    channelKey: 'emergency_traumacare',
                    title: 'Notification',
                    body: noti['message'].toString()));

            await _databaseReference
                .child(FirebaseStructure.notification)
                .child('isNew')
                .set(false);
          }
        });
      }
    });
  }

  Future<void> getLastData() async {
    _databaseReference
        .child(FirebaseStructure.dailyCaloriesPredictionHistory)
        .orderByKey()
        .limitToLast(1)
        .once()
        .then((DatabaseEvent data) async {
      dynamic dd = data.snapshot.value;
      liveData2 = dd.values.first;
    }).whenComplete(() {
      setState(() {});
    });
  }

  void _askQuestions(BuildContext context) {
    answersFormFields.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
              height: MediaQuery.of(context).size.height * 0.5,
              child: Column(
                children: [
                  Text(
                    questions.keys.elementAt(currentQuestionIndex),
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                      fontWeight: FontWeight.bold,
                      color: colorPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Expanded(
                      child: _buildQuestionInputWidget(
                          questions.keys.elementAt(currentQuestionIndex))),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (currentQuestionIndex > 0)
                        ElevatedButton.icon(
                          onPressed: () =>
                              setState(() => currentQuestionIndex--),
                          icon: Icon(Icons.arrow_back),
                          label: Text("Previous"),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: colorPrimary),
                        ),
                      if (currentQuestionIndex < questions.length - 1)
                        ElevatedButton.icon(
                          onPressed: answers.length >= currentQuestionIndex + 1
                              ? () => setState(() => currentQuestionIndex++)
                              : null,
                          icon: Icon(Icons.arrow_forward),
                          label: Text("Next"),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: colorPrimary),
                        ),
                      if (currentQuestionIndex == questions.length - 1)
                        ElevatedButton.icon(
                          onPressed: () {
                            Map<String, dynamic> data = {'isNew': true.toString()};
                            int counter = 1;
                            answers.forEach((key, value) {
                              Map<String, dynamic> elem = questions.values
                                  .elementAt(
                                      answers.keys.toList().indexOf(key));
                              data['q$counter'] = elem['type'] == 'dropdown'
                                  ? elem['values'].indexOf(value).toString()
                                  : value.toString();
                              counter++;
                            });
                            CustomUtils.showLoader(context);
                            _databaseReference
                                .child(FirebaseStructure.questionnaire)
                                .set(data)
                                .whenComplete(() {
                              CustomUtils.hideLoader(context);
                              answers.clear();
                              currentQuestionIndex = 0;
                              Navigator.pop(context);
                            });
                          },
                          icon: Icon(Icons.check),
                          label: Text("Submit"),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                        ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  final Map<String, TextEditingController> answersFormFields = {};

  Widget _buildQuestionInputWidget(String question) {
    final questionDetails = questions[question];
    final List<String> values = questionDetails?['values'] ?? [];

    if (questionDetails!['type'] == 'dropdown') {
      if (answers[question] == null) {
        answers[question] = values.first;
      }
      return StatefulBuilder(builder: (context, setState) {
        return CustomDropDown(
            leadingIcon: Icons.type_specimen_outlined,
            leadingIconColor: colorPrimary,
            dropdownValue: answers[question],
            actionIconColor: colorBlack,
            textColor: colorBlack,
            backgroundColor: color7,
            underlineColor: color7,
            onChanged: (value) {
              setState(() {
                answers[question] = value;
              });
            },
            items: (values).map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList());
      });
    } else if (questionDetails['type'] == 'number') {
      if (answers[question] == null) {
        answers[question] = '0';
      }

      if (!answersFormFields.containsKey(question)) {
        answersFormFields[question] = TextEditingController();
      }

      return CustomTextFormField(
        height: 5.0,
        controller: answersFormFields[question]!,
        backgroundColor: color7,
        iconColor: colorPrimary,
        isIconAvailable: true,
        hint: question,
        icon: Icons.numbers,
        textInputType: TextInputType.number,
        validation: (value) {
          final validator = Validator(
            validators: [const RequiredValidator()],
          );
          return validator.validate(
            label: register_validation_invalid_email,
            value: value,
          );
        },
        obscureText: false,
        onChanged: (value) {
          setState(() {
            answers[question] = value;
          });
        },
      );
    }
    return SizedBox();
  }

  Widget getLiveTile(IconData icon, String title, dynamic value,
      {String? symbol,
      Function(int?)? onToggle,
      String? subTitle,
      bool changeOnTap = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: Card(
        color: color6,
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                      color: colorPrimary.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(100.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      icon,
                      color: colorWhite,
                      size: displaySize.width * 0.06,
                    ),
                  ),
                ),
                title: Text(
                  title.toString(),
                  style: TextStyle(
                      color: color15,
                      fontWeight: FontWeight.w400,
                      fontSize: 15.0),
                ),
                subtitle: subTitle != null
                    ? Text(
                        subTitle,
                        style: TextStyle(
                            color: colorGrey,
                            fontWeight: FontWeight.w400,
                            fontSize: 13.0),
                      )
                    : null,
                trailing: (onToggle != null)
                    ? ToggleSwitch(
                        activeBgColor: [colorPrimary],
                        initialLabelIndex: value is bool && value ? 1 : 0,
                        totalSwitches: 2,
                        labels: const ['OFF', 'ON'],
                        onToggle: onToggle,
                        changeOnTap: changeOnTap,
                      )
                    : Text(
                        '$value ${symbol ?? ''}',
                        style: TextStyle(
                            color: color15,
                            fontWeight: FontWeight.w400,
                            fontSize: 16.0),
                      ))),
      ),
    );
  }

  void checkQuestionsinit() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final DateTime dateTime = DateTime.now();
    final String checkKey =
        '${dateTime.year}-${dateTime.month}-${dateTime.weekOfMonth}';
    final bool val = prefs.getBool(checkKey) ?? false;

    if (!val) {
      await prefs.setBool(checkKey, true);
      _askQuestions(context);
    }
  }

  Future<void> getData() async {
    _databaseReference
        .child(FirebaseStructure.liveData)
        .onValue
        .listen((DatabaseEvent data) async {
      setState(() {
        liveData = data.snapshot.value;
      });
    });
  }
}
