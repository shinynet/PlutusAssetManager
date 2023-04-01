module BurnAsset where

import           Cardano.Api                  (displayError,
                                               writeFileTextEnvelope)
import           Contracts.AssetBurningPolicy (serialisedScript)
import           Plutus.V2.Ledger.Api
import           PlutusTx.Builtins.Class
import           Prelude
import           System.Environment           (getArgs)

main :: IO ()
main = do
  [serialNumber] <- getArgs
  putStrLn serialNumber

  let scriptFile = "asset-burning-policy.plutus"

  mintResult <- writeFileTextEnvelope scriptFile Nothing $
                serialisedScript (TokenName $ stringToBuiltinByteString serialNumber)
  case mintResult of
      Left err -> print $ displayError err
      Right () -> putStrLn $ "wrote script to file " ++ scriptFile

