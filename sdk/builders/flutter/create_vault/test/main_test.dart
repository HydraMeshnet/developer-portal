// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

///###FLUTTER_STEP_1
import 'dart:io';

//Import the Crypto module from our SDK
import 'package:iop_sdk/crypto.dart';
///###FLUTTER_STEP_1


void main() {
  test('Create Vault', () async {
///###FLUTTER_STEP_2
// YOU HAVE TO SAVE THE PASSPHRASE SECURELY!
final phrase = Bip39('en').generatePhrase();

// Creates a new vault using a passphrase, password and unlock password, which encrypts/decrypts the seed
final vault = Vault.create(
  phrase,
  '8qjaX^UNAafDL@!#',
  'unlock password',
);
///###FLUTTER_STEP_2

///###FLUTTER_STEP_3
// Saves the encrypted seed of the vault.
final serializedState = vault.save();

// Writes the state to a file
await File('tutorial_vault.state').writeAsString(
  serializedState,
  flush: true,
);
///###FLUTTER_STEP_3

///###FLUTTER_STEP_4
// Reads and loads the vault from the saved file
final backup = await File('tutorial_vault.state').readAsString();
final loadedVault = Vault.load(backup);
///###FLUTTER_STEP_4
    if(loadedVault.save() != serializedState) {
      throw Exception('Vaults are not identical');
    }
  });
}
