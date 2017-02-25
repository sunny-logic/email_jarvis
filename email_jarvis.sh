#!/bin/bash

#########################################################################################################################
#A simple setup to issue predefined commands to Raspberry Pi from Email (Gmail).

#There are times when you want to remotely perform some actions on your Raspberry Pi but
#you are not in your local network. This program helps you to get around this problem by using Email (Gmail)
#and run predefined commands and get a response back from Raspberry Pi.

#You can use this program to get around the process of installing VPN and the hassles around it like
#port-forwarding, Static IP, Etc. Although, I have OpenVPN installed and running on my Raspberry Pi2
#and is used in this project to stop/start using OpenVPN using email.

# This can also be used to start certain programs & services on-demand when you need them and 
# then shutdown the programs & services once the work is complete. This helps in security and save computing power !

#Primarily, I had to install sSMTP, Fetchmail & Cron and do some configuration changes.
#Below are some of the command you can send via a trusted Email (Gmail) account
#and it will perform the required action and acknowledge you back via Email.

        #ipaddress      -       Return your current public IP address
        #_shutdown      -       Shutdown your Raspberry Pi
        #_reboot        -       Restart your Raspberry Pi
        #force_ddclient -       Force ddclient to update your preregistered DNS account.
        #stop_ddclient  -       Stop ddclient
        #start_ddclient -       Start ddclient
        #stop_openvpn   -       Stop Open VPN
        #start_openvpn  -       Start Open VPN
        #stop_samba     -       Stop Samba
        #start_samba    -       Start Samba
        #systime        -       Systime of your Raspberry Pi (safe to use for initial setup and subsequent testing)

#I have created this during my spare leisure time as a hobby to (re)indulge myself into the wonderful world of programming.
#There may be bugs/issues and need improvements for this project which I will try to address as and when possible.
#Appreciations/Suggestions/ideas are welcome.
###ENJOY###

#https://github.com/sunny-logic/email_jarvis
#Version 0.1
#########################################################################################################################

# Define the trusted email from which you will send and receive the email
trusted="rapizero@gmail.com"
verified=0

# Define the log file paths
tmpFile="/home/osmc/email_jarvis/logs/runlog.txt"
cmdoutput="/home/osmc/email_jarvis/logs/mailbody.txt"
readmail="/home/osmc/email_jarvis/logs/readmail.txt"
tmpMail="/home/osmc/email_jarvis/logs/mailtxt.txt"

# Initialize the logs files with timestamp
echo "##############`date`##############" > $tmpFile
echo "##############`date`##############" > $cmdoutput
echo "##############`date`##############" > $readmail
echo "##############`date`##############" > $tmpMail

# Block to send Email to predefined trusted email address
sendEmail() {
echo "Sending mail to $trusted" >> $tmpFile
echo "To: "$trusted > $tmpMail
echo "From: "$trusted >> $tmpMail
echo "Subject: "$1 >> $tmpMail
echo "" >> $tmpMail
echo $2 >> $tmpMail
cat "$cmdoutput" >> $tmpMail
/usr/sbin/ssmtp $trusted < $tmpMail
if [ $? -eq 0 ]; then
        echo "Command acknowledged and confirmation mail sent to $trusted" >> $tmpFile
else
        echo "SSTMP Error : Failed sending confirmation mail to $trusted" >> $tmpFile
fi
}

# Block to read email from predefined mailbox using .fetchmailrc configuration file located in Home directory
while read ml
        do
        echo "Content of mail is $ml" >> $tmpFile
        echo $ml >> $readmail
done

# Validate email address, extract keyword from email and match keyword with predefined keyword
grep "From:" $readmail | grep $trusted >> $tmpFile
        if [ $? -eq 0 ]; then
        echo "Mail received from trusted account $trusted" >> $tmpFile
        verified=1
        echo "verified flag value is $verified" >> $tmpFile

                if [ $verified -eq 1 ]; then
                        trigger=`grep "Subject:" $readmail`
                        echo "Trigger Keyword with subject line is $trigger" >> $tmpFile
                        trigger=${trigger:9}
                        echo "Parsed Trigger flag value without subject is $trigger" >> $tmpFile
                        trigger=`echo $trigger | tr [:upper:] [:lower:]`
                        echo "Case converted Trigger flag value is $trigger" >> $tmpFile
                        echo "Trigger Keyword from email subject line is $trigger" >> $tmpFile

                                case "$trigger" in
                                        ipaddress)
                                                echo "Getting IP Address..." >> $tmpFile
                                                ip=$(wget -qO- ipv4.icanhazip.com)
                                                if [ $? -eq 0 ]; then
                                                        echo "Here is $ip" >> $tmpFile
                                                        echo "Here is current public IP - $ip" >> $cmdoutput
                                                        sendEmail "RPi_Reply - IP Address" ""
                                                else
                                                        echo "Failed getting $trigger..." >> $tmpFile
                                                fi
                                          ;;

                                        _shutdown)
                                                echo "Initiating to Shutdown..." >> $tmpFile
                                                echo "Raspberry Pi will shutdown in 1 min" >> $cmdoutput
                                                echo "If you want to verify if Raspberry Pi is down" >> $cmdoutput
                                                echo "Send another mail with Trigger Keyword as systime" >> $cmdoutput
                                                echo "You will NOT get a response..." >> $cmdoutput
                                                sendEmail "RPi_Reply - Shutdown Trigger Acknowledged" ""
                                                sudo /sbin/shutdown -h +1 &
                                                if [ $? -eq 0 ]; then
                                                        echo "Shutdown will be initiatied in 1 min" >> $tmpFile
                                                #exit 0
                                                else
                                                        echo "Failed Initiating to Trigger $trigger..." >> $tmpFile
                                                fi
                                          ;;

                                        _reboot)
                                                echo "Initiating to Reboot..." >> $tmpFile
                                                echo "Raspberry Pi will reboot in 1 min." >>  $cmdoutput
                                                echo "If you want to verify if Raspberry Pi is UP." >> $cmdoutput
                                                echo "Send another mail with Trigger Keyword as systime." >> $cmdoutput
                                                echo "You will get a response with systime..." >> $cmdoutput
                                                sendEmail "RPi_Reply - Reboot Trigger Acknowledged" ""
                                                sudo /sbin/shutdown -r +1 &
                                                if [ $? -eq 0 ]; then
                                                        echo "Reboot will be initiatied in 1 min" >> $tmpFile
                                                #exit 0
                                                else
                                                        echo "Failed Initiating to Trigger $trigger..." >> $tmpFile
                                                fi
                                          ;;

                                        force_ddclient)
                                                echo "Initiating to force_ddclient..." >> $tmpFile
                                                sudo /usr/sbin/ddclient -force  >> $cmdoutput
                                                if [ $? -eq 0 ]; then
                                                        echo "force_ddclient Completed" >> $tmpFile
                                                        sendEmail "RPi_Reply - force_ddclient Acknowledged" ""
                                                else
                                                        echo "Failed to Trigger $trigger..." >> $tmpFile
                                                fi
                                          ;;

                                        stop_ddclient)
                                                echo "Initiating to stop_ddclient.." >> $tmpFile
                                                sudo /etc/init.d/ddclient stop >> $cmdoutput
                                                if [ $? -eq 0 ]; then
                                                        sleep 2
                                                        sudo /usr/sbin/service ddclient status >> $cmdoutput
                                                        echo "stop_ddclient Completed" >> $tmpFile
                                                        sendEmail "RPi_Reply - stop_ddclient Acknowledged" ""
                                                else
                                                        echo "Failed to Trigger $trigger..." >> $tmpFile
                                                fi
                                          ;;

                                        start_ddclient)
                                                echo "Initiating to start_ddclient..." >> $tmpFile
                                                sudo /etc/init.d/ddclient start >> $cmdoutput
                                                flag1=$?
                                                echo "Flag1 is $flag1" >> $tmpFile
                                                if [ $flag1 -eq 0 ]; then
                                                        sleep 2
                                                        sudo /usr/sbin/service ddclient status >> $cmdoutput
                                                        echo "start_ddclient Completed" >> $tmpFile
                                                        sendEmail "RPi_Reply - start_ddclient Acknowledged" ""
                                                else
                                                        echo "Failed to Trigger $trigger..." >> $tmpFile
                                                fi
                                          ;;

                                        stop_openvpn)
                                                echo "Initiating to Stop OpenVPN Server & Service..." >> $tmpFile
                                                sudo systemctl stop openvpn@server.service >> $cmdoutput
                                                flag1=$?
                                                sudo systemctl stop openvpn >> $cmdoutput
                                                flag2=$?
                                                echo "Flag1 is $flag1 & Flag2 is $flag2" >> $tmpFile
                                                if [[ $flag1 -eq 0 && $flag2 -eq 0 ]]; then
                                                        sudo systemctl status openvpn@server.service >> $cmdoutput
                                                        sleep 2
                                                        sudo systemctl status openvpn >> $cmdoutput
                                                        echo "stop_openvpn Completed" >> $tmpFile
                                                        sendEmail "RPi_Reply - stop_openvpn Acknowledged" ""
                                                else
                                                        echo "Failed to Trigger $trigger..." >> $tmpFile
                                                fi
                                          ;;

                                        start_openvpn)
                                                echo "Initiating to Start OpenVPN Server & Service..." >> $tmpFile
                                                sudo systemctl start openvpn@server.service >> $cmdoutput
                                                flag1=$?
                                                sudo systemctl start openvpn >> $cmdoutput
                                                flag2=$?
                                                echo "Flag1 is $flag1 & Flag2 is $flag2" >> $tmpFile
                                                if [[ $flag1 -eq 0 && $flag2 -eq 0 ]]; then
                                                        sudo systemctl status openvpn@server.service >> $cmdoutput
                                                        sleep 2
                                                        sudo systemctl status openvpn >> $cmdoutput
                                                        echo "start_openvpn Completed" >> $tmpFile
                                                        sendEmail "RPi_Reply - start_openvpn Acknowledged" ""
                                                else
                                                        echo "Failed to Trigger $trigger..." >> $tmpFile
                                                fi
                                          ;;

                                        stop_samba)
                                                echo "Initiating to Trigger $trigger.." >> $tmpFile
                                                sudo /etc/init.d/samba stop >> $cmdoutput
                                                if [ $? -eq 0 ]; then
                                                        sleep 2
                                                        sudo /etc/init.d/samba status >> $cmdoutput
                                                        echo "stop_samba Completed" >> $tmpFile
                                                        sendEmail "RPi_Reply - stop_samba Acknowledged" ""
                                                else
                                                        echo "Failed to Trigger $trigger..." >> $tmpFile
                                                fi
                                          ;;

                                        start_samba)
                                                echo "Initiating to Trigger $trigger..." >> $tmpFile
                                                sudo /etc/init.d/samba start >> $cmdoutput
                                                if [ $? -eq 0 ]; then
                                                        sleep 2
                                                        sudo /etc/init.d/samba status >> $cmdoutput
                                                        echo "start_samba Completed" >> $tmpFile
                                                        sendEmail "RPi_Reply - start_samba Acknowledged" ""
                                                else
                                                        echo "Failed to Trigger $trigger..." >> $tmpFile
                                                fi
                                          ;;

                                        systime)
                                                echo "Getting systime..." >> $tmpFile
                                                _date=`date`
                                                if [ $? -eq 0 ]; then
                                                        echo "Here is $_date" >> $tmpFile
                                                        sendEmail "RPi_Reply - Date" "$_date"
                                                else
                                                        echo "Failed getting $trigger" >> $tmpFile
                                                fi
                                         ;;

                                        *)
                                         echo "Invalid trigger keyword $trigger" >> $tmpFile
                                         sendEmail "Attention: Invalid trigger keyword $trigger" ""
                                        ;;
                                esac

                        else
                                echo "Mail received from untrusted account $trusted" , Exiting... >> $tmpFile
                                echo "verified flag value is $verified" >> $tmpFile
                        fi

        else
                echo "Mail received from untrusted account $trusted" , Exiting... >> $tmpFile
        fi
exit 0
