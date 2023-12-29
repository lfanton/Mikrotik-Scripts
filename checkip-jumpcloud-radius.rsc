:local myhostname [/system identity get name]
:local mydate ([/system clock get date])
:local mytime ([/system clock get time])
:local toEmail email@notify.me
:global lastip

:global getmyip [/tool fetch url="https://ipconfig.io" as-value output=user];
:global myip ($getmyip->"data")

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
