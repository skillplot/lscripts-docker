# System:    Kernel: 6.1.21-v8+ aarch64 bits: 64 compiler: gcc v: 10.2.1 Console: tty 1 
#            Distro: Debian GNU/Linux 11 (bullseye) 
# Machine:   Type: ARM Device System: Raspberry Pi 4 Model B Rev 1.2 details: BCM2835 rev: b03112 serial: <filter> 
# CPU:       Info: Quad Core model: N/A variant: cortex-a72 bits: 64 type: MCP arch: ARMv8 rev: 3 
#            features: Use -f option to see features bogomips: 432 
#            Speed: 1500 MHz min/max: 600/1500 MHz Core speeds (MHz): 1: 1500 2: 1500 3: 1500 4: 1500 
# Graphics:  Device-1: bcm2711-hdmi0 driver: vc4_hdmi v: N/A bus ID: N/A 
#            Device-2: bcm2711-hdmi1 driver: vc4_hdmi v: N/A bus ID: N/A 
#            Device-3: bcm2711-vc5 driver: vc4_drm v: N/A bus ID: N/A 
#            Display: server: X.org 1.20.11 driver: loaded: modesetting unloaded: fbdev tty: 122x31 
#            Message: Advanced graphics data unavailable in console. Try -G --display 
# Audio:     Device-1: bcm2711-hdmi0 driver: vc4_hdmi bus ID: N/A 
#            Device-2: bcm2711-hdmi1 driver: vc4_hdmi bus ID: N/A 
#            Sound Server: ALSA v: k6.1.21-v8+ 
# Network:   Message: No ARM data found for this feature. 
#            IF-ID-1: eth0 state: up speed: 1000 Mbps duplex: full mac: <filter> 
#            IF-ID-2: wlan0 state: down mac: <filter> 
# Drives:    Local Storage: total: 29.12 GiB used: 5.75 GiB (19.8%) 
#            ID-1: /dev/mmcblk0 vendor: Apacer model: APPSD size: 29.12 GiB 
#            Message: No Optical or Floppy data was found. 
# Partition: ID-1: / size: 28.34 GiB used: 5.72 GiB (20.2%) fs: ext4 dev: /dev/mmcblk0p2 
#            ID-2: /boot size: 255 MiB used: 30.6 MiB (12.0%) fs: vfat dev: /dev/mmcblk0p1 
# Swap:      ID-1: swap-1 type: file size: 100 MiB used: 0 KiB (0.0%) file: /var/swap 
# Sensors:   System Temperatures: cpu: 31.6 C mobo: N/A 
#            Fan Speeds (RPM): N/A 
# Info:      Processes: 197 Uptime: 1h 22m Memory: 1.88 GiB used: 478.4 MiB (24.8%) gpu: 76 MiB Init: systemd 
#            runlevel: 5 Compilers: gcc: 10.2.1 Packages: 1555 Shell: Bash v: 5.1.4 inxi: 3.3.01 

sudo apt update
## sudo apt upgrade
sudo apt install -y libcurl4 openssl liblzma-dev
echo "deb [ arch=arm64 ] http://repo.mongodb.org/apt/debian bullseye/mongodb-org/4.4 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
sudo apt update
sudo apt install -y mongodb-org
# sudo systemctl start mongod
# sudo systemctl enable mongod
# sudo systemctl status mongod
# mongo
