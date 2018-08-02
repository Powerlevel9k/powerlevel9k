# Coding Style Guide

## Indentation

Code block indentation is two (2) spaces, and tabs may not be used.

Use blank lines between blocks to improve readability. For existing files, stay faithful to the existing indentation.

```shell
if [ -z 'some string' ]; then
  p9k::someFunction
fi
```

## Line Length and Long Strings

Maximum line length is 80 characters.

Lines of code should be no longer than 80 characters unless absolutely necessary. When lines are wrapped using the backslash character '\', subsequent lines should be indented with four (4) spaces so as to differentiate from the standard spacing of two characters. Tabs may *not* be used.

```shell
for x in some set of very long arguments that make for a very long line that \
    extends much too long for one line
do
  echo ${x}
done
```

If you have to write strings that are longer than 80 characters, this should be done with a "here document" or an embedded newline if possible. Literal strings that have to be longer than 80 chars and can't sensibly be split are okay, but it's strongly preferred to find a way to make it shorter.

##### _Bad:_
```shell
long_string_1="I am an exceptionalllllllllllly looooooooooooooooooooooooooooooooooooooooong string."
```

##### _Good:_
```shell
cat <<END;
I am an exceptionalllllllllllly
looooooooooooooooooooooooooooooooooooooooong string.
END
```

##### _Good:_
```shell
long_string_2="I am an exceptionalllllllllllly
 looooooooooooooooooooooooooooooooooooooooong string."
```

## Comments

Since there are many contributors to the codebase, all code should be commented throughout as much as possible.

## Variable and function names

All powerlevel9k specific constants, variables, and functions will be prefixed appropriately with 'p9k'. This is to distinguish usage in the powerlevel9k code from users own scripts so that the shell namespace remains predictable to users. The exceptions here are the public functions, e.g. `show_defined_icons`. We use `snake_case` throughout, _except_ for private functions, as discussed below.

All non-builtin constants and variables will be surrounded with curly braces, e.g. `${some_variable}` to improve code readability.

Care in the naming and use of variables, both public and private, is very important. Accidental overriding of the variables can occur easily if care is not taken.

Type                             | Sample
---------------------------------|----------------------
global public constant           | `P9K_TRUE`
global private constant          | `__P9K_SHELL_FLAGS`
global public variable           | `P9K_SOME_VARIABLE`
global private variable          | `__p9k_some_variable`
global macro                     | `_P9K_SOME_MACRO_`
local variable                   | `some_variable`
public function                  | `some_function`
private function                 | `p9k::someFunction`

Private functions are prefixed with `p9k::` and have the first letter of the second and later words capitalized. For example, the private function name for always displaying the user might be `p9k::alwaysDisplayUser`.

## Naming Conventions

Meaningful self-documenting names should be used. If the variable name does not make it reasonably obvious as to the meaning of the variable, appropriate comments should be added.

Variable names should not clobber command names, such as `dir` or `pwd`.

##### _Bad:_
```shell
local pwd=""
```

##### _Good:_
```shell
local pwd_value=""
```

Variable names for loop indexes should be named similarly to any variable you're looping through as far as possible.

##### _Bad:_
```shell
for x in ${zones}; do
  somethingWith "${x}"
done
```

##### _Good:_
```shell
for zone in ${zones}; do
  p9k::somethingWith "${zone}"
done
```

## Use local variables

Ensure that local variables are only seen inside a function and its children by using `local` or other `typeset` variants when declaring them. This avoids polluting the global namespace and inadvertently setting or interacting with variables that may have significance outside the function.

##### _Bad:_
```shell
p9k::funcBad() {
  global_var=37  #  Visible only within the function block
                 #  before the function has been called.
}

echo "global_var = $global_var"  # Function "func_bad" has not yet been called,
                                 # so $global_var is not visible here.

func_bad
echo "global_var = $global_var"  # global_var = 37
                                 # Has been set by function call.
```

##### _Good:_
```shell
p9k::funcGood() {
  local local_var=""
  local_var=37
  echo $local_var
}

echo "local_var = $local_var" # local

p9k::funcGood
echo "local_var = $local_var" # still local

global_var=$(p9k::funcGood)
echo "global_var = $global_var" # move function result to global scope
```

### Local variable cleanup

All variables local to a function must be declared using the `local` keyword. Where applicable, default values should be assigned in the declaration. Local variables should be assigned at the beginning of the function or code block, for example:

```shell
p9k::someFunction() {
  # these variables are used throughout the function.
  local some_variable=true another_variable

  ...

  if [[ some_variable == true ]]; then
    # this variable is only used in this block and nowhere else in the function.
    local block_variable

    ...

  else

    ...

  fi
```

Array variables have to be assigned using two lines, and should be`unset` when not needed any longer. Care needs to be taken that declarations and assignments are separated, due to some earlier versions of Zsh not supporting assignment during declaration. For example:

```shell
typeset -a some_array
someArray=( one two three )

...

unset some_array
```

## Constants and Environment Variable Names

All caps, separated with underscores, declared at the top of the file. Constants and anything exported to the environment should be capitalized.

##### _Constant:_
```shell
readonly PATH_TO_FILES='/some/path'
```

##### _Constant and environment:_
```shell
declare -xr P9K_RELEASE_VERSION='PROD'
```

Some things become constant at their first setting (for example, via `getopts`). Thus, it's okay to set a constant in `getopts` or based on a condition, but it should be made `readonly` immediately afterwards. Note that `declare` doesn't operate on global variables within functions, so `readonly` or `export` is recommended instead.

```shell
VERBOSE='false'
while getopts 'v' flag; do
  case "${flag}" in
    v) VERBOSE='true' ;;
  esac
done
readonly VERBOSE
```

## Read-only Variables

Use `readonly` or `declare -r` to ensure they're read only. As globals are widely used in the shell, it's important to catch errors when working with them. When you declare a variable that is meant to be read-only, make this explicit.

```shell
zip_version="$(dpkg --status zip | grep Version: | cut -d ' ' -f 2)"
if [[ -z "${zip_version}" ]]; then
  error_message
else
  readonly zip_version
fi
```

###  If / For / While

Put `; do` and `; then` on the same line as the `while`, `for` or `if`.

##### _Good:_
```shell
for dir in ${_p9k_dirs}; do
  if [[ -d "${dir}" ]]; then

    ...

  else

    ...

  fi
done
```

## Functions

### Naming Conventions

Parentheses are required after the function name. The `function` keyword is optional when `()` is present after the function name, but it aids readability and prevents [conflicts with alias declarations](http://zsh.sourceforge.net/Doc/Release/Shell-Grammar.html#Aliasing). The POSIX specification says "`fname() compound-command[io-redirect ...]`", so we prefer the default from the specification!

The opening brace should appear on the same line as the function name.

##### _Bad:_
```shell
function my_bad_func {
  ...
}
```

##### _Good:_
```shell
my_good_func() {
  ...
}

```

Private or utility functions should be prefixed with `p9k::`:

##### _Good:_
```shell
p9k::helperUtil()  {
  ...
}
```

### Use return values

After a script or function terminates, a `$?` from the command line gives the exit status of the script, that is, the exit status of the last command executed in the script, which is, by convention, 0 on success or an integer in the range 1 - 255 on error.

##### _Bad:_
```shell
my_bad_func() {
  for port in $(seq 32768 61000); do
    for i in $(netstat_used_local_ports); do
      if [[ $used_port -eq $port ]]; then
        continue
      else
        echo $port
      fi
    done
  done
}
```

##### _Good:_
```shell
p9k::myGoodFunc() {
  for port in $(seq 32768 61000); do
    for i in $(netstat_used_local_ports); do
      if [[ $used_port -eq $port ]]; then
        continue
      else
        echo $port
        return 0
      fi
    done
  done

  return 1
}
```

### Check return values

Always check return values and give informative error messages. For unpiped commands, use `$?` or check directly via an if statement to keep it simple. Use nonzero return values to indicate errors.

##### _Bad:_
```shell
mv "${file_list}" "${dest_dir}/"
```

##### _Good:_
```shell
mv "${file_list}" "${dest_dir}/" || exit 1
```

##### _Good:_
```shell
if ! mv "${file_list}" "${dest_dir}/"; then
  echo "Unable to move ${file_list} to ${dest_dir}" >&2
  exit 1
fi
```

##### _Good:_ use "$?" to get the last return value
```shell
mv "${file_list}" "${dest_dir}/"
if [[ "$?" -ne 0 ]]; then
  echo "Unable to move ${file_list} to ${dest_dir}" >&2
  exit 1
fi
```

## Conditionals

`if`/`then` conditionals can be shortened using `[[ ]]`.

```shell
[[ -z 'some string' ]] && someFunction
```

Shortened `if`/`then` conditionals that exceed the 80 character limit, should place the `&&` and/or `||` on the next line, indented by four (4) spaces.

```shell
[[ -z 'some string' ]] \
    && p9k::someFunction \
    || p9k::anotherFunction
```

## Command Substitution

Use `$(command)` instead of backticks.

Nested backticks require escaping the inner ones with `\`. The `$(command)` format doesn't change when nested and is easier to read.

##### _Bad:_
```shell
var="`command \`command1\``"
```

##### _Good:_
```shell
var="$(command \"$(command1)\")"
```

## Eval

Eval is evil! Eval munges the input when used for assignment to variables and can set variables without making it possible to check what those variables were. Avoid `eval` if possible.

## External commands

External commands should be kept to a minimum as much as possible. Where possible, commands using `grep`, `sed`, `awk`, `cut`, or `tail` should be replaced using Zsh string manipulations.

Output from external commands should be assigned to a local variable for use instead of multiple calls to the same external command wherever possible. For example:

##### _Bad:_
```shell
if [[ $(some_program) == "some_value" ]]; then
  my_var=$(some_program)

  ...

fi
```

##### _Good:_
```shell
my_var=$(some_program)
if [[ ${my_var} == "some_value" ]]; then

  ...

fi
```

## Pipelines

If a pipeline all fits on one line, it should be on one line.

If not, it should be split at one pipe segment per line with each pipe on a new line and a four (4) space indent for the next section of the pipe.

##### _Bad:_
```shell
command1 | command2 | command3 | command4 | command5 | command6 | command7 | command8 | command9
```

##### _Good:_
```shell
command1 \
    | command2 \
    | command3 \
    | command4
    |  ...
```

##### _Good:_ All fits on one line
```shell
command1 | command2
```

When possible, use environment variables instead of shelling out to a command.

##### _Bad:_
```shell
$(pwd)
```

##### _Good:_
```shell
$PWD
```

## Conclusion
Use common sense and _BE CONSISTENT_.

## References

- [Shell Style Guide](https://google.github.io/styleguide/shell.xml)
- [BASH Programming - Introduction HOW-TO](http://tldp.org/HOWTO/Bash-Prog-Intro-HOWTO.html)
- [Linux kernel coding style](https://www.kernel.org/doc/Documentation/CodingStyle)
