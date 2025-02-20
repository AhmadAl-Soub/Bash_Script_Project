#!/bin/bash

#System Health Script


#Function to check disk space.
function check_disk_space(){
        echo "Checking disk space..."
        df -h | awk '$NF=="/"{print "Disk Usage: "$5 " ("$3" used out of "$2")"}'
}


#Function to check memory usage.
function check_memory_usage(){
        echo "Checking memory usage..."
        free -h | awk ' /^Mem:/{print "Memory Usage: "$3" used out of "$2" ("$3/$2*100 "%)"}' 
}

#Function to check running services.
function check_running_services(){
        echo "Checking running services..."
        services=("cron" "apache2")
        for service in "${services[@]}";
        do
                if systemctl is-active --quiet "$service"; then
                        echo "Service $service is running."
                else
                        echo "Service $service is NOT running. Consider Starting it: sudo systemctl start $service"
                fi
        done
}

#Function to check recent system updates.
function check_system_updates(){
        echo "Checking for recent updates..."
        updates=$(apt list --upgradable 2>/dev/null | grep -v "Listing" | wc -l)
        if [ "$updates" -gt 0 ]; then
                echo "There are $updates update available. Consider running: sudo apt update && sudo apt upgrade"
        else
                echo "System is up-to-date."
        fi
}

#Generate Health report
function health_report(){
        echo "--- System Health Report ---"
        check_disk_space
        check_memory_usage
        check_running_services
        check_system_updates
        echo "--- End of Report ---"
}


health_report #Then, Execute the health report
