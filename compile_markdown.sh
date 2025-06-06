#!/bin/bash

# Script to convert the LaTeX CV project to a Markdown file using pandoc.

# --- Configuration ---
PROJECT_DIR_NAME="CV_LaTeX"
MAIN_TEX_FILE="main_cv.tex"
OUTPUT_MD_NAME="Jahir_Medina-CV_eng.md"
MARKDOWN_FORMAT="gfm" # GitHub Flavored Markdown (common options: commonmark, markdown_strict, gfm)
                      # Use 'markdown' for Pandoc's default extended markdown.

# --- Script Execution ---

echo "Starting LaTeX CV to Markdown conversion with Pandoc..."

# Check if Pandoc is installed
if ! command -v pandoc &> /dev/null; then
    echo "Error: Pandoc is not installed. Please install Pandoc to use this script."
    exit 1
fi
echo "Pandoc found."

# Check if the project directory exists
if [ ! -d "$PROJECT_DIR_NAME" ]; then
    echo "Error: Project directory '$PROJECT_DIR_NAME' not found."
    echo "Please ensure this script is in the correct location (one level above '$PROJECT_DIR_NAME')."
    exit 1
fi

# Navigate into the project directory
cd "$PROJECT_DIR_NAME" || { echo "Error: Could not change to directory '$PROJECT_DIR_NAME'."; exit 1; }

echo "Changed directory to: $(pwd)"

# Check if the main TeX file exists
if [ ! -f "$MAIN_TEX_FILE" ]; then
    echo "Error: Main TeX file '$MAIN_TEX_FILE' not found in '$PROJECT_DIR_NAME'."
    cd .. # Go back to the original directory before exiting
    exit 1
fi

echo "Converting '$MAIN_TEX_FILE' to '$OUTPUT_MD_NAME' (Format: $MARKDOWN_FORMAT) using Pandoc..."

# Pandoc command
# --resource-path=. ensures pandoc looks for included files (like those in sections/) in the current directory.
# --wrap=auto can help with line wrapping in the output markdown. Use 'none' for no wrapping.
pandoc "$MAIN_TEX_FILE" \
    --resource-path=. \
    -f latex \
    -t "$MARKDOWN_FORMAT" \
    --wrap=auto \
    -o "$OUTPUT_MD_NAME"

# Check if Pandoc command was successful and Markdown file was created
if [ $? -eq 0 ] && [ -f "$OUTPUT_MD_NAME" ]; then
    echo "Successfully converted to Markdown: $(pwd)/$OUTPUT_MD_NAME"
else
    echo "Error: Pandoc conversion to Markdown failed or Markdown file was not created."
    echo "Check Pandoc output for details."
    cd .. # Go back to the original directory
    exit 1
fi

# Navigate back to the original directory
cd ..
echo "Script finished."

exit 0
