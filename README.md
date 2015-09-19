# entropy
Simple keystroke counter for Mac OS X. 

Logs the number of keystrokes per minute from any application (ie. APM, not including mouse).
A 45min Friday-night toy project created to help track the amount of time spent thinking vs. doing.

###Requires:
* Xcode command line tools

###Build:
    gcc -Wall -o entropy main.m -framework ApplicationServices -framework Foundation -lobjc

###Run:
    $ sudo ./entropy
    2015-09-19 00:39:30.959 entropy[20674:847073] 395
    ...
