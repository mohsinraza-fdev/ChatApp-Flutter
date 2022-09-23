import 'package:flutter/material.dart';

double screenWidth(BuildContext context, {double percentage = 1}) =>
    MediaQuery.of(context).size.width * percentage;
double screenHeight(BuildContext context, {double percentage = 1}) =>
    MediaQuery.of(context).size.height * percentage;
double statusBarHeight(BuildContext context) =>
    MediaQuery.of(context).padding.top;
