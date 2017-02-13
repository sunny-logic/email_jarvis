# email_jarvis
A simple setup to issue predefined commands to Raspberry Pi from Email (Gmail).

There are times when you want to remotely perform some actions on your Raspberry Pi but you are not in your local network.
This program helps you to get around this problem and run predefined commands and get a response back from Raspberry Pi .

You can use this program to get around the process of installing VPN and the hassles around it like port-forwarding, Static IP, Etc.
Although, I have OpenVPN installed and running on my Raspberry Pi 2 and used in this project to restart using OpenVPN using email.

Below are some of the command you can send via a trusted Email (Gmail) account and it will perform the required action and acknowledge you back via Email.

    ipaddress - Return your current public IP address
    _shutdown - Shutdown your Raspberry Pi
    _reboot - Restart your Raspberry Pi
    force_ddclient - Force ddclient to update your preregistered DNS account. 
    restart_ddclient - Restart ddclient
    restart_openvpn - Restart Open VPN
    systime - Systime of your Raspberry Pi (safe to use for initial setup and subsequent testing)

Primariry, I had to install SSMTP &  Fetchmail and do some configuration changes.

I have created this during my spare leisure time as a hobby to (re)indulge myself into the wonderful world of programming.
There may be issues/improvements needed for this project which I will try to address as and when possible.

Appreciations/Suggestions/ideas are welcome.

