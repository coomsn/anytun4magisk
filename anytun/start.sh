#!/system/bin/sh
clear
scripts=$(realpath $0)
scripts_dir=$(dirname ${scripts})
parent_dir=$(dirname ${scripts_dir})
module_dir="/data/adb/modules/anytun-module"

# environment variables
export PATH="/data/adb/magisk:/data/adb/ksu/bin:$PATH:/system/bin"

source ${scripts_dir}/anytun.service

if [ ! -f "${module_dir}/disable" ]; then
  forward "-D" 2> /dev/null
  start_tun
  grep -qE "tun[0-9]$" "${rt_tables}" || log Warn "vpn not enabled"
else
  stop_tun 2> /dev/null
  log Warn "module not enabled"
fi

create_anytun_inotify() {
  PIDs=($(busybox pidof inotifyd))
  for PID in "${PIDs[@]}"; do
    if grep -q "anytun.inotify" "/proc/$PID/cmdline"; then
      kill -9 "$PID"
    fi
  done
  inotifyd "${scripts_dir}/anytun.inotify" "${module_dir}" >/dev/null 2>&1 &
}

create_anytun_inotify
