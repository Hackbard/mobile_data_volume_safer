#!/bin/bash
set -e

update_database() {
    SQUID_DB="/usr/local/squidGuard/db"
    mkdir -p $SQUID_DB

    cd /tmp
    echo "Load new Blacklists"
    wget -q -c http://www.shallalist.de/Downloads/shallalist.tar.gz
    tar -zxf shallalist.tar.gz
    cp -ar /tmp/BL/* $SQUID_DB

    for DIR in $SQUID_DB/*/
    do
        echo "Learn from" ${DIR}
        squidGuard -vbC ${DIR}domains
        squidGuard -vbC ${DIR}urls
    done
    rm -R /tmp/BL
    chown proxy:proxy -R $SQUID_DB/
}

create_log_dir() {
  mkdir -p ${SQUID_LOG_DIR}
  chmod -R 755 ${SQUID_LOG_DIR}
  chown -R ${SQUID_USER}:${SQUID_USER} ${SQUID_LOG_DIR}
}

create_cache_dir() {
  mkdir -p ${SQUID_CACHE_DIR}
  chown -R ${SQUID_USER}:${SQUID_USER} ${SQUID_CACHE_DIR}
}

apply_backward_compatibility_fixes() {
  if [[ -f /etc/squid3/squid.user.conf ]]; then
    rm -rf /etc/squid3/squid.conf
    ln -sf /etc/squid3/squid.user.conf /etc/squid3/squid.conf
  fi
}

create_log_dir
create_cache_dir
update_database
apply_backward_compatibility_fixes

# allow arguments to be passed to squid3
if [[ ${1:0:1} = '-' ]]; then
  EXTRA_ARGS="$@"
  set --
elif [[ ${1} == squid3 || ${1} == $(which squid3) ]]; then
  EXTRA_ARGS="${@:2}"
  set --
fi

# default behaviour is to launch squid
if [[ -z ${1} ]]; then
  if [[ ! -d ${SQUID_CACHE_DIR}/00 ]]; then
    echo "Initializing cache..."
    $(which squid3) -N -f /etc/squid3/squid.conf -z
  fi
  echo "Starting squid3..."
  exec $(which squid3) -f /etc/squid3/squid.conf -NYCd 1 ${EXTRA_ARGS}
else
  exec "$@"
fi
