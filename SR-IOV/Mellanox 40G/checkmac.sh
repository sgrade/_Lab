#!/bin/bash
#
# check interface and MAC
#
# Author MShtern@beeline.ru
# All Rights Reserved
#

#####CONFIG SECTION#########

VER=1.4


INF=ens8d1          #Which interface to check?
COUNT=2             #How many time to check?
LOGDIR=/root/log    #should be without last "/"
LOG=mac.out         #Raw data log
PATHTORUN=/root     #dir where the script located
FRMLOG=mac.formated #Bigdata file



#####CONFIG SECTION END#####

function get_mac
{

MAC=`ifconfig $INF | grep ether | awk '{ print $2}'`

}

function get_attr
{
INF=$1
LIST=$(ls /sys/class/net/$INF | grep -v "power\|qos\|queues\|statistics\|subsystem\|upper_bond0\|master\|operstate\|speed\|tx_queue_len\|broadcast\|device")
for i in $LIST

     do echo $i  >> $2 ; cat /sys/class/net/$INF/$i  >> $2 ; echo "---" >> $2; done
}

function get_pci
{
PCI=`cat /sys/class/net/${INF}/device/uevent | grep PCI_SLOT_NAME`
echo $PCI >> $1
}

TEMPLOG=${LOGDIR}/tmp.log

if [ "$1" = "-v" ] ; then

     echo $VER ; exit 0

fi

if [ "$1" = "--help" ] ; then

     echo "Usage: just run script and it will reboot and compare MAC. Fill the config section inside the script. After script finished check mac.formated file"

fi


if [ ! -d "$LOGDIR" ]; then

     mkdir -p $LOGDIR
fi

#init

INITCHECK=`ls $LOGDIR | grep initlogfile.log`

if [ -z "$INITCHECK" ] ; then

     echo "init stage"
     touch $LOGDIR/initlogfile.log
     touch $TEMPLOG
     echo "stage=1" >> $TEMPLOG
     get_mac
         echo "MAC" >> $TEMPLOG
     echo "$MAC" >> $TEMPLOG
         echo "ATTRS" >> $TEMPLOG
         get_attr $INF $TEMPLOG
         get_pci $TEMPLOG
     echo "stage_end=1" >> $TEMPLOG

         #autorun
         cp -rp /etc/rc.d/rc.local /etc/rc.d/rc.local_before_check_scr
         sed --i "s/exit 0//g" /etc/rc.d/rc.local
         echo "$PATHTORUN/checkmac.sh" >> /etc/rc.d/rc.local
         echo "exit 0" >> /etc/rc.d/rc.local
                 chmod +x /etc/rc.d/rc.local #; chmod +x /etc/rc.d/rc.local
                 systemctl start rc-local ; sleep 1
#         reboot
         exit 0

fi

STAGE=`tail -n 1 $TEMPLOG | sed 's/stage_end=//g'`

if [ "$STAGE" -lt "$COUNT" ] ; then

     echo "stage=$(($STAGE+1))" >> $TEMPLOG
     get_mac
         echo "MAC" >> $TEMPLOG
     echo "$MAC" >> $TEMPLOG
         echo "ATTRS" >> $TEMPLOG
         get_attr $INF $TEMPLOG
         get_pci $TEMPLOG
     echo "stage_end=$(($STAGE+1))" >> $TEMPLOG
#     sleep 5 ; reboot
     exit 0

fi

if [ "$STAGE" = "$COUNT" ] ; then

     echo "stage=$(($STAGE+1))" >> $TEMPLOG
         get_mac
          echo "MAC" >> $TEMPLOG
         echo "$MAC" >> $TEMPLOG
         echo "ATTRS" >> $TEMPLOG
         get_attr $INF $TEMPLOG
         get_pci $TEMPLOG
         echo "stage_end=$(($STAGE+1))" >> $TEMPLOG
         rm $LOGDIR/initlogfile.log
         touch ${LOGDIR}/${LOG} ; mv $TEMPLOG ${LOGDIR}/${LOG}
         mv /etc/rc.d/rc.local_before_check_scr /etc/rc.d/rc.local ; chmod -x /etc/rc.d/rc.local


         echo "Finished"

                 #bigdata

                  FORMATEDMAC=`cat ${LOGDIR}/${LOG} | grep -v stage | sort | uniq`
                  echo "$INF MAC during $COUNT reboot was $FORMATEDMAC" > ${PATHTORUN}/${FRMLOG}
                  #rm


         exit 0

fi

exit 0
