import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences prefs;

main() async {
  prefs = await SharedPreferences.getInstance();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Lifecycle Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _lastSaved;
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();

    _counter = (prefs.getInt('counter') ?? 0);
    _lastSaved = (prefs.getString('last-saved') ?? 'Unknown');

    SystemChannels.lifecycle.setMessageHandler((String event) async {
      if (event == AppLifecycleState.paused.toString()) {
        await saveState();
      }
    });
  }

  Future<void> saveState() async {
    await prefs.setInt('counter', _counter);
    _lastSaved = DateTime.now().toString();
    await prefs.setString('last-saved', _lastSaved);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text('Last saved: $_lastSaved'),
            new Text('Counter: $_counter'),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
}
