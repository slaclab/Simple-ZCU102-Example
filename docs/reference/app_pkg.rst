Package Reference
=================

``Simple-ZCU102-Example`` does not ship a platform-level VHDL package
(``firmware/shared/rtl/AppPkg.vhd`` is absent from this design).
Application-relevant constants are declared directly in the top-level
entity's architecture body.

This design is a PRBS loopback test; it has no DSP data path, no
sample-rate conversion, and no DAC waveform generator. As a result,
sample-bus-width and sample-rate constants are not present.

Top-level constants
-------------------

The following constant is declared in the ``architecture top_level`` body of
:repo:`firmware/targets/SimpleZcu102Example/hdl/SimpleZcu102Example.vhd`:

.. list-table::
   :header-rows: 1
   :widths: 30 15 55

   * - Constant
     - Value
     - Purpose
   * - ``DMA_SIZE_C``
     - ``2``
     - Number of DMA lanes. Lane 0 carries PRBS application traffic;
       lane 1 carries XVC (Xilinx Virtual Cable) JTAG-over-Ethernet traffic.

For the platform-level register map and crossbar patterns, see
:hub:`reference/register_map.html`.
