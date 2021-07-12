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
// Instantiate the demo vault that acts as a source of funds
final sourcePassword = 'correct horse battery staple';
final sourceVault = Vault.create(Bip39.DEMO_PHRASE, '', sourcePassword);
///###FLUTTER_STEP_2

///###FLUTTER_STEP_3
// Initialize the Hydra plugin on the vault object
final accountNumber = 0;
final network = Network.TestNet;
HydraPlugin.init(sourceVault, sourcePassword, network, accountNumber);

// Get the private interface of the Hydra plugin
final hydra = HydraPlugin.get(sourceVault, network, accountNumber);
final hydraPrivate = hydra.private(sourcePassword);

// The address from which funds are sent from
final sourceAddress = hydra.public.key(0).address;
///###FLUTTER_STEP_3

///###FLUTTER_STEP_4
// Initialize your personal vault that will act as the target
final mnemonic = Bip39('en').generatePhrase();
final targetPassword = 'horse battery staple correct';
final targetVault = Vault.create(mnemonic, '', targetPassword);
HydraPlugin.init(targetVault, targetPassword, network, accountNumber);

// The address to which the funds are sent to
final targetHydra = HydraPlugin.get(targetVault, network, accountNumber);

// Initialize the second key on the private hydra interface
targetHydra.private(targetPassword).key(1);
final targetAddress = targetHydra.public.key(1).address;
///###FLUTTER_STEP_4

///###FLUTTER_STEP_5
// Return an api that can interact with the hydra blockchain
final networkConfig = NetworkConfig.fromNetwork(network);
final layer1Api = Layer1Api.createApi(networkConfig);

// Send a hydra transaction using the hydra private object.
final amount = 1e8; // 1 HYD in flakes
final txId = await layer1Api.sendTransferTx(
  sourceAddress,
  targetAddress,
  amount.toInt(),
  hydraPrivate
); 

// Prints the transaction ID
print('Transaction ID: $txId');
///###FLUTTER_STEP_5

if(txId == null) {
  throw Exception('TX could not be sent');
}
  });
}
