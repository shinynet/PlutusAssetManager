
# args
# $1 token name
# $2 utxo in

KEYS_DIR="../keys"
OUTPUT_ADDRESS=$(cat $KEYS_DIR/asset-dept.addr)
TOKEN_NAME=$(echo -n "$1" | xxd -ps | tr -d '\n')
POLICY_ID_FILE="asset-minting-policy.plutus"
UNSIGNED_TX_FILE="asset-minting-tx.raw"
SIGNED_TX_FILE="asset-minting-tx.signed"
TESTNET="--testnet-magic 2"

#haskell program
SCRIPT=$(cabal list-bin mint-asset)
$SCRIPT

POLICY_ID=$(
  cardano-cli transaction policyid \
    --script-file $POLICY_ID_FILE
)

cardano-cli transaction build \
  --babbage-era \
  --tx-in $2 \
  --tx-in "7552e53391147e4edbf7893b869662d5d17648649d184eb1193c50082f47d7a8#0" \
  --tx-in "e77aa16b807818d315233a249fd3330845c6447fab1b76e008f6b8b703288cf8#1" \
  --tx-in-collateral "3f78b3161e13084552967c367e5614e06bf9a1d8b5f97d6c757afdb215def882#0" \
  --tx-out "$OUTPUT_ADDRESS+2000000 + 0 $POLICY_ID.$TOKEN_NAME" \
  --mint "-1 $POLICY_ID.$TOKEN_NAME" \
  --mint-script-file $POLICY_ID_FILE \
  --mint-redeemer-value [] \
  --change-address $OUTPUT_ADDRESS \
  --protocol-params-file protocol-parameters.json \
  --out-file $UNSIGNED_TX_FILE \
  $TESTNET

cardano-cli transaction sign \
  --tx-body-file $UNSIGNED_TX_FILE \
  --signing-key-file $KEYS_DIR/asset-dept.skey \
  --signing-key-file $KEYS_DIR/collateral.skey \
  --out-file $SIGNED_TX_FILE \
  $TESTNET

cardano-cli transaction submit \
  --tx-file $SIGNED_TX_FILE \
  $TESTNET
