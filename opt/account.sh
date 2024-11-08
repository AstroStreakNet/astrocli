#!/usr/bin/env bash



# actions ----------------------------------------------------------------------

PASS_FILE="/opt/streak/.cred"

case $1 in

"help")
    $PRINT "HELP_ACCOUNT"
;;

"login")
    # delete previous record
    rm $PASS_FILE 2>/dev/null

    # get username and password
    read -p "Enter your username: " username
    read -s -p "Enter your password: " password
    echo ""

    echo "$username:$password" > $PASS_FILE
    $BIN "account" $PASS_FILE

;;

"logout")
    rm $PASS_FILE 2>/dev/null
    # print- have logged out
;;

*)
    if [ -f $PASS_FILE ]; then
        echo "Logged in as: $(cat $PASS_FILE | cut -d ':' -f 1)"
        # check username
        # check if authenticated
    else
        echo "not logged in"
        # not logged in
    fi
;;

esac

