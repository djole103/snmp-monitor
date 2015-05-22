#! /bin/bash
while [ True ]; do
	#snmpwalk localhost UCD-SNMP-MIB::systemStats |	logger -p local0.INFO 
	
	#available ram  
	ramfree=$(snmpget localhost .1.3.6.1.4.1.2021.4.11.0)
	IFS=', ' read -a ramarray <<< "$ramfree"
	if [ ${ramarray[3]} -lt 100000 ]; then
		logger -p local0.WARN $ramfree 
	else
		logger -p local0.INFO $ramfree
	fi
	
	#available disc
	discfree=$(snmpget localhost .1.3.6.1.4.1.2021.9.1.7.1)
	IFS=', ' read -a discarray <<< "$discfree"
	if [ ${discarray[3]} -lt 100000 ]; then
		logger -p local0.WARN $discfree
	else
		logger -p local0.INFO $discfree
	fi
	
	#1min avg cpu load
	avgload=$(snmpget localhost .1.3.6.1.4.1.2021.10.1.3.1)	
	IFS=', ' read -a loadarray <<< "$avgload"
	#if [ ${loadarray[3]} -gt 8 ]; then
	#if [ $("${loadarray[3]} > 8" | bc <<<) ]; then
	if [ $(bc <<< ${loadarray[3]} > 8) ]; then

		logger -p local0.WARN $avgload
	else
		logger -p local0.INFO $avgload
	fi

	sleep 5
done
