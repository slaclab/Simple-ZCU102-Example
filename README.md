# Simple-ZCU102-Example

Reference application for the SLAC SoC platform on the Xilinx ZCU102 evaluation board (`xczu9eg-ffvb1156-2-e`).

**Application docs:** https://slaclab.github.io/Simple-ZCU102-Example/

**Shared workflow docs (clone, FW build, Yocto, SD card, Rogue install/launch, remote bitstream update):** https://slaclab.github.io/axi-soc-ultra-plus-core/

## Board-specific deltas

- **Target directory:** `firmware/targets/SimpleZcu102Example/`
- **Default DHCP IP convention:** `10.0.0.10` (used in remote-update and GUI launch examples on the docs site)
- **Board:** Xilinx ZCU102 evaluation board; FPGA part: `XCZU9EG-FFVB1156-2-E`; firmware version: `v3.2.0.0` (`PRJ_VERSION = 0x03020000`)
- **Conda env (SLAC AFS):** `rogue_v6.8.0`
- **ZCU102-specific Yocto notes:** none beyond the shared procedure.
- **SD boot mode:** `Mode SW6 [4:1] = 1110` (switch OFF = 1 = High; ON = 0 = Low).
