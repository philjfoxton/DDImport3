#!/bin/bash

LB=pfm-prod-alb-limited-ingress

aws elb create-load-balancer-policy --load-balancer-name $LB --policy-name my-ProxyProtocol-policy --policy-type-name ProxyProtocolPolicyType --policy-attributes AttributeName=ProxyProtocol,AttributeValue=true
aws elb set-load-balancer-policies-for-backend-server --load-balancer-name $LB --instance-port 443 --policy-names my-ProxyProtocol-policy


