#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"
  # Load Powerlevel9k
  source powerlevel9k.zsh-theme

  # Initialize icon overrides
  _powerlevel9kInitializeIconOverrides

  # Precompile the Segment Separators here!
  _POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR="$(print_icon 'LEFT_SEGMENT_SEPARATOR')"
  _POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR="$(print_icon 'LEFT_SUBSEGMENT_SEPARATOR')"
  _POWERLEVEL9K_LEFT_SEGMENT_END_SEPARATOR="$(print_icon 'LEFT_SEGMENT_END_SEPARATOR')"
  _POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR="$(print_icon 'RIGHT_SEGMENT_SEPARATOR')"
  _POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR="$(print_icon 'RIGHT_SUBSEGMENT_SEPARATOR')"

  # Disable TRAP, so that we have more control how the segment is build,
  # as shUnit does not work with async commands.
  trap WINCH

  P9K_HOME=$(pwd)
  ### Test specific
  # Create default folder
  FOLDER=/tmp/powerlevel9k-test
  mkdir -p "${FOLDER}"
  cd $FOLDER

  # Prepare folder for pmset (OSX)
  PMSET_PATH=$FOLDER/usr/bin
  mkdir -p $PMSET_PATH
  # Prepare folder for $BATTERY (Linux)
  BATTERY_PATH=$FOLDER/sys/class/power_supply
  mkdir -p $BATTERY_PATH
  mkdir -p $BATTERY_PATH/BAT0
  mkdir -p $BATTERY_PATH/BAT1
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
  p9k_clear_cache
}

# Mock Battery
# For mocking pmset on OSX this function takes one argument (the
# content that pmset should echo).
# For mocking the battery on Linux this function takes two
# arguments: $1 is the capacity; $2 the battery status.
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
  local capacity="$1"
  echo "$capacity" > $BATTERY_PATH/BAT0/capacity
  echo "$capacity" > $BATTERY_PATH/BAT1/capacity
  local battery_status="$2"
  echo "$battery_status" > $BATTERY_PATH/BAT0/status
  echo "$battery_status" > $BATTERY_PATH/BAT1/status
}

function testBatterySegmentIfBatteryIsLowWhileDischargingOnOSX() {
  OS='OSX'
  makeBatterySay "Now drawing from 'Battery Power'
 -InternalBattery-0 (id=1234567)	4%; discharging; 0:05 remaining present: true"

  prompt_battery "left" "1" "false" "${FOLDER}"
  p9k_build_prompt_from_cache 0

  assertEquals "%K{black} %F{red%}🔋%f %F{red}4%% (0:05) %k%F{black}%f " "${PROMPT}"
}

function testBatterySegmentIfBatteryIsLowWhileChargingOnOSX() {
  OS='OSX'
  makeBatterySay "Now drawing from 'Battery Power'
 -InternalBattery-0 (id=1234567)	4%; charging; 0:05 remaining present: true"

  prompt_battery "left" "1" "false" "${FOLDER}"
  p9k_build_prompt_from_cache 0

  assertEquals "%K{black} %F{yellow%}🔋%f %F{yellow}4%% (0:05) %k%F{black}%f " "${PROMPT}"
}

function testBatterySegmentIfBatteryIsAlmostFullWhileDischargingOnOSX() {
  OS='OSX'
  makeBatterySay "Now drawing from 'Battery Power'
 -InternalBattery-0 (id=1234567)	98%; discharging; 3:57 remaining present: true"

  prompt_battery "left" "1" "false" "${FOLDER}"
  p9k_build_prompt_from_cache 0

  assertEquals "%K{black} %F{white%}🔋%f %F{white}98%% (3:57) %k%F{black}%f " "${PROMPT}"
}

function testBatterySegmentIfBatteryIsAlmostFullWhileChargingOnOSX() {
  OS='OSX'
  makeBatterySay "Now drawing from 'Battery Power'
 -InternalBattery-0 (id=1234567)	98%; charging; 3:57 remaining present: true"

  prompt_battery "left" "1" "false" "${FOLDER}"
  p9k_build_prompt_from_cache 0

  assertEquals "%K{black} %F{yellow%}🔋%f %F{yellow}98%% (3:57) %k%F{black}%f " "${PROMPT}"
}

function testBatterySegmentIfBatteryIsFullOnOSX() {
  OS='OSX'
  makeBatterySay "Now drawing from 'AC Power'
 -InternalBattery-0 (id=1234567)	99%; charged; 0:00 remaining present: true"

  prompt_battery "left" "1" "false" "${FOLDER}"
  p9k_build_prompt_from_cache 0

  assertEquals "%K{black} %F{green%}🔋%f %F{green}99%% %k%F{black}%f " "${PROMPT}"
}

function testBatterySegmentIfBatteryIsCalculatingOnOSX() {
  OS='OSX'
  makeBatterySay "Now drawing from 'Battery Power'
 -InternalBattery-0 (id=1234567)	99%; discharging; (no estimate) present: true"

  prompt_battery "left" "1" "false" "${FOLDER}"
  p9k_build_prompt_from_cache 0

  assertEquals "%K{black} %F{white%}🔋%f %F{white}99%% (...) %k%F{black}%f " "${PROMPT}"
}

function testBatterySegmentIfBatteryIsLowWhileDischargingOnLinux() {
  OS='Linux'
  makeBatterySay "4" "Discharging"

  prompt_battery "left" "1" "false" "${FOLDER}"
  p9k_build_prompt_from_cache 0

  assertEquals "%K{black} %F{red%}🔋%f %F{red}4%% %k%F{black}%f " "${PROMPT}"
}

function testBatterySegmentIfBatteryIsLowWhileChargingOnLinux() {
  OS='Linux'
  makeBatterySay "4" "Charging"

  prompt_battery "left" "1" "false" "${FOLDER}"
  p9k_build_prompt_from_cache 0

  assertEquals "%K{black} %F{yellow%}🔋%f %F{yellow}4%% %k%F{black}%f " "${PROMPT}"
}

function testBatterySegmentIfBatteryIsNormalWhileDischargingOnLinux() {
  OS='Linux'
  makeBatterySay "10" "Discharging"

  prompt_battery "left" "1" "false" "${FOLDER}"
  p9k_build_prompt_from_cache 0

  assertEquals "%K{black} %F{white%}🔋%f %F{white}10%% %k%F{black}%f " "${PROMPT}"
}

function testBatterySegmentIfBatteryIsNormalWhileChargingOnLinux() {
  OS='Linux'
  makeBatterySay "10" "Charging"

  prompt_battery "left" "1" "false" "${FOLDER}"
  p9k_build_prompt_from_cache 0

  assertEquals "%K{black} %F{yellow%}🔋%f %F{yellow}10%% %k%F{black}%f " "${PROMPT}"
}

function testBatterySegmentIfBatteryIsFullOnLinux() {
  OS='Linux'
  makeBatterySay "100" "Full"

  prompt_battery "left" "1" "false" "${FOLDER}"
  p9k_build_prompt_from_cache 0

  assertEquals "%K{black} %F{green%}🔋%f %F{green}100%% %k%F{black}%f " "${PROMPT}"
}

function testBatterySegmentIfBatteryIsNormalWithAcpiEnabledOnLinux() {
  OS='Linux'
  makeBatterySay "50" "Discharging"
  alias acpi="echo 'Batter 0: Discharging, 50%, 01:38:54 remaining'"
  touch $FOLDER/usr/bin/acpi
  # For running on Mac, we need to mock date :(
  [[ -f /usr/local/bin/gdate ]] && alias date=gdate

  prompt_battery "left" "1" "false" "${FOLDER}"
  p9k_build_prompt_from_cache 0

  assertEquals "%K{black} %F{white%}🔋%f %F{white}50%% (1:38) %k%F{black}%f " "${PROMPT}"

  unalias acpi
  unalias date &>/dev/null
}

function testBatterySegmentIfBatteryIsCalculatingWithAcpiEnabledOnLinux() {
  OS='Linux'
  makeBatterySay "50" "Discharging"
  # Todo: Include real acpi output!
  alias acpi="echo 'Batter 0: Discharging, 50%, rate remaining'"
  touch $FOLDER/usr/bin/acpi

  prompt_battery "left" "1" "false" "${FOLDER}"
  p9k_build_prompt_from_cache 0

  assertEquals "%K{black} %F{white%}🔋%f %F{white}50%% (...) %k%F{black}%f " "${PROMPT}"

  unalias acpi
}

source shunit2/source/2.1/src/shunit2
