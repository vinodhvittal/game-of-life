#! /bin/ksh

# Entry Level Assigning

if [ -e "input" ]
then
set=cont
fi
if [ -e "Error" ]
then
rm Error
fi
if [ -e "RunScript.sh" ]
then
rm RunScript.sh
fi
if [ -e "Results" ]
then
rm Results
fi
(cat input; echo) | while read -r line
do
scriptType=`echo "$line" | awk '{print $3}'`
#---------------------------download------------------------------------
if [[ "$scriptType" == *"download"* ]];
then
# read values
#Local Directory
ld=`echo "$line" | awk -F "ld:" '{ print $2 }' | awk -F "]" '{print $1}'`
LD=`echo "$line" | awk -F "LD:" '{ print $2 }' | awk -F "]" '{print $1}'`
#Remote Directory
rd=`echo "$line" | awk -F "rd:" '{ print $2 }' | awk -F "]" '{print $1}'`
RD=`echo "$line" | awk -F "RD:" '{ print $2 }' | awk -F "]" '{print $1}'`
#Remote File
rf=`echo "$line" | awk -F "rf:" '{ print $2 }' | awk -F "]" '{print $1}'`
RF=`echo "$line" | awk -F "RF:" '{ print $2 }' | awk -F "]" '{print $1}'`
#Inputs
if [ "$rd" ]
then
RemoteDir=`echo $rd`
elif [ "$RD" ]
then
RemoteDir=`echo $RD`
fi
script=`echo "$line" | awk '{print $2}'`
des=`passfor "$script" | grep "$RemoteDir"`
if [ "$des" ]
then
echo "\nMessage: The Below Entries are present in Password tool for $script!"
echo "$des"
else
echo "\nMessage: No Entry is found in Password tool for $script!"
fi
downloadorg=`echo "$line" | awk '{print $3}'`
script=`echo "$line" | awk '{print $2}'`
passfor "$script" > temp
downloadno=`cat temp | awk '{ print $3}' | awk -F "download" '{print $2}' | sort -n | tail -1`
echo $downloadno
downloadadd=`expr $downloadno + 1`
newEntry=`echo "$line" | sed "s/$downloadorg/download$downloadadd/g"` >> input_back
echo "\nPassword Tool entries for download:
===================================================
`echo adding entry`
`echo "\n$newEntry"`
======================================================================================="
first=`echo "$newEntry" | awk '{print "\""$1"\""}'`
second=`echo "$newEntry" | awk '{print "\""$2"\""}'`
thrid=`echo "$newEntry" | awk '{print "\""$3"\""}'`
thr=`echo "$newEntry" | awk '{print $3}'`
fourth=`echo "$newEntry" | awk -v de=$thr '{ FS = de
print $2}' | sed "s/^ \{1,\}//g" | sed "s/^	\{1,\}//g"`
echo "expect comm_pass_tool $first $second $thrid \"$fourth\"" >> RunScript.sh
chmod 777 RunScript.sh
	./RunScript.sh
#	rm RunScript.sh

echo "\nPassword Tool Entry is completed for $newEntry"
remoteDir="/u/spool/ftponly/clients/testmeto$rd"
# Directory Creation
if [ ! -e "$remoteDir" ]
then
echo "\nMessage: $remoteDir is created!"
mkdir $remoteDir
fi

echo "\nTest files in $remoteDir dir:
---------------------------------------------
[`hostname`:`pwd`]$ ls -lrt $remoteDir" >> Results
ls -lrt $remoteDir >> Results
fi
#---------------------------upload------------------------------------
if [[ "$scriptType" == *"upload"* ]];
then
#Local Directory
ld=`echo "$line" | awk -F "ld:" '{ print $2 }' | awk -F "]" '{print $1}'`
LD=`echo "$line" | awk -F "LD:" '{ print $2 }' | awk -F "]" '{print $1}'`
#Local File
lf=`echo "$line" | awk -F "lf:" '{ print $2 }' | awk -F "]" '{print $1}'`
LF=`echo "$line" | awk -F "LF:" '{ print $2 }' | awk -F "]" '{print $1}'`
#Remote Directory
rd=`echo "$line" | awk -F "rd:" '{ print $2 }' | awk -F "]" '{print $1}'`
RD=`echo "$line" | awk -F "RD:" '{ print $2 }' | awk -F "]" '{print $1}'`
#Remote File
rf=`echo "$line" | awk -F "rf:" '{ print $2 }' | sed 's/.$//'`
RF=`echo "$line" | awk -F "RF:" '{ print $2 }' | sed 's/.$//'`
val=`echo $rf | tail -c 2`
if [[ "$val" == "]" ]];
then
rf="${rf%?}"
fi
val=`echo $RF | tail -c 2`
if [[ "$val" == "]" ]];
then
RF="${RF%?}"
fi
if [ "$rd" ]
then
RemoteDir=`echo $rd`
elif [ "$RD" ]
then
RemoteDir=`echo $RD`
fi
script=`echo "$line" | awk '{print $2}'`
des=`passfor $script | grep "$RemoteDir"`
if [ "$des" ]
then
echo "\nMessage: The Below Entries are present in Password tool for $script!"
echo "$des"
else
echo "\nMessage: No Entry is found in Password tool for $script!"
fi
uploadorg=`echo "$line" | awk '{print $3}'`
passfor "$script" > temp
uploadno=`cat temp | awk '{ print $3}' | awk -F "upload" '{print $2}' | sort -n | tail -1`
echo $uploadno
uploadadd=`expr $uploadno + 1`
newEntry=`echo "$line" | sed "s/$uploadorg/upload$uploadadd/g"` >> input_back

echo "\nPassword Tool entries for upload:
===================================================
`echo $newEntry`
======================================================================================="
first=`echo "$newEntry" | awk '{print "\""$1"\""}'`
second=`echo "$newEntry" | awk '{print "\""$2"\""}'`
thrid=`echo "$newEntry" | awk '{print "\""$3"\""}'`
thr=`echo "$newEntry" | awk '{print $3}'`
fourth=`echo "$newEntry" | awk -v de=$thr '{ FS = de
print $2}' | sed "s/^ \{1,\}//g" | sed "s/^	\{1,\}//g"`
echo "expect comm_pass_tool $first $second $thrid \"$fourth\"" >> RunScript.sh

chmod 777 RunScript.sh
	./RunScript.sh
	rm RunScript.sh

echo "\nPassword Tool Entry is completed for $newEntry"

# Directory Creation
if [ "$ld" ]
then
LocalDir=`echo $ld`
elif [ "$LD" ]
then
LocalDir=`echo $LD`
fi
if [ "$rd" ]
then
RemoteDir="/u/spool/ftponly/clients/testmeto$rd"
elif [ "$RD" ]
then
RemoteDir="/u/spool/ftponly/clients/testmeto$RD"
fi
if [ ! -e "$RemoteDir" ]
then
echo "\nMessage: $RemoteDir is created!"
mkdir $RemoteDir
fi

if [ ! -e "$LocalDir" ]
then
echo "\nMessage: $LocalDir is created!"
mkdir $LocalDir
fi

echo "\nClaims in source Directory:
---------------------------------------------
[`hostname`:`pwd`]$ ls -lrt $LocalDir" >> Results
ls -lrt $LocalDir >> Results
fi
done
#================= END OF FIRST  PART====================================================#
#==============Script Execution====================#
echo "\nDo you want to Proceed with /u/local/bin/sendxfer -nvalence script? [ y / n ]"
read wish2
if [ "$wish2" == "y" ] || [ "$wish2" == "YES" ] || [ "$wish2" == "Yes" ] || [ "$wish2" == "yes" ]
then
     echo "\nMessage: Sleeping 60!"
	 sleep 60
	 Today=`date +%Y%m%d%H%M%S`
     mv /u/spool/zlogs/sendvalence /u/spool/zlogs/sendvalence.$Today
	 echo "\nScript Execution:
--------------------
[`hostname`:`pwd`]$ sudo -u uniclaim /u/local/bin/sendxfer -nvalence" >> Results

     echo "\nMessage: Running..."
	sudo -u uniclaim /u/local/bin/sendxfer -nvalence
	
	echo "\nLogs:
-----------" >> Results
	cat /u/spool/zlogs/sendvalence >> Results
fi
	
# rename input_back to input
mv input_back input

# capture output in inbound and outbound directory
(cat input; echo) | while read -r line
do
if [[ "$scriptType" == *"download"* ]];
then
# read values
#Local Directory
ld=`echo "$line" | awk -F "ld:" '{ print $2 }' | awk -F "]" '{print $1}'`
LD=`echo "$line" | awk -F "LD:" '{ print $2 }' | awk -F "]" '{print $1}'`
#Remote Directory
rd=`echo "$line" | awk -F "rd:" '{ print $2 }' | awk -F "]" '{print $1}'`
RD=`echo "$line" | awk -F "RD:" '{ print $2 }' | awk -F "]" '{print $1}'`
#Remote File
rf=`echo "$line" | awk -F "rf:" '{ print $2 }' | awk -F "]" '{print $1}'`
RF=`echo "$line" | awk -F "RF:" '{ print $2 }' | awk -F "]" '{print $1}'`

echo "\nAfter Execution, reports in inbound directory:
---------------------------------
[`hostname`:`pwd`]$ ls -ltr $ld
`ls -lrt $ld`" >> Results

remoteDir="/u/spool/ftponly/clients/testmeto$rd"
echo "\nAfter Execution, reports in remote directory:
---------------------------------
[`hostname`:`pwd`]$ ls -ltr $remoteDir
`ls -lrt $remoteDir`" >> Results
fi
if [[ "$scriptType" == *"upload"* ]];
then
#Local Directory
ld=`echo "$line" | awk -F "ld:" '{ print $2 }' | awk -F "]" '{print $1}'`
LD=`echo "$line" | awk -F "LD:" '{ print $2 }' | awk -F "]" '{print $1}'`
#Local File
lf=`echo "$line" | awk -F "lf:" '{ print $2 }' | awk -F "]" '{print $1}'`
LF=`echo "$line" | awk -F "LF:" '{ print $2 }' | awk -F "]" '{print $1}'`
#Remote Directory
rd=`echo "$line" | awk -F "rd:" '{ print $2 }' | awk -F "]" '{print $1}'`
RD=`echo "$line" | awk -F "RD:" '{ print $2 }' | awk -F "]" '{print $1}'`
#Remote File
rf=`echo "$line" | awk -F "rf:" '{ print $2 }' | sed 's/.$//'`
RF=`echo "$line" | awk -F "RF:" '{ print $2 }' | sed 's/.$//'`
val=`echo $rf | tail -c 2`
if [[ "$val" == "]" ]];
then
rf="${rf%?}"
fi
val=`echo $RF | tail -c 2`
if [[ "$val" == "]" ]];
then
RF="${RF%?}"
fi
if [ "$rd" ]
then
RemoteDir="/u/spool/ftponly/clients/testmeto$rd"
elif [ "$RD" ]
then
RemoteDir="/u/spool/ftponly/clients/testmeto$RD"
fi
if [ "$ld" ]
then
LocalDir=`echo $ld`
elif [ "$LD" ]
then
LocalDir=`echo $LD`
fi

echo "\nAfter execution , Claims in outbound directory:
---------------------------------
[`hostname`:`pwd`]$ ls -ltr $RemoteDir
`ls -lrt $RemoteDir`" >> Results

echo "\nAfter Execution no files in source directory:
---------------------------------
[`hostname`:`pwd`]$ ls -ltr $LocalDir
`ls -lrt $remoteDir`" >> Results
fi
done