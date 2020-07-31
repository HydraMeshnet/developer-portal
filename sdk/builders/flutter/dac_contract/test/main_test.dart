// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
///###FLUTTER_STEP_1
import 'dart:convert';
import 'dart:typed_data';

import 'package:iop_sdk/crypto.dart';
import 'package:iop_sdk/layer1.dart';
import 'package:iop_sdk/layer2.dart';
import 'package:iop_sdk/network.dart';
///###FLUTTER_STEP_1

void main() {
  test('DAC Contract - Before Proof', () async {
///###FLUTTER_STEP_2
final network = Network.TestNet;
final hydraGasPassphrase = 'scout try doll stuff cake welcome random taste load town clerk ostrich';
final hydraGasPublicKey = "03d4bda72219264ff106e21044b047b6c6b2c0dde8f49b42c848e086b97920adbf";
final unlockPassword = '+*7=_X8<3yH:v2@s';
///###FLUTTER_STEP_2

///###FLUTTER_STEP_3
// YOU HAVE TO SAVE IT TO A SAFE PLACE!
final phrase = Bip39('en').generatePhrase();
final vault = Vault.create(
  phrase,
  '8qjaX^UNAafDL@!#', // this is for plausible deniability
  unlockPassword,
);
///###FLUTTER_STEP_3

///###FLUTTER_STEP_4
MorpheusPlugin.rewind(vault, unlockPassword);
final morpheusPlugin = MorpheusPlugin.get(vault);

final did = morpheusPlugin.public.personas.did(0);  // you are going to use the first DID
print('Using DID: ${did.toString()}');
///###FLUTTER_STEP_4

if(did == null) {
  throw Exception('DID is null');
}

///###FLUTTER_STEP_5
final keyId = did.defaultKeyId(); // acquire the default key
final contractStr = 'A long legal document, e.g. a contract with all details';
final contractBytes = Uint8List.fromList(utf8.encode(contractStr)).buffer.asByteData();
final morpheusPrivate = morpheusPlugin.private(unlockPassword); // acquire the plugin's private interface that provides you the sign interface

final signedContract = morpheusPrivate.signDidOperations(keyId, contractBytes); // YOU NEED TO SAVE IT TO A SAFE PLACE!

final signedContractJson = <String, dynamic>{
  'content': utf8.decode(signedContract.content.content.buffer.asUint8List()), // you must use this Buffer wrapper at the moment, we will improve in later releases,
  'publicKey': signedContract.signature.publicKey.value,
  'signature': signedContract.signature.bytes.value,
};
print('Signed contract: ${stringifyJson(signedContractJson)}');
///###FLUTTER_STEP_5

///###FLUTTER_STEP_6
final beforeProof = digestJson(signedContractJson);
print('Before proof: ${beforeProof.value}');
///###FLUTTER_STEP_6

if(beforeProof == null) {
    throw Exception('beforeProof is null');
}

///###FLUTTER_STEP_7
final opAttempts = OperationAttemptsBuilder()  // let's create our operation attempts data structure
  .registerBeforeProof(beforeProof)
  .getAttempts();

// let's initialize our layer-1 API
final layer1Api = Layer1Api(network);

// let's query and then increment the current nonce of the owner of the tx fee
int nonce = await layer1Api.getWalletNonce(hydraGasPublicKey);
nonce = nonce + 1;

// and now you are ready to send it
final txId = await layer1Api.sendMorpheusTxWithPassphrase(opAttempts, hydraGasPassphrase, nonce: nonce);
print('Transaction ID: $txId');
///###FLUTTER_STEP_7

///###FLUTTER_STEP_8
await Future.delayed(Duration(seconds: 12));  // it'll be included in the SDK Soon in 2020

// layer-1 transaction must be confirmed
final txStatus = await layer1Api.getTxnStatus(txId);
print('Tx status: ${json.encode(txStatus.value.toJson())}');  // the SDK uses optional's Optional result

// now you can query from the layer-2 API as well!
final layer2Api = Layer2Api(network);
final dacTxStatus = await layer2Api.getTxnStatus(txId);
print('DAC Tx status: ${dacTxStatus.value}');  // the SDK uses optional's Optional result
///###FLUTTER_STEP_8

///###FLUTTER_STEP_9
// we assume here that signedContract is in scope and available
final expectedContentId = digestJson(signedContractJson);
///###FLUTTER_STEP_9

///###FLUTTER_STEP_10
final history = await layer2Api.getBeforeProofHistory(expectedContentId);
print('Proof history: ${json.encode(history.toJson())}');
///###FLUTTER_STEP_10

if(history.contentId != expectedContentId) {
  throw Exception('Content Id does not match');
}
  });
}
