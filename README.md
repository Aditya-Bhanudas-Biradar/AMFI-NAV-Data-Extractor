# AMFI NAV Data Extractor

## Overview
This project provides a shell script (Script.sh) to automatically fetch the latest Net Asset Value (NAV) data for mutual fund schemes from the AMFI website. It extracts the "Scheme Name" and "Net Asset Value" and saves the information into a clean, Tab-Separated Values (TSV) file.

## The Problem
AMFI India provides NAV data in a text file (NAVAll.txt) that includes informational headers and uses a semi-colon (;) delimiter. Processing this file manually to extract specific columns is inefficient.

## The Solution
The shell script automates this by:
1. **Fetching Data:** Downloads NAVAll.txt using curl.
2. **Processing Data:** Uses awk to:
   - Skip irrelevant header lines.
   - Extract and clean the "Scheme Name" (4th field) and "Net Asset Value" (5th field).
   - Filter out invalid or missing entries.
3. **Saving Output:** Writes a TSV file (amfi_nav_data.tsv) with a header.
4. **Feedback:** Prints status messages, a preview of data, and the total record count.

## Features
- Automated data fetching and extraction.
- Clean TSV output.
- Basic data cleaning.
- Informative terminal feedback.

## Getting the Script
1. Using Git (recommended):
   ```bash
   git clone <your_github_repository_url_here>
   cd <repository_directory_name>
   ```
2. Downloading Script.sh directly from the GitHub repository page.

## Prerequisites
- Bash (or a compatible shell)
- curl for downloading
- awk for text processing
- head, tail, and wc for terminal output

## How to Run
Open your terminal, then in the script directory run:
   ```bash
   chmod +x Script.sh
   ./Script.sh
   ```

## Output
In the terminal, you will see progress messages, a preview of the first five records, and the total number of extracted records.

The TSV file (amfi_nav_data.tsv) contains:
- A header line: Scheme Name and Asset Value (tab-separated).
- Subsequent lines with cleaned data extracted from NAVAll.txt.

## How It Works (Script Logic)
The script uses curl to download the data and pipes it to awk for processing:
- Sets input (;) and output (\t) field separators.
- Identifies the header line marking the start of data.
- Processes subsequent rows if they meet the criteria (NF ≥ 5 and valid asset value).
- Cleans values with gsub and prints the output.
- Uses "set -euo pipefail" for robust error handling.

## Data Format Consideration

While the script currently outputs data in a Tab-Separated Values (TSV) format, another option is to output the data in JSON format. 

**Why JSON?**
- **Structured Data:** JSON provides hierarchical structure, which is useful if you need to include nested data.
- **Interoperability:** JSON is widely accepted in web APIs and many programming environments.
- **Ease of Parsing:** Most modern languages offer built-in JSON parsing, making it easy to integrate with other systems.

**Why keep TSV?**
- **Simplicity:** TSV is straightforward and perfect for flat data tables.
- **Human-Readable:** Data in TSV format can be quickly previewed using simple text editors.

The choice between JSON and TSV depends on your requirements. For complex or nested datasets and better compatibility with web services, JSON would be a beneficial format; for simpler, flat data structures and ease of use with traditional tools, TSV remains an effective choice.


