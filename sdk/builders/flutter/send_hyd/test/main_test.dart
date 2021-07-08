// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

///###FLUTTER_STEP_1
// Import the necessary modules from our SDK
import 'package:iop_sdk/crypto.dart';
import 'package:iop_sdk/layer1.dart';
import 'package:iop_sdk/network.dart';
///###FLUTTER_STEP_1

void main() {
  test('Sending Hydra', () async {
///###FLUTTER_STEP_2
// Instantiate a vault object deployed for test purposes
final unlockPassword = 'correct horse battery staple';
final vault = Vault.create(Bip39.DEMO_PHRASE, '', unlockPassword);
///###FLUTTER_STEP_2

///###FLUTTER_STEP_3
// Initialize the Hydra plugin on the vault object
final accountNumber = 0;
final network = Network.TestNet;
HydraPlugin.init(vault, unlockPassword, network, accountNumber);

// Get the private interface of the Hydra plugin
final hydra = HydraPlugin.get(vault, network, accountNumber);
final hydraPrivate = hydra.private(unlockPassword);
///###FLUTTER_STEP_3

///###FLUTTER_STEP_4
// The address from which funds are sent from
final sourceAddress = hydra.public.key(0).address;

// The address to which the funds are sent to
const targetAddress = "tjseecxRmob5qBS2T3qc8frXDKz3YUGB8J";
///###FLUTTER_STEP_4

///###FLUTTER_STEP_5
// Initialize the Hydra plugin on the vault object
final layer1Api = Layer1Api.createApi(NetworkConfig.fromNetwork(network));

// Send a hydra transaction using the hydra private object.
final amount = 1e8 / 10; // 0.1 HYD
final txId = await layer1Api.sendTransferTx(
    sourceAddress,
    targetAddress,
    amount.toInt(),
    hydraPrivate
); 
///###FLUTTER_STEP_5

if(txId == null) {
  throw Exception('TX could not be sent');
}

///###FLUTTER_STEP_6
// Prints the transaction ID
print('Transaction ID: $txId');
///###FLUTTER_STEP_6
  });
}
