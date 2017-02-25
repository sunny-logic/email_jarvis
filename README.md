# email_jarvis
A simple setup to issue predefined commands to Raspberry Pi from Email (Gmail).


There are times when you want to remotely perform some actions on your Raspberry Pi but you are not in your local network.
This program helps you to get around this problem and run predefined commands and get a response back from Raspberry Pi .


You can use this program to get around the process of installing VPN and the hassles around it like port-forwarding, Static IP, Etc.
Although, I have OpenVPN installed and running on my Raspberry Pi 2 and used in this project to restart using OpenVPN using email.

This can also be used to start certain programs & services on-demand when you need them and 
then shutdown the programs & services once the work is complete. This helps in security and save computing power !

Primariry, I had to install SSMTP &  Fetchmail and do some configuration changes.

Below are some of the command you can send via a trusted Email (Gmail) account and it will perform the required action and acknowledge you back via Email.

################################################################################################
ipaddress - Return your current public IP address

_shutdown - Shutdown your Raspberry Pi

_reboot - Restart your Raspberry Pi

force_ddclient - Force ddclient to update your preregistered DNS account.

stop_ddclient - Stop ddclient

start_ddclient - Start ddclient

stop_openvpn - Stop Open VPN

start_openvpn - Start Open VPN

stop_samba - Stop Samba

start_samba - Start Samba

systime - Systime of your Raspberry Pi (safe to use for initial setup and subsequent testing)
################################################################################################

I have created this during my spare leisure time as a hobby to (re)indulge myself into the wonderful world of programming.
There may be issues/improvements needed for this project which I will try to address as and when possible.


Appreciations/Suggestions/ideas are welcome.


################################################################################################
Installation steps
################################################################################################
sudo apt-get install mailutils ssmtp
sudo apt-get install fetchmail
sudo apt-get install cron

mkdir $HOME/email_jarvis/
mkdir $HOME/email_jarvis/logs

#Use the files from the repository for below steps
#Now edit .fetchmailrc to add your Gmail username and password and place the edited .fetchmailrc in $HOME
#Place fetchmail.sh and email_jarvis.sh in $HOME/email_jarvis/
#Edit Crontab using crontab -l and append the content of crontab

#In the email_jarvis.sh script, define your trusted email (gmail) too send/receive the email
trusted="XXXXXXXXXX@gmail.com"

#Login to your Gmail account, Go to Settings and create a new label called "RPi_Reply".
#Now add a filter to Match: "subject:RPi_Reply" and add action as : "Skip the Inbox (Archive it)", "Apply the label - RPi_Reply"
#This will ensure that RaspberryPi's emails are labelled and also the replies are moved to RPi_Reply label.
################################################################################################





