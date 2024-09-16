/*
 * Upload.Go
 *
 * Parse .toml file and upload images to the server.
 */

package cmd

import (
    "strings"
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
    PublicView       string `toml:"PublicView"`
    AllowAITraining  string `toml:"AllowAITraining"`
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

func isItTrue( aValue string ) bool {
    // flexible with possible identifiers for no/false
    lFalseValues := []string{ "false", "no", "f", "n"  }
	for _, value := range lFalseValues {
        if strings.ToLower( aValue ) == value {
			return false
		}
	}

    // default operation for invalid identifier is true
	return true
}

func makeRequest( aFilePath *string, aFileData Properties ) {
    PrintDebug( "Uploading ", *aFilePath )

    if ( isItTrue( aFileData.AllowAITraining ) ) {
        PrintDebug( "Can train AI" )
    }

    if ( isItTrue( aFileData.PublicView ) ) {
        PrintDebug( "Public can view" )
    }

    PrintDebug( "Telescope: ", aFileData.Telescope )
    PrintDebug( "Observatory Code: ", aFileData.ObservatoryCode )
    PrintDebug( "Right Ascension: ", aFileData.RightAscension )
    PrintDebug( "Declination: ", aFileData.Declination )
    PrintDebug( "Julian Date: ", aFileData.JulianDate )
    PrintDebug( "Exposure Duration: ", aFileData.ExposureDuration )
    PrintDebug( "Streak Type: ", aFileData.StreakType )
    PrintDebug( "--------------------------" )
}


//- Function Call --------------------------------------------------------------

func StreakUpload( aTOMLfile string ) {
    var lConfig Config
    if _, err := toml.DecodeFile( aTOMLfile, &lConfig ); err != nil {
        PrintError( 102, "Decoding .toml file.", err )
        return
    }

    // Get the default properties
    lDefaults, _ := lConfig.Properties["default"]

    // Iterate over the properties, skipping the default one
    for lPath, lValues := range lConfig.Properties {
        if lPath == "default" {
            continue
        }

        makeRequest( &lPath, Properties {
            Telescope       : overrideDefault(
                &lValues.Telescope, &lDefaults.Telescope),

            ObservatoryCode : overrideDefault(
                &lValues.ObservatoryCode, &lDefaults.ObservatoryCode ),

            RightAscension  : overrideDefault(
                &lValues.RightAscension, &lDefaults.RightAscension ),

            Declination     : overrideDefault(
                &lValues.Declination, &lDefaults.Declination ),

            JulianDate      : overrideDefault(
                &lValues.JulianDate, &lDefaults.JulianDate ),

            ExposureDuration: overrideDefault(
                &lValues.ExposureDuration, &lDefaults.ExposureDuration ),

            PublicView      : overrideDefault(
                &lValues.PublicView, &lDefaults.PublicView ),

            AllowAITraining : overrideDefault(
                &lValues.AllowAITraining, &lDefaults.AllowAITraining ),

            StreakType      : overrideDefault(
                &lValues.StreakType, &lDefaults.StreakType ),
        })
    }
}

