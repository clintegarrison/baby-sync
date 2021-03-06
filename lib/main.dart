import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_date/dart_date.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MyAppState(),
      builder: (context, _) => MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Login(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MyAppState>(context);

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(
          "Baby Sync",
          overflow: TextOverflow.fade,
        ),
        actions: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(provider._user?.displayName ?? "",
                  style: TextStyle(fontSize: 20))
            ],
          ),
          PopupMenuButton(
            icon: Icon(Icons.account_circle),
            color: Colors.white,
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: Text(
                  "Logout",
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ),
            ],
            onSelected: (item) {
              provider.logout();
              WidgetsBinding.instance?.addPostFrameCallback((_) {
                Navigator.push(context, SlideRightRoute(page: Login()));
              });
            },
          ),
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Container(
          color: Color.fromARGB(100, 174, 125, 189),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage('images/baby.jpg'),
                height: 150,
              ),
              Card(
                  child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        log('Card tapped.');
                        provider.selectDate(context);
                      },
                      child: Expanded(child: Consumer<MyAppState>(
                        builder: (BuildContext context, state, Widget? child) {
                          var formattedDate = DateFormat("EEEE, MMM d")
                              .format(state.selectedDate);
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.calendar_month),
                              Text(
                                formattedDate,
                                style: new TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              )
                            ],
                          );
                        },
                      )))),
              Consumer<MyAppState>(
                builder: (BuildContext context, state, Widget? child) {
                  return Expanded(
                      child: ListView(
                    children: [BabyEventsWidget(state.babyEvents)],
                  ));
                },
              ),
              Row(
                children: [
                  Card(
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        log('Card tapped.');
                        Navigator.push(
                            context, SlideRightRoute(page: DiaperChange()));
                      },
                      child: SizedBox(
                          width: 120,
                          height: 100,
                          child: Container(
                            child: Row(
                              children: [
                                SizedBox(width: 5),
                                SvgPicture.asset(
                                  'images/diaper.svg',
                                  width: 100.0,
                                  height: 100.0,
                                  color: Colors.blue[800],
                                ),
                                SizedBox(width: 5),
                              ],
                            ),
                          )),
                    ),
                  ),
                  Card(
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        log('Card tapped.');
                        Navigator.push(
                            context, SlideRightRoute(page: Feeding()));
                      },
                      child: SizedBox(
                          width: 120,
                          height: 100,
                          child: Container(
                            child: Row(
                              children: [
                                SizedBox(width: 5),
                                SvgPicture.asset(
                                  'images/bottle.svg',
                                  width: 100.0,
                                  height: 100.0,
                                  color: Colors.pinkAccent,
                                ),
                                SizedBox(width: 5),
                              ],
                            ),
                          )),
                    ),
                  ),
                  Card(
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        log('Card tapped.');
                        Navigator.push(
                            context, SlideRightRoute(page: Sleeping()));
                      },
                      child: SizedBox(
                          width: 120,
                          height: 100,
                          child: Container(
                            child: Row(
                              children: [
                                SizedBox(width: 5),
                                SvgPicture.asset(
                                  'images/sleeping.svg',
                                  width: 100.0,
                                  height: 100.0,
                                  color: Colors.green,
                                ),
                                SizedBox(width: 5),
                              ],
                            ),
                          )),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class DiaperChange extends StatelessWidget {
  const DiaperChange({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MyAppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Diaper Change"),
      ),
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    provider.addEvent("diaperWet", context);
                  },
                  child: SizedBox(
                      width: 100,
                      height: 130,
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'images/water-drop.svg',
                              width: 80.0,
                              height: 80.0,
                              color: Colors.blue[800],
                            ),
                            SizedBox(width: 0, height: 10),
                            Text(
                              'Wet',
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            )
                          ],
                        ),
                      )),
                ),
              ),
              SizedBox(width: 40, height: 40),
              Card(
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    provider.addEvent("diaperDirty", context);
                  },
                  child: SizedBox(
                      width: 100,
                      height: 130,
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'images/poop.svg',
                              width: 80.0,
                              height: 80.0,
                              color: Colors.brown,
                            ),
                            SizedBox(width: 0, height: 10),
                            Text(
                              'Dirty',
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            )
                          ],
                        ),
                      )),
                ),
              ),
            ],
          ),
          SizedBox(width: 40, height: 40),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    provider.addEvent("diaperMixed", context);
                  },
                  child: SizedBox(
                      width: 100,
                      height: 130,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'images/poop.svg',
                                    width: 40.0,
                                    height: 40.0,
                                    color: Colors.brown,
                                  ),
                                  SvgPicture.asset(
                                    'images/water-drop.svg',
                                    width: 40.0,
                                    height: 40.0,
                                    color: Colors.blue[800],
                                  )
                                ]),
                            SizedBox(width: 0, height: 10),
                            Text(
                              'Mixed',
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            )
                          ],
                        ),
                      )),
                ),
              ),
              SizedBox(width: 40, height: 40),
              Card(
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    provider.addEvent("diaperDry", context);
                  },
                  child: SizedBox(
                      width: 100,
                      height: 130,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'images/diaper.svg',
                              width: 80.0,
                              height: 80.0,
                              color: Colors.black,
                            ),
                            Text(
                              'Dry',
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            )
                          ],
                        ),
                      )),
                ),
              ),
            ],
          ),
        ],
      )),
    );
  }
}

class Feeding extends StatelessWidget {
  const Feeding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MyAppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Feeding"),
      ),
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {
                provider.addEvent("feedingNursed", context);
              },
              child: SizedBox(
                  width: 200,
                  height: 130,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'images/breastfeed.svg',
                          width: 80.0,
                          height: 80.0,
                          color: Colors.pinkAccent,
                        ),
                        SizedBox(width: 0, height: 10),
                        Text(
                          'Nursed',
                          style: new TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        )
                      ],
                    ),
                  )),
            ),
          ),
          SizedBox(width: 40, height: 40),
          Card(
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {
                provider.addEvent("feedingExpressed", context);
              },
              child: SizedBox(
                  width: 200,
                  height: 130,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'images/breastpump.svg',
                                width: 70.0,
                                height: 70.0,
                                color: Colors.pinkAccent,
                              ),
                              SvgPicture.asset(
                                'images/bottle.svg',
                                width: 70.0,
                                height: 70.0,
                                color: Colors.pinkAccent,
                              )
                            ]),
                        Text(
                          'Expressed',
                          style: new TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        )
                      ],
                    ),
                  )),
            ),
          ),
          SizedBox(width: 40, height: 40),
          Card(
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {
                provider.addEvent("feedingFormula", context);
              },
              child: SizedBox(
                  width: 200,
                  height: 130,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'images/bottle.svg',
                          width: 80.0,
                          height: 80.0,
                          color: Colors.pinkAccent,
                        ),
                        Text(
                          'Formula',
                          style: new TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        )
                      ],
                    ),
                  )),
            ),
          ),
        ],
      )),
    );
  }
}

class Sleeping extends StatelessWidget {
  const Sleeping({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MyAppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Sleeping"),
      ),
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {
                provider.addEvent("sleepingStart", context);
              },
              child: SizedBox(
                  width: 200,
                  height: 130,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'images/fall-asleep.svg',
                          width: 80.0,
                          height: 80.0,
                          color: Colors.green,
                        ),
                        SizedBox(width: 0, height: 10),
                        Text(
                          'Fell asleep',
                          style: new TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        )
                      ],
                    ),
                  )),
            ),
          ),
          SizedBox(width: 40, height: 40),
          Card(
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {
                provider.addEvent("sleepingEnd", context);
              },
              child: SizedBox(
                  width: 200,
                  height: 130,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'images/alarm.svg',
                          width: 80.0,
                          height: 80.0,
                          color: Colors.green,
                        ),
                        Text(
                          'Awoke',
                          style: new TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        )
                      ],
                    ),
                  )),
            ),
          ),
        ],
      )),
    );
  }
}

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      log("FirebaseAuthException");
    }
  }

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login"), automaticallyImplyLeading: false),
      body: Center(
        child: Column(
          children: [
            Consumer<MyAppState>(
              builder: (BuildContext context, state, Widget? child) {
                if (state.authenticated) {
                  String title = 'Baby Sync';
                  if (state._user?.displayName != null &&
                      state._user?.displayName != '') {
                    title += ' - ';
                    title += state._user?.displayName ?? '';
                  }
                  WidgetsBinding.instance?.addPostFrameCallback((_) {
                    Navigator.of(context).pushAndRemoveUntil(
                        SlideRightRoute(page: MyHomePage(title: title)),
                        (Route<dynamic> route) => false);
                  });
                }
                return Text("");
              },
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
              child: TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  )),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
              child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  )),
            ),
            TextButton(
              child: Text(
                'Login',
                style: TextStyle(fontSize: 20.0),
              ),
              onPressed: () {
                signInWithEmailAndPassword(
                    emailController.text, passwordController.text);
              },
            )
          ],
        ),
      ),
    );
  }
}

class BabyEvent {
  BabyEvent(
      {required this.eventType,
      required this.timestamp,
      required this.email,
      required this.displayName});
  final String eventType;
  final DateTime timestamp;
  final String email;
  final String displayName;
}

class MyAppState extends ChangeNotifier {
  MyAppState() {
    init();
  }

  bool authenticated = false;

  User? _user;

  DateTime selectedDate = DateTime.now();

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        authenticated = true;
        if (user.displayName!.isEmpty) {
          if (user.email!.contains('clint')) {
            user.updateDisplayName('Clint');
          } else {
            user.updateDisplayName('Brianna');
          }
        }
        _eventsSubscription = FirebaseFirestore.instance
            .collection('events')
            .orderBy('timestamp', descending: true)
            .snapshots()
            .listen((snapshot) {
          _allBabyEvents = [];
          for (final document in snapshot.docs) {
            var timestamp = document.data()['timestamp'];
            var dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
            _allBabyEvents.add(
              BabyEvent(
                eventType: document.data()['eventType'] as String,
                timestamp: dateTime,
                email: document.data()['email'] as String,
                displayName: document.data()['displayName'] as String,
              ),
            );
          }
          filterEventsByDate();
          notifyListeners();
        });
      } else {
        authenticated = false;
        _allBabyEvents = [];
        _eventsSubscription?.cancel();
      }
      _user = user;
      notifyListeners();
    });
  }

  StreamSubscription<QuerySnapshot>? _eventsSubscription;
  List<BabyEvent> _allBabyEvents = [];
  List<BabyEvent> get babyEvents => _filteredEvents;
  List<BabyEvent> _filteredEvents = [];

  Future<void> addEvent(String eventType, BuildContext context) async {
    if (!authenticated) {
      throw Exception('Must be logged in');
    }

    FirebaseFirestore.instance.collection('events').add(<String, dynamic>{
      'eventType': eventType,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'email': FirebaseAuth.instance.currentUser!.email,
      'displayName': FirebaseAuth.instance.currentUser!.displayName
    });

    Navigator.pop(context);
  }

  Future<void> logout() async {
    FirebaseAuth.instance.signOut();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2021, 8),
        lastDate: DateTime(2031));
    if (picked != null && picked != selectedDate) selectedDate = picked;
    filterEventsByDate();
    notifyListeners();
  }

  void filterEventsByDate() {
    var filteredEvents = _allBabyEvents
        .where((element) => element.timestamp.isSameDay(selectedDate));
    _filteredEvents = filteredEvents.toList();
  }
}

class BabyEventsWidget extends StatefulWidget {
  const BabyEventsWidget(this.babyEvents);
  final List<BabyEvent> babyEvents;

  @override
  State<StatefulWidget> createState() {
    return _BabyEventsState();
  }
}

class _BabyEventsState extends State<BabyEventsWidget> {
  @override
  // Modify from here
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Card(
            child: Column(
          children: [
            for (var i = 0; i < widget.babyEvents.length; i++)
              renderEvent(widget.babyEvents[i], i == 0)
          ],
        )));
  }

  Widget renderEvent(BabyEvent event, bool hideBorder) {
    String eventType = event.eventType;
    String userWhoCreatedEvent = event.displayName;
    String formattedTime =
        ' @ ' + DateFormat("hh:mm a").format(event.timestamp);

    Color? color = Colors.blue[800];
    String svgPath = 'images/diaper.svg';
    String eventDescription = '';

    switch (eventType) {
      case 'sleepingStart':
        color = Colors.green;
        eventDescription = ' baby fell asleep ';
        svgPath = 'images/fall-asleep.svg';
        break;
      case 'sleepingEnd':
        color = Colors.green;
        eventDescription = 'baby woke up ';
        svgPath = 'images/alarm.svg';
        break;
      case 'diaperWet':
        color = Colors.blue[800];
        eventDescription = ' changed a wet diaper ';
        svgPath = 'images/water-drop.svg';
        break;
      case 'diaperDirty':
        color = Colors.blue[800];
        eventDescription = ' changed a dirty diaper ';
        svgPath = 'images/poop.svg';
        break;
      case 'diaperMixed':
        color = Colors.blue[800];
        eventDescription = ' changed a mixed diaper ';
        svgPath = 'images/diaper.svg';
        break;
      case 'diaperDry':
        color = Colors.blue[800];
        eventDescription = ' changed a dry diaper ';
        svgPath = 'images/diaper.svg';
        break;
      case 'feedingNursed':
        color = Colors.pinkAccent;
        eventDescription = ' nursed ';
        svgPath = 'images/breastfeed.svg';
        break;
      case 'feedingExpressed':
        color = Colors.pinkAccent;
        eventDescription = ' formula ';
        svgPath = 'images/breastpump.svg';
        break;
      case 'feedingFormula':
        color = Colors.pinkAccent;
        eventDescription = ' formula ';
        svgPath = 'images/bottle.svg';
        break;
    }

    return SizedBox(
        width: double.infinity,
        height: 50,
        child: Container(
          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: hideBorder
                ? Border() // This will create no border for the first item
                : Border(
                    top: BorderSide(
                        width: 1,
                        color: Colors.grey
                            .shade300)), // This will create top borders for the rest
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                svgPath,
                width: 40.0,
                height: 40.0,
                color: color,
              ),
              SizedBox(width: 10),
              Text(
                userWhoCreatedEvent + ':' + eventDescription + formattedTime,
                style: new TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 14, color: color),
              ),
            ],
          ),
        ));
  }
}

class SlideRightRoute extends PageRouteBuilder {
  final Widget page;
  SlideRightRoute({required this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}
