#!/bin/bash

###----------------------------------------------------------
## create menu
###----------------------------------------------------------

declare -a choices=(red green blue yellow magenta)
declare -a choices=(Editors Gis Graphics Multimedia Programming System-utils)

PS3="Choose (1-${#choices[@]}):"
echo "Choose from the list below."
select name in ${choices[@]}
do
	break
done
if [ "$name" = "" ]; then
	echo "Error in entry."
	exit 1
fi
echo "You chose $name."

