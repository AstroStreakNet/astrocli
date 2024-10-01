
package cmd

/* Account.Go
 *
 * Manage AstroStreaknet account and session.
 */

import (
    "os"
	"strings"
    "bytes"
    "fmt"
    "net/http"
    "net/url"
)

const URL = "http://localhost:8080";


//- Helper ---------------------------------------------------------------------

func signIn( aUsername, lPassword *string ) ( *http.Client, error ) {
    lClient := &http.Client{}
    lData := url.Values{}

    lData.Set( "username", *aUsername )
    lData.Set( "password", *lPassword )

    // create the POST request
    lRequest, lError := http.NewRequest( "POST", ( URL + "/login" ),
        bytes.NewBufferString( lData.Encode() ),
    )
    if lError != nil {
        return nil, lError
    }

    // set the Content-Type header to application/x-www-form-urlencoded
    lRequest.Header.Set("Content-Type", "application/x-www-form-urlencoded")

    // send the request
    lResponse, lError := lClient.Do(lRequest)
    if lError != nil {
        return nil, lError
    }
    defer lResponse.Body.Close()

    // check if login was successful (usually status code 200)
    if lResponse.StatusCode != http.StatusOK {
        return nil, fmt.Errorf("Authentication Error. %v", lResponse.StatusCode)
    }
    PrintDebug( "Login Successful" )

    // return the HTTP client to use for subsequent requests (keeps the session)
    return lClient, nil
}


//- Function Calls -------------------------------------------------------------

func StreakLogin ( aCredFile string ) ( *http.Client, error ) {
    data, err := os.ReadFile(*&aCredFile)
	if err != nil {
	}

	// Split the data into username and hashed password
	credentials := strings.Split(string(data), ":")
	if len(credentials) != 2 {
		fmt.Println("Invalid credentials file format")
	}

    PrintDebug( "Username  = ", credentials[0] )
    PrintDebug( "Password  = ", credentials[1] )

    // get session if login is successful
    lSession, lError := signIn( &credentials[0], &credentials[1] )
    if lError != nil {
        PrintError( 300, "Login Fail.", lError )
        return nil, lError
    }

    return lSession, nil
}

