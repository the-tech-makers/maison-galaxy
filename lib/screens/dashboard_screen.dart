import 'dart:async';
import 'dart:io';

// import '../screens/products_overview_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maison_galaxy/helpers/config.dart';
import 'package:maison_galaxy/screens/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'auth_screen.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/Dashboard';

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

late WebViewController controllerGlobal;

class _DashboardScreenState extends State<DashboardScreen>
    with WidgetsBindingObserver {
  late DragGesturePullToRefresh dragGesturePullToRefresh;
  late WebViewController _controller;
  // final Completer<WebViewController> _controller =
  //     Completer<WebViewController>();
  final CookieManager cookieManager = CookieManager();
  String urls=Config.API_BASE_URL;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState

    getSharedPref().then((value) => setState(() {
          urls = value;
        }));
    super.initState();
    dragGesturePullToRefresh = DragGesturePullToRefresh();
    WidgetsBinding.instance!.addObserver(this);
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  void dispose() {
    // remove listener
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _goBack(context),
        child: Scaffold(
            // We're using a Builder here so we have a context that is below the Scaffold
            // to allow calling Scaffold.of(context) so we can show a snackbar.
            body: RefreshIndicator(
                onRefresh: () => dragGesturePullToRefresh.refresh(),
                child: Builder(
                  builder: (context) => WebView(
                    initialUrl: '$urls',
                    gestureRecognizers: {
                      Factory(() => dragGesturePullToRefresh)
                    },
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (WebViewController webViewController) {
                      // _controller.future.then((value) => _controller1 = value);
                      // _controller.complete(webViewController);
                      _controller=webViewController;
                      _controller=webViewController;
                      dragGesturePullToRefresh
                          .setContext(context)
                          .setController(_controller);
                    },
                    onProgress: (int progress) {
                      // _showDialogError('TEST', 'Test1');
                      if (!isLoading && progress == 10) {
                        _showLoaderDialog(context);
                      }
                      // if (isLoading&&progress==100) {
                      //   Navigator.pop(context);
                      //   isLoading = false;
                      // }
                      print("WebView is loading (progress : $progress%)");
                    },
                    javascriptChannels: <JavascriptChannel>{
                      _toasterJavascriptChannel(context),
                    },
                    navigationDelegate: (NavigationRequest request) {
                      if (request.url
                          .toString()
                          .contains('customer/account/logout')) {
                        removeSharedPref();

                        _onClearCookies(context);
                        print('blocking navigation to $request}');
                        Navigator.of(context).pushReplacementNamed(
                            AuthScreen.routeName,
                            arguments: "");
                        return NavigationDecision.prevent;
                      }
                      if (request.url
                          .toString()
                          .contains('customer/account/login')) {
                        removeSharedPref();
                        _onClearCookies(context);
                        print('blocking navigation to $request}');
                        Navigator.of(context).pushReplacementNamed(
                            AuthScreen.routeName,
                            arguments: "");
                        return NavigationDecision.prevent;
                      }
                      print('allowing navigation to $request');
                      return NavigationDecision.navigate;
                    },
                    onPageStarted: (String url) {
                      // if (urls.contains("maisongalaxy")) {
                      if (isLoading) {
                        Navigator.pop(context);
                        isLoading = false;
                        _showLoaderDialog(context);
                      } else {
                        _showLoaderDialog(context);
                      }
                      dragGesturePullToRefresh.started();
                      // }
                      print('Page started loading: $url');
                    },
                    onPageFinished: (String url) {
                      if (isLoading) {
                        Navigator.pop(context);
                        isLoading = false;
                      }
                      dragGesturePullToRefresh.finished();
                      print('Page finished loading: $url');
                    },
                    onWebResourceError: (error) {
                      if (isLoading) {
                        Navigator.pop(context);
                        isLoading = false;
                      }
                      debugPrint(
                          'MyWebViewWidget:onWebResourceError(): ${error.description}');
                      dragGesturePullToRefresh.finished();
                    },
                    gestureNavigationEnabled: true,
                  ),
                ))));
    // return Scaffold(

    // floatingActionButton: favoriteButton(),
    // );
  }

  Future<bool> _goBack(BuildContext context) async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return Future.value(false);
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Do you want to exit'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('No'),
                  ),
                  TextButton(
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
    String url = Config.API_BASE_URL;
    if (prefs.containsKey("URL")) {
      url = prefs.getString("URL")!;
    } else if (prefs.containsKey("pp")) {
      url = prefs.getString("pp")!;
    }
    return url;
  }

  Future<void> removeSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("URL")) {
      prefs.remove("URL");
    }
    if (prefs.containsKey("pp")) {
      prefs.remove("pp");
    }
  }

  _showLoaderDialog(BuildContext context) {
    isLoading = true;
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        isLoading = true;
        return alert;
      },
    );
  }

  void _onClearCookies(BuildContext context) async {
    final bool hadCookies = await cookieManager.clearCookies();
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
}
