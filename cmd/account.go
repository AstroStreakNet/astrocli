package cmd

import (
    "os"
    "fmt"
    "golang.org/x/term"
    "github.com/spf13/cobra"
    "github.com/fatih/color"
)

// accountCmd represents the account command
var accountCmd = &cobra.Command{
    Use:   "account",
    Short: "Manage your AstroStreak account status",

    Run: func(cmd *cobra.Command, args []string) {
		// if both --login and --logout flags are used together, the utility
		// will prioritise --login and will override existing account details
		// with new ones.
	
		if login {
		    loginPrompt()
		} else if logout {
		    logoutAction()
		}
    },
}

func init() {
    rootCmd.AddCommand(accountCmd)

    accountCmd.Flags().BoolVarP(&login,
		"login", "i",
		false,
		"login into your account",
    )

    accountCmd.Flags().BoolVarP(&logout,
		"logout", "o",
		false,
		"logout from your account",
    )
}

func loginPrompt() {
    yellow := color.New(color.FgHiYellow).SprintFunc()

    var username string 
    fmt.Printf("%s: ", yellow("username"))
    fmt.Scanln(&username)

    fmt.Printf("%s: ", yellow("password"))
    password, err := term.ReadPassword(int(os.Stdin.Fd()))

    if err != nil {
		fmt.Println("Error reading password:", err)
		return
    }
    fmt.Println("")
    
    fmt.Printf("entered password is %s\n", password)  // just for testing
}

func logoutAction() {
    red := color.New(color.FgRed).SprintFunc()

    fmt.Printf("%s", red("logout\n"))
    // add logout action here
}

