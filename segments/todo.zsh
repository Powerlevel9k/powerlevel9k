# todo.sh: shows the number of tasks in your todo.sh file
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
prompt_todo() {
  local todos=$(todo.sh ls 2>/dev/null | egrep "TODO: [0-9]+ of ([0-9]+) tasks shown" | awk '{ print $4 }')

  serialize_segment "$0" "" "$1" "$2" "${3}" "244" "$DEFAULT_COLOR" "${todos}" "TODO_ICON"
}

