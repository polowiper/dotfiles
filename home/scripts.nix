{pkgs}:
# Several scripts that will be used throughout the system.
{
  # The Temperature module should "just work" on Waybar, but it does not. Maybe my machine is too old?
  # That's why I resort to these hacks.
  waybarTemperatureScript = pkgs.writeShellScriptBin "script" ''
    temp=$(cat /sys/class/hwmon/hwmon4/temp1_input)
    actualTemp=$((temp / 1000))
    echo $actualTemp
  '';

  batteryNotificationScript = pkgs.writeShellScriptBin "script" ''
    percentage=$(cat /sys/class/power_supply/BAT1/capacity)
    if [ $percentage -ge 100 ]; then
      ${pkgs.libnotify}/bin/notify-send "Battery Full" # My battery reports over 356% when full. It is broken.
    else
      ${pkgs.libnotify}/bin/notify-send "Current battery: $percentage"
    fi
  '';

  screenshotScript = pkgs.writeShellScriptBin "script" ''
  grim -g "$(slurp)" - | swappy -f -
  '';

  suspendScript = pkgs.writeShellScriptBin "script" ''
    ${pkgs.pipewire}/bin/pw-cli i all 2>&1 | ${pkgs.ripgrep}/bin/rg running -q
    # only suspend if audio isn't running
    if [ $? == 1 ]; then
      ${pkgs.systemd}/bin/systemctl suspend
    fi
  '';

  rofiPowerMenuScript = pkgs.writeShellScriptBin "script" ''
    lock="🔒️  Lock"
    logout="🏃  Log Out"
    shutdown="💡  Shut Down"
    reboot="🔃  Reboot"
    sleep="💤  Sleep"
    # Get answer from user via rofi
    selected_option=$(echo "$lock
    $logout
    $sleep
    $reboot
    $shutdown" | ${pkgs.rofi-wayland}/bin/rofi -dmenu -i -p "Power")
    # Do something based on selected option
    if [ "$selected_option" == "$lock" ]
    then
      hyprlock
    elif [ "$selected_option" == "$logout" ]
    then
      loginctl terminate-user "$(whoami)"
    elif [ "$selected_option" == "$shutdown" ]
    then
      systemctl poweroff
    elif [ "$selected_option" == "$reboot" ]
    then
      systemctl reboot
    elif [ "$selected_option" == "$sleep" ]
    then
      systemctl suspend
    else
      echo "No match"
    fi
  '';

  rofiWifiMenuScript = pkgs.writeShellScriptBin "script" ''

  nmcli -t d wifi rescan
  LIST=$(nmcli --fields SSID,SECURITY,BARS device wifi list | sed '/^--/d' | sed 1d | sed -E "s/WPA*.?\S/~~/g" | sed "s/~~ ~~/~~/g;s/802\.1X//g;s/--/~~/g;s/  *~/~/g;s/~  */~/g;s/_/ /g" | column -t -s '~')

  CONSTATE=$(nmcli -fields WIFI g)
  if [[ "$CONSTATE" =~ "enabled" ]]; then
	  TOGGLE="Disable WiFi 睊"
  elif [[ "$CONSTATE" =~ "disabled" ]]; then
	  TOGGLE="Enable WiFi 直"
  fi

  CHENTRY=$(echo -e "$TOGGLE\n$LIST" | uniq -u | ${pkgs.rofi-wayland}/bin/rofi -dmenu -selected-row 1 -p "Wifi Networks 󰤨 ")
  CHSSID=$(echo "$CHENTRY" | sed  's/\s\{2,\}/\|/g' | awk -F "|" '{print $1}')

  if [ "$CHENTRY" = "" ]; then
      exit
  elif [ "$CHENTRY" = "Enable WiFi 直" ]; then
	  nmcli radio wifi on
  elif [ "$CHENTRY" = "Disable WiFi 睊" ]; then
	  nmcli radio wifi off
  else
      KNOWNCON=$(nmcli connection show)
	
  	if [ "$CHSSID" = "*" ]; then
	  	CHSSID=$(echo "$CHENTRY" | sed  's/\s\{2,\}/\|/g' | awk -F "|" '{print $3}')
	  fi

	  if [[ $(echo "$KNOWNCON" | grep "$CHSSID") = "$CHSSID" ]]; then
		  nmcli con up "$CHSSID"
	  else
		  if [[ "$CHENTRY" =~ "" ]]; then
			  WIFIPASS=$(echo " Press Enter if network is saved" | ${pkgs.rofi-wayland}/bin/rofi -dmenu -p " WiFi Password: " -lines 1 )
		  fi
		  if nmcli dev wifi con "$CHSSID" password "$WIFIPASS"
		  then
			  ${pkgs.libnotify}/bin/notify-send 'Connection successful'
		  else
			  ${pkgs.libnotify}/bin/notify-send 'Connection failed'
		  fi
	  fi
  fi
  '';
}
