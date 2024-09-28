
package cmd

/* Download.Go
 *
 * Print downloadable links of result images on STDOUT, and let the shell
 * wrapper pull that with curl or wget, or whatever it choses to use.
 */

import (
    // "strings"
    // "github.com/BurntSushi/toml"
)


//- Data Structures ------------------------------------------------------------

type DownloadData struct {
    Username    string  `toml:"username"`
    Password    string  `toml:"password"`
    SessionID   string  `toml:"sessionID"`
}

type DownloadType struct {
    DownloadData map[string]DownloadData `toml:"DownloadData"`
}


//- Helper ---------------------------------------------------------------------




//- Function Calls -------------------------------------------------------------

func StreakGetResults( aTOMLfile string ) {
    //
}


