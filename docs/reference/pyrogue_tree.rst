PyRogue Device Tree
===================

The ``simple_zcu102_example`` Python package exposes a two-file hierarchy
(:repo:`firmware/python/simple_zcu102_example/`): ``_Root.py`` (the top-level
device) and ``_Application.py`` (the application sub-device). There is no
separate RFSoC layer in this package.

Hierarchy
---------

.. code-block:: text

   Root  (_Root.py)
   ├── AxiSocCore             (offset 0x04_0000_0000)  — axi_soc_ultra_plus_core
   ├── Application            (offset 0x04_8000_0000)  — simple_zcu102_example
   │   ├── SsiPrbsTx          (offset 0x0_0000)        — surf.protocols.ssi
   │   └── SsiPrbsRx          (offset 0x1_0000)        — surf.protocols.ssi
   ├── prbsRx                 — pr.utilities.prbs.PrbsRx (software-side, DMA lane 0)
   └── prbTx                  — pr.utilities.prbs.PrbsTx (software-side, DMA lane 0)

``Root`` also wires DMA lane 1 to an XVC (Xilinx Virtual Cable) protocol
handler for JTAG-over-Ethernet access.

Public surface
--------------

:repo:`firmware/python/simple_zcu102_example/__init__.py` re-exports:

- ``Application`` (from ``_Application.py``)
- ``Root`` (from ``_Root.py``)

Startup sequence
----------------

The ``Root.__init__`` method (see :repo:`firmware/python/simple_zcu102_example/_Root.py`)
performs the following steps:

- Optionally starts a ZMQ server (``zmqSrvEn=True`` default).
- Opens a TCP memory client to port 9000 for AXI-Lite register access.
- Opens TCP stream clients: port 10000 (DMA lane 0, application data)
  and port 10512 (DMA lane 1, XVC).
- Creates the XVC protocol handler and connects it to DMA lane 1.
- Adds ``AxiSocCore`` and ``Application`` to the device tree.
- Adds software-side PRBS receiver (``prbsRx``) and transmitter (``prbTx``)
  connected to DMA lane 0.

No clock initialisation, RFDC tile setup, or multi-tile synchronisation is
performed — the ZCU102 design operates on a single register-access clock
domain.

For the platform-level PyRogue API reference, see
:hub:`reference/pyrogue_api.html`.
