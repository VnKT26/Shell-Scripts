#!/bin/sh
#################################
MIT License

Copyright (c) 2021 Ventura Torres

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
#############################################################################
#############################################################################
#Author: Ventura Torres
#Date Created: 04/26/18
#Revised for Mojave: 10/10/2018 #no longer supported
#Revised to work with 11.5.x - 11.x 09-08-2021
#############################################################################
#############################################################################
##Check what OS is running. Command to find free disk space in bytes varies depending on the mac OS version. 
freeSpace=$( /usr/sbin/diskutil info / | grep "Free Space" | awk '{print $6}' | cut -c 2- )

#Convert bytes into GB
GBS=$(echo "$freeSpace" | awk '{ byte =$1 /1024/1024**2 ; print byte " GB" }'| awk '{printf("%.2f\n", $1)}')

##Check if free space > 15GB
if [[ ${freeSpace%.*} -ge 15000000000 ]]; then
    spaceStatus="OK"
    /bin/echo "Disk Space: OK - ${freeSpace%.*} Bytes or $GBS GB off Free Space Detected"

else
    spaceStatus="Not Enough Space"
    /bin/echo "Disk Space: Not Enough Space - ${freeSpace%.*} or $GBS GB Free Space Detected"

#identifies who is currently logged into the computer
lastUser=$(ls -l /dev/console | cut -d " " -f4)


#Identifies the 5 largest files within the user's home directory.
cd /Users/$lastUser/

largeFiles=$(find . -type f -print0 | xargs -0 du | sort -n -r | head  -5 | cut -f2 | xargs -I{} du -sh {})


#Prompt to End User to make more space. Using JamfHelper to prompt the user
/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -title "Alert! "  -alignHeading center -alignDescription left -description "Your Mac currently only has $GBS GB of free space left. To ensure your Mac remains healthy and performs properly we recommend that you have at least 15 GB of free disk space.
Please make space on your computer by clearing out unnecesary files to ensure you have at least 15 GB of free space. The files listed below are the 5 largest files in your home directory:

$largeFiles.

Please contact IT if you have any questions or require any assistance. You will receive this prompt daily until you have at least 15 GB of free space on your mac." -button1 OK -defaultButton 1 -icon /System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/AlertStopIcon.icns #-iconSize pixels 300

fi

exit 0
