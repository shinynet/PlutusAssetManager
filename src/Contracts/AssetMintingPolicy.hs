module Contracts.AssetMintingPolicy where

import           Cardano.Api.Shelley                  (PlutusScript (..),
                                                       PlutusScriptV2)
import           Codec.Serialise                      (serialise)
import           Data.ByteString.Lazy                 (toStrict)
import           Data.ByteString.Short                (ShortByteString, toShort)
import           Ledger.Typed.Scripts                 (mkUntypedMintingPolicy)
import           Plutus.Script.Utils.V2.Typed.Scripts (MintingPolicy)
import           Plutus.V2.Ledger.Api                 (PubKeyHash (..), Script,
                                                       ScriptContext,
                                                       mkMintingPolicyScript,
                                                       unMintingPolicyScript)
import qualified PlutusTx
import           PlutusTx.Builtins.Class              (fromBuiltin, stringToBuiltinByteString)
import           PlutusTx.Prelude                     hiding ((.), fromBuiltin)
import           Prelude                              ((.))

publicKeyHash :: BuiltinByteString
publicKeyHash = stringToBuiltinByteString "6f9f37db37e734116636c074243a4c35f9156da01e77c0ad63ab6574"

{-# INLINABLE mkPolicy #-}
mkPolicy :: PubKeyHash -> () -> ScriptContext -> Bool
mkPolicy pkh () _ = True

policy :: PubKeyHash -> MintingPolicy
policy pkh = mkMintingPolicyScript $
    $$(PlutusTx.compile [|| wrap ||])
    `PlutusTx.applyCode` PlutusTx.liftCode pkh
  where
    wrap pkh' = mkUntypedMintingPolicy $ mkPolicy pkh'

script :: Script
script = unMintingPolicyScript
       $ policy (PubKeyHash $ fromBuiltin publicKeyHash)

scriptSBS :: ShortByteString
scriptSBS = toShort . toStrict $ serialise script

serialisedScript :: PlutusScript PlutusScriptV2
serialisedScript = PlutusScriptSerialised scriptSBS
