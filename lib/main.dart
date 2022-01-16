import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
          widget.title,
          overflow: TextOverflow.fade,
        ),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Consumer<MyAppState>(
              builder: (BuildContext context, state, Widget? child) {
                return Expanded(
                    child: ListView(
                  children: [BabyEventsWidget(state.babyEvents)],
                ));
              },
            ),
            Card(
              child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () {
                  log('Card tapped.');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DiaperChange()),
                  );
                },
                child: SizedBox(
                    width: double.infinity,
                    height: 100,
                    child: Container(
                      child: Row(
                        children: [
                          SizedBox(width: 20),
                          Image(image: AssetImage('images/diaper.png')),
                          SizedBox(width: 10),
                          Text(
                            'Add diaper change',
                            style: new TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          )
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
                },
                child: SizedBox(
                    width: double.infinity,
                    height: 100,
                    child: Container(
                      child: Row(
                        children: [
                          SizedBox(width: 20),
                          Image(image: AssetImage('images/bottle.png')),
                          SizedBox(width: 10),
                          Text(
                            'Add feeding record',
                            style: new TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          )
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
                },
                child: SizedBox(
                    width: double.infinity,
                    height: 100,
                    child: Container(
                      child: Row(
                        children: [
                          SizedBox(width: 20),
                          Image(image: AssetImage('images/sleeping.png')),
                          SizedBox(width: 10),
                          Text(
                            'Add sleep record',
                            style: new TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          )
                        ],
                      ),
                    )),
              ),
            )
          ],
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
                    provider.addEvent("wetDiaper");
                  },
                  child: SizedBox(
                      width: 100,
                      height: 130,
                      child: Container(
                        child: Column(
                          children: [
                            Image(image: AssetImage('images/diaper.png')),
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
                    provider.addEvent("dirtyDiaper");
                  },
                  child: SizedBox(
                      width: 100,
                      height: 130,
                      child: Container(
                        child: Column(
                          children: [
                            Image(image: AssetImage('images/diaper.png')),
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
                    provider.addEvent("mixedDiaper");
                  },
                  child: SizedBox(
                      width: 100,
                      height: 130,
                      child: Container(
                        child: Column(
                          children: [
                            Image(image: AssetImage('images/diaper.png')),
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
                    provider.addEvent("dryDiaper");
                  },
                  child: SizedBox(
                      width: 100,
                      height: 130,
                      child: Container(
                        child: Column(
                          children: [
                            Image(image: AssetImage('images/diaper.png')),
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
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
        child: Column(
          children: [
            Consumer<MyAppState>(
              builder: (BuildContext context, state, Widget? child) {
                if (state.authenticated) {
                  String title = 'Baby Sync';
                  if (state._user?.email != null && state._user?.email != '') {
                    title += ' - ';
                    title += state._user?.email ?? '';
                  }
                  WidgetsBinding.instance?.addPostFrameCallback((_) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyHomePage(title: title)),
                    );
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
      required this.userId,
      required this.email});
  final String eventType;
  final int timestamp;
  final String userId;
  final String email;
}

class MyAppState extends ChangeNotifier {
  MyAppState() {
    init();
  }

  bool authenticated = false;

  User? _user;

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        authenticated = true;
        _eventsSubscription = FirebaseFirestore.instance
            .collection('events')
            .orderBy('timestamp', descending: true)
            .snapshots()
            .listen((snapshot) {
          _babyEvents = [];
          for (final document in snapshot.docs) {
            _babyEvents.add(
              BabyEvent(
                eventType: document.data()['eventType'] as String,
                timestamp: document.data()['timestamp'],
                userId: document.data()['userId'] as String,
                email: document.data()['email'] as String,
              ),
            );
          }
          notifyListeners();
        });
      } else {
        authenticated = false;
        _babyEvents = [];
        _eventsSubscription?.cancel();
      }
      _user = user;
      notifyListeners();
    });
  }

  StreamSubscription<QuerySnapshot>? _eventsSubscription;
  List<BabyEvent> _babyEvents = [];
  List<BabyEvent> get babyEvents => _babyEvents;

  Future<DocumentReference> addEvent(String eventType) {
    if (!authenticated) {
      throw Exception('Must be logged in');
    }

    return FirebaseFirestore.instance
        .collection('events')
        .add(<String, dynamic>{
      'eventType': eventType,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'email': FirebaseAuth.instance.currentUser!.email
    });
  }
}

class BabyEventsWidget extends StatefulWidget {
  const BabyEventsWidget(this.babyEvents);
  // final FutureOr<void> Function(String message) addMessage;
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
    return Column(
      children: [
        // for (var i = 0; i < 10; i++) Text('testing'),
        for (var babyEvent in widget.babyEvents)
          SizedBox(
              width: double.infinity,
              height: 50,
              child: Container(
                child: Row(
                  children: [
                    SizedBox(width: 20),
                    Image(image: AssetImage('images/diaper.png')),
                    SizedBox(width: 10),
                    Text(
                      babyEvent.email + ' @ ' + babyEvent.timestamp.toString(),
                      style: new TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 10),
                    )
                  ],
                ),
              )),
      ],
    );
  }
}
