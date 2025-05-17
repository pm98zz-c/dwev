#!/bin/sh

###
# This script installs the Dwev keyboard layout on a Linux system.
###

cd "$(dirname "$0")" || exit 1
OWN_DIR=$(/bin/pwd)

# Check if the script is run as root.
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
    # Copy whole xkb folder to the user's config directory.
    cp -r "$OWN_DIR/xkb" "$XDG_CONFIG_HOME/" || {
        echo "Failed to copy xkb folder to $XDG_CONFIG_HOME."
        exit 1
    }
    echo "Dwev keyboard layout installed for user $USER at $XDG_CONFIG_HOME/xkb."
    echo "You need to log out of your session and log back in for the keyboard to be available."
fi