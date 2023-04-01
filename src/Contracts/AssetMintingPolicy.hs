module Contracts.AssetMintingPolicy where

import qualified PlutusTx
import           PlutusTx.Prelude                     hiding (Semigroup (..),
                                                       unless, (.))
import           Ledger.Typed.Scripts                 as MPScripts
import           Plutus.Script.Utils.V2.Typed.Scripts as Scripts
import           Plutus.V2.Ledger.Api                 as PlutusV2
import           Cardano.Api.Shelley                  (PlutusScript (..),
                                                       PlutusScriptV2)
import           Codec.Serialise
import qualified Data.ByteString.Lazy                 as LBS
import qualified Data.ByteString.Short                as SBS
import           Prelude                              ((.))

{-# INLINABLE mkPolicy #-}
mkPolicy :: BuiltinData -> PlutusV2.ScriptContext -> Bool
mkPolicy _ _ = True

policy :: Scripts.MintingPolicy
policy = PlutusV2.mkMintingPolicyScript $
    $$(PlutusTx.compile [|| wrap ||])
  where
    wrap = MPScripts.mkUntypedMintingPolicy mkPolicy

script :: PlutusV2.Script
script = PlutusV2.unMintingPolicyScript policy

scriptSBS :: SBS.ShortByteString
scriptSBS = SBS.toShort . LBS.toStrict $ serialise script

serialisedScript :: PlutusScript PlutusScriptV2
serialisedScript = PlutusScriptSerialised scriptSBS
