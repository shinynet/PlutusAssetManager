module Contracts.AssetMintingPolicy where

import           Cardano.Api.Shelley                  (PlutusScript (..),
                                                       PlutusScriptV2)
import           Codec.Serialise                      (serialise)
import           Data.ByteString.Lazy                 (toStrict)
import           Data.ByteString.Short                (ShortByteString, toShort)
import           Ledger.Typed.Scripts                 (mkUntypedMintingPolicy)
import           Plutus.Script.Utils.V2.Typed.Scripts (MintingPolicy)
import           Plutus.V2.Ledger.Api                 (Script, ScriptContext,
                                                       mkMintingPolicyScript,
                                                       unMintingPolicyScript)
import qualified PlutusTx
import           PlutusTx.Prelude                     hiding ((.))
import           Prelude                              ((.))

{-# INLINABLE mkPolicy #-}
mkPolicy :: BuiltinData -> ScriptContext -> Bool
mkPolicy _ _ = True

policy :: MintingPolicy
policy = mkMintingPolicyScript $
    $$(PlutusTx.compile [|| wrap ||])
  where
    wrap = mkUntypedMintingPolicy mkPolicy

script :: Script
script = unMintingPolicyScript policy

scriptSBS :: ShortByteString
scriptSBS = toShort . toStrict $ serialise script

serialisedScript :: PlutusScript PlutusScriptV2
serialisedScript = PlutusScriptSerialised scriptSBS
