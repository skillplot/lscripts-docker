#!/bin/bash

###----------------------------------------------------------
## menu navigation
###----------------------------------------------------------

#Coloring scheme
ld=`tput bold`
bld=`tput smso`
nrml=`tput rmso`
reset=`tput reset`
red=$(tput setaf 1)
normal=$(tput sgr0)
rev=$(tput rev)
cyan_start="\033[36m"
cyan_stop="\033[0m"

#1. Display a menu. 
#2. Get the user's menu pick. 
#3. Check that the pick is valid and if not, display an lsd-mod.log.error message and return to step 1. 
#4. If the user's menu pick is to exit, then exit. 
#5. Otherwise, execute the command(s) associated with the menu pick. 
#6. Loop back to step 1. 

# The logo will be displayed at the top of the screen
LOGO="Menu"

#------------------------------------------------------
# MENU PROMPTS
#------------------------------------------------------
cmdarry=(Previous Next Exit)
PS3="Choose (1-${#cmdarry[*]}):"

#------------------------------------------------------
# DISPLAY FUNCTION DEFINITION
#------------------------------------------------------
themenu () {
	clear
	echo `date`
	echo
	echo "$LOGO"
	echo
	echo "Please Select:"
	echo
	#echo "1.Select		2.Next		3.Previous"
	select cmdtypname in ${cmdarry[@]}
	do

		echo $cmdtypname
	        if [ "$cmdtypname" = "" ]; then
			badchoice
	                exit 1
	        fi
	        break

                case  $cmdtypname in
                   Previous)
                                #PS3="Choose (1-${#processmgmnt[*]}):"
                                break
                                ;;
                       Next)
                                #PS3="Choose (1-${#memcmds[*]}):"
                                break
                                ;;
                       Exit)
				exit -1
                                ;;
                          *)   badchoice
				exit -1
                                ;;
                 esac

	done
}

#------------------------------------------------------
# MENU FUNCTION DEFINITIONS
#------------------------------------------------------

badchoice () { MSG="Invalid Selection ... Please Try Again" ; }
themenu
