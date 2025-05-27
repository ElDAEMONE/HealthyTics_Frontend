import 'dart:async';

import 'package:flutter/material.dart';
import 'package:healthytics/Controllers/AuthController.dart';
import 'package:healthytics/Models/Strings/app.dart';
import 'package:healthytics/Models/Strings/splash_screen.dart';
import 'package:healthytics/Models/Utils/Colors.dart';
import 'package:healthytics/Models/Utils/Common.dart';
import 'package:healthytics/Models/Utils/Images.dart';
import 'package:healthytics/Models/Utils/Routes.dart';
import 'package:healthytics/Models/Utils/Utils.dart';
import 'package:healthytics/Views/Auth/Login.dart';
import 'package:healthytics/Views/Contents/Home/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  final AuthController _authController = AuthController();

  @override
  void initState() {
    super.initState();
    startApp();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    displaySize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: colorWhite,
      body: SafeArea(
          child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: displaySize.width * 0.4,
                    child: Image.asset(logo),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      app_name,
                      style: TextStyle(fontSize: 23.0, color: colorBlack),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      app_quote.toUpperCase(),
                      style: TextStyle(fontSize: 13.0, color: colorBlack),
                    ),
                  ),
                ],
              )),
          Positioned(
              bottom: 0.0,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Text(
                  SplashScreen_version.toUpperCase(),
                  style: TextStyle(fontSize: 10.0, color: colorBlack),
                ),
              ))
        ],
      )),
    );
  }

  Future<void> startApp() async {
    if (await CustomUtils.getAuth() != null &&
        await _authController.doLoginCheck()) {
      // ignore: use_build_context_synchronously
      Routes(context: context).navigateReplace(const Home());
    } else {
      _timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
        _timer!.cancel();
        Routes(context: context).navigateReplace(const Login());
      });
    }
  }
}
