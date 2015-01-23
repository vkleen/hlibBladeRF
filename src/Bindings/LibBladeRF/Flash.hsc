#include <bindings.dsl.h>
#include <libbladeRF.h>

module Bindings.LibBladeRF.Flash where

#strict_import
import Bindings.LibBladeRF.Types


#ccall bladerf_erase_flash , Ptr (<bladerf>) -> Word32 -> Word32 -> CInt
#ccall bladerf_read_flash , Ptr (<bladerf>) -> Ptr (Word8) -> Word32 -> Word32 -> CInt
#ccall bladerf_write_flash , Ptr (<bladerf>) -> Ptr (Word8) -> Word32 -> Word32 -> CInt