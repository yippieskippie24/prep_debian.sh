#! /bin/bash

## Script written by Tyler M Johnson
## https://github.com/yippieskippie24



echo '######################################################'
echo '##                                                  ##'
echo '##                Prepare Debian                    ##'
echo '##                                                  ##'
echo '##    Setup script for new Debian server install    ##'
echo '##                                                  ##'
echo '######################################################'


## INITIALIZE VARIABLES ##
software_to_install="" 		#variable that will be appended to apt-get install
installSELECTION="" 		#variable that gets updated with user selection of what function to run to install software



## ROOT CHECK ##
# Are we root? If not use sudo
if [[ $EUID -eq 0 ]];then
    echo "You are root."
else
    echo "Sudo will be used for the install."
    # Check if it is actually installed
    # If it isn't, exit because the install cannot complete
    if [[ $(dpkg-query -s sudo) ]];then
        export SUDO="sudo"
    else
        echo "Please install sudo or run this as root."
        exit 1
    fi
fi

whiptail --title "Tools to be Installed" --msgbox "The followign tools will be installed:" 8 78

#Functions:

##installler selector
function installer_selector() {
	installSELECTION=$(whiptail --title "select software to install" --menu "Choose software to install:" 15 65 6 \
			"Webmin" "|  Web based management of server" \
			"htop" "|  A more pretty version of top" \
			"ssh" "|  SSH client and server"\
			"Install" "|  Run's installer of marked software" \
			"Exit" "|  Quit this Installer" 3>&1 1>&2 2>&3)

	case $installSELECTION in
		Webmin)
			echo "Selecting Webmin for install"
			if [ ! -d "/etc/webmin" ]; then
				echo "Adding Webmin repository"
				##add webmin repository to APT
<<<<<<< HEAD
				$SUDO touch /etc/apt/sources.list.d/webmin.list
				$SUDO echo '#Webmin repository:' >> /etc/apt/sources.list.d/webmin.list
				$SUDO echo 'deb http://download.webmin.com/download/repository sarge contrib' >> /etc/apt/sources.list.d/webmin.list
				$SUDO echo 'deb http://webmin.mirror.somersettechsolutions.co.uk/repository sarge contrib' >> /etc/apt/sources.list.d/webmin.list
	
=======
				$SUDO sh -c 'echo "deb http://download.webmin.com/download/repository sarge contrib" > /etc/apt/sources.list.d/webmin.list' 
				
>>>>>>> webmin
				##download and install apt keys
				$SUDO wget -qO - http://www.webmin.com/jcameron-key.asc | $SUDO apt-key add -
	
				##add webmin to the software_to_install variable
				software_to_install="$software_to_install webmin"
				whiptail --title "Software Marked" --msgbox "Webmin is marked for installation. You must hit OK to continue." 8 78
			else
				whiptail --title "ERROR" --msgbox "Webmin is already installed, Skipping install." 8 78
			fi
			##return to install menu
			installer_selector
		;;
	
		htop)
		
			echo "Selecting htop for install"
			##add htop to the installSELECTION variable
			software_to_install="$software_to_install htop"
			##display message stating that htop has been added to the software_to_install variable
			whiptail --title "Software Marked" --msgbox "htop is marked for installation. You must hit OK to continue." 8 78
			
			##return to install menu
			installer_selector
		
		;;
		
		ssh)
			echo "Selecting ssh for install"
			##add ssh to the installSELECTION variable
			software_to_install="$software_to_install ssh"
			##display message stating that ssh has been added to the software_to_install variable
			whiptail --title "Software Marked" --msgbox "ssh is marked for installation. You must hit OK to continue." 8 78
			
			##return to install menu
			installer_selector
		
		;;
		
		Install)
			echo "$software_to_install"
			$SUDO apt-get update
			$SUDO apt-get install -y $software_to_install
			whiptail --title "Software Installed" --msgbox "The software you selected has been installed. You must hit OK to continue." 8 78
			exit
			
		;;
		
		Exit)
			echo "Exiting Installer"
			if (whiptail --title "Exiting Installer" --yesno "Are you sure you want to exit?  No software will be installed." 8 78) then
				echo ""
				exit
			else
				echo "User selected No, returning to main menu"
				installer_selector
			fi
	
	esac


}





# functions to run

installer_selector

