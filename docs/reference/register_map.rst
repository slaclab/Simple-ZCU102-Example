Application Register Map
========================

Top-level AXI-Lite routing
---------------------------

The top-level entity
(:repo:`firmware/targets/SimpleZcu102Example/hdl/SimpleZcu102Example.vhd`)
does not contain a top-level AXI-Lite crossbar. Instead, it passes the
AXI-Lite bus directly from ``AxiSocUltraPlusCore`` to the ``Application``
entity using the ``APP_ADDR_OFFSET_C`` base address (defined in the
``axi_soc_ultra_plus_core`` package). There is no multi-index top-level
crossbar in this design.

Application crossbar
--------------------

The Application crossbar is declared in
:repo:`firmware/shared/rtl/Application.vhd`.
It uses ``genAxiLiteConfig`` to generate a two-master configuration
(``NUM_AXIL_MASTERS_C = 2``):

.. list-table::
   :header-rows: 1
   :widths: 30 15 55

   * - Index constant
     - Value
     - Slave
   * - ``PRBS_TX_C``
     - ``0``
     - ``SsiPrbsTx`` — AXI-Lite control registers for the PRBS transmitter
   * - ``PRBS_RX_C``
     - ``1``
     - ``SsiPrbsRx`` — AXI-Lite control registers for the PRBS receiver

The crossbar decoding uses 20-bit address space per master (``ADDR_BITS=20``,
``DECODE_BITS=16``), yielding a 64 KB window per index.

This is a PRBS loopback test design; it does not include a ring-buffer
DAC SigGen sub-device or HDA I/O passthrough.

Pattern: genAxiLiteConfig
--------------------------

The ``genAxiLiteConfig`` function is a SLAC platform utility that generates
the ``AxiLiteCrossbarMasterConfigArray`` from a base address, an address
bit-width, and a decode bit-width. For the platform-level crossbar pattern
and address-space layout, see :hub:`reference/register_map.html`.
