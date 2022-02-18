import 'dart:async';

// import '../screens/products_overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'auth_screen.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/Dashboard';

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

late WebViewController controllerGlobal;

class _DashboardScreenState extends State<DashboardScreen> {
  late WebViewController _controller1;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  final CookieManager cookieManager = CookieManager();
  late String urls;
  @override
  void initState() {
    // TODO: implement initState
    getSharedPref().then((value) => setState(() {
          urls = value;
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _goBack(context),
      child: Scaffold(
        // We're using a Builder here so we have a context that is below the Scaffold
        // to allow calling Scaffold.of(context) so we can show a snackbar.
        body: Builder(builder: (BuildContext context) {
          return WebView(
            initialUrl: '$urls',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.future.then((value) => _controller1 = value);
              _controller.complete(webViewController);
            },
            onProgress: (int progress) {
              // _showDialogError('TEST', 'Test1');
              print("WebView is loading (progress : $progress%)");
            },
            javascriptChannels: <JavascriptChannel>{
              _toasterJavascriptChannel(context),
            },
            navigationDelegate: (NavigationRequest request) {
              if (request.url.toString().contains('customer/account/logout')) {
                removeSharedPref();

                _onClearCookies(context);
                print('blocking navigation to $request}');
                Navigator.of(context)
                    .pushReplacementNamed(AuthScreen.routeName, arguments: "");
                return NavigationDecision.prevent;
              }
              if (request.url.toString().contains('customer/account/login')) {
                removeSharedPref();
                _onClearCookies(context);
                print('blocking navigation to $request}');
                Navigator.of(context)
                    .pushReplacementNamed(AuthScreen.routeName, arguments: "");
                return NavigationDecision.prevent;
              }
              print('allowing navigation to $request');
              return NavigationDecision.navigate;
            },
            onPageStarted: (String url) {
              print('Page started loading: $url');
            },
            onPageFinished: (String url) {
              print('Page finished loading: $url');
            },
            gestureNavigationEnabled: true,
          );
        }),
      ),
    );
    // return Scaffold(

    //   // floatingActionButton: favoriteButton(),
    // );
  }

  Future<bool> _goBack(BuildContext context) async {
    if (await _controller1.canGoBack()) {
      _controller1.goBack();
      return Future.value(false);
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Do you want to exit'),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('No'),
                  ),
                  FlatButton(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    child: Text('Yes'),
                  ),
                ],
              ));
      return Future.value(true);
    }
  }

  Future<String> getSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = "http://maisongalaxy.com/";
    if (prefs.containsKey("URL")) {
      url = prefs.getString("URL")!;
    }
    return url;
  }

  Future<void> removeSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("URL")) {
      prefs.remove("URL");
    }
  }

  void _onClearCookies(BuildContext context) async {
    final bool hadCookies = await cookieManager.clearCookies();
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
}
