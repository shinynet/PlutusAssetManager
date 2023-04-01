module MintAsset where

import           Cardano.Api                  (displayError,
                                               writeFileTextEnvelope)
import           Contracts.AssetMintingPolicy
import           Plutus.V2.Ledger.Api
import           PlutusTx.Builtins.Class
import           Prelude
import           System.Environment           (getArgs)

main :: IO ()
main = do
  -- [serialNumber] <- getArgs
  -- putStrLn serialNumber

  let scriptFile = "asset-minting-policy.plutus"

  mintResult <- writeFileTextEnvelope scriptFile Nothing serialisedScript
  -- mintResult <- writeFileTextEnvelope scriptFile Nothing $
  --               serialisedScript (TokenName $ stringToBuiltinByteString serialNumber)
  case mintResult of
      Left err -> print $ displayError err
      Right () -> putStrLn $ "wrote script to file " ++ scriptFile

