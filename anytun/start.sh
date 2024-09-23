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
  start_tun
else
  echo "module not turned on"
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
