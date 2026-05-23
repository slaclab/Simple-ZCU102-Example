Top-Level RTL Entity
====================

The top-level entity is ``SimpleZcu102Example``, defined in
:repo:`firmware/targets/SimpleZcu102Example/hdl/SimpleZcu102Example.vhd`.
FPGA part: ``XCZU9EG-FFVB1156-2-E``.

Entity surface
--------------

.. list-table:: Generics
   :header-rows: 1
   :widths: 30 20 50

   * - Generic
     - Type
     - Description
   * - ``TPD_G``
     - ``time``
     - Propagation delay (default: ``1 ns``)
   * - ``BUILD_INFO_G``
     - ``BuildInfoType``
     - Build metadata injected at synthesis time

.. list-table:: Ports
   :header-rows: 1
   :widths: 25 10 15 50

   * - Port
     - Direction
     - Type
     - Description
   * - ``vPIn``
     - in
     - ``sl``
     - SYSMON VP differential input
   * - ``vNIn``
     - in
     - ``sl``
     - SYSMON VN differential input

Instantiated blocks
-------------------

.. list-table::
   :header-rows: 1
   :widths: 35 65

   * - Instance
     - Description
   * - ``U_XVC_PLL`` (``surf.ClockManagerUltraScale``)
     - MMCM that derives the 156.25 MHz XVC clock from the 100 MHz
       ``axilClk`` supplied by ``AxiSocUltraPlusCore``
   * - ``U_Core`` (``axi_soc_ultra_plus_core.AxiSocUltraPlusCore``)
     - Platform core: DMA engine, AXI-Lite PS bridge, SysMon.
       Provides ``dmaClk`` (250 MHz), ``axilClk`` (100 MHz), and
       the application AXI-Lite master bus
   * - ``U_App`` (``work.Application``)
     - Application logic: PRBS TX and RX on DMA lane 0
   * - ``U_XVC`` (``surf.DmaXvcWrapper``)
     - XVC (Xilinx Virtual Cable) handler on DMA lane 1

Clock domain
------------

This design operates with two clock domains:

- ``axilClk`` (100 MHz) — AXI-Lite register access; sourced from
  ``AxiSocUltraPlusCore``.
- ``dmaClk`` (250 MHz) — DMA and Application logic; sourced from
  ``AxiSocUltraPlusCore``.

The ``Application`` entity crosses from ``axilClk`` to ``dmaClk`` using
``surf.AxiLiteAsync``. There is no ADC/DAC sample clock in this design.

Async clock groups (XDC)
------------------------

The XDC (:repo:`firmware/targets/SimpleZcu102Example/hdl/SimpleZcu102Example.xdc`)
declares one asynchronous clock group:

.. code-block:: text

   set_clock_groups -asynchronous \
     -group [get_clocks -of_objects [get_pins U_XVC_PLL/.../CLKOUT0]] \
     -group [get_clocks -of_objects [get_pins U_Core/.../CLKOUT0]]

This constrains the XVC 156.25 MHz clock (from ``U_XVC_PLL``) as
asynchronous with respect to the CPU DMA clock (from ``U_Core``).

For the platform-level architecture overview, see
:hub:`explanation/architecture.html`.
