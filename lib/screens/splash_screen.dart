import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maison_galaxy/screens/auth_screen.dart';
import 'package:maison_galaxy/screens/dashboard_screen.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
  static const routeName = '/';
}

class _SplashScreenState extends State<SplashScreen> {
  // String appName;
  // String packageName;
  late String _version = "";
  late String _versionCode = "";

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      //  appName = packageInfo.appName;
      //  packageName = packageInfo.packageName;

      setState(() {
        _version = packageInfo.version;
        _versionCode = packageInfo.buildNumber;
      });
    });
    // GEOLocation geoLocation = new GEOLocation();
    // geoLocation.calculateDistanceM(_locationDTO.lat, _locationDTO.lng,
    //  userDTO.entity.locLatitude, userDTO.entity.locLongitude);
    Timer(Duration(seconds: 3), () => getData());
    super.initState();
  }

  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool dataExist = prefs.containsKey("URL");
    // print('data:- ' + prefs.getString("URL").toString());
    if (dataExist) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => DashboardScreen()));
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => AuthScreen()));
    }
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // _ConnectivityAlert(context);
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: Color(0xfffece2e),
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg.png"),
                fit: BoxFit.cover,
              ),
            ),
            // margin: EdgeInsets.only(left: 30, top: 30, right: 30),
            alignment: Alignment.center,
            child: Image.asset(
              "assets/images/my_icon_ios.png",
              width: deviceSize.width * 0.75,
            ),
          ),
        ],
      ),
    );
  }
}
