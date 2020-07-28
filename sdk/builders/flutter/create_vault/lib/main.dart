import 'package:flutter/material.dart';
///###FLUTTER_STEP_1
import 'dart:io';
import 'package:iop_sdk/crypto.dart';
///###FLUTTER_STEP_1

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  Future<void> _incrementCounter() async {
///###FLUTTER_STEP_2
// YOU HAVE TO SAVE IT TO A SAFE PLACE!
final phrase = Bip39('en').generatePhrase();
final vault = Vault.create(
  phrase,
  '8qjaX^UNAafDL@!#',
  'unlock password',
);
///###FLUTTER_STEP_2

///###FLUTTER_STEP_3
final serializedState = vault.save();
await File('tutorial_vault.state').writeAsString(
  serializedState,
  flush: true,
);
///###FLUTTER_STEP_3

///###FLUTTER_STEP_4
final backup = await File('tutorial_vault.state').readAsString();
final vault = Vault.load(backup);
///###FLUTTER_STEP_4
    if(backup != serializedState) {
      throw Exception('Vaults are not identical');
    }

    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
