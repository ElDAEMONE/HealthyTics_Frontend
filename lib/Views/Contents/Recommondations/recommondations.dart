import 'package:healthytics/Views/Widgets/custom_dropdown.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:form_validation/form_validation.dart';
import 'package:healthytics/Models/Utils/Colors.dart';
import 'package:healthytics/Models/Utils/Common.dart';
import 'package:healthytics/Models/Utils/FirebaseStructure.dart';
import 'package:healthytics/Models/Utils/Routes.dart';
import 'package:healthytics/Models/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthytics/Views/Widgets/custom_text_form_field.dart';
import 'package:intl/intl.dart';

class ManageRecommondations extends StatefulWidget {
  const ManageRecommondations({Key? key}) : super(key: key);

  @override
  _ManageRecommondationsState createState() => _ManageRecommondationsState();
}

class _ManageRecommondationsState extends State<ManageRecommondations> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  List<dynamic> list = [];

  DateTime start = DateTime.now();
  DateTime end = DateTime.now();
  bool useFilters = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      backgroundColor: colorWhite,
      body: SizedBox(
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
                            "Manage Recommondations",
                            style: TextStyle(fontSize: 16.0, color: color7),
                          ),
                          GestureDetector(
                            onTap: () async {
                              showEnrollment(null, null);
                            },
                            child: Icon(
                              Icons.add_outlined,
                              color: colorWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
              Expanded(
                  child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: colorWhite,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0))),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          for (var rec in list)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: Card(
                                child: ListTile(
                                  title: Text(
                                    rec['value']['type']
                                        .toString()
                                        .capitalize()
                                        .replaceAll('_', ' '),
                                    style: GoogleFonts.nunitoSans(
                                        color: colorBlack, fontSize: 15.0),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        onTap: () => showEnrollment(
                                            rec['key'], rec['value']),
                                        child: Icon(Icons.edit,
                                            color: colorPrimary),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            _databaseReference
                                                .child(FirebaseStructure
                                                    .recommondations)
                                                .child(rec['key'])
                                                .remove()
                                                .then((value) => getData());
                                          },
                                          child: Icon(Icons.delete,
                                              color: colorRed),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                        ]),
                  ),
                ),
              ))
            ],
          )),
    ));
  }

  Future<void> getData() async {
    _databaseReference
        .child(FirebaseStructure.recommondations)
        .once()
        .then((DatabaseEvent data) {
      list.clear();
      for (DataSnapshot element in data.snapshot.children) {
        list.add({'key': element.key, 'value': element.value});
      }
      setState(() {});
    });
  }

  String getDateTime(int mills) {
    return DateFormat('yyyy/MM/dd hh:mm a')
        .format(DateTime.fromMillisecondsSinceEpoch(mills));
  }

  Uint8List getImageString(String value) {
    return Uri.parse(value).data!.contentAsBytes();
  }

  final _formKey = GlobalKey<FormState>();

  void showEnrollment(key, dynamic savedRecord) {
    String type;

    final List<String> types = [
      'Low Probability',
      'Moderate Probability',
      'High Probability'
    ];
    final List<TextEditingController> recommondations = [
      TextEditingController()
    ];

    if (savedRecord != null) {
      recommondations.clear();
      type = savedRecord['type'];
      for (String recommondation in savedRecord['recommondations']) {
        recommondations.add(TextEditingController(text: recommondation));
      }
    } else {
      type = types.first;
    }

    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return SizedBox(
                width: displaySize.width,
                height: displaySize.height * 0.7,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                        flex: 0,
                        child: Container(
                          decoration: BoxDecoration(color: colorPrimary),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                top: 18.0,
                                bottom: 18.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.refresh,
                                  color: colorPrimary,
                                ),
                                Text(
                                  "Enrollment",
                                  style: GoogleFonts.nunitoSans(
                                      fontSize: 18.0, color: colorWhite),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(
                                    Icons.close,
                                    color: colorWhite,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Form(
                            key: _formKey,
                            child: ListView(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 5.0),
                                  child: CustomDropDown(
                                      leadingIcon: Icons.type_specimen_outlined,
                                      leadingIconColor: colorPrimary,
                                      dropdownValue: (type)
                                          .toLowerCase()
                                          .replaceAll(' ', '_'),
                                      actionIconColor: colorBlack,
                                      textColor: colorBlack,
                                      backgroundColor: color7,
                                      underlineColor: color7,
                                      onChanged: (value) {
                                        setState(() {
                                          type = value!;
                                        });
                                      },
                                      items: types
                                          .map((record) =>
                                              DropdownMenuItem<String>(
                                                  value: record
                                                      .toLowerCase()
                                                      .replaceAll(' ', '_'),
                                                  child: Text(
                                                    record,
                                                    style: TextStyle(
                                                        fontSize: 14.0),
                                                  )))
                                          .toList()),
                                ),
                                for (TextEditingController controller
                                    in recommondations)
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 10.0,
                                            top: 20.0,
                                            left: 15.0),
                                        child: CustomTextFormField(
                                            height: 5.0,
                                            controller: controller,
                                            backgroundColor: color7,
                                            iconColor: colorPrimary,
                                            isIconAvailable: true,
                                            hint:
                                                'Recommondation ${recommondations.indexOf(controller) + 1}',
                                            icon: Icons.description_outlined,
                                            maxLines: 50,
                                            textInputType:
                                                TextInputType.multiline,
                                            validation: (value) {
                                              final validator = Validator(
                                                validators: [
                                                  const RequiredValidator()
                                                ],
                                              );
                                              return validator.validate(
                                                label: 'This field is required',
                                                value: value,
                                              );
                                            },
                                            obscureText: false),
                                      )),
                                      Expanded(
                                          flex: 0,
                                          child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  recommondations.removeAt(
                                                      recommondations
                                                          .indexOf(controller));
                                                });
                                              },
                                              icon: Icon(
                                                  Icons.remove_circle_outline,
                                                  color: colorRed)))
                                    ],
                                  ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: SizedBox(
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
                                      onPressed: () {
                                        setState(() {
                                          recommondations
                                              .add(TextEditingController());
                                        });
                                      },
                                      child: Text(
                                        'New Recommondation',
                                        style: GoogleFonts.nunitoSans(),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: SizedBox(
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
                                        if (_formKey.currentState!.validate()) {
                                          FocusScope.of(context).unfocus();
                                          CustomUtils.showLoader(context);
                                          DatabaseReference ref =
                                              _databaseReference.child(
                                                  FirebaseStructure
                                                      .recommondations);

                                          if (savedRecord != null) {
                                            ref = ref.child(key);
                                          } else {
                                            ref = ref.push();
                                          }

                                          ref.set({
                                            'name': type
                                                .replaceAll(' Probability', '')
                                                .capitalize(),
                                            'type': type,
                                            'recommondations': recommondations
                                                .map((controller) =>
                                                    controller.text)
                                                .toList(),
                                          }).then((value) {
                                            getData();
                                            CustomUtils.hideLoader(context);
                                            Navigator.pop(context);
                                          });
                                        }
                                      },
                                      child: Text(
                                        (savedRecord != null)
                                            ? "Update"
                                            : "Save",
                                        style: GoogleFonts.nunitoSans(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }
}
