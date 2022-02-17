import 'dart:async';

// import '../screens/products_overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'auth_screen.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/Dashboard';

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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
    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl: '$urls',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
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
      // floatingActionButton: favoriteButton(),
    );
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
