# entropy
Simple keystroke counter for Mac OS X. 

Logs the number of keystrokes per minute from any application (ie. APM, not including mouse).
A 45min Friday-night toy project created to help track the amount time spent thinking vs. doing.

###Requires:
* Xcode command line tools

###Build:
    gcc -Wall -o entropy main.m -framework ApplicationServices -framework Foundation -lobjc

###Run:
    sudo ./entropy
