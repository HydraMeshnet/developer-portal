///###TS_STEP_1
import { Crypto } from '@internet-of-people/sdk';
///###TS_STEP_1

///###TS_STEP_2
// YOU HAVE TO SAVE IT TO A SAFE PLACE!
const phrase = new Crypto.Bip39('en').generate().phrase;

const vault = Crypto.Vault.create(
  phrase,
  '8qjaX^UNAafDL@!#',
  'unlock password',
);
///###TS_STEP_2

///###TS_STEP_3
import { promises as fsAsync } from 'fs';

const serializedState = JSON.stringify(vault.save());
///###TS_STEP_3

(async () => {
///###TS_STEP_3
await fsAsync.writeFile(
  'tutorial_vault.state',
  serializedState,
  { encoding: 'utf-8' },
);
///###TS_STEP_3

///###TS_STEP_4
const backup = await fsAsync.readFile(
    'tutorial_vault.state',
    { encoding: 'utf-8' },
);

const vault = Crypto.Vault.load(JSON.parse(backup));
///###TS_STEP_4

if(backup !== serializedState) {
    throw new Error('Vaults are not identical');
}

})().catch((e)=>{
    process.stderr.write(e.message);
    process.exit(1);
});
