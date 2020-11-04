import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:sms/sms.dart';

// ignore: non_constant_identifier_names
int motor_number;
// ignore: non_constant_identifier_names
int feedback_number;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  motor_number = prefs.getInt("motor_number");
  feedback_number = prefs.getInt("feedback_number");
  print('motor_number $motor_number');
  print('feedback_number $feedback_number');
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String x, y;
  final feedbacknumberController = TextEditingController();
  final motornumberController = TextEditingController();

  int displaymotornumber(int mn) {
    return (mn);
  }

  int displayfeedbacknumber(int fn) {
    return (fn);
  }

  @override
  void dispose() {
    feedbacknumberController.dispose();
    motornumberController.dispose();
    super.dispose();
  }

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        "motor_number", int.tryParse(motornumberController.text));
    await prefs.setInt(
        "feedback_number", int.tryParse(feedbacknumberController.text));
    var num1 = int.tryParse(motornumberController.text);
    var num2 = int.tryParse(feedbacknumberController.text);
    x = displaymotornumber(num1).toString();
    y = displayfeedbacknumber(num2).toString();
    setState(() {});
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (context) => new Control_page(
                text: x,
              )));
    } else {
      prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new Registration_page()));
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (motor_number != null && feedback_number != null) {
        feedbacknumberController.text = feedback_number.toString();
        motornumberController.text = motor_number.toString();
        x = displaymotornumber(motor_number).toString();
        y = displayfeedbacknumber(feedback_number).toString();

        setState(() {});
      }
    });
    Future.delayed(
      Duration(seconds: 6),
      () {
        checkFirstSeen();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Registration_page(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage('assets/Krsik_X_logo.gif'),
              height: 400,
              width: 700,
            ),
            SizedBox(
              height: 50,
            ),
            Image(
              image: AssetImage('assets/loadinghouse.gif'),
              height: 100,
              width: 70,
            )
          ],
        ),
      ),
    );
  } //Splash Screen
}

// ignore: camel_case_types
class Registration_page extends StatefulWidget {
  @override
  _Registration_pageState createState() => _Registration_pageState();
}

// ignore: camel_case_types
class _Registration_pageState extends State<Registration_page> {
  String x, y;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final feedbacknumberController = TextEditingController();
  final motornumberController = TextEditingController();

  int displaymotornumber(int mn) {
    return (mn);
  }

  int displayfeedbacknumber(int fn) {
    return (fn);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (motor_number != null && feedback_number != null) {
        feedbacknumberController.text = feedback_number.toString();
        motornumberController.text = motor_number.toString();
        x = displaymotornumber(motor_number).toString();
        y = displayfeedbacknumber(feedback_number).toString();

        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    feedbacknumberController.dispose();
    motornumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Image.asset('images/SwBandhi_removebg_crop.png',
                  height: 100.0, width: 320.0),
            ),
          ), //SwBandhi logo
          Expanded(
            child: Form(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 35.0),
                  ),
                  Text(
                    'Register Here !!!',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28.0,
                        color: Colors.green),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: motornumberController,
                      maxLength: 10,
                      autovalidate: true,
                      keyboardType: TextInputType.number,
                      validator: (input) {
                        final isDigitsOnly = int.tryParse(input);
                        return isDigitsOnly == null
                            ? 'Input needs to be digits only'
                            : null;
                      },
                      decoration: InputDecoration(
                          hintText: 'Enter your machine mobile number'),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: feedbacknumberController,
                      maxLength: 10,
                      autovalidate: true,
                      keyboardType: TextInputType.number,
                      validator: (input) {
                        final isDigitsOnly = int.tryParse(input);
                        return isDigitsOnly == null
                            ? 'Input needs to be digits only'
                            : null;
                      },
                      decoration: InputDecoration(
                          hintText: 'Enter your feedback mobile number'),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Center(
                        child: MaterialButton(
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setInt("motor_number",
                                int.tryParse(motornumberController.text));
                            await prefs.setInt("feedback_number",
                                int.tryParse(feedbacknumberController.text));
                            var num1 = int.tryParse(motornumberController.text);
                            var num2 =
                                int.tryParse(feedbacknumberController.text);
                            x = displaymotornumber(num1).toString();
                            y = displayfeedbacknumber(num2).toString();
                            setState(() {});
                            _sendDataToSecondScreen(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Control_page(
                                          text: x.substring(0, 10),
                                        )));

                            SmsSender sender = SmsSender();
                            String address = x.toString();
                            SmsMessage message =
                                SmsMessage(address, y.toString());
                            message.onStateChanged.listen((state) {
                              if (state == SmsMessageState.Sent) {
                                print("SMS is sent!");
                              } else if (state == SmsMessageState.Delivered) {
                                print("SMS is delivered!");
                              }
                            });
                            sender.sendSms(message);
                          },
                          color: Colors.blue,
                          textColor: Colors.white,
                          child: Text('Submit'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendDataToSecondScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Control_page(
            text: x.substring(0, 10),
          ),
        ));
  }
}

// ignore: camel_case_types
class app1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, title: "Sms", home: Control_page());
  }
}

// ignore: camel_case_types
class Control_page extends StatefulWidget {
  final String text;
  Control_page({Key key, @required this.text}) : super(key: key);
  @override
  _Control_pageState createState() => _Control_pageState();
}

// ignore: camel_case_types
class _Control_pageState extends State<Control_page> {
  bool isSwitched1 = false;
  bool isSwitched2 = false;
  int count = 0;

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text("NO"),
              ),
              SizedBox(height: 16),
              new GestureDetector(child: Text("YES"), onTap: () => exit(0)),
            ],
          ),
        ) ??
        false;
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.indigo[50],
            body: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Image.asset(
                      'images/Krsik_X_removebg_crop.png',
                      height: 120.0,
                      width: 320.0,
                    ),
                  ),
                ), //Krsik X logo
                Expanded(
                  child: Container(
                    child: Image.asset('images/SwBandhi_removebg_crop.png'),
                  ),
                ), //SwBandhi logo
                SizedBox(
                  height: 40.0,
                ),
                Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'MOTOR AND JATKA MACHINE CONTROLLER',
                        style: TextStyle(
                            color: Colors.green[900],
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ), //Controller banner
                Center(
                  child: SizedBox(
                    height: 50.0,
                  ),
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 25.0,
                    ),
                    Flexible(
                      flex: 1,
                      child: Icon(
                        Icons.toys,
                        color: Colors.black,
                        size: 40.0,
                      ),
                    ), //Motor logo
                    SizedBox(
                      width: 20.0,
                    ),
                    Flexible(
                      flex: 10,
                      child: Container(
                        child: SwitchListTile(
                            title: new Text(
                              'MOTOR SWITCH : ',
                              style: TextStyle(
                                  color: Colors.green[900],
                                  fontSize: 27.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            value: isSwitched1,
                            activeColor: Colors.green[900],
                            onChanged: (value) {
                              setState(() {
                                isSwitched1 = value;
                                if (isSwitched1 == true) {
                                  sendsmsontomotor();
                                } else {
                                  sendsmsofftomotor();
                                }
                              });
                            }),
                      ),
                    ), //Motor Switch
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 25.0,
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        child: Icon(
                          Icons.flash_on,
                          color: Colors.black,
                          size: 40.0,
                        ),
                      ),
                    ), //Jatka Machine logo
                    SizedBox(
                      width: 20.0,
                    ),
                    Flexible(
                      flex: 10,
                      child: Container(
                        child: SwitchListTile(
                            title: new Text(
                              'JATKA MACHINE : ',
                              style: TextStyle(
                                  color: Colors.green[900],
                                  fontSize: 27.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            value: isSwitched2,
                            activeColor: Colors.green[900],
                            onChanged: (value) {
                              setState(() {
                                isSwitched2 = value;
                                if (isSwitched2 == true) {
                                  sendsmsontojatka();
                                } else {
                                  sendsmsofftojatka();
                                }
                              });
                            }),
                      ),
                    ), // Jatka Machine switch
                  ],
                ),
                SizedBox(
                  height: 30.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Center(
                      child: RaisedButton(
                        child: Text(
                          'Call for Care',
                        ),
                        color: Colors.lightGreen,
                        elevation: 20.0,
                        onPressed: () {
                          String call1 = "tel:+91 9924720999";
                          launch(call1);
                        },
                      ), //CC call
                    ),
                    Center(
                      child: RaisedButton(
                        child: Text(
                          'Visit Krsik X',
                        ),
                        color: Colors.lightGreen,
                        elevation: 20.0,
                        onPressed: () {
                          String url1 = "https://www.krsikx.com/";
                          launch(url1);
                        },
                      ), //Website Button
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }

  sendsmsontomotor() {
    SmsSender sender = SmsSender();
    String address = widget.text.toString();

    SmsMessage message = SmsMessage(address, '9510 ON');
    message.onStateChanged.listen((state) {
      if (state == SmsMessageState.Sent) {
        print("SMS is sent!");
      } else if (state == SmsMessageState.Delivered) {
        print("SMS is delivered!");
      }
    });
    sender.sendSms(message);
  }

  sendsmsofftomotor() {
    SmsSender sender = SmsSender();
    String address = widget.text.toString();

    SmsMessage message = SmsMessage(address, '9510 OFF');
    message.onStateChanged.listen((state) {
      if (state == SmsMessageState.Sent) {
        print("SMS is sent!");
      } else if (state == SmsMessageState.Delivered) {
        print("SMS is delivered!");
      }
    });
    sender.sendSms(message);
  }

  sendsmsontojatka() {
    SmsSender sender = SmsSender();
    String address = widget.text.toString();

    SmsMessage message = SmsMessage(address, 'ZK ON');
    message.onStateChanged.listen((state) {
      if (state == SmsMessageState.Sent) {
        print("SMS is sent!");
      } else if (state == SmsMessageState.Delivered) {
        print("SMS is delivered!");
      }
    });
    sender.sendSms(message);
  }

  sendsmsofftojatka() {
    SmsSender sender = SmsSender();
    String address = widget.text.toString();

    SmsMessage message = SmsMessage(address, 'ZK OFF');
    message.onStateChanged.listen((state) {
      if (state == SmsMessageState.Sent) {
        print("SMS is sent!");
      } else if (state == SmsMessageState.Delivered) {
        print("SMS is delivered!");
      }
    });
    sender.sendSms(message);
  }
}
