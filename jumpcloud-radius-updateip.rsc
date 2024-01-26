:local myhostname [/system identity get name]
:local mydate ([/system clock get date])
:local mytime ([/system clock get time])
:local toEmail email@notify.me
:global lastip

# using Mikrotik embedded service /ip/cloud/
# https://help.mikrotik.com/docs/display/ROS/Cloud
:global getmyip [/ip/cloud/print as-value without-paging]
:global myip ($getmyip->"public-address")

# external website like ifconfig.io or ifconfig.io
#:global getmyip [/tool fetch url="https://ifconfig.io/ip" as-value output=user];
# (simply remove /n character)
#:global myip [ :pick ($getmyip->"data") 0 ( [ :len ($getmyip->"data") ] -1 ) ];

:if ([:typeof $lastip] ~ "(nil|nothing)") do= {
:log info nolastip
:global lastip ($getmyip->"data")
}

:if (($myip != $lastip)) do={
:log info ("MYIP: $myip")
:tool e-mail send to=$toEmail subject="$myhostname NEW IP" body="$myip"
:set lastip $myip

/tool fetch http-method=put mode=https http-header-field="x-api-key:XXX,content-type:application/json" http-data="{\"name\":\"$myhostname $mydate ($mytime)\",\"networkSourceIp\":\"$myip\",\"sharedSecret\":\"XXX\"}" output=none url="https://console.jumpcloud.com/api/radiusservers/XXX"

} else={
#:log info ("MYIP $hostname: No update needed")
}
