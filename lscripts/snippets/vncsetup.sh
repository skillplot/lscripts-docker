sudo apt install tigervnc-standalone-server tigervnc-common
sudo apt install xterm
vncserver -kill :1
vncserver :1

sudo su - skynet


sudo apt update
sudo apt install xfce4 xfce4-goodies -y

sudo apt install gnome-core gnome-session gnome-panel gnome-terminal -y

sudo apt install turbovnc -y

https://github.com/TurboVNC/turbovnc/releases/tag/3.1.2

wget https://github.com/TurboVNC/turbovnc/releases/download/3.1.2/turbovnc_3.1.2_amd64.deb -O turbovnc.deb

sudo dpkg -i turbovnc.deb
sudo apt install dbus-x11

sudo dpkg --configure -a
sudo dpkg -i turbovnc.deb

vncserver :1 -geometry 1920x1080 -depth 24

which vncserver

/opt/TurboVNC/bin/vncserver :1 -geometry 1920x1080 -depth 24

---

client

sudo apt install tigervnc-viewer -y
