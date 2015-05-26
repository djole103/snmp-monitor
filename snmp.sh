#! /bin/bash
while [ True ]; do

        ip=$(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}')

        #available ram  
        ramfree=$(snmpget -v2c -c public localhost .1.3.6.1.4.1.2021.4.11.0)
        IFS=', ' read -a ramarray <<< "$ramfree"
        if [ ${ramarray[3]} -lt 100000 ]; then
                logger -p local0.WARN $ip  RAM available: ${ramarray[3]} #$ramfree 
        else
                logger -p local0.INFO $ip  RAM available: ${ramarray[3]}  #$ramfree
        fi

        #available disc
        discfree=$(snmpget -v2c -c public localhost .1.3.6.1.4.1.2021.9.1.7.1)
        IFS=', ' read -a discarray <<< "$discfree"
        if [ ${discarray[3]} -lt 100000 ]; then
                logger -p local0.WARN $ip DISC available: ${discarray[3]} #$discfree
        else
                logger -p local0.INFO $ip DISC available: ${discarray[3]} #$discfree
        fi

        #1min avg cpu load
        avgload=$(snmpget -v2c -c public localhost .1.3.6.1.4.1.2021.10.1.3.1)
        IFS=', ' read -a loadarray <<< "$avgload"
        if [ $(bc <<< "${loadarray[3]} > 8") ]; then

                logger -p local0.WARN $ip CPU average load for 1 minute: ${loadarray[3]} #$avgload
        else
                logger -p local0.INFO $ip CPU average load for 1 minute: ${loadarray[3]} # $avgload
        fi

        sleep 5
done

