# Simple-ZCU102-Example

<!--- ######################################################## -->

# Clone the GIT repository

Install git large filesystems (git-lfs) in your .gitconfig (1-time step per unix environment)
```bash
$ git lfs install
```
Clone the git repo with git-lfs enabled
```bash
$ git clone --recursive https://github.com/slaclab/Simple-ZCU102-Example.git
```
Note: `recursive flag` used to initialize all submodules within the clone

<!--- ######################################################## -->

# How to generate the SOC .BIT and .XSA files

1) Setup Xilinx PATH and licensing (if on SLAC AFS network) else requires Vivado install and licensing on your local machine

```bash
$ source Simple-ZCU102-Example/firmware/setup_env_slac.sh
```

2) Go to the target directory and make the firmware:

```bash
$ cd Simple-ZCU102-Example/firmware/targets/SimpleZcu102Example/
$ make
```

3) Optional: Review the results in GUI mode

```bash
$ make gui
```

The .bit and .XSA files are dumped into the SimpleZcu102Example/image directory:

```bash
$ ls -lath SimpleZcu102Example/images/
total 47M
drwxr-xr-x 5 ruckman re 2.0K Feb  7 07:13 ..
drwxr-xr-x 2 ruckman re 2.0K Feb  4 21:15 .
-rw-r--r-- 1 ruckman re  14M Feb  4 21:15 SimpleZcu102Example-0x03000000-20250710093359-ruckman-XXXXXXX.xsa
-rw-r--r-- 1 ruckman re  33M Feb  4 21:14 SimpleZcu102Example-0x03000000-20250710093359-ruckman-XXXXXXX.bit
```

<!--- ######################################################## -->

# How to build Yocto Linux images

1) Generate the .bit and .xsa files (refer to `How to generate the SOC .BIT and .XSA files` instructions).

2) Setup Xilinx PATH and licensing (if on SLAC AFS network) else requires Vivado install and licensing on your local machine

```bash
$ source Simple-ZCU102-Example/firmware/setup_env_slac.sh
```

3) Go to the target directory and run the `BuildYoctoProject.sh` script with arg pointing to path of .XSA file:

```bash
$ cd Simple-ZCU102-Example/firmware/targets/SimpleZcu102Example/
$ source BuildYoctoProject.sh images/SimpleZcu102Example-0x03000000-20250710093359-ruckman-XXXXXXX.xsa
```

<!--- ######################################################## -->

# How to make the SD memory card for the first time

1) Creating Two Partitions.  Refer to URL below

https://xilinx-wiki.atlassian.net/wiki/x/EYMfAQ

2) Copy For the boot images, simply copy the files to the FAT partition.
This typically will include system.bit, BOOT.BIN, image.ub, and boot.scr.  Here's an example:

Note: Assumes SD memory FAT32 is `/dev/sde1` in instructions below

```bash
sudo mkdir -p boot
sudo mount /dev/sde1 boot
sudo cp Simple-ZCU102-Example/firmware/build/YoctoProjects/SimpleZcu102Example/images/linux/system.bit boot/.
sudo cp Simple-ZCU102-Example/firmware/build/YoctoProjects/SimpleZcu102Example/images/linux/BOOT.BIN   boot/.
sudo cp Simple-ZCU102-Example/firmware/build/YoctoProjects/SimpleZcu102Example/images/linux/image.ub   boot/.
sudo cp Simple-ZCU102-Example/firmware/build/YoctoProjects/SimpleZcu102Example/images/linux/boot.scr   boot/.
sudo sync boot/
sudo umount boot
```

3) Power down the ZCU102 board

4) Insert the SD memory card

5) Confirm the Mode SW6 [4:1] = 1110 (Mode Pins [3:0]). Note: Switch OFF = 1 = High; ON = 0 = Low.

6) Power up the ZCU102 board

7) Confirm that you can ping the boot after it boots up

<!--- ######################################################## -->

# How to remote update the firmware bitstream

- Assumes the DHCP assigned IP address is 10.0.0.10

1) Using "scp" to copy your .bit file to the SD memory card on the RFSoC.  Here's an example:

```bash
scp SimpleZcu102Example-0x03000000-20250710093359-ruckman-XXXXXXX.bit root@10.0.0.10:/boot/system.bit
```

2) Send a "sync" and "reboot" command to the RFSoC to load new firmware:  Here's an example:

```bash
ssh root@10.0.0.10 '/bin/sync; /sbin/reboot'
```

<!--- ######################################################## -->

# How to install the Rogue With miniforge

> https://slaclab.github.io/rogue/installing/miniforge.html

<!--- ######################################################## -->

# How to run the Rogue GUI

- Assumes the DHCP assigned IP address is 10.0.0.10

1) Setup the rogue environment (if on SLAC AFS network) else install rogue (recommend miniforge method) on your local machine

```bash
$ source Simple-ZCU102-Example/software/setup_env_slac.sh
```

2) Go to software directory and lauch the GUI:

```bash
$ cd Simple-ZCU102-Example/software
$ python scripts/devGui.py --ip 10.0.0.10
```

<!--- ######################################################## -->
