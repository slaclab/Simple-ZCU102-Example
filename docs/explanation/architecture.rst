Architecture Overview (Simple-ZCU102-Example)
=============================================

``Simple-ZCU102-Example`` is a PRBS loopback test design targeting the Xilinx
ZCU102 evaluation board (``XCZU9EG-FFVB1156-2-E``). It exercises the SLAC
``axi-soc-ultra-plus-core`` DMA and register-access infrastructure without
an ADC/DAC data path. For the platform-level architectural patterns (DMA
engine, PS/PL bridge, Rogue TCP protocols), see
:hub:`explanation/architecture.html`.

Topology
--------

The design instantiates two top-level blocks beyond the platform core:

- **Application** — contains a PRBS transmitter (``SsiPrbsTx``) and a PRBS
  receiver (``SsiPrbsRx``) connected back-to-back over DMA lane 0. The
  transmitter sends pseudo-random bit sequences; the receiver checks them and
  reports error statistics via AXI-Lite registers. The Application crossbar
  routes register access to each sub-module using
  ``PRBS_TX_C = 0`` and ``PRBS_RX_C = 1`` (see
  :doc:`../reference/register_map`).
- **DmaXvcWrapper** — connects DMA lane 1 to an XVC (Xilinx Virtual Cable)
  endpoint, providing JTAG-over-Ethernet access to the FPGA fabric.

DMA is configured with ``DMA_SIZE_C = 2`` lanes (see :doc:`../reference/app_pkg`).
The host-side PyRogue tree wires software PRBS primitives to DMA lane 0
for loopback verification (see :doc:`../reference/pyrogue_tree`).

Clock domain
------------

This design operates with two clocks supplied by ``AxiSocUltraPlusCore``:

- ``axilClk`` (100 MHz) — AXI-Lite register access from the PS.
- ``dmaClk`` (250 MHz) — DMA engine and Application logic.

The ``Application`` entity bridges ``axilClk`` to ``dmaClk`` using
``surf.AxiLiteAsync``. A third clock (156.25 MHz for XVC) is derived from
``axilClk`` by an on-chip MMCM (``U_XVC_PLL``) and is declared asynchronous
to the DMA clock in the XDC (see :doc:`../reference/rtl_top_entity`).

There is no ADC sample clock or DAC DSP clock in this design.

For the platform-level clock-domain discussion (dmaClk derivation, CDC
patterns), see :hub:`explanation/architecture.html#clock-domains`.
