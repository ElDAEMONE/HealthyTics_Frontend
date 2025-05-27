import 'package:flutter/material.dart';
import 'package:healthytics/Controllers/AuthController.dart';
import 'package:healthytics/Models/DB/LoggedUser.dart';
import 'package:healthytics/Models/Utils/Colors.dart';
import 'package:healthytics/Models/Utils/Common.dart';
import 'package:healthytics/Models/Utils/Images.dart';
import 'package:healthytics/Models/Utils/Routes.dart';
import 'package:healthytics/Models/Utils/Utils.dart';
import 'package:healthytics/Views/Contents/Enrollments/excercise.dart';
import 'package:healthytics/Views/Contents/Enrollments/meals.dart';
import 'package:healthytics/Views/Contents/History/daily_calories_prediction_history.dart';
import 'package:healthytics/Views/Contents/History/iot_history.dart';
import 'package:healthytics/Views/Contents/History/questionnaire_prediction_history.dart';
import 'package:healthytics/Views/Contents/Plan/plan.dart';
import 'package:healthytics/Views/Contents/Recommondations/recommondations.dart';

class HomeDrawer extends StatelessWidget {
  HomeDrawer({Key? key}) : super(key: key);

  final AuthController _authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: displaySize.width * 0.9,
      decoration: BoxDecoration(color: color6),
      child: ListView(
        children: [
          SizedBox(
            width: double.infinity,
            height: displaySize.height * 0.15,
            child: Container(
                decoration: BoxDecoration(color: colorBlack),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 15.0, bottom: 12.0, left: 15.0, right: 15.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 60.0,
                          width: 60.0,
                          child: ClipOval(
                            child: Image.asset(
                              user,
                              fit: BoxFit.cover,
                              colorBlendMode: BlendMode.darken,
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  CustomUtils.loggedInUser!.name!,
                                  style: TextStyle(
                                      color: color6,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18.0),
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  CustomUtils.loggedInUser!.email!,
                                  style: TextStyle(
                                      color: color6,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ))
                      ],
                    ),
                  ),
                )),
          ),
          ListTile(
            onTap: () => Navigator.pop(context),
            tileColor: color6,
            leading: Icon(
              Icons.home_outlined,
              color: color15,
            ),
            title: Text(
              'Home',
              style: TextStyle(
                  color: color15, fontWeight: FontWeight.w400, fontSize: 14.0),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: color15,
              size: 15.0,
            ),
          ),
          if (CustomUtils.loggedInUser!.type == LoggedUser.user)
            ListTile(
              onTap: () => Routes(context: context).navigate(Plan()),
              tileColor: color6,
              leading: Icon(
                Icons.air_outlined,
                color: color15,
              ),
              title: Text(
                'Suggested Excercise & Meal Plan',
                style: TextStyle(
                    color: color15,
                    fontWeight: FontWeight.w400,
                    fontSize: 14.0),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: color15,
                size: 15.0,
              ),
            ),
          if (CustomUtils.loggedInUser!.type == LoggedUser.admin)
            ListTile(
              onTap: () => Routes(context: context).navigate(ExerciseManage()),
              tileColor: color6,
              leading: Icon(
                Icons.workspaces_outlined,
                color: color15,
              ),
              title: Text(
                'Excercise Management',
                style: TextStyle(
                    color: color15,
                    fontWeight: FontWeight.w400,
                    fontSize: 14.0),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: color15,
                size: 15.0,
              ),
            ),
          if (CustomUtils.loggedInUser!.type == LoggedUser.admin)
            ListTile(
              onTap: () => Routes(context: context).navigate(MealsManage()),
              tileColor: color6,
              leading: Icon(
                Icons.food_bank_outlined,
                color: color15,
              ),
              title: Text(
                'Meals Management',
                style: TextStyle(
                    color: color15,
                    fontWeight: FontWeight.w400,
                    fontSize: 14.0),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: color15,
                size: 15.0,
              ),
            ),
          if (CustomUtils.loggedInUser!.type == LoggedUser.user)
            ListTile(
              onTap: () => Routes(context: context).navigate(IOTHistory()),
              tileColor: color6,
              leading: Icon(
                Icons.chrome_reader_mode_outlined,
                color: color15,
              ),
              title: Text(
                'IOT History',
                style: TextStyle(
                    color: color15,
                    fontWeight: FontWeight.w400,
                    fontSize: 14.0),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: color15,
                size: 15.0,
              ),
            ),
          if (CustomUtils.loggedInUser!.type == LoggedUser.user)
            ListTile(
              onTap: () => Routes(context: context)
                  .navigate(QuestionnairePredictionHistory()),
              tileColor: color6,
              leading: Icon(
                Icons.electrical_services,
                color: color15,
              ),
              title: Text(
                'Questionnaire Prediction History',
                style: TextStyle(
                    color: color15,
                    fontWeight: FontWeight.w400,
                    fontSize: 14.0),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: color15,
                size: 15.0,
              ),
            ),
          if (CustomUtils.loggedInUser!.type == LoggedUser.admin)
            ListTile(
              onTap: () =>
                  Routes(context: context).navigate(ManageRecommondations()),
              tileColor: color6,
              leading: Icon(
                Icons.settings,
                color: color15,
              ),
              title: Text(
                'Recommondations',
                style: TextStyle(
                    color: color15,
                    fontWeight: FontWeight.w400,
                    fontSize: 14.0),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: color15,
                size: 15.0,
              ),
            ),
          if (CustomUtils.loggedInUser!.type == LoggedUser.user)
            ListTile(
              onTap: () => Routes(context: context)
                  .navigate(DailyCaloriesPredictionHistory()),
              tileColor: color6,
              leading: Icon(
                Icons.balcony_rounded,
                color: color15,
              ),
              title: Text(
                'Daily Calories Prediction History',
                style: TextStyle(
                    color: color15,
                    fontWeight: FontWeight.w400,
                    fontSize: 14.0),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: color15,
                size: 15.0,
              ),
            ),
          ListTile(
            onTap: () => _authController.logout(context),
            tileColor: color6,
            leading: Icon(
              Icons.logout_outlined,
              color: color15,
            ),
            title: Text(
              'Logout',
              style: TextStyle(
                  color: color15, fontWeight: FontWeight.w400, fontSize: 14.0),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: color15,
              size: 15.0,
            ),
          ),
        ],
      ),
    );
  }
}
