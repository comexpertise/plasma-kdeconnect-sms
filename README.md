## Plasma KDEConnect SMS
#### Plasmoid for KDE Plasma desktop

Tested on:
- Kubuntu 16.10+
- openSuSE Leap 43

### Demo
<div align="center">
  <a href="https://youtu.be/DCGK2X_62-Y"><img src="https://img.youtube.com/vi/DCGK2X_62-Y/0.jpg" alt="KDE Connect for Kubuntu"></a>
</div>

### Requirements
* [KDE Connect](https://github.com/KDE/kdeconnect-kde) (desktop app) with one paired device
* KDE Plasma 5.x

### How to install
To get and install the latest version:

```bash
git clone git@github.com:comexpertise/plasma-kdeconnect-sms.git
cd plasma-kdeconnect-sms/build
cmake -DCMAKE_INSTALL_PREFIX=/usr/ ..
make
sudo make install
```

### Alternatives apps?
* Google has released "Android Messages" for receive/send SMS from your favorite broswer: https://messages.android.com
