#!/bin/bash

USAGE="
Usage: install.sh [--no-iptables | --iptables | -i] [--no-config | --config | -c] [--no-hosts | --hosts] [--help | -h]

  --no-config         Set no config
  --config            Set config        (default)
  -c

  --no-iptables       Set no iptables   (default)
  --iptables          Set iptables
  -i

  --no-hosts          Set no hosts      (default)
  --hosts             Set hosts

  --help              Display this message
  -h
";

CONFIG=1;
IPTABLES=0;
HOSTS=0;

for var in $@; do
  case $var in
    "--no-iptables")
      IPTABLES=0;
      ;;
    "--iptables" | "-i")
      IPTABLES=1;
      ;;

    "--no-config")
      CONFIG=0;
      ;;
    "--config" | "-c")
      CONFIG=1;
      ;;

    "--no-hosts")
      HOSTS=0;
      ;;
    "--hosts")
      HOSTS=1;
      ;;

    "--help" | "-h")
      echo -e "$USAGE";
      exit;
      ;;
  esac
done

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ $CONFIG == 1 ]; then
  if [ -z $XDK_CONFIG_HOME ]; then
      XDK_CONFIG_HOME=$HOME/.config
  fi

  cp -R $DIR/.config/* $XDK_CONFIG_HOME
  cp $DIR/.vimrc ~/
fi

if [ $IPTABLES == 1 ]; then
  mkdir /etc/iptables
  cp $DIR/iptables /etc/iptables/rules.v4
fi

if [ $HOSTS == 1 ]; then
  cp $DIR/hosts/hosts /etc/hosts
fi
