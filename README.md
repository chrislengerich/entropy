# entropy
Simple keystroke count logger for Mac OS X. 

Logs the number of keystrokes per minute from any application (APM, not including mouse).
A 45min Friday-night toy project.

###Requires:
* Xcode command line tools

###Build:
    gcc -Wall -o entropy main.m -framework ApplicationServices -framework Foundation -lobjc

###Run:
    sudo ./entropy
