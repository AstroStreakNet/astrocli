#!/bin/bash

#- Debug.sh --------------------------------------------------------------------
#- Provide more information on error and warning codes -------------------------

error_code() {
    echo -e "\
    \033[31mError $1:\033[33m $2\033[0m"
}

warning_code() {
    echo -e "
    \033[34mWarning $1:\033[33m $2\033[0m"
}

report_dialogue() {
    echo -e "\033[32m
    Please report this error on project github @ gh:AstroStreaknet/streak with
    the extra information printed with this error.
    \033[0m "
}


# 100 Invalid Arguments Passed / Invalid Usage
# 101 Missing Arguments
# 102 TOML error

# 200 Broken Install
# 201 Invalid Script Call
# 202 Invalid Script Function Call
# 203 Invalid Binary Call
# 204 Failure Binary Internals
# 205 Invalid Internal Path

# 400 Missing System Packages
# 403 No files selected.
# 404 File trying to upload doesn't exist
# 405 Path trying to find in isn't valid
# 406 File trying to upload in isn't valid



##* broken indentation for better readability
print_information() {
case "$1" in

# 1xx -INVALID-USE--------------------------------------------------------------

"100")
    error_code 100 "Invalid Usage"
    echo -e "\
    This error is triggered when the command tried is not a valid supported
    command. More often than not, this may be due to some typo, or invalid
    capitalisation.

    Get a list of all possible streak commands with:
    \033[1;35m\$ streak help"
;;


"101")
    error_code 101 "Missing Arguments"
    echo -e "\
    ======== "
;;


"102")
    error_code 102 "Invalid .toml Syntax"
    echo "
    This is likely caused by a syntax error or invalid formatting in the .toml
    file. Please review the file and ensure it conforms to the TOML format
    specification."
    ;;



# 2xx -SYSTEM-ERROR-------------------------------------------------------------

"200")
    error_code 200 "Broken Install"
    echo -e "\
    The streak utility consists of several shell scripts wrapped around a Go
    binary. These scripts are located at $STREAK_INSTALL_PATH. 
    The error occurs when one or more of these essential scripts are missing or
    when the program has not been initialised.

    The utility will automatically resolve this issue by reinitialising the
    installation."
;;


"201")
    error_code 201 "Invalid Script Call"
    echo -e "\
    This error is triggered when some internal wrapper script within the utility
    is not called properly, i.e., with missing parameters."
    report_dialogue
;;


"203")
    error_code 203 "Invalid Binary Call"
    echo -e "\
    This error occurs when the wrapper shell scripts call the core Go binary
    without any flags, i.e., without specifying the purpose call."
    report_dialogue
;;


"204")
    error_code 204 "Internal Binary Failure"
    echo -e "\
    ======== "
;;


"205")
    error_code 205 "Invalid Essential Internal Path"
    echo -e "\
    ====="

    warning_code 205 "Invalid Optional Internal Path"
    echo "\
    Warning is thrown when the program tries to use a system path for internal
    use but cannot find that location. This warning can be safetly ignored. It
    is printed only to inform user about any change within internal processes."
;;



# 3xx -WEB-SERVER-TALK----------------------------------------------------------



# 4xx -FILES-AND-PATH-----------------------------------------------------------

"400")
    error_code 400 "Missing Essential System Package"
    echo -e "\
    This error occurs when a required system utility, as specified in the error
    message, is missing. To resolve this issue, you can install the missing
    package.

    For example:
        On Debian-based Linux systems, use:
        $ sudo apt install <package_name>

        On MacOS, if your have homebrew installed, use:
        $ brew install <package_name>
    "

    warning_code 400 "Missing Optional System Package"
    echo -e "\
    The warning occurs for the same reason as the error and can be resolved
    similarly. However, unlike the error, a missing package in this case won't
    terminate the action, but may limit certain use cases."
;;


"403")
    error_code 403 "No Files Selected" # context of fzf
    echo -e "\
    ======== "
;;


"404")
    error_code 404 "File Doesn't Exist"
    echo -e "\
    ======== "
;;


"405")
    error_code 405 "Invalid Path"
    echo -e "\
    ======== "
;;


"406")
    error_code 406 "Invalid File Type"
    echo -e "\
    ======== "
;;



#-------------------------------------------------------------------------------
esac
}

for code in "$@"; do
    print_information "$code"
done

