:global wgXnew [:resolve xxxxxxxx.sn.mynetname.net]
:global wgXold [/interface wireguard peers get value-name=endpoint-address [find interface="wgX"]]

:if ($wgXold != $wgXnew) do={
/interface wireguard peers set endpoint-address="$wgXnew" [find interface="wgX"]
/log info "Wireguard peer wgX IP updated";
}
