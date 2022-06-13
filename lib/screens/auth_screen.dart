import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/gestures.dart';
// import '../screens/products_overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:maison_galaxy/Models/user_d_t_o.dart';
import 'package:maison_galaxy/helpers/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard_screen.dart';

enum AuthMode { Signup, Login }
// String Role [ "R01, R02, R04 ]"

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/bg.png"),
                  fit: BoxFit.cover,
                ),
              ),
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    // flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDialogError(String msg, String title) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Container(
          margin: EdgeInsets.zero,
          // color: Colors.red,
          child: AlertDialog(
            backgroundColor: Theme.of(context).highlightColor,
            titlePadding: EdgeInsets.zero,
            title: Container(
              alignment: Alignment.center,

              height: 44,
              width: double.infinity,
              // alignment: Alignment.topLeft,
              color: Theme.of(context).focusColor,

              child: Text(
                title,
                softWrap: true,
                overflow: TextOverflow.fade,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(msg),
                  TextButton(
                    child: Text(
                      'OK',
                      // style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {
                      setState(() {});
                      Navigator.of(context).pop();
                    },
                  )

                  // Text('Would you like to approve of this message?'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  String s = "";
  bool _isHidden = true;
  Map _source = {ConnectivityResult.none: false};
  late Connectivity _connectivity;

  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'username': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  late String _setList;
  late SharedPreferences prefs;

  @override
  void initState() {
    print("initstate");
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    SharedPreferences.getInstance().then((value) => prefs=value);
    // _connectivity = MyConnectivity.instance;
    super.initState();
  }

  @override
  void dispose() {
    // _connectivity.disposeStream();
    super.dispose();
  }

  Future<void> _showDialogError(String msg, String title) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Container(
          margin: EdgeInsets.zero,
          // color: Colors.red,
          child: AlertDialog(
            backgroundColor: Theme.of(context).highlightColor,
            titlePadding: EdgeInsets.zero,
            title: Container(
              alignment: Alignment.center,

              height: 44,
              width: double.infinity,
              // alignment: Alignment.topLeft,
              color: Theme.of(context).focusColor,

              child: Text(
                title,
                softWrap: true,
                overflow: TextOverflow.fade,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(msg),
                  TextButton(
                    child: Text(
                      'OK',
                      // style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {
                      setState(() {
                        _isLoading = false;
                      });
                      Navigator.of(context).pop();
                    },
                  )

                  // Text('Would you like to approve of this message?'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _submit() async {
    // return;
    // AlertFormState()
    //     .showDialogBox(context, "Error:Alert Dialog body!!!\n ErrorCode:404");
    // return;
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    // try {
    print("Email:" + _authData['username'].toString());
    String url = Config.API_BASE_URL+"rest/all/V1/ttm/login-api/";
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-type': 'application/json'},
      body: json.encode({
        "username": _authData['username'].toString(),
        "password": _authData['password'].toString()
      }),
    );
    print(" N " + response.body);
    print(response.statusCode.toString());
    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);

      if (list[0].toString().contains('code')) {
        setState(() {
          _isLoading = false;
        });
        var snackBar = SnackBar(
            content: Text('Please enter valid username or password!!!'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        setState(() {
          UserDTO authDTO = UserDTO.fromJson(list[0]);
          prefs.setString("URL", authDTO.websiteUrl.toString());
          _isLoading = false;
        });
        // _showDialogError(response.body, "title");
        Navigator.of(context).pushReplacementNamed(DashboardScreen.routeName);
      }
    } else if (response.statusCode == 401) {
      setState(() {
        _isLoading = false;
      });
      var snackBar =
          SnackBar(content: Text('Please enter valid username or password'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      setState(() {
        _isLoading = false;
      });
      var snackBar =
          SnackBar(content: Text('Please enter valid username or password!!!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    // setState(() {
    //   _isLoading = false;
    // });

    // Navigator.of(context)
    //     .pushReplacementNamed(AdminScreen.routeName, arguments: "");
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(16.0),
      // ),
      // elevation: 8.0,
      child: Wrap(
        children: [
          Container(
            width: deviceSize.width * 1,
            padding: EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    // Text(_source.keys.toList()[0].),
                    Container(
                      alignment: Alignment.center,
                      child: Image.asset(
                        "assets/images/loginlogo.png",
                        width: deviceSize.width * 0.35,
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                      // height: 44,
                      width: double.infinity,
                      // alignment: Alignment.topLeft,
                      // padding: EdgeInsets.all(13),
                      // padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Text(
                        "Enter Your Email/Mobile No. to continue",
                        softWrap: true,
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                    TextFormField(
                      cursorColor: Theme.of(context).accentColor,
                      style: TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        labelText: 'User Name',
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10.0),
                        labelStyle:
                            TextStyle(color: Theme.of(context).accentColor),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).accentColor),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).accentColor),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Invalid User Login!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _authData['username'] = value!;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      cursorColor: Theme.of(context).accentColor,
                      style: TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: InkWell(
                          onTap: _togglePasswordView,
                          child: Icon(
                            _isHidden ? Icons.visibility : Icons.visibility_off,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10.0),
                        labelStyle:
                            TextStyle(color: Theme.of(context).accentColor),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).accentColor),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).accentColor),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      obscureText: _isHidden,
                      controller: _passwordController,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 3) {
                          return 'Password is too short!';
                        }
                      },
                      onSaved: (value) {
                        _authData['password'] = value!;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'By continuing, you agree to Maison Galaxy\'s ',
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Terms of use',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()..onTap = () {
                              var snackBar = SnackBar(
                                  content: Text('Terms of use'));
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              // prefs.setString("pp", Config.API_BASE_URL+"en/privacy-policy");
                              // Navigator.of(context).pushReplacementNamed(DashboardScreen.routeName);
                              // Single tapped.
                            },),
                          TextSpan(text: ' and '),
                          TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()..onTap = () {
                              // var snackBar = SnackBar(
                              //     content: Text('Privacy Policy'));
                              // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              prefs.setString("pp", Config.API_BASE_URL+"en/privacy-policy");
                              Navigator.of(context).pushReplacementNamed(
                                  DashboardScreen.routeName);
                              // Single tapped.
                            },),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (_isLoading)
                      CircularProgressIndicator()
                    else
                      Container(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                child: Text(
                                  'Login',
                                  style: TextStyle(fontSize: 16),
                                ),
                                onPressed: _submit,
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    primary: Theme.of(context).accentColor,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 8),
                                    textStyle: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold)),
                                // shape: RoundedRectangleBorder(
                                //   borderRadius: BorderRadius.circular(30),
                                // ),
                                // padding: EdgeInsets.symmetric(
                                //     horizontal: 30.0, vertical: 8.0),
                                // color: Theme.of(context).accentColor,
                                //color: Color(0xff73c076),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.topRight,
                                child: TextButton(
                                  child: Text(
                                    'Skip',
                                    style: TextStyle(
                                      fontSize: 18,
                                      // fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pushReplacementNamed(
                                        DashboardScreen.routeName);
                                  },
                                  // color: Theme.of(context).accentColor,
                                  //color: Color(0xff73c076),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
