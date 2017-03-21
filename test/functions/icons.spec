#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  source functions/utilities.zsh
  source functions/icons.zsh
}

# Go through all icons defined in default mode, and
# check if all of them are defined in the other modes.
function testAllIconsAreDefinedLikeInDefaultMode() {
  # Always compare against this mode
  local _P9K_TEST_MODE="default"
  POWERLEVEL9K_MODE="${_P9K_TEST_MODE}"
  local icon_array_name=$(_p9k_get_current_icon_array_name)
  typeset -Ah icon_array
  icon_array=${(@Pkv)icon_array_name}
  # _ICONS_UNDER_TEST is an array of just the keys of $icons.
  # We later check via (r) "subscript" flag that our key
  # is in the values of our flat array.
  typeset -ah _ICONS_UNDER_TEST
  _ICONS_UNDER_TEST=(${(k)icon_array[@]})

  # Switch to "awesome-patched" mode
  POWERLEVEL9K_MODE="awesome-patched"
  local icon_array_name=$(_p9k_get_current_icon_array_name)
  typeset -Ah icon_array
  icon_array=${(@Pkv)icon_array_name}
  typeset -ah current_icons
  current_icons=(${(k)icon_array[@]})
  for key in ${_ICONS_UNDER_TEST}; do
    # Iterate over all keys found in the _ICONS_UNDER_TEST
    # array and compare it with the icons array of the
    # current POWERLEVEL9K_MODE.
    # Use parameter expansion, to directly check if the
    # key exists in the flat current array of keys. That
    # is quite complicated, but there seems no easy way
    # to check the mere existance of a key in an array.
    # The usual way would always return the value, so that
    # would do the wrong thing as we have some (on purpose)
    # empty values.
    assertTrue "The key ${key} does exist in ${_P9K_TEST_MODE} mode, but not in ${POWERLEVEL9K_MODE}!" "(( ${+current_icons[(r)$key]} ))"
  done

  # Switch to "awesome-fontconfig" mode
  POWERLEVEL9K_MODE="awesome-fontconfig"
  local icon_array_name=$(_p9k_get_current_icon_array_name)
  typeset -Ah icon_array
  icon_array=${(@Pkv)icon_array_name}
  typeset -ah current_icons
  current_icons=(${(k)icon_array[@]})
  for key in ${_ICONS_UNDER_TEST}; do
    assertTrue "The key ${key} does exist in ${_P9K_TEST_MODE} mode, but not in ${POWERLEVEL9K_MODE}!" "(( ${+current_icons[(r)$key]} ))"
  done

  # Switch to "nerdfont-fontconfig" mode
  POWERLEVEL9K_MODE="nerdfont-fontconfig"
  local icon_array_name=$(_p9k_get_current_icon_array_name)
  typeset -Ah icon_array
  icon_array=${(@Pkv)icon_array_name}
  typeset -ah current_icons
  current_icons=(${(k)icon_array[@]})
  for key in ${_ICONS_UNDER_TEST}; do
    assertTrue "The key ${key} does exist in ${_P9K_TEST_MODE} mode, but not in ${POWERLEVEL9K_MODE}!" "(( ${+current_icons[(r)$key]} ))"
  done

  # Switch to "flat" mode
  POWERLEVEL9K_MODE="flat"
  local icon_array_name=$(_p9k_get_current_icon_array_name)
  typeset -Ah icon_array
  icon_array=${(@Pkv)icon_array_name}
  typeset -ah current_icons
  current_icons=(${(k)icon_array[@]})
  for key in ${_ICONS_UNDER_TEST}; do
    assertTrue "The key ${key} does exist in ${_P9K_TEST_MODE} mode, but not in ${POWERLEVEL9K_MODE}!" "(( ${+current_icons[(r)$key]} ))"
  done

  # Switch to "compatible" mode
  POWERLEVEL9K_MODE="compatible"
  local icon_array_name=$(_p9k_get_current_icon_array_name)
  typeset -Ah icon_array
  icon_array=${(@Pkv)icon_array_name}
  typeset -ah current_icons
  current_icons=(${(k)icon_array[@]})
  for key in ${_ICONS_UNDER_TEST}; do
    assertTrue "The key ${key} does exist in ${_P9K_TEST_MODE} mode, but not in ${POWERLEVEL9K_MODE}!" "(( ${+current_icons[(r)$key]} ))"
  done

  unset current_icons
  unset _ICONS_UNDER_TEST
}

# Go through all icons defined in awesome-patched mode, and
# check if all of them are defined in the other modes.
function testAllIconsAreDefinedLikeInAwesomePatchedMode() {
  # Always compare against this mode
  local _P9K_TEST_MODE="awesome-patched"
  POWERLEVEL9K_MODE="$_P9K_TEST_MODE"
  local icon_array_name=$(_p9k_get_current_icon_array_name)
  typeset -Ah icon_array
  icon_array=${(@Pkv)icon_array_name}
  # _ICONS_UNDER_TEST is an array of just the keys of $icons.
  # We later check via (r) "subscript" flag that our key
  # is in the values of our flat array.
  typeset -ah _ICONS_UNDER_TEST
  _ICONS_UNDER_TEST=(${(k)icon_array[@]})

  # Switch to "default" mode
  POWERLEVEL9K_MODE="default"
  local icon_array_name=$(_p9k_get_current_icon_array_name)
  typeset -Ah icon_array
  icon_array=${(@Pkv)icon_array_name}
  typeset -ah current_icons
  current_icons=(${(k)icon_array[@]})
  for key in ${_ICONS_UNDER_TEST}; do
    # Iterate over all keys found in the _ICONS_UNDER_TEST
    # array and compare it with the icons array of the
    # current POWERLEVEL9K_MODE.
    # Use parameter expansion, to directly check if the
    # key exists in the flat current array of keys. That
    # is quite complicated, but there seems no easy way
    # to check the mere existance of a key in an array.
    # The usual way would always return the value, so that
    # would do the wrong thing as we have some (on purpose)
    # empty values.
    assertTrue "The key ${key} does exist in ${_P9K_TEST_MODE} mode, but not in ${POWERLEVEL9K_MODE}!" "(( ${+current_icons[(r)$key]} ))"
  done

  # Switch to "awesome-fontconfig" mode
  POWERLEVEL9K_MODE="awesome-fontconfig"
  local icon_array_name=$(_p9k_get_current_icon_array_name)
  typeset -Ah icon_array
  icon_array=${(@Pkv)icon_array_name}
  typeset -ah current_icons
  current_icons=(${(k)icon_array[@]})
  for key in ${_ICONS_UNDER_TEST}; do
    assertTrue "The key ${key} does exist in ${_P9K_TEST_MODE} mode, but not in ${POWERLEVEL9K_MODE}!" "(( ${+current_icons[(r)$key]} ))"
  done

  # Switch to "nerdfont-fontconfig" mode
  POWERLEVEL9K_MODE="nerdfont-fontconfig"
  local icon_array_name=$(_p9k_get_current_icon_array_name)
  typeset -Ah icon_array
  icon_array=${(@Pkv)icon_array_name}
  typeset -ah current_icons
  current_icons=(${(k)icon_array[@]})
  for key in ${_ICONS_UNDER_TEST}; do
    assertTrue "The key ${key} does exist in ${_P9K_TEST_MODE} mode, but not in ${POWERLEVEL9K_MODE}!" "(( ${+current_icons[(r)$key]} ))"
  done

  # Switch to "flat" mode
  POWERLEVEL9K_MODE="flat"
  local icon_array_name=$(_p9k_get_current_icon_array_name)
  typeset -Ah icon_array
  icon_array=${(@Pkv)icon_array_name}
  typeset -ah current_icons
  current_icons=(${(k)icon_array[@]})
  for key in ${_ICONS_UNDER_TEST}; do
    assertTrue "The key ${key} does exist in ${_P9K_TEST_MODE} mode, but not in ${POWERLEVEL9K_MODE}!" "(( ${+current_icons[(r)$key]} ))"
  done

  # Switch to "compatible" mode
  POWERLEVEL9K_MODE="compatible"
  local icon_array_name=$(_p9k_get_current_icon_array_name)
  typeset -Ah icon_array
  icon_array=${(@Pkv)icon_array_name}
  typeset -ah current_icons
  current_icons=(${(k)icon_array[@]})
  for key in ${_ICONS_UNDER_TEST}; do
    assertTrue "The key ${key} does exist in ${_P9K_TEST_MODE} mode, but not in ${POWERLEVEL9K_MODE}!" "(( ${+current_icons[(r)$key]} ))"
  done

  unset current_icons
  unset _ICONS_UNDER_TEST
}

# Go through all icons defined in awesome-fontconfig mode, and
# check if all of them are defined in the other modes.
function testAllIconsAreDefinedLikeInAwesomeFontconfigMode() {
  # Always compare against this mode
  local _P9K_TEST_MODE="awesome-fontconfig"
  POWERLEVEL9K_MODE="$_P9K_TEST_MODE"
  local icon_array_name=$(_p9k_get_current_icon_array_name)
  typeset -Ah icon_array
  icon_array=${(@Pkv)icon_array_name}
  # _ICONS_UNDER_TEST is an array of just the keys of $icons.
  # We later check via (r) "subscript" flag that our key
  # is in the values of our flat array.
  typeset -ah _ICONS_UNDER_TEST
  _ICONS_UNDER_TEST=(${(k)icon_array[@]})

  # Switch to "default" mode
  POWERLEVEL9K_MODE="default"
  local icon_array_name=$(_p9k_get_current_icon_array_name)
  typeset -Ah icon_array
  icon_array=${(@Pkv)icon_array_name}
  typeset -ah current_icons
  current_icons=(${(k)icon_array[@]})
  for key in ${_ICONS_UNDER_TEST}; do
    # Iterate over all keys found in the _ICONS_UNDER_TEST
    # array and compare it with the icons array of the
    # current POWERLEVEL9K_MODE.
    # Use parameter expansion, to directly check if the
    # key exists in the flat current array of keys. That
    # is quite complicated, but there seems no easy way
    # to check the mere existance of a key in an array.
    # The usual way would always return the value, so that
    # would do the wrong thing as we have some (on purpose)
    # empty values.
    assertTrue "The key ${key} does exist in ${_P9K_TEST_MODE} mode, but not in ${POWERLEVEL9K_MODE}!" "(( ${+current_icons[(r)$key]} ))"
  done

  # Switch to "awesome-patched" mode
  POWERLEVEL9K_MODE="awesome-patched"
  local icon_array_name=$(_p9k_get_current_icon_array_name)
  typeset -Ah icon_array
  icon_array=${(@Pkv)icon_array_name}
  typeset -ah current_icons
  current_icons=(${(k)icon_array[@]})
  for key in ${_ICONS_UNDER_TEST}; do
    assertTrue "The key ${key} does exist in ${_P9K_TEST_MODE} mode, but not in ${POWERLEVEL9K_MODE}!" "(( ${+current_icons[(r)$key]} ))"
  done

  # Switch to "nerdfont-fontconfig" mode
  POWERLEVEL9K_MODE="nerdfont-fontconfig"
  local icon_array_name=$(_p9k_get_current_icon_array_name)
  typeset -Ah icon_array
  icon_array=${(@Pkv)icon_array_name}
  typeset -ah current_icons
  current_icons=(${(k)icon_array[@]})
  for key in ${_ICONS_UNDER_TEST}; do
    assertTrue "The key ${key} does exist in ${_P9K_TEST_MODE} mode, but not in ${POWERLEVEL9K_MODE}!" "(( ${+current_icons[(r)$key]} ))"
  done

  # Switch to "flat" mode
  POWERLEVEL9K_MODE="flat"
  local icon_array_name=$(_p9k_get_current_icon_array_name)
  typeset -Ah icon_array
  icon_array=${(@Pkv)icon_array_name}
  typeset -ah current_icons
  current_icons=(${(k)icon_array[@]})
  for key in ${_ICONS_UNDER_TEST}; do
    assertTrue "The key ${key} does exist in ${_P9K_TEST_MODE} mode, but not in ${POWERLEVEL9K_MODE}!" "(( ${+current_icons[(r)$key]} ))"
  done

  # Switch to "compatible" mode
  POWERLEVEL9K_MODE="compatible"
  local icon_array_name=$(_p9k_get_current_icon_array_name)
  typeset -Ah icon_array
  icon_array=${(@Pkv)icon_array_name}
  typeset -ah current_icons
  current_icons=(${(k)icon_array[@]})
  for key in ${_ICONS_UNDER_TEST}; do
    assertTrue "The key ${key} does exist in ${_P9K_TEST_MODE} mode, but not in ${POWERLEVEL9K_MODE}!" "(( ${+current_icons[(r)$key]} ))"
  done

  unset current_icons
  unset _ICONS_UNDER_TEST
}

# Go through all icons defined in nerdfont-fontconfig mode, and
# check if all of them are defined in the other modes.
function testAllIconsAreDefinedLikeInNerdfontFontconfigMode() {
  # Always compare against this mode
  local _P9K_TEST_MODE="nerdfont-fontconfig"
  POWERLEVEL9K_MODE="$_P9K_TEST_MODE"
  local icon_array_name=$(_p9k_get_current_icon_array_name)
  typeset -Ah icon_array
  icon_array=${(@Pkv)icon_array_name}
  # _ICONS_UNDER_TEST is an array of just the keys of $icons.
  # We later check via (r) "subscript" flag that our key
  # is in the values of our flat array.
  typeset -ah _ICONS_UNDER_TEST
  _ICONS_UNDER_TEST=(${(k)icon_array[@]})

  # Switch to "default" mode
  POWERLEVEL9K_MODE="default"
  local icon_array_name=$(_p9k_get_current_icon_array_name)
  typeset -Ah icon_array
  icon_array=${(@Pkv)icon_array_name}
  typeset -ah current_icons
  current_icons=(${(k)icon_array[@]})
  for key in ${_ICONS_UNDER_TEST}; do
    # Iterate over all keys found in the _ICONS_UNDER_TEST
    # array and compare it with the icons array of the
    # current POWERLEVEL9K_MODE.
    # Use parameter expansion, to directly check if the
    # key exists in the flat current array of keys. That
    # is quite complicated, but there seems no easy way
    # to check the mere existance of a key in an array.
    # The usual way would always return the value, so that
    # would do the wrong thing as we have some (on purpose)
    # empty values.
    assertTrue "The key ${key} does exist in ${_P9K_TEST_MODE} mode, but not in ${POWERLEVEL9K_MODE}!" "(( ${+current_icons[(r)$key]} ))"
  done

  # Switch to "awesome-patched" mode
  POWERLEVEL9K_MODE="awesome-patched"
  local icon_array_name=$(_p9k_get_current_icon_array_name)
  typeset -Ah icon_array
  icon_array=${(@Pkv)icon_array_name}
  typeset -ah current_icons
  current_icons=(${(k)icon_array[@]})
  for key in ${_ICONS_UNDER_TEST}; do
    assertTrue "The key ${key} does exist in ${_P9K_TEST_MODE} mode, but not in ${POWERLEVEL9K_MODE}!" "(( ${+current_icons[(r)$key]} ))"
  done

  # Switch to "awesome-fontconfig" mode
  POWERLEVEL9K_MODE="awesome-fontconfig"
  local icon_array_name=$(_p9k_get_current_icon_array_name)
  typeset -Ah icon_array
  icon_array=${(@Pkv)icon_array_name}
  typeset -ah current_icons
  current_icons=(${(k)icon_array[@]})
  for key in ${_ICONS_UNDER_TEST}; do
    assertTrue "The key ${key} does exist in ${_P9K_TEST_MODE} mode, but not in ${POWERLEVEL9K_MODE}!" "(( ${+current_icons[(r)$key]} ))"
  done

  # Switch to "flat" mode
  POWERLEVEL9K_MODE="flat"
  local icon_array_name=$(_p9k_get_current_icon_array_name)
  typeset -Ah icon_array
  icon_array=${(@Pkv)icon_array_name}
  typeset -ah current_icons
  current_icons=(${(k)icon_array[@]})
  for key in ${_ICONS_UNDER_TEST}; do
    assertTrue "The key ${key} does exist in ${_P9K_TEST_MODE} mode, but not in ${POWERLEVEL9K_MODE}!" "(( ${+current_icons[(r)$key]} ))"
  done

  # Switch to "compatible" mode
  POWERLEVEL9K_MODE="compatible"
  local icon_array_name=$(_p9k_get_current_icon_array_name)
  typeset -Ah icon_array
  icon_array=${(@Pkv)icon_array_name}
  typeset -ah current_icons
  current_icons=(${(k)icon_array[@]})
  for key in ${_ICONS_UNDER_TEST}; do
    assertTrue "The key ${key} does exist in ${_P9K_TEST_MODE} mode, but not in ${POWERLEVEL9K_MODE}!" "(( ${+current_icons[(r)$key]} ))"
  done

  unset current_icons
  unset _ICONS_UNDER_TEST
}

source shunit2/source/2.1/src/shunit2