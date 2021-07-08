// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:async';

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
// Create a vault
final unlockPassword = 'unlockPassword';
final mnemonic = Bip39('en').generatePhrase();
final vault = Vault.create(mnemonic, '', unlockPassword);
///###FLUTTER_STEP_2

///###FLUTTER_STEP_3
// Initialize the Hydra plugin on the vault object
final accountNumber = 0;
final network = Network.TestNet;
HydraPlugin.init(vault, unlockPassword, network, accountNumber);
///###FLUTTER_STEP_3

///###FLUTTER_STEP_4
// Select the Hydra Account and different addresses
final hydra = HydraPlugin.get(vault, network, accountNumber);

final sourceAddress = hydra.public.key(0).address;
final targetAddress = hydra.public.key(1).address;
///###FLUTTER_STEP_4

///###FLUTTER_STEP_5
// Initialize the Layer-1 API
final layer1Api = Layer1Api.createApi(NetworkConfig.fromNetwork(network));

// Access the vault of the test faucet
final faucetPassword = 'correct horse battery staple';
final faucetVault = Vault.create(Bip39.DEMO_PHRASE, '', faucetPassword);
HydraPlugin.init(faucetVault, faucetPassword, network, accountNumber);
final faucetPrivate = HydraPlugin.get(faucetVault, network, accountNumber).private(faucetPassword);

// The Layer-1 API is used to send funds to the source address
final amount = 1e8.toInt(); // 1 HYD in flakes
final txId = await layer1Api.sendTransferTx(sourceAddress, targetAddress, amount, faucetPrivate);
///###FLUTTER_STEP_5

if(txId == null) {
  throw Exception('TX could not be sent');
}

///###FLUTTER_STEP_6
// The previous transaction has to be confirmed.
Timer(
  Duration(seconds: 15), () async {
    final txId = await layer1Api.sendTransferTx(
      sourceAddress,
      targetAddress,
      amount~/2,
      hydra.private(unlockPassword)
    );
    print(txId);
  }
);
///###FLUTTER_STEP_6
});
}
