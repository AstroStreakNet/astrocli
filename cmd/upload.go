/*
 * Upload.Go
 *
 * Parse .toml file and upload images to the server.
 */

package cmd

import (
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

func overrideDefault( aValue, aDefaultValue string ) string {
    if aValue != "" {
        return aValue
    }
    return aDefaultValue
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
        fmt.Println( "Error decoding TOML file:", err )
        return
    }

    // Get the default properties
    defaultProperties, ok := lConfig.Properties["default"]
    if !ok {
        fmt.Println( "Error: No default properties found in TOML file" )
        return
    }

    // Iterate over the properties, skipping the default one
    for path, property := range lConfig.Properties {
        if path == "default" {
            continue
        }

        makeRequest( &path, Properties{
            Telescope       : overrideDefault(property.Telescope, defaultProperties.Telescope),
            ObservatoryCode : overrideDefault(property.ObservatoryCode, defaultProperties.ObservatoryCode),
            RightAscension  : overrideDefault(property.RightAscension, defaultProperties.RightAscension),
            Declination     : overrideDefault(property.Declination, defaultProperties.Declination),
            JulianDate      : overrideDefault(property.JulianDate, defaultProperties.JulianDate),
            ExposureDuration: overrideDefault(property.ExposureDuration, defaultProperties.ExposureDuration),
            StreakType      : overrideDefault(property.StreakType, defaultProperties.StreakType),
        })
    }
}

