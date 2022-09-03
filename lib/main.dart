import 'package:flutter/material.dart';

import 'screens/auth_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: '',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            // primarySwatch: colorCustom,
            primaryColor: Color(0xFF1c2224),
            accentColor: Color(0xFFe96125),
            primaryColorDark: Color(0xff000000),

            // backgroundColor: Color(0xFFf1fce3),
            // secondaryHeaderColor: Color(0xFFb7d594),
            buttonColor: Color(0xffe96125),
            // errorColor: Color(0xffd1222a),
            // highlightColor: Color(0xfff2b4c3),
            // focusColor: Color(0xffe78aa0),

            // canvasColor: Color(0xfff2b4c3),
            // accentColor: Color(Constants.ButtonBG),
            fontFamily: 'Roboto',
            textTheme: Theme.of(context).textTheme.apply(

                // bodyColor: Colors.blue,
                // displayColor: Colors.blue,
                )),
        // textTheme: TextTheme(
        //   headline1:
        //       TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        //   headline6:
        //       TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        //   bodyText1:
        //       TextStyle(fontSize: 48.0, fontStyle: FontStyle.normal),
        // )),
        home: SplashScreen(), //AuthScreen(),
        // home: PlantScreen(),
        routes: {
          // ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          // SplashScreen.routeName: (ctx) => SplashScreen(),
          AuthScreen.routeName: (ctx) => AuthScreen(),
          // CartScreen.routeName: (ctx) => CartScreen(),
          DashboardScreen.routeName: (ctx) => DashboardScreen(),
        });
  }
}
