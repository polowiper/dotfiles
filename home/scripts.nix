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

  #TEST SCRIPT MIGHT BE THE DEFAULT LATER

  # Volume Script
  volume = pkgs.writeShellApplication {
    name = "volume";
    runtimeInputs = with pkgs; [pamixer dunst];
    text = ''
      # Icon directory
      icon_dir="/etc/nixos/hm-modules/icons/"

      # Get Volume
      get_volume() {
      	volume=$(pamixer --get-volume)
      	echo "$volume"
      }

      # Get icons
      get_icon() {
      	vol="$(get_volume)"
      	current="''${vol%%%}"
      	if [[ "$current" -eq "0" ]]; then
      		icon=''${icon_dir}'audio-volume-muted-symbolic.svg'
      	elif [[ ("$current" -ge "0") && ("$current" -le "30") ]]; then
      		icon=''${icon_dir}'audio-volume-low-symbolic.svg'
      	elif [[ ("$current" -ge "30") && ("$current" -le "60") ]]; then
      		icon=''${icon_dir}'audio-volume-medium-symbolic.svg'
      	elif [[ ("$current" -ge "60") && ("$current" -le "90") ]]; then
      		icon=''${icon_dir}'audio-volume-high-symbolic.svg'
      	elif [[ ("$current" -ge "90") && ("$current" -le "100") ]]; then
      		icon=''${icon_dir}'audio-volume-overamplified-symbolic.svg'
      	fi
      }

      # Increase Volume
      up_volume() {
      	pamixer -i 5 --unmute && get_icon && dunstify -u low --replace=69 -i "$icon" "Volume : $(get_volume)%"
      }

      # Decrease Volume
      down_volume() {
      	pamixer -d 5 --unmute && get_icon && dunstify -u low --replace=69 -i "$icon" "Volume : $(get_volume)%"
      }

      # Toggle Mute
      toggle_mute() {
          status=$(pamixer --get-mute)

      	if [[ "$status" == "true" ]]; then
      		pamixer --unmute && get_icon && dunstify -u low --replace=69 -i "$icon" "Unmuted"
      	else
      		pamixer --mute && dunstify -u low --replace=69 -i "''${icon_dir}"'audio-volume-muted-symbolic.svg' "Muted"
      	fi
      }

      # Execute accordingly
      if [[ "$1" == "--get" ]]; then
      	get_volume
      elif [[ "$1" == "--up" ]]; then
      	up_volume
      elif [[ "$1" == "--down" ]]; then
              down_volume
      elif [[ "$1" == "--toggle" ]]; then
      	toggle_mute
      else
      	get_volume
      fi
    '';
  };

  brightness = pkgs.writeShellApplication {
    name = "brightness";
    runtimeInputs = with pkgs; [brightnessctl light dunst];
    text = ''
      ## Script To Manage Brightness For Axyl OS.

      # Icon directory
      icon_dir="/etc/nixos/hm-modules/icons/"

      # Graphics card
      CARD=$(basename "$(find /sys/class/backlight/* | head -n 1)")

      # Get brightness
      get_backlight() {
      	if [[ "$CARD" == *"intel_"* ]]; then
                      BNESS=$(light | sed 's/\.[0-9]*//')
      		LIGHT=''${BNESS%.*}
      	else
                      LIGHT=$(printf '%s' "$(light -G)" | awk 'BEGIN {FS="."}{print $1}')
      	fi
      	echo "''${LIGHT}%"
      }

      # Get icons
      get_icon() {
      	backlight="$(get_backlight)"
      	current="''${backlight%%%}"
      	if [[ ("$current" -ge "0") && ("$current" -le "20") ]]; then
      		icon=''${icon_dir}'display-brightness-off-symbolic.svg'
      	elif [[ ("$current" -ge "20") && ("$current" -le "40") ]]; then
      		icon=''${icon_dir}'display-brightness-low-symbolic.svg'
      	elif [[ ("$current" -ge "40") && ("$current" -le "60") ]]; then
      		icon=''${icon_dir}'display-brightness-medium-symbolic.svg'
      	elif [[ ("$current" -ge "60") && ("$current" -le "100") ]]; then
      		icon=''${icon_dir}'display-brightness-high-symbolic.svg'
      	fi
      }

      # Increase brightness
      inc_backlight() {
      	if [[ "$CARD" == *"intel_"* ]]; then
      		brightnessctl sset 5%+ && get_icon && dunstify -u low --replace=69 -i "$icon" "Brightness : $(get_backlight)"
      	else
      		light -A 5 && get_icon && dunstify -u low --replace=69 -i "$icon" "Brightness : $(get_backlight)"
      	fi
      }

      # Decrease brightness
      dec_backlight() {
      	if [[ "$CARD" == *"intel_"* ]]; then
      		brightnessctl sset 5%- && get_icon && dunstify -u low --replace=69 -i "$icon" "Brightness : $(get_backlight)"
      	else
      		light -U 5 && get_icon && dunstify -u low --replace=69 -i "$icon" "Brightness : $(get_backlight)"
      	fi
      }

      # Execute accordingly
      if [[ "$1" == "--get" ]]; then
      	get_backlight
      elif [[ "$1" == "--up" ]]; then
      	inc_backlight
      elif [[ "$1" == "--down" ]]; then
      	dec_backlight
      else
      	get_backlight
      fi
    '';
  };

  screenshot = pkgs.writeShellApplication {
    name = "screenshot";
    runtimeInputs = with pkgs; [rofi-wayland grim slurp];
    text = ''
      icon=/etc/nixos/hm-modules/icons/camera-photo-symbolic.svg

      op1=" Fullscreen"
      op2="󰆟 Selected Area"

      ops="''${op1}\n''${op2}"

      selected=$(echo -e "$ops" | rofi -dmenu -theme ~/.config/rofi/screenshot/style-1.rasi drun -display-drun -p "Screenshot")

      sleep 0.3

      if [[ $selected == "$op1" ]]; then
          grim - | wl-copy && dunstify "Screenshot Clipped" -i "$icon"
      elif [[ $selected == "$op2" ]]; then
          grim -g "$(slurp)" -| wl-copy && dunstify "Screenshot Clipped" -i "$icon"
      fi
    '';
  };

  library = pkgs.writeShellApplication {
    name = "library";
    runtimeInputs = with pkgs; [zathura rofi-wayland];
    text = ''
      book_directory="$HOME/Documents/Books/"
      selected=$(find "''${book_directory}" -mindepth 1 -printf '%P\n' -iname ".pdf" | rofi -dmenu -theme ~/.config/rofi/pdf-launcher/style-1.rasi drun -display-drun -p " ")

      [ -z "$selected" ] && exit

      zathura "''${book_directory}""''${selected}"
    '';
  };

  wallpaper-switch = pkgs.writeShellApplication {
    name = "wallpaper-switch";
    runtimeInputs = with pkgs; [swww];
    text = ''
      wallpapers="/etc/nixos/wallpapers/"

      list_wallpapers() {
          for file in "$1"/*
          do
              if [[ -f "$file" ]]; then
                  echo -en "$(basename "$file")\0icon\x1f$(realpath "$file")\n"
              fi
          done
      }

      selected_wallpaper="$(list_wallpapers "''${wallpapers}" |  rofi -dmenu -theme ~/.config/rofi/wallpaper-selection/style-1.rasi -p " ")"

      icon="''${wallpapers}""''${selected_wallpaper}"

      if [[ -f "$selected_wallpaper" ]]; then
          exit 0;
      fi

      swww img "''${wallpapers}""''${selected_wallpaper}" && dunstify -u low --replace=69 -i "''${icon}" "Wallpaper Changed: $selected_wallpaper"
    '';
  };

  power-menu = pkgs.writeShellApplication {
    name = "powermenu";
    runtimeInputs = with pkgs; [swaylock-effects rofi-wayland];
    text = ''
        # Current Theme
      dir="$HOME/.config/rofi/powermenu/"
      theme='style-1'

      # Options
      shutdown='⏻ Shutdown'
      reboot=' Reboot'
      lock='󰌾 Lock'
      suspend='󰤄 Suspend'
      logout='󰍃 Logout'
      yes=' Yes'
      no='  No'

      # Rofi CMD
      rofi_cmd() {
      	rofi -dmenu \
      		-p "Powermenu" \
      		-theme "''${dir}"/"''${theme}".rasi
      }

      # Confirmation CMD
      confirm_cmd() {
      	rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 250px;}' \
      		-theme-str 'mainbox {children: [ "message", "listview" ];}' \
      		-theme-str 'listview {columns: 2; lines: 1;}' \
      		-theme-str 'element-text {horizontal-align: 0.5;}' \
      		-theme-str 'textbox {horizontal-align: 0.5;}' \
      		-dmenu \
      		-p 'Confirmation' \
      		-mesg 'Are you Sure?' \
      		-theme "''${dir}"/"''${theme}".rasi
      }

      # Ask for confirmation
      confirm_exit() {
      	echo -e "$yes\n$no" | confirm_cmd
      }

      # Pass variables to rofi dmenu
      run_rofi() {
      	echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi_cmd
      }

      # Execute Command
      run_cmd() {
      	selected="$(confirm_exit)"
      	if [[ "$selected" == "$yes" ]]; then
      		if [[ $1 == '--shutdown' ]]; then
      			systemctl poweroff
      		elif [[ $1 == '--reboot' ]]; then
      			systemctl reboot
      		elif [[ $1 == '--suspend' ]]; then
      		  systemctl suspend && swaylock
      		elif [[ $1 == '--logout' ]]; then
      			if [[ "$DESKTOP_SESSION" == 'openbox' ]]; then
      				openbox --exit
      			elif [[ "$DESKTOP_SESSION" == 'bspwm' ]]; then
      				bspc quit
      			elif [[ "$DESKTOP_SESSION" == 'i3' ]]; then
      				i3-msg exit
      			elif [[ "$DESKTOP_SESSION" == 'plasma' ]]; then
      				qdbus org.kde.ksmserver /KSMServer logout 0 0 0
      			fi
      		fi
      	else
      		exit 0
      	fi
      }

      # Actions
      chosen="$(run_rofi)"
      case "''${chosen}" in
          "$shutdown")
      		run_cmd --shutdown
              ;;
          "$reboot")
      		run_cmd --reboot
              ;;
          "$lock")
      		if [[ -x '/usr/bin/betterlockscreen' ]]; then
      			betterlockscreen -l
      		elif [[ -x '/usr/bin/i3lock' ]]; then
      			i3lock
      		fi
              ;;
          "$suspend")
      		run_cmd --suspend
              ;;
          "$logout")
      		run_cmd --logout
              ;;
      esac
    '';
  };

  rofi-menu = pkgs.writeShellApplication {
    name = "rofi-menu";
    runtimeInputs = with pkgs; [rofi-wayland];
    text = ''
      dir="$HOME/.config/rofi/launchers/type-1"
       theme='style-1'

       rofi \
         -show drun \
         -theme "''${dir}"/"''${theme}".rasi
    '';
  };

  wifi-menu = pkgs.writeShellScriptBin "wifi-menu" ''
    bssid=$( ${pkgs.networkmanager}/bin/nmcli dev wifi list | sed -n '1!p' | cut -b 9- | ${pkgs.rofi-wayland}/bin/rofi -dmenu -theme ~/.config/rofi/wifi-menu/style-1.rasi -p " " | cut -d' ' -f1)

    [ -z "$bssid" ] && exit

    password=$(echo "" | ${pkgs.rofi-wayland}/bin/rofi -dmenu -theme ~/.config/rofi/wifi-menu/wifi-password.rasi -p " " )

    [ -z "$password" ] && exit

    icon=/etc/nixos/hm-modules/icons/wifi-icon.png
    iconE=/etc/nixos/hm-modules/icons/error-warning.png

    # Notify the status
    notify_connect() {
      status=$(echo $?)
      wifi_network=$( ${pkgs.networkmanager}/bin/nmcli -t -f active,ssid dev wifi | egrep '^yes' | cut -d\' -f2 | sed 's/^[^:]*://')

      if [[ "$status" == '0' ]]; then
        ${pkgs.dunst}/bin/dunstify -u low --replace=69 -i "$icon" "Connected to Network: $wifi_network"
      elif [[ "$status" -gt '0' ]]; then
        ${pkgs.dunst}/bin/dunstify -u low --replace=69 -i "$iconE" "Unable to Connect: Incorrect Passphrase"
      fi
    }

    # Connect to the Wifi & Display status
    ${pkgs.networkmanager}/bin/nmcli device wifi connect $bssid password $password ; notify_connect
  '';
}
