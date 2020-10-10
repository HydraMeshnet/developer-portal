// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

///###FLUTTER_STEP_1
// Import the necessary modules from our SDK
import 'package:iop_sdk/layer1.dart';
import 'package:iop_sdk/network.dart';
///###FLUTTER_STEP_1

void main() {
  test('Sending Hydra', () async {
///###FLUTTER_STEP_2
// Select the testnet
final network = Network.TestNet;

// Gives access to a pre-generated wallet on the testnet
final walletPassphrase = 'scout try doll stuff cake welcome random taste load town clerk ostrich';

// The genesis address
final targetAddress = 'tjseecxRmob5qBS2T3qc8frXDKz3YUGB8J'; // genesis
///###FLUTTER_STEP_2

///###FLUTTER_STEP_3
// Return an api that can interact with the hydra blockchain
final layer1Api = Layer1Api(network);

// Sends a hydra transaction using a passphrase
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
// Prints the transaction ID
print('Transaction ID: $txId');
///###FLUTTER_STEP_3
  });
}
