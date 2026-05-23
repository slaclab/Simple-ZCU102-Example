First Build (Simple-ZCU102-Example)
====================================

This tutorial covers the end-to-end build procedure for the
``Simple-ZCU102-Example`` firmware on the Xilinx ZCU102 evaluation board
(FPGA part ``XCZU9EG-FFVB1156-2-E``). It covers only the commands specific
to this board; for host-prep details, build-output redirection, the
bare-metal-vs-Docker decision, and the serial-console snippet — all
board-agnostic — see the corresponding sections on the platform docs site
(:hub:`tutorial/first_soc_bringup.html`).

Output filenames embed the build timestamp, the building user's username,
and the current git short-SHA, following the schema
``<TargetName>-<PRJ_VERSION>-<YYYYMMDDHHMMSS>-<user>-<git-short-SHA>``. The
``<full-name>`` placeholder is used below wherever the exact filename is
build-specific.

Verified host environment
--------------------------

Per-board build verification was not performed in this iteration; toolchain
matches the platform reference environment. For the verified host-package
list, Vivado install path, and conda environment setup, see
:hub:`tutorial/first_soc_bringup.html#setup-environment`.

Clone
-----

Install `git-lfs <https://git-lfs.com>`_ in your shell profile (one-time per
environment) before cloning, so any LFS-tracked binaries are fetched correctly:

.. code-block:: bash

   git lfs install

Clone the repository with all submodules:

.. code-block:: bash

   git clone --recursive https://github.com/slaclab/Simple-ZCU102-Example.git

The ``--recursive`` flag initialises the firmware submodules in one step.
Omitting it leaves the firmware build unable to find the required RTL and
TCL sources.

Firmware build
--------------

Change into the target directory and run ``make``:

.. code-block:: bash

   source firmware/vivado_setup.sh
   cd firmware/targets/SimpleZcu102Example/
   make

After a successful build, the ``.bit`` and ``.xsa`` artifacts are written to
``firmware/targets/SimpleZcu102Example/images/`` using the schema
``SimpleZcu102Example-<PRJ_VERSION>-<YYYYMMDDHHMMSS>-<user>-<git-short-SHA>``.

For the platform-level firmware-build narrative (Vivado strategy, log
locations, common build failures), see
:hub:`tutorial/first_soc_bringup.html#firmware-build`.

Yocto build
-----------

Pass the ``.xsa`` file produced by the firmware build to
``BuildYoctoProject``:

.. code-block:: bash

   cd firmware/targets/SimpleZcu102Example/
   ./BuildYoctoProject -f images/<TargetName>-<PRJ_VERSION>-<YYYYMMDDHHMMSS>-<user>-<git-short-SHA>.xsa

.. note::

   Your filename will differ — the build embeds the build timestamp, your
   username, and the current git short-SHA.

For the bare-metal-vs-Docker decision, Yocto host-package list, and
deploy-path layout, see :hub:`tutorial/first_soc_bringup.html#yocto-build`.

SD card
-------

Once the Yocto build is complete, write the boot images to an SD card.
See :hub:`tutorial/first_soc_bringup.html#sd-card` for the verified
procedure.

Boot
----

The ZCU102 uses DIP switch ``SW6`` to select the boot mode.
Set ``Mode SW6 [4:1] = 1110`` for SD card boot
(switch OFF = 1 = High; ON = 0 = Low).

After inserting the SD card and powering on, confirm the board is reachable
on the default DHCP IP ``10.0.0.10``:

.. code-block:: bash

   ping 10.0.0.10

For serial-console access and troubleshooting boot or network failures, see
:hub:`tutorial/first_soc_bringup.html#boot`.

Run the Rogue GUI
-----------------

Once the board is reachable on the network, launch the PyDM GUI from the host:

.. code-block:: bash

   python software/scripts/devGui.py --ip 10.0.0.10

For installing Rogue on a non-SLAC host, see :hub:`how-to/rogue_install.html`.
For the platform-level GUI launch how-to, see
:hub:`how-to/rogue_gui_launch.html`.

Next steps
----------

- Update the bitstream on a running board without rebooting:
  :hub:`how-to/remote_bitstream_update.html`.
- Flash the boot images to QSPI for SD-cardless boot:
  :hub:`how-to/qspi_flash.html`.
- Recover from a bricked QSPI image using XSCT JTAG boot mode:
  :hub:`how-to/xsct_boot_mode.html`.
