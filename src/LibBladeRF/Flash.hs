{-|
  Module      : $Header$
  Copyright   : (c) 2014 Edward O'Callaghan
  License     : LGPL-2.1
  Maintainer  : eocallaghan@alterapraxis.com
  Stability   : provisional
  Portability : portable

  This module encapsulates flash libbladeRF library functions.
  WARNING !!! Untested !!!
-}

module LibBladeRF.Flash ( bladeRFEraseFlash
                        , bladeRFReadFlash
                        , bladeRFWriteFlash
                        ) where

import Foreign
import Foreign.C.Types
import Foreign.C.String

import qualified Data.ByteString as BS

import Bindings.LibBladeRF
import LibBladeRF.LibBladeRF


-- | Erase regions of the bladeRF's SPI flash
--
-- This function operates in units of 64KiB erase blocks
bladeRFEraseFlash :: DeviceHandle  -- ^ Device handle
                  -> Word32        -- ^ Erase block to start erasing at
                  -> Word32        -- ^ Number of blocks to erase.
                  -> IO CInt
bladeRFEraseFlash dev b c = c'bladerf_erase_flash (unDeviceHandle dev) b c

-- | Read data from the bladeRF's SPI flash
--
-- This function operates in units of 256-byte pages.
bladeRFReadFlash :: DeviceHandle -- ^ Device handle
                 -> Word32       -- ^ Page to begin reading from
                 -> Word32       -- ^ Number of pages to read
                 -> IO (CInt, Word8)
bladeRFReadFlash dev p c = do
  bptr <- malloc :: IO (Ptr Word8)
  ret <- c'bladerf_read_flash (unDeviceHandle dev) bptr p c
  buffer <- peek bptr
  free bptr
  return (ret, buffer)

-- | Write data from the bladeRF's SPI flash
-- XXX - Buffer allocation size must be `page` * BLADERF_FLASH_PAGE_SIZE bytes or larger.
bladeRFWriteFlash :: DeviceHandle     -- ^ Device handle
                  -> BS.ByteString    -- ^ Data to write to flash
                  -> Word32           -- ^ page  Page to begin writing at
                  -> Word32           -- ^ count
                  -> IO ()
bladeRFWriteFlash dev b p c = allocaBytes (fromIntegral $ p * c'BLADERF_FLASH_PAGE_SIZE) $ \bptr -> do
  pokeArray bptr (BS.unpack b) -- XXX can we overflow here??
  _ <- c'bladerf_write_flash (unDeviceHandle dev) bptr p c
  return () -- ignore ret
