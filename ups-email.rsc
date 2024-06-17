:local mailto "notify@me";
:local online;
:local sysname [/system identity get name];
:local datetime "$[/system clock get date] $[/system clock get time]";
:local upsname
:set upsname [system ups get value-name=name 0];

:global oldonline;

:if ([:typeof $oldonline]="nothing") do={:set $oldonline true};

:set online true;
:set online [system ups get value-name=on-line 0];

:if ( ( $online = false ) && ( $oldonline = true ) ) do={
  :set oldonline false;

  /tool e-mail send to=$mailto subject="$upsname power failed!" body="$upsname on $sysname is on battery since $datetime";
  :log info "UPS: Power-Failed email sent to $mailto";
}

:if ( ( $online = true ) && ( $oldonline = false ) ) do={
  :set oldonline true;

  /tool e-mail send to=$mailto subject="$upsname: Power restored!" body="$upsname on $sysname is back online since $datetime";
  :log info "UPS: Power-Restored email sent to $mailto";
}
