SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/commons.sh"
logger dependencies "$@" # register own debug tag & logger functions

function flagExists() { [[ "$*" =~ $1 ]] && echo true || echo false; }

function dependency() {
  local tool_name=$1 tool_version_pattern=$2
  local tool_fallback=${3:-"No details. Please google it."} tool_version_flag=${4:-"--version"}
  local is_exec=$(flagExists "--exec" "$@") is_optional=$(flagExists "--optional" "$@")

  configDebugDependencies "$@" # refresh debug flags
  local escaped_version=$(sed -e 's#[&\\/\.{}]#\\&#g; s#$#\\#' -e '$s#\\$##' -e 's#*#[0-9]\\{1,4\\}#g' <<<"$tool_version_pattern")
  local tool_path=$(command -v "$tool_name")

  if [ -z "$tool_path" ]; then
    logDependencyError "$tool_name" "$tool_version_pattern" "$escaped_version" "$tool_fallback" $is_optional
    return
  fi

  local version_msg=$("$tool_name" "$tool_version_flag" 2>&1)
  local clean_version=$(echo "'$version_msg'" | sed -n "s#.*\($escaped_version\).*#\1#p")
  logDependencySuccess "$tool_path" "$version_msg" "$tool_version_pattern" "$escaped_version" "$clean_version" "$tool_name" $is_optional

  if [ -z "$clean_version" ]; then
    handleVersionMismatch "$tool_name" "$clean_version" "$tool_version_pattern" "$tool_fallback" $is_exec $is_optional
  else
    printDependencyStatus "$tool_name" "$clean_version" $is_optional
  fi
}

function optional() {
  local args=("${@/--debug/}"); args=("${args/--exec/}")
  args=("${args/--silent/}"); args=("${args/--optional/}")

  [[ ${#args[@]} -eq 2 ]] && args+=("No details. Please google it." "--version")
  [[ ${#args[@]} -eq 3 ]] && args+=("--version")
  args+=("--optional" "$(flagExists "--exec" "$@")" "$(flagExists "--silent" "$@")" "$(flagExists "--debug" "$@")")

  # Logging Function
logMessage() {
    local message_type=$1
    local message=$2
    printf "[%s] %s\n" "$message_type" "$message"
}

# Dependency Error Logging
logDependencyError() {
    local tool_name=$1
    local tool_version_pattern=$2
    local escaped_version=$3
    local tool_fallback=$4
    local is_optional=$5

    if $is_optional; then
        logMessage "WARNING" "Optional dependency '$tool_name' not found. Try: $tool_fallback"
    else
        logMessage "ERROR" "Mandatory dependency '$tool_name' not found. Install using: $tool_fallback"
    fi
}

# Dependency Success Logging
logDependencySuccess() {
    local tool_path=$1
    local version_msg=$2
    local tool_version_pattern=$3
    local escaped_version=$4
    local clean_version=$5
    local tool_name=$6
    local is_optional=$7

    if $is_optional; then
        logMessage "INFO" "Optional dependency '$tool_name' version $clean_version found at $tool_path."
    else
        logMessage "INFO" "Mandatory dependency '$tool_name' version $clean_version found at $tool_path."
    fi
}

# Handle Version Mismatch
handleVersionMismatch() {
    local tool_name=$1
    local clean_version=$2
    local tool_version_pattern=$3
    local tool_fallback=$4
    local is_exec=$5
    local is_optional=$6

    if $is_optional; then
        logMessage "WARNING" "Optional dependency '$tool_name' version mismatch. Expected: $tool_version_pattern, Found: $clean_version"
    else
        logMessage "ERROR" "Mandatory dependency '$tool_name' version mismatch. Expected: $tool_version_pattern, Found: $clean_version"
        if $is_exec; then
            logMessage "INFO" "Executing fallback command for $tool_name."
            eval $tool_fallback
        else
            logMessage "INFO" "To install or update, use the command: $tool_fallback"
        fi
    fi
}

# Print Dependency Status
printDependencyStatus() {
    local tool_name=$1
    local clean_version=$2
    local is_optional=$3

    if $is_optional; then
        logMessage "INFO" "Optional dependency '$tool_name' version $clean_version is correctly installed."
    else
        logMessage "INFO" "Mandatory dependency '$tool_name' version $clean_version is correctly installed."
    fi
}


  dependency "${args[@]}"
}

# Helper functions for logging, error handling, etc. to be defined here...
