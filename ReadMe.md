docker compose run --rm -it create-cert

docker compose up hive -d

docker exec -it solace /usr/sw/loads/currentload/bin/cli -A

50a5f4173558>enable
50a5f4173558>configure
50a5f4173558>ssl
50a5f4173558(configure/ssl)#server-certificate combined_cert.pem
50a5f4173558(configure/ssl)#create domain-certificate-authority ca
9ed090c64c68(...gure/ssl/domain-certificate-authority)#certificate file ca_cert_combined.pem

50a5f4173558>configure
9ed090c64c68(configure)#authentication
9ed090c64c68(configure/authentication)#create client-certificate-authority ca
9ed090c64c68(...tication/client-certificate-authority)#certificate file ca_cert_combined.pem


solace(configure)# message-vpn default
solace(configure/message-vpn)# authentication
solace(...message-vpn/authentication)# client-certificate
solace(...ication/client-certificate)# matching-rules
solace(...certificate/matching-rules)# create rule mqtt

solace(...certificate/matching-rules/rule)# create condition {certificate-thumbprint | common-name | common-name-last | subject-alternate-name-msupn | uid | uid-last | org-unit | org-unit-last | issuer | subject | serial-number | dns-name | ip-address} {{matches-attribute <attribute>} | {matches-expression <expression>}}

create condition certificate-thumbprint matches-attribute 1ce4657bc19a543b4fadd9d69062cbdff32e85a7 --> sha1

create condition certificate-thumbprint matches-attribute 1D:E5:44:51:0E:FC:EE:E9:9C:EB:34:F4:BD:06:27:D4:11:46:C3:26 

https://gist.github.com/deskoh/e3338a3b84daa28dc8e3640ea4f50c52

docker exec -it pubSubStandardSingleNode /usr/sw/loads/currentload/bin/cli -A -es /cliscripts/setup.cli

docker exec -it pubSubStandardSingleNode /usr/sw/loads/currentload/bin/cli -A -es /usr/sw/jail/setup.cli