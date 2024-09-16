/*
 * Upload.Go
 *
 * Parse .toml file and upload images to the server.
 */

package cmd

import (
    "os"
    "fmt"
    "github.com/BurntSushi/toml"
)


//- Data Structures ------------------------------------------------------------

type Properties struct {
    Telescope        string `toml:"Telescope"`
    ObservatoryCode  string `toml:"ObservatoryCode"`
    RightAscension   string `toml:"RightAscension"`
    Declination      string `toml:"Declination"`
    JulianDate       string `toml:"JulianDate"`
    ExposureDuration string `toml:"ExposureDuration"`
    StreakType       string `toml:"StreakType"`
}

type Config struct {
    Properties map[string]Properties `toml:"properties"`
}


//- Helper ---------------------------------------------------------------------

func overrideDefault( aValue, aDefaultValue *string ) string {
    if *aValue != "" {
        return *aValue
    }
    return *aDefaultValue
}

func makeRequest( aFilePath *string, aFileData Properties ) {
    fmt.Printf( "Uploading %s\n", *aFilePath )
    fmt.Printf("Telescope: %s\n", aFileData.Telescope)
    fmt.Printf("Observatory Code: %s\n", aFileData.ObservatoryCode)
    fmt.Printf("Right Ascension: %s\n", aFileData.RightAscension)
    fmt.Printf("Declination: %s\n", aFileData.Declination)
    fmt.Printf("Julian Date: %s\n", aFileData.JulianDate)
    fmt.Printf("Exposure Duration: %s\n", aFileData.ExposureDuration)
    fmt.Printf("Streak Type: %s\n", aFileData.StreakType)
    fmt.Println("--------------------------")
}


//- Function Call --------------------------------------------------------------

func StreakUpload( aTOMLfile string ) {
    var lConfig Config
    if _, err := toml.DecodeFile( aTOMLfile, &lConfig ); err != nil {
        fmt.Fprintf( os.Stderr,
            "\033[31mError 204:\033[0m Decoding TOML file.\n%v\n", err )

        return
    }

    // Get the default properties
    var lDefaults Properties
    lDefaults, err := lConfig.Properties["default"]
    if err {
        lDefaults = Properties {
            Telescope: "",
            ObservatoryCode: "",
            RightAscension: "",
            Declination: "",
            JulianDate: "",
            ExposureDuration: "",
            StreakType: "",
        }
    }

    // Iterate over the properties, skipping the default one
    for lPath, lValues := range lConfig.Properties {
        if lPath == "default" {
            continue
        }

        makeRequest( &lPath, Properties {
            Telescope       : overrideDefault(&lValues.Telescope, &lDefaults.Telescope),
            ObservatoryCode : overrideDefault(&lValues.ObservatoryCode, &lDefaults.ObservatoryCode),
            RightAscension  : overrideDefault(&lValues.RightAscension, &lDefaults.RightAscension),
            Declination     : overrideDefault(&lValues.Declination, &lDefaults.Declination),
            JulianDate      : overrideDefault(&lValues.JulianDate, &lDefaults.JulianDate),
            ExposureDuration: overrideDefault(&lValues.ExposureDuration, &lDefaults.ExposureDuration),
            StreakType      : overrideDefault(&lValues.StreakType, &lDefaults.StreakType),
        })
    }
}

