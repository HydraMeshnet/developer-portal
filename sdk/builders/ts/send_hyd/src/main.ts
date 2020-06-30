///###TS_STEP_1
import { Layer1, Network } from '@internet-of-people/sdk';
///###TS_STEP_1

///###TS_STEP_2
export const network = Network.Testnet;
export const walletPassphrase = "scout try doll stuff cake welcome random taste load town clerk ostrich";
export const targetAddress = "tjseecxRmob5qBS2T3qc8frXDKz3YUGB8J"; // genesis
///###TS_STEP_2

(async () => {

///###TS_STEP_3
const layer1Api = await Layer1.createApi(network);
const amount = 1e8 / 10; // 0.1 HYD
const txId = await layer1Api.sendTransferTxWithPassphrase(walletPassphrase, targetAddress, BigInt(amount)); 
///###TS_STEP_3
if(!txId) {
    throw new Error('TX could not be sent');
}
///###TS_STEP_3
console.log('Transaction ID: ', txId);
///###TS_STEP_3

})().catch((e)=>{
    process.stderr.write(e.message);
    process.exit(1);
});
