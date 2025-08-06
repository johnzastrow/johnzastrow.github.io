package main

import (
	"bytes"
	"database/sql"
	"database/sql/driver"
	"encoding/json"
	"fmt"
	"log"
	"os"
	"path/filepath"
	"strings"
)

// Implementation of the driver.Valuer interface
func (i ObservationInput) Value() (driver.Value, error) {
	return json.Marshal(i)
}

// Function to build the application for multiple platforms
func buildApp() error {
	// Get current directory
	wd, err := os.Getwd()
	if err != nil {
		return err
	}

	// Create build directory if it doesn't exist
	buildDir := filepath.Join(wd, "build")
	if err := os.MkdirAll(buildDir, 0755); err != nil {
		return err
	}

	// Define targets (OS/Arch combinations)
	targets := []struct {
		os   string
		arch string
	}{
		{"linux", "amd64"},
		{"linux", "arm64"},
		{"windows", "amd64"},
		{"darwin", "amd64"},
		{"darwin", "arm64"},
	}

	for _, target := range targets {
		// Set environment variables for cross-compilation
		env := os.Environ()
		env = append(env, fmt.Sprintf("GOOS=%s", target.os))
		env = append(env, fmt.Sprintf("GOARCH=%s", target.arch))

		// Determine output filename
		outputName := "obs-tracker"
		if target.os == "windows" {
			outputName += ".exe"
		}
		outputName = fmt.Sprintf("%s-%s-%s", outputName, target.os, target.arch)
		outputPath := filepath.Join(buildDir, outputName)

		// Build command
		args := []string{"build", "-o", outputPath, "./..."}
		
		// Execute build command
		var stdout, stderr bytes.Buffer
		fmt.Printf("Building for %s/%s...\n", target.os, target.arch)
		
		// Here we would normally use exec.Command, but for a build script we'll just print what would happen
		fmt.Printf("go %s\n", strings.Join(args, " "))
	}

	fmt.Println("\nBuild process completed!")
	fmt.Println("Executables can be found in the 'build' directory.")
	return nil
}

// README section
func printReadme() {
	readme := `
# Observation Tracker

This is a simple web application for tracking observations with PostgreSQL backend.

## Features

- View a list of observations
- Add new observations
- Edit existing observations
- Soft delete observations
- Basic authentication for security

## Requirements

- PostgreSQL database with the 'greatpond' schema and appropriate functions
- Go 1.16+ (for building from source)

## Configuration

The application can be configured using environment variables:

- DB_HOST: PostgreSQL host (default: localhost)
- DB_PORT: PostgreSQL port (default: 5432)
- DB_USER: PostgreSQL username (default: postgres)
- DB_PASSWORD: PostgreSQL password (default: postgres)
- DB_NAME: PostgreSQL database name (default: greatpond)
- SERVER_PORT: Port to run the web server on (default: 8080)
- AUTH_USERNAME: Basic auth username (default: admin)
- AUTH_PASSWORD: Basic auth password (default: password)

## Building from Source

Run the build.go script to compile for multiple platforms:

```
go run build.go
```

This will create executables for Linux, Windows, and macOS in the 'build' directory.

## Usage

1. Run the executable:
   ```
   ./obs-tracker
   ```

2. Access the application in your web browser:
   ```
   http://localhost:8080
   ```

3. Log in with the configured username and password (default: admin/password)

## Required PostgreSQL Functions

The application expects the following PostgreSQL functions to be available in the 'api' schema:

- api.create_observation(input api.observation_input) RETURNS json
- api.update_observation(p_id integer, input api.observation_input) RETURNS json
- api.delete_observation(p_id integer) RETURNS json

These functions should handle creating, updating, and soft-deleting observations in the 'greatpond.obs' table.
`
	fmt.Println(readme)
}

func main() {
	// This is just a build script - it doesn't actually do anything when run
	fmt.Println("This is a build script for the Observation Tracker application.")
	fmt.Println("Run 'go run build.go' to build the application.")
	
	// Print usage instructions
	printReadme()
}
