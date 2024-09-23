#!/system/bin/sh
clear
scripts=$(realpath $0)
scripts_dir=$(dirname ${scripts})
parent_dir=$(dirname ${scripts_dir})
module_dir="/data/adb/modules/anytun-module"

# environment variables
export PATH="/data/adb/magisk:/data/adb/ksu/bin:$PATH:/system/bin"

source ${scripts_dir}/anytun.service

if [ ! -f "${module_dir}/disable" ] && ip link | grep -Eq 'tun[0-9]'; then
  log Info "The process is starting, please wait" > "${scripts_dir}/run.log"
  echo "The process is starting, please wait"
  stop_tun
  start_tun
else
  log Warn "Open the VPN and restart the module" > "${scripts_dir}/run.log"
  echo "Open the VPN and restart the module"
fi

start_anytun.inotify() {
  PIDs=($(busybox pidof inotifyd))
  for PID in "${PIDs[@]}"; do
    if grep -q "anytun.inotify" "/proc/$PID/cmdline"; then
      kill -9 "$PID"
    fi
  done
  inotifyd "${scripts_dir}/anytun.inotify" "${module_dir}" >/dev/null 2>&1 &
}

start_anytun.inotify
