#!/usr/bin/env zsh
# vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

export LIBPERF_PERFORMANCE_LOG="perf.out"
export LIBPERF_SAMPLE_SIZE=30 # The rule of thumb in statistics is 30 samples.
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
  
  local i=2
  repeat ${#LIBPERF_LAPS[@]}; do;
    local prev="$(($i - 1))"
    if [[ "$i" -ne "$(( ${#LIBPERF_LAPS[@]} + 1 ))" ]]; then;
      LIBPERF_LAPS_RESULT[i]="$(libperf_calculate "(${LIBPERF_LAPS[i]} - ${LIBPERF_LAPS[prev]}) / 1000000")"
    fi
    i="$(($i + 1))"
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
    print min "," sum/(NF-1) "," max "," ((sum*sum) - sum2)/(NF-1); 
  }'
}

function libperf_initLog() {
  echo "name,min,mean,max,variance" > "$LIBPERF_PERFORMANCE_LOG"
}

# First argument is the name of the performance test. Everything afterward is
# executed within the test.
function samplePerformance() {
  local name="$1"
  shift
  libperf_stopwatchStart
  repeat "$LIBPERF_SAMPLE_SIZE"; do;
    $@
    libperf_stopwatchLap
  done;
  local stats="$(libperf_stopwatchFinish)"
  echo "$name,$stats"
  echo "$name,$stats" >> "$LIBPERF_PERFORMANCE_LOG"
}

# Same as samplePerformance() except with silenced output.
function samplePerformanceSilent() {
  local name="$1"
  shift
  libperf_stopwatchStart
  repeat "$LIBPERF_SAMPLE_SIZE"; do;
    $@ 2>&1 > /dev/null
    libperf_stopwatchLap
  done;
  local stats="$(libperf_stopwatchFinish)"
  echo "$name,$stats"
  echo "$name,$stats" >> "$LIBPERF_PERFORMANCE_LOG"
}

libperf_initLog
samplePerformance "Warmup" awk "BEGIN { print 1 + 2 + 3 }"
samplePerformance "Echo" echo Hello, world
samplePerformanceSilent "Echo" echo Hello, world
samplePerformance "Sleep" sleep 0.1
