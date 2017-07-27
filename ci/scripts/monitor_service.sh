#!/bin/sh
 
ELB_NAME="{{ pcfdemo-clb }}"
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
 
while :; do
  stat=$(aws elb describe-instance-health --region ap-northeast-1 --load-balancer-name $ELB_NAME --instances $INSTANCE_ID --query InstanceStates[0].State)
  if [ `echo $stat | grep 'InService'` ] ; then
     exit 0
  fi
  sleep 5
done