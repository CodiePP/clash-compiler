import CLaSH.Driver
import CLaSH.Driver.Types
import CLaSH.Rewrite.Types
import CLaSH.GHC.Evaluator
import CLaSH.GHC.GenerateBindings
import CLaSH.GHC.NetlistTypes
import CLaSH.Primitives.Util
import CLaSH.Backend
import CLaSH.Backend.SystemVerilog
import CLaSH.Backend.VHDL
import CLaSH.Backend.Verilog

genSystemVerilog :: String
                 -> IO ()
genSystemVerilog = doHDL (initBackend :: SystemVerilogState)

genVHDL :: String
        -> IO ()
genVHDL = doHDL (initBackend :: VHDLState)

genVerilog :: String
           -> IO ()
genVerilog = doHDL (initBackend :: VerilogState)

doHDL :: Backend s
       => s
       -> String
       -> IO ()
doHDL b src = do
  pd      <- primDir b
  primMap <- generatePrimMap [pd,"."]
  (bindingsMap,tcm,tupTcm,topEnt,testInpM,expOutM) <- generateBindings primMap src Nothing
  generateHDL bindingsMap (Just b) primMap tcm tupTcm ghcTypeToHWType reduceConstant topEnt testInpM expOutM (CLaSHOpts 20 20 15 DebugFinal True)

main :: IO ()
main = genVHDL "./examples/FIR.hs"
