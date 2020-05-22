#!/bin/bash

LB=ab245f6d88daf4439aca253d4bad72e5

aws elb create-load-balancer-policy --load-balancer-name $LB --policy-name my-ProxyProtocol-policy --policy-type-name ProxyProtocolPolicyType --policy-attributes AttributeName=ProxyProtocol,AttributeValue=true
aws elb set-load-balancer-policies-for-backend-server --load-balancer-name $LB --instance-port 443 --policy-names my-ProxyProtocol-policy


