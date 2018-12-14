#!/usr/bin/env zsh
# vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function oneTimeSetUp() {
  source ./test/performance/libperf.zsh
}

function setUp() {
  export TERM="xterm-256color"
  # Load Powerlevel9k
  source powerlevel9k.zsh-theme
  source segments/battery.p9k

  P9K_HOME=$(pwd)
  ### Test specific
  # Create default folder
  FOLDER=/tmp/powerlevel9k-test
  mkdir -p "${FOLDER}"
  cd $FOLDER

  # Prepare folder for pmset (OSX)
  PMSET_PATH=$FOLDER/usr/bin
  mkdir -p $PMSET_PATH
  # Prepare folder for ${BATTERY} (Linux)
  BATTERY_PATH=$FOLDER/sys/class/power_supply
  mkdir -p $BATTERY_PATH/BAT{0..2}
  # empty battery
  mkdir -p $BATTERY_PATH/BAT3
}

function tearDown() {
  # Go back to powerlevel9k folder
  cd "${P9K_HOME}"
  # Remove eventually created test-specific folder
  rm -fr "${FOLDER}" &>/dev/null
  # At least remove test folder completely
  rm -fr /tmp/powerlevel9k-test &>/dev/null
  unset PMSET_PATH
  unset BATTERY_PATH
  unset FOLDER
  unset P9K_HOME
}

# Mock Battery
# For mocking pmset on OSX this function takes one argument (the
# content that pmset should echo).
# For mocking the battery on Linux this function takes three
# arguments: $1 capacity in %; $2 the battery status; $3 charging speed in %.
function makeBatterySay() {
  if [[ -z "${FOLDER}" ]]; then
    echo "Fake root path is not correctly set!"
    exit 1
  fi
  # OSX
  echo "#!/bin/sh" > $PMSET_PATH/pmset
  echo "echo \"$1\"" >> $PMSET_PATH/pmset
  chmod +x $PMSET_PATH/pmset

  # Linux
  local battery_status="$2"
  echo "$battery_status" > $BATTERY_PATH/BAT0/status
  echo "$battery_status" > $BATTERY_PATH/BAT1/status
  echo "$battery_status" > $BATTERY_PATH/BAT2/status

  local capacity="$1"
  if [[ $capacity =~ ^[0-9]*$ ]]; then
    echo "10000000" > $BATTERY_PATH/BAT0/energy_full
    echo  "5000000" > $BATTERY_PATH/BAT1/charge_full
    echo  "2500000" > $BATTERY_PATH/BAT2/energy_full
    echo  "$((10000000*$capacity/100))" > $BATTERY_PATH/BAT0/energy_now
    echo  "$(( 5000000*$capacity/100))" > $BATTERY_PATH/BAT1/energy_now
    echo  "$(( 2500000*$capacity/100))" > $BATTERY_PATH/BAT2/charge_now
  fi

  # charge or discharge
  local charging_speed="${3:-100}"
  if [[ $battery_status == (Charging|Discharging) ]]; then
    echo  "$((5000000*$charging_speed/100))" > $BATTERY_PATH/BAT0/current_now
    echo  "$((2500000*$charging_speed/100))" > $BATTERY_PATH/BAT1/power_now
    echo                                 "0" > $BATTERY_PATH/BAT2/power_now
  else
    echo        "0" > $BATTERY_PATH/BAT0/current_now
    echo        "0" > $BATTERY_PATH/BAT1/power_now
    echo        "0" > $BATTERY_PATH/BAT2/power_now
  fi
}

function testBatterySegmentIfBatteryIsLowWhileDischargingOnOSX() {
  local __P9K_OS='OSX' # Fake OSX
  makeBatterySay "Now drawing from 'Battery Power'
 -InternalBattery-0 (id=1234567)	4%; discharging; 0:05 remaining present: true"

  assertEquals "%K{000} %F{001}🔋 %f%F{001}4%% (0:05) " "$(prompt_battery left 1 false ${FOLDER})"
  samplePerformanceSilent "Battery Low (OSX)" prompt_battery left 1 false "${FOLDER}"
}

function testBatterySegmentIfBatteryIsLowWhileChargingOnOSX() {
  local __P9K_OS='OSX' # Fake OSX
  makeBatterySay "Now drawing from 'Battery Power'
 -InternalBattery-0 (id=1234567)	4%; charging; 0:05 remaining present: true"

  assertEquals "%K{000} %F{003}🔋 %f%F{003}4%% (0:05) " "$(prompt_battery left 1 false ${FOLDER})"
}

function testBatterySegmentIfBatteryIsNormalWhileDischargingOnOSX() {
  local __P9K_OS='OSX' # Fake OSX
  makeBatterySay "Now drawing from 'Battery Power'
 -InternalBattery-0 (id=1234567)	98%; discharging; 3:57 remaining present: true"

  assertEquals "%K{000} %F{015}🔋 %f%F{015}98%% (3:57) " "$(prompt_battery left 1 false ${FOLDER})"
}

function testBatterySegmentIfBatteryIsNormalWhileChargingOnOSX() {
  local __P9K_OS='OSX' # Fake OSX
  makeBatterySay "Now drawing from 'Battery Power'
 -InternalBattery-0 (id=1234567)	98%; charging; 3:57 remaining present: true"

  assertEquals "%K{000} %F{003}🔋 %f%F{003}98%% (3:57) " "$(prompt_battery left 1 false ${FOLDER})"
}

function testBatterySegmentIfBatteryIsFullOnOSX() {
  local __P9K_OS='OSX' # Fake OSX
  makeBatterySay "Now drawing from 'AC Power'
 -InternalBattery-0 (id=1234567)	99%; charged; 0:00 remaining present: true"

  assertEquals "%K{000} %F{002}🔋 %f%F{002}99%% " "$(prompt_battery left 1 false ${FOLDER})"
  samplePerformanceSilent "Battery Full (OSX)" prompt_battery left 1 false "${FOLDER}"
}

function testBatterySegmentIfBatteryIsCalculatingOnOSX() {
  local __P9K_OS='OSX' # Fake OSX
  makeBatterySay "Now drawing from 'Battery Power'
 -InternalBattery-0 (id=1234567)	99%; discharging; (no estimate) present: true"

  assertEquals "%K{000} %F{015}🔋 %f%F{015}99%% (...) " "$(prompt_battery left 1 false ${FOLDER})"
}

function testBatterySegmentIfBatteryIsLowWhileDischargingOnLinux() {
  local __P9K_OS='Linux' # Fake Linux
  makeBatterySay "4" "Discharging"

  assertEquals "%K{000} %F{001}🔋 %f%F{001}4%% (0:05) " "$(prompt_battery left 1 false ${FOLDER})"
  samplePerformanceSilent "Battery Low (Linux)" prompt_battery left 1 false "${FOLDER}"
}

function testBatterySegmentIfBatteryIsLowWhileChargingOnLinux() {
  local __P9K_OS='Linux' # Fake Linux
  makeBatterySay "4" "Charging"

  assertEquals "%K{000} %F{003}🔋 %f%F{003}4%% (2:14) " "$(prompt_battery left 1 false ${FOLDER})"
}

function testBatterySegmentIfBatteryIsLowWhileUnknownOnLinux() {
  local __P9K_OS='Linux' # Fake Linux
  makeBatterySay "4" "Unknown"

  assertEquals "%K{000} %F{001}🔋 %f%F{001}4%% " "$(prompt_battery left 1 false ${FOLDER})"
}

function testBatterySegmentIfBatteryIsNormalWhileDischargingOnLinux() {
  local __P9K_OS='Linux' # Fake Linux
  makeBatterySay "98" "Discharging"

  assertEquals "%K{000} %F{015}🔋 %f%F{015}98%% (2:17) " "$(prompt_battery left 1 false ${FOLDER})"
}

function testBatterySegmentIfBatteryIsNormalWhileChargingOnLinux() {
  local __P9K_OS='Linux' # Fake Linux
  makeBatterySay "98" "Charging"

  assertEquals "%K{000} %F{003}🔋 %f%F{003}98%% (0:02) " "$(prompt_battery left 1 false ${FOLDER})"
}

function testBatterySegmentIfBatteryIsNormalWhileUnknownOnLinux() {
  local __P9K_OS='Linux' # Fake Linux
  makeBatterySay "98" "Unknown"

  assertEquals "%K{000} %F{015}🔋 %f%F{015}98%% " "$(prompt_battery left 1 false ${FOLDER})"
}

function testBatterySegmentIfBatteryIsFullOnLinux() {
  local __P9K_OS='Linux' # Fake Linux
  makeBatterySay "100" "Full"

  assertEquals "%K{000} %F{002}🔋 %f%F{002}100%% " "$(prompt_battery left 1 false ${FOLDER})"
  samplePerformanceSilent "Battery Full (Linux)" prompt_battery left 1 false "${FOLDER}"
}

function testBatterySegmentIfBatteryNearlyFullButNotChargingOnLinux() {
  local __P9K_OS='Linux' # Fake Linux
  makeBatterySay "98" "Unknown" "0"

  assertEquals "%K{000} %F{015}🔋 %f%F{015}98%% " "$(prompt_battery left 1 false ${FOLDER})"
  samplePerformanceSilent "Battery Normal ACPI (Linux)" prompt_battery left 1 false "${FOLDER}"
}

function testBatterySegmentIfBatteryIsCalculatingOnLinux() {
  local __P9K_OS='Linux' # Fake Linux
  makeBatterySay "99" "Charging" "0"

  assertEquals "%K{000} %F{003}🔋 %f%F{003}99%% (...) " "$(prompt_battery left 1 false ${FOLDER})"
  samplePerformanceSilent "Battery Calculating ACPI (Linux)" prompt_battery left 1 false "${FOLDER}"
}

source shunit2/shunit2
