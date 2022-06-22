# wg-peer-update

This script allows to automatically update the public IP router address in a site-to-site Wireguard VPN when both routers have a dynamic public IP address and one of the two changes. 
It can be used by creating a netwatch on both routers and checking the opposite remote hostname.
Cancel changes
Below the explenation:

<b>xxxxxxxx.sn.mynetname.net</b> is the hostname of the remote router (You can enable it on /ip/cloud/ddns...)

<b>wgX</b> is the name of the wireguard tunnel interface, generally it's called wg0, in this example it's also the interface comment.

<b>wgXold</b> and wgXnew it's the respective variable with the old and new ip address.

<b>x.x.x.x</b> is the remote wireguard IP address, for example 172.17.0.2.


<pre>
  <code>
/tool/netwatch
add down-script=":global wgXnew [:resolve xxxxxxxx.sn.mynetname.net]\
    \n#:global wgXold [/interface wireguard peers get [find comment=\"wgX\"] endpoint-address ]\
    \n:global wgXold [/interface wireguard peers get value-name=endpoint-address [find interface=\"wgX\"]]\
    \n\
    \n:if (\$wgXold != \$wgXnew) do={\
    \n/interface wireguard peers set endpoint-address=\"\$wgXnew\" [find interface=\"wgX\"]\
    \n/log info \"Wireguard wgX ip updated\";\
    \n}" host=x.x.x.x interval=2m
  </code>
</pre>
