-------------------------------------------------------------------------------
-- Company    : SLAC National Accelerator Laboratory
-------------------------------------------------------------------------------
-- Description: Application Module
-------------------------------------------------------------------------------
-- This file is part of 'Simple-ZCU102-Example'.
-- It is subject to the license terms in the LICENSE.txt file found in the
-- top-level directory of this distribution and at:
--    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html.
-- No part of 'Simple-ZCU102-Example', including this file,
-- may be copied, modified, propagated, or distributed except according to
-- the terms contained in the LICENSE.txt file.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library surf;
use surf.StdRtlPkg.all;
use surf.AxiLitePkg.all;
use surf.AxiStreamPkg.all;

library axi_soc_ultra_plus_core;
use axi_soc_ultra_plus_core.AxiSocUltraPlusPkg.all;

entity Application is
   generic (
      TPD_G            : time := 1 ns;
      AXIL_BASE_ADDR_G : slv(31 downto 0));
   port (
      -- DMA Interfaces  (dmaClk domain)
      dmaClk          : in  sl;
      dmaRst          : in  sl;
      dmaObMaster     : in  AxiStreamMasterType;
      dmaObSlave      : out AxiStreamSlaveType;
      dmaIbMaster     : out AxiStreamMasterType;
      dmaIbSlave      : in  AxiStreamSlaveType;
      -- AXI-Lite Interface (axilClk domain)
      axilClk         : in  sl;
      axilRst         : in  sl;
      axilWriteMaster : in  AxiLiteWriteMasterType;
      axilWriteSlave  : out AxiLiteWriteSlaveType;
      axilReadMaster  : in  AxiLiteReadMasterType;
      axilReadSlave   : out AxiLiteReadSlaveType);
end Application;

architecture mapping of Application is

   constant INI_WRITE_REG_C : Slv32Array(1 downto 0) := (others => x"FFFF_FFFF");

   constant PRBS_TX_C          : natural  := 0;
   constant PRBS_RX_C          : natural  := 1;
   constant NUM_AXIL_MASTERS_C : positive := 2;

   constant AXIL_CONFIG_C : AxiLiteCrossbarMasterConfigArray(NUM_AXIL_MASTERS_C-1 downto 0) := genAxiLiteConfig(NUM_AXIL_MASTERS_C, AXIL_BASE_ADDR_G, 20, 16);

   signal axilReadMasters  : AxiLiteReadMasterArray(NUM_AXIL_MASTERS_C-1 downto 0);
   signal axilReadSlaves   : AxiLiteReadSlaveArray(NUM_AXIL_MASTERS_C-1 downto 0)  := (others => AXI_LITE_READ_SLAVE_EMPTY_DECERR_C);
   signal axilWriteMasters : AxiLiteWriteMasterArray(NUM_AXIL_MASTERS_C-1 downto 0);
   signal axilWriteSlaves  : AxiLiteWriteSlaveArray(NUM_AXIL_MASTERS_C-1 downto 0) := (others => AXI_LITE_WRITE_SLAVE_EMPTY_DECERR_C);

begin

   U_XBAR : entity surf.AxiLiteCrossbar
      generic map (
         TPD_G              => TPD_G,
         NUM_SLAVE_SLOTS_G  => 1,
         NUM_MASTER_SLOTS_G => NUM_AXIL_MASTERS_C,
         MASTERS_CONFIG_G   => AXIL_CONFIG_C)
      port map (
         axiClk              => axilClk,
         axiClkRst           => axilRst,
         sAxiWriteMasters(0) => axilWriteMaster,
         sAxiWriteSlaves(0)  => axilWriteSlave,
         sAxiReadMasters(0)  => axilReadMaster,
         sAxiReadSlaves(0)   => axilReadSlave,
         mAxiWriteMasters    => axilWriteMasters,
         mAxiWriteSlaves     => axilWriteSlaves,
         mAxiReadMasters     => axilReadMasters,
         mAxiReadSlaves      => axilReadSlaves);

   U_SsiPrbsTx : entity surf.SsiPrbsTx
      generic map (
         TPD_G                      => TPD_G,
         PRBS_SEED_SIZE_G           => 64,
         VALID_THOLD_G              => 1,
         VALID_BURST_MODE_G         => false,
         MASTER_AXI_PIPE_STAGES_G   => 1,
         MASTER_AXI_STREAM_CONFIG_G => DMA_AXIS_CONFIG_C)
      port map (
         -- Master Port (mAxisClk)
         mAxisClk        => dmaClk,
         mAxisRst        => dmaRst,
         mAxisMaster     => dmaIbMaster,
         mAxisSlave      => dmaIbSlave,
         -- Trigger Signal (locClk domain)
         locClk          => axilClk,
         locRst          => axilRst,
         trig            => '0',
         packetLength    => x"0000_0FFF",
         -- Optional: Axi-Lite Register Interface (locClk domain)
         axilReadMaster  => axilReadMasters(PRBS_TX_C),
         axilReadSlave   => axilReadSlaves(PRBS_TX_C),
         axilWriteMaster => axilWriteMasters(PRBS_TX_C),
         axilWriteSlave  => axilWriteSlaves(PRBS_TX_C));

   U_SsiPrbsRx : entity surf.SsiPrbsRx
      generic map (
         TPD_G                     => TPD_G,
         PRBS_SEED_SIZE_G          => 64,
         SLAVE_AXI_PIPE_STAGES_G   => 1,
         SLAVE_AXI_STREAM_CONFIG_G => DMA_AXIS_CONFIG_C)
      port map (
         sAxisClk       => dmaClk,
         sAxisRst       => dmaRst,
         sAxisMaster    => dmaObMaster,
         sAxisSlave     => dmaObSlave,
         axiClk         => axilClk,
         axiRst         => axilRst,
         axiReadMaster  => axilReadMasters(PRBS_RX_C),
         axiReadSlave   => axilReadSlaves(PRBS_RX_C),
         axiWriteMaster => axilWriteMasters(PRBS_RX_C),
         axiWriteSlave  => axilWriteSlaves(PRBS_RX_C));

end mapping;
