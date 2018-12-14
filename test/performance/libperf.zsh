#!/usr/bin/env zsh
# vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

if [[ -z "${LIBPERF_SOURCED}" ]]; then
  local LIBPERF_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
  if [[ -z "${LIBPERF_ENABLED}" ]]; then export LIBPERF_ENABLED=true; fi
  if [[ -z "${LIBPERF_SAMPLE_SIZE}" ]]; then export LIBPERF_SAMPLE_SIZE=30; fi # The rule of thumb in statistics is 30 samples.
  if [[ -z "${LIBPERF_PERFORMANCE_LOG}" ]]; then export LIBPERF_PERFORMANCE_LOG="${LIBPERF_PATH}/perf_log.csv"; fi
  if [[ -z "${LIBPERF_QUIET}" ]]; then export LIBPERF_QUIET=false; fi
  export LIBPERF_STOPWATCH="$(date +%s%N)"
  export LIBPERF_LAPS=()

  # A calculator that accepts floats and some fancier operations than Bash/ZSH.
  function libperf_calculate() {
    awk "BEGIN { print $* }"
  }

  # Begins the stopwatch with nanosecond precision.
  function libperf_stopwatchStart() {
    export LIBPERF_LAPS=()
    export LIBPERF_STOPWATCH="$(date +%s%N)"
  }

  # Records the instantaneous running time of the stopwatch and returns it in
  # millisecond format (with decimals).
  function libperf_stopwatchRead() {
    local stop_time="$(date +%s%N)"
    local sample_size="${1:-1}"
    local duration="$(($stop_time - $LIBPERF_STOPWATCH))"
    libperf_calculate $duration / 1000000 / $sample_size
  }

  # Marks the instant into an array containing lap times with nanosecond
  # precision.
  function libperf_stopwatchLap() {
    LIBPERF_LAPS+=("$(date +%s%N)")
  }

  # Summarizes the statistics of the laps into min, mean, max, and variance.
  function libperf_stopwatchFinish() {
    LIBPERF_LAPS_RESULT=()
    LIBPERF_LAPS_RESULT[1]="$(libperf_calculate "(${LIBPERF_LAPS[1]} - $LIBPERF_STOPWATCH) / 1000000")"
    
    for i in {2..${#LIBPERF_LAPS[@]}}; do;
      local prev="$(($i - 1))"
      if [[ "$i" -ne "$(( ${#LIBPERF_LAPS[@]} + 1 ))" ]]; then;
        LIBPERF_LAPS_RESULT[i]="$(libperf_calculate "(${LIBPERF_LAPS[i]} - ${LIBPERF_LAPS[prev]}) / 1000000")"
      fi
    done;
    
    LIBPERF_LAPS=()

    echo "${LIBPERF_LAPS_RESULT[@]}" | awk '{
      min = max = sum = $1;       # Initialize to the first value (2nd field)
      sum2 = $1 * $1              # Running sum of squares
      for (n=2; n <= NF; n++) {   # Process each value on the line
        if ($n < min) min = $n    # Current minimum
        if ($n > max) max = $n    # Current maximum
        sum += $n;                # Running sum of values
        sum2 += $n * $n           # Running sum of squares
      }
      
      # min, mean, max, variance
      printf min "," sum/(NF) "," max "," ((sum*sum) - sum2)/(NF); 
    }' && printf ',%s' "${LIBPERF_LAPS_RESULT[@]}"
  }

  # Clears and sets the header of the CSV log file.
  function libperf_initLog() {
    printf "name,min,mean,max,variance" > "$LIBPERF_PERFORMANCE_LOG"
    for i in {1.."${LIBPERF_SAMPLE_SIZE}"}; do;
      printf ",sample_${i}" >> "$LIBPERF_PERFORMANCE_LOG"
    done;
    printf "\n" >> "$LIBPERF_PERFORMANCE_LOG"
  }

  # Checks if the log file exists, and if not, initializes it.
  function libperf_checkLog() {
    if [[ ! -f "$LIBPERF_PERFORMANCE_LOG" ]]; then
      libperf_initLog
    fi
  }

  # First argument is the name of the performance test. Everything afterward is
  # executed within the test.
  function samplePerformance() {
    if ("$LIBPERF_ENABLED"); then
      local name="$1"
      shift
      libperf_stopwatchStart
      repeat "$LIBPERF_SAMPLE_SIZE"; do;
        $@
        libperf_stopwatchLap
      done;
      local stats="$(libperf_stopwatchFinish)"
      if [[ ! "$LIBPERF_QUIET" ]]; then
        local mean="$(echo $stats | awk -F ',' '{ printf $2 };')"
        local variance="$(echo $stats | awk  -F ',' '{ printf $4 };')"
        echo "[$name] mean: $mean ms; variance: $variance ms"
      fi
      libperf_checkLog
      echo "$name,$stats" >> "$LIBPERF_PERFORMANCE_LOG"
    fi
  }

  # Same as samplePerformance() except with silenced output.
  function samplePerformanceSilent() {
    if ("$LIBPERF_ENABLED"); then
      local name="$1"
      shift
      libperf_stopwatchStart
      repeat "$LIBPERF_SAMPLE_SIZE"; do;
        $@ 2>&1 > /dev/null
        libperf_stopwatchLap
      done;
      local stats="$(libperf_stopwatchFinish)"
      if [[ ! "$LIBPERF_QUIET" ]]; then
        local mean="$(echo $stats | awk -F ',' '{ printf $2 };')"
        local variance="$(echo $stats | awk  -F ',' '{ printf $4 };')"
        echo "[$name] mean: $mean ms; variance: $variance ms"
      fi
      libperf_checkLog
      echo "$name,$stats" >> "$LIBPERF_PERFORMANCE_LOG"
    fi
  }

  # if ("$LIBPERF_ENABLED"); then
    # libperf_initLog
  # fi

  export LIBPERF_SOURCED=true
else
  if [[ ! "$LIBPERF_QUIET" ]]; then
    echo "Attempted to source libperf more than once; source loop aborted."
  fi
fi

# libperf_initLog
# samplePerformance "Warmup" awk "BEGIN { print 1 + 2 + 3 }"
# samplePerformance "Echo" echo Hello, world
# samplePerformanceSilent "Echo" echo Hello, world
# samplePerformance "Sleep" sleep 0.1
