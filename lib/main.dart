import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revision/Pages/home_detail_page.dart';
import 'package:revision/core/store.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:revision/Pages/home_page.dart';
import 'package:revision/models/themes.dart';
import 'package:revision/utils/routs.dart';

import 'Pages/cart_page.dart';
import 'Pages/login_page.dart';

void main() {
  runApp(VxState(store: MyStore(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: MyTheme.lightTheme(context),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      routes: {
        "/": (context) => LoginPage(),
        MyRouts.loginRoute: (context) => LoginPage(),
        MyRouts.cartRount: (context) => CartPage(),
        MyRouts.homeRoute: (context) => HomePage(),
      },
    );
  }
}
