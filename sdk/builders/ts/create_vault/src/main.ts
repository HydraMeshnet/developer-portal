///###TS_STEP_1
// Import the Crypto module from our SDK
import { Crypto } from '@internet-of-people/sdk';
///###TS_STEP_1

///###TS_STEP_2
// YOU HAVE TO SAVE THE PASSPHRASE SECURELY!
const phrase = new Crypto.Bip39('en').generate().phrase;

// Creates a new vault using a passphrase, password and unlock password, which encrypts/decrypts the seed
const vault = Crypto.Vault.create(
  phrase,
  '8qjaX^UNAafDL@!#',
  'unlock password',
);
///###TS_STEP_2

///###TS_STEP_3
// Necessary import to write to the file system
import { promises as fsAsync } from 'fs';

// Saves the encrypted seed of the vault.
const serializedState = JSON.stringify(vault.save());
///###TS_STEP_3

(async () => {
///###TS_STEP_3
// Writes the state to a file
await fsAsync.writeFile(
  'tutorial_vault.state',
  serializedState,
  { encoding: 'utf-8' },
);
///###TS_STEP_3

///###TS_STEP_4
// Reads and loads the vault from the saved file
const backup = await fsAsync.readFile(
    'tutorial_vault.state',
    { encoding: 'utf-8' },
);
const loadedVault = Crypto.Vault.load(JSON.parse(backup));
///###TS_STEP_4

if(JSON.stringify(loadedVault.save()) !== serializedState) {
    throw new Error('Vaults are not identical');
}

})().catch((e)=>{
    process.stderr.write(e.message);
    process.exit(1);
});
