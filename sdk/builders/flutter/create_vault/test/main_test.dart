// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

///###FLUTTER_STEP_1
import 'dart:io';
import 'package:iop_sdk/crypto.dart';
///###FLUTTER_STEP_1


void main() {
  test('Create Vault', () async {
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
final loadedVault = Vault.load(backup);
///###FLUTTER_STEP_4
    if(loadedVault.save() != serializedState) {
      throw Exception('Vaults are not identical');
    }
  });
}
