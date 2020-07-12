import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(new MaterialApp(home: new MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  bool _enabled = false;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSettings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) {
//    debugPrint("payload : $payload");
    return showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text('Notification'),
        content: new Text('$payload'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var showNotification;
    if (_enabled) {
      showNotification = () async {
        var android = new AndroidNotificationDetails(
            'App id', 'App NAME', 'App DESCRIPTION',
            priority: Priority.High, importance: Importance.Max);
        var iOS = new IOSNotificationDetails();
        var platform = new NotificationDetails(android, iOS);
        await flutterLocalNotificationsPlugin.show(
            0, 'TEAM 6G', '4G NETWORK ACTIVATED', platform,
            payload: 'ENJOY YOUR 4G SERVICES');
      };
    }
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blueGrey[50],
        appBar: AppBar(
          title: Center(
              child: Text(
            'TEAM 6G',
            style: TextStyle(
              fontSize: 30.0,
            ),
          )),
          backgroundColor: Colors.black87,
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              title: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: RaisedButton(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Text(
                      'PRESS HERE',
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                  onPressed: showNotification,
                ),
              ),
            ),
            Container(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 30.0, horizontal: 0.0),
                child: Center(
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 700),
                    height: 50.0,
                    width: 130.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: _enabled
                          ? Colors.greenAccent[100]
                          : Colors.redAccent[100].withOpacity(0.5),
                    ),
                    child: Stack(
                      children: <Widget>[
                        AnimatedPositioned(
                          duration: Duration(milliseconds: 700),
                          curve: Curves.easeIn,
                          top: 3.0,
                          left: _enabled ? 80.0 : 0.0,
                          right: _enabled ? 0.0 : 80.0,
                          child: InkWell(
                            onTap: toggleButton,
                            child: AnimatedSwitcher(
                                duration: Duration(milliseconds: 700),
                                transitionBuilder: (Widget child,
                                    Animation<double> animation) {
                                  return ScaleTransition(
                                      child: child, scale: animation);
                                },
                                child: _enabled
                                    ? Icon(Icons.check_circle,
                                        color: Colors.green,
                                        size: 45.0,
                                        key: UniqueKey())
                                    : Icon(
                                        Icons.remove_circle_outline,
                                        color: Colors.red,
                                        size: 45.0,
                                        key: UniqueKey(),
                                      )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 100.0,
              child: Divider(
                color: Colors.black12,
              ),
            ),
            SizedBox(
              height: 10.0,
              child: Divider(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  toggleButton() {
    setState(() {
      _enabled = !_enabled;
    });
  }
}
