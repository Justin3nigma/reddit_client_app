import 'package:flutter/material.dart';
import 'package:reddit_client/detail.dart';
import 'package:reddit_client/data.dart';
import 'package:reddit_client/login.dart';
import 'homepage.dart';

void main() => runApp(MaterialApp(
  initialRoute: '/',
  //initial route is gonna show first when we launch the map
  routes: {
    '/': (context) => Login(),
  },
));

