#!/bin/sh

###
# This script installs the Dwev keyboard layout on a Linux system.
###

cd "$(dirname "$0")" || exit 1
OWN_DIR=$(/bin/pwd)

# User installation.
if [ "$(id -u)" -ne 0 ]; then
    if [ -z "$XDG_CONFIG_HOME" ]; then
        XDG_CONFIG_HOME="$HOME/.config"
    fi
    echo "Installing the Dwev keboard layout for user $USER."
    echo "To install globally, you need to run this script as root."
    echo ""
    echo "Do you want to install the Dwev keyboard layout for user $USER at $XDG_CONFIG_HOME? (y/n)"
    read -r answer
    if [ "$answer" != "y" ] && [ "$answer" != "yes" ]; then
        echo "Cancelling."
        exit 0
    fi

    # Check if the xkb folder exists in the user's config directory.
    if [ -d "$XDG_CONFIG_HOME/xkb" ]; then
        echo "An xkb folder already exists in $XDG_CONFIG_HOME."
        echo "If it only contains the Dwev keyboard layout, you can safely overwrite it."
        echo "If you have other keyboard layouts, you need to manually amend the evdev.lst and evdev.xml files."
        echo "Do you want to overwrite it? (y/n)"
        read -r force
        if [ "$force" != "y" ] && [ "$force" != "yes" ]; then
            echo "Cancelling."
            exit 0
        fi
    fi

    # Copy whole xkb folder to the user's config directory.
    cp -r "$OWN_DIR/xkb" "$XDG_CONFIG_HOME/" || {
        echo "Failed to copy xkb folder to $XDG_CONFIG_HOME."
        exit 1
    }
    echo "Dwev keyboard layout installed for user $USER at $XDG_CONFIG_HOME/xkb."
    echo "You need to log out of your session and log back in for the keyboard to be available."
    exit 0
fi

# Root installation.
echo "Installing the Dwev keboard layout globally for all users."
echo "How do you want to install it?"
echo "See https://dwev.xyz/#linux for more information."
echo ""
echo "1) Install as 'Dwev' keyboard layout under /etc/xkb"
echo "2) Install as the 'Custom' keyboard layout under /usr/share/X11/xkb"
read -r answer
    if [ "$answer" != "1" ] && [ "$answer" != "2" ]; then
        echo "Cancelling."
        exit 0
    fi
if [ "$answer" = "1" ]; then
    echo "Installing the Dwev keyboard layout as 'Dwev' under /etc/xkb."
    # Check if the xkb folder exists in /etc/X11.
    if [ -d "/etc/xkb" ]; then
        echo "An xkb folder already exists in /etc/."
        echo "If it only contains the Dwev keyboard layout, you can safely overwrite it."
        echo "If you have other keyboard layouts, you need to manually amend the evdev.lst and evdev.xml files."
        echo "Do you want to overwrite it? (y/n)"
        read -r force
        if [ "$force" != "y" ] && [ "$force" != "yes" ]; then
            echo "Cancelling."
            exit 0
        fi
    fi
    # Copy whole xkb folder to /etc/.
    cp -r "$OWN_DIR/xkb" "/etc/" || {
        echo "Failed to copy xkb folder to /etc/."
        exit 1
    }
    echo "Dwev keyboard layout installed globally at /etc/xkb."
    echo "You need reboot for the keyboard to be available."
    exit 0
fi
if [ "$answer" = "2" ]; then
    echo "Installing as the 'custom' keyboard layout under /usr/share/X11/xkb."
    # Check if the custom file exists.
    if [ -f "/usr/share/X11/xkb/symbols/custom" ]; then
        echo "An custom layout already exists at /usr/share/X11/xkb/symbols/custom."
        echo "Only a single 'custom' layout can be defined."
        echo "Do you want to overwrite it? (y/n)"
        read -r force
        if [ "$force" != "y" ] && [ "$force" != "yes" ]; then
            echo "Cancelling."
            exit 0
        fi
    fi
    echo "Only a single 'custom' layout can be defined."
    echo "Which layout do you want to use?"
    echo "1) Dwev (default)"
    echo "2) Dwev (numeric)"
    read -r version
    if [ "$version" != "1" ] && [ "$version" != "2" ]; then
        echo "Cancelling."
        exit 0
    fi
    FILENAME="dwev"
    if [ "$version" = "2" ]; then
        FILENAME="dwev-num"
    fi
    cp "$OWN_DIR/xkb/symbols/$FILENAME" "/usr/share/X11/xkb/symbols/custom" || {
        echo "Failed to copy xkb folder to /usr/share/X11/xkb/symbols/custom."
        exit 1
    }
    echo "Dwev keyboard layout defined as the custom layout."
    echo "You need to reboot for the keyboard to be available."
    exit 0
fi