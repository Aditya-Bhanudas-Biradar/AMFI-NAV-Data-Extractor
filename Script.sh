#!/bin/bash

# Exit immediately if a command exits with a non-zero status,
# or if an undefined variable is used, or if a command in a pipe fails.
set -euo pipefail

NAV_URL="https://www.amfiindia.com/spages/NAVAll.txt"
OUTPUT_TSV_FILE="amfi_nav_data.tsv"

echo "Fetching NAV data from AMFI India..."

# Fetch data with curl and process with awk
# curl options: -f (fail fast on HTTP errors), -s (silent), -S (show errors if -s is used)
curl -fsS "$NAV_URL" | awk '
    BEGIN {
        FS = ";";  # Set input field separator to semicolon
        OFS = "\t"; # Set output field separator to tab
        found_data_header = 0; # Flag to indicate if we are past the AMFI informational headers
        print "Scheme Name\tAsset Value"; # Print our desired TSV header
    }

    # Identify the actual data header line from AMFI.
    # This pattern marks the beginning of the relevant data rows.
    /Scheme Code;ISIN Div Payout\/ ISIN Growth;ISIN Div Reinvestment;Scheme Name;Net Asset Value;/ {
        found_data_header = 1; # Set flag as we found the data section
        next; # Skip printing this AMFI header line
    }

    # Process lines only after the AMFI data header has been found
    # and ensure the line has enough fields and a valid asset value.
    (found_data_header == 1 && NF >= 5 && $5 != "" && $5 != "-") {
        # $4 is Scheme Name, $5 is Net Asset Value based on AMFI file structure
        scheme_name = $4;
        asset_value = $5;

        # Remove potential leading/trailing whitespace from the extracted fields
        gsub(/^[ \t]+|[ \t]+$/, "", scheme_name);
        gsub(/^[ \t]+|[ \t]+$/, "", asset_value);

        print scheme_name, asset_value;
    }
' > "$OUTPUT_TSV_FILE"

echo "Data extracted and saved to $OUTPUT_TSV_FILE"
echo "First 5 data lines of $OUTPUT_TSV_FILE (excluding header):"
# tail -n +2 skips the header line we added to the TSV
tail -n +2 "$OUTPUT_TSV_FILE" | head -n 5

echo "Total records extracted (excluding header): $(tail -n +2 "$OUTPUT_TSV_FILE" | wc -l)"