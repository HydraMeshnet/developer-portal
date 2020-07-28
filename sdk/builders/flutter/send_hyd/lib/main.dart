import 'package:flutter/material.dart';
///###FLUTTER_STEP_1
import 'package:iop_sdk/layer1.dart';
import 'package:iop_sdk/network.dart';
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
final network = Network.TestNet;
final targetAddress = 'tjseecxRmob5qBS2T3qc8frXDKz3YUGB8J'; // genesis
final walletPassphrase = 'scout try doll stuff cake welcome random taste load town clerk ostrich';
///###FLUTTER_STEP_2

///###FLUTTER_STEP_3
final layer1Api = Layer1Api(network);
final amount = 1e8 ~/ 10;
final txId = await layer1Api.sendTransferTxWithPassphrase(
  walletPassphrase,
  targetAddress,
  amount,
);
///###FLUTTER_STEP_3

if(txId == null) {
  throw Exception('TX could not be sent');
}

///###FLUTTER_STEP_3
print('Transaction ID: $txId');
///###FLUTTER_STEP_3
    
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
