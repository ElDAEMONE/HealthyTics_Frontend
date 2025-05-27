import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:healthytics/Views/Widgets/custom_dropdown.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:form_validation/form_validation.dart';
import 'package:healthytics/Models/Utils/Colors.dart';
import 'package:healthytics/Models/Utils/Common.dart';
import 'package:healthytics/Models/Utils/FirebaseStructure.dart';
import 'package:healthytics/Models/Utils/Routes.dart';
import 'package:healthytics/Models/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthytics/Views/Widgets/custom_text_form_field.dart';
import 'package:image_picker/image_picker.dart';

class ExerciseManage extends StatefulWidget {
  const ExerciseManage({Key? key}) : super(key: key);

  @override
  _ExerciseManageState createState() => _ExerciseManageState();
}

class _ExerciseManageState extends State<ExerciseManage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  final _firebaseStorage = FirebaseStorage.instance;

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
                            "Exercises Management",
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
                                    rec['value']['name']
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
                                                    .exercises)
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
        .child(FirebaseStructure.exercises)
        .once()
        .then((DatabaseEvent data) {
      list.clear();
      for (DataSnapshot element in data.snapshot.children) {
        list.add({'key': element.key, 'value': element.value});
      }
      setState(() {});
    });
  }

  final _formKey = GlobalKey<FormState>();

  Future<File?> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      return File(image.path);
    }

    return null;
  }

  void showEnrollment(key, dynamic savedRecord) {
    String type;
    final List<dynamic> _images = [];
    final TextEditingController _name = TextEditingController();
    final TextEditingController _video = TextEditingController();
    final TextEditingController _minF = TextEditingController();
    final TextEditingController _maxF = TextEditingController();
    final TextEditingController _minD = TextEditingController();
    final TextEditingController _maxD = TextEditingController();
    QuillController _controller = QuillController.basic();

    final List<String> types = [
      'Select Suitable Calories Range',
      '500-1000',
      '1000-1500',
      '1500-2000',
      '2000-3000'
    ];

    if (savedRecord != null) {
      _name.text = savedRecord['name'];
      _video.text = savedRecord['video'];
      _minF.text = savedRecord['minF'];
      _maxF.text = savedRecord['maxF'];
      _minD.text = savedRecord['minD'];
      _maxD.text = savedRecord['maxD'];
      type = '${savedRecord['min']}-${savedRecord['max']}';
      _controller.document =
          Document.fromJson(jsonDecode(savedRecord['description']));

      for (int i = 0; i < savedRecord['images'].length; i++) {
        _images.add(savedRecord['images'][i]);
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
                                      horizontal: 10.0, vertical: 5.0),
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
                                                        fontSize: 14.0,
                                                        color: types.indexOf(
                                                                    record) ==
                                                                0
                                                            ? colorGrey
                                                            : colorBlack),
                                                  )))
                                          .toList()),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 10.0, top: 10.0, left: 15.0),
                                  child: CustomTextFormField(
                                      height: 5.0,
                                      controller: _name,
                                      backgroundColor: color7,
                                      iconColor: colorPrimary,
                                      isIconAvailable: true,
                                      hint: 'Name for your exercise',
                                      icon: Icons.perm_identity,
                                      maxLines: 50,
                                      textInputType: TextInputType.text,
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
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 10.0, top: 10.0, left: 15.0),
                                  child: CustomTextFormField(
                                      height: 5.0,
                                      controller: _video,
                                      backgroundColor: color7,
                                      iconColor: colorPrimary,
                                      isIconAvailable: true,
                                      hint: 'Sample Video URL',
                                      icon: Icons.perm_identity,
                                      maxLines: 50,
                                      textInputType: TextInputType.text,
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
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 10.0,
                                            top: 10.0,
                                            left: 15.0),
                                        child: CustomTextFormField(
                                            height: 5.0,
                                            controller: _minF,
                                            backgroundColor: color7,
                                            iconColor: colorPrimary,
                                            isIconAvailable: true,
                                            hint: 'Frequency - Min',
                                            icon: Icons.speed_outlined,
                                            maxLines: 50,
                                            textInputType: TextInputType.number,
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
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 10.0,
                                            top: 10.0,
                                            right: 15.0),
                                        child: CustomTextFormField(
                                            height: 5.0,
                                            controller: _maxF,
                                            backgroundColor: color7,
                                            iconColor: colorPrimary,
                                            isIconAvailable: true,
                                            hint: 'Max',
                                            icon: Icons.speed_outlined,
                                            maxLines: 50,
                                            textInputType: TextInputType.number,
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
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 10.0,
                                            top: 10.0,
                                            left: 15.0),
                                        child: CustomTextFormField(
                                            height: 5.0,
                                            controller: _minD,
                                            backgroundColor: color7,
                                            iconColor: colorPrimary,
                                            isIconAvailable: true,
                                            hint: 'Duration - Min',
                                            icon: Icons.timelapse,
                                            maxLines: 50,
                                            textInputType: TextInputType.number,
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
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 10.0,
                                            top: 10.0,
                                            right: 15.0),
                                        child: CustomTextFormField(
                                            height: 5.0,
                                            controller: _maxD,
                                            backgroundColor: color7,
                                            iconColor: colorPrimary,
                                            isIconAvailable: true,
                                            hint: 'Max',
                                            icon: Icons.timelapse,
                                            maxLines: 50,
                                            textInputType: TextInputType.number,
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
                                      ),
                                    ),
                                  ],
                                ),
                                QuillSimpleToolbar(
                                  controller: _controller,
                                  config: const QuillSimpleToolbarConfig(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 10.0, top: 10.0, left: 15.0),
                                  child: Container(
                                    color: color7,
                                    child: SizedBox(
                                      height: displaySize.width * 0.5,
                                      child: QuillEditor.basic(
                                        controller: _controller,
                                        config: const QuillEditorConfig(
                                            expands: true),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 20.0),
                                        child: Text(
                                          'Images',
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: colorBlack),
                                        ),
                                      ),
                                      Wrap(
                                        direction: Axis.horizontal,
                                        children: [
                                          for (dynamic ele in _images)
                                            GestureDetector(
                                              onTap: () {
                                                _images.remove(
                                                    _images.indexOf(ele));
                                              },
                                              child: Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 2.0,
                                                    horizontal: 5.0),
                                                decoration: BoxDecoration(
                                                    color: colorSecondary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0)),
                                                width: displaySize.width * 0.3,
                                                height: displaySize.width * 0.3,
                                                child: (ele is File)
                                                    ? Image.file(
                                                        ele,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.network(ele),
                                              ),
                                            ),
                                          GestureDetector(
                                            onTap: () async {
                                              File? file = await pickImage(
                                                  ImageSource.gallery);
                                              if (file != null) {
                                                setState(() {
                                                  _images.add(file);
                                                });
                                              }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: colorSecondary,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0)),
                                              width: displaySize.width * 0.3,
                                              height: displaySize.width * 0.3,
                                              child: Icon(
                                                Icons.add_a_photo,
                                                color: colorWhite,
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
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
                                          print(types
                                                  .map((type) => type
                                                      .toLowerCase()
                                                      .replaceAll(' ', '_'))
                                                  .toList()
                                                  .indexOf(type) ==
                                              0);
                                          if (types
                                                  .map((type) => type
                                                      .toLowerCase()
                                                      .replaceAll(' ', '_'))
                                                  .toList()
                                                  .indexOf(type) ==
                                              0) {
                                            CustomUtils.showSnackBar(
                                                context,
                                                'Please select calories range first',
                                                CustomUtils.ERROR_SNACKBAR);
                                            return;
                                          }

                                          if (_controller.document.length < 2) {
                                            CustomUtils.showSnackBar(
                                                context,
                                                'Please fill more information',
                                                CustomUtils.ERROR_SNACKBAR);
                                            return;
                                          }

                                          print(_images.isEmpty);

                                          if (_images.isEmpty) {
                                            CustomUtils.showSnackBar(
                                                context,
                                                'Please attach atleast one image',
                                                CustomUtils.ERROR_SNACKBAR);
                                            return;
                                          }

                                          FocusScope.of(context).unfocus();
                                          CustomUtils.showLoader(context);
                                          DatabaseReference ref =
                                              _databaseReference.child(
                                                  FirebaseStructure.exercises);

                                          if (savedRecord != null) {
                                            ref = ref.child(key);
                                          } else {
                                            ref = ref.push();
                                          }

                                          List<String> _imagesLinks = [];

                                          for (dynamic img in _images) {
                                            if (img is File) {
                                              TaskSnapshot taskSnapshot =
                                                  await _firebaseStorage
                                                      .ref()
                                                      .child(
                                                          "${_images.indexOf(img)}${DateTime.now().millisecondsSinceEpoch}.png")
                                                      .putFile(img);
                                              _imagesLinks.add(
                                                  await taskSnapshot.ref
                                                      .getDownloadURL());
                                            } else {
                                              _imagesLinks.add(img);
                                            }
                                          }

                                          ref.set({
                                            'images': _imagesLinks,
                                            'name': _name.text,
                                            'video': _video.text,
                                            'description': jsonEncode(
                                                _controller.document
                                                    .toDelta()
                                                    .toJson()),
                                            'min': type.split('-')[0],
                                            'max': type.split('-')[1],
                                            'minF': _minF.text,
                                            'maxF': _maxF.text,
                                            'minD': _minD.text,
                                            'maxD': _maxD.text,
                                            'type': type,
                                          }).then((value) {
                                            getData();
                                            // ignore: use_build_context_synchronously
                                            CustomUtils.hideLoader(context);
                                            // ignore: use_build_context_synchronously
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
