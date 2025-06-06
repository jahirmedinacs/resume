#!/bin/bash

# Script to compile the LaTeX CV project using pandoc and output a named PDF.

# --- Configuration ---
PROJECT_DIR_NAME="CV_LaTeX"
MAIN_TEX_FILE="main_cv.tex"
OUTPUT_PDF_NAME="Jahir_Medina-CV_eng.pdf"
PDF_ENGINE="pdflatex" # Can be pdflatex, xelatex, lualatex - ensure it's installed

# Auxiliary files to clean (extensions, same as for pdflatex)
AUX_FILES_EXTENSIONS=("aux" "log" "out" "toc" "fls" "fdb_latexmk" "synctex.gz")

# --- Script Execution ---

echo "Starting LaTeX CV compilation with Pandoc..."

# Check if Pandoc is installed
if ! command -v pandoc &> /dev/null; then
    echo "Error: Pandoc is not installed. Please install Pandoc to use this script."
    exit 1
fi
echo "Pandoc found."

# Check if the specified PDF engine is installed (basic check)
if ! command -v "$PDF_ENGINE" &> /dev/null; then
    echo "Error: LaTeX engine '$PDF_ENGINE' not found. Please install it or choose another engine."
    exit 1
fi
echo "PDF engine '$PDF_ENGINE' found."


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

echo "Compiling '$MAIN_TEX_FILE' to '$OUTPUT_PDF_NAME' using Pandoc (engine: $PDF_ENGINE)..."

# Pandoc command
# -s (standalone) is often implied for PDF output but good to be explicit.
# --resource-path=. ensures pandoc looks for included files (like those in sections/) in the current directory.
pandoc "$MAIN_TEX_FILE" \
    -s \
    --resource-path=. \
    --pdf-engine="$PDF_ENGINE" \
    -o "$OUTPUT_PDF_NAME"

# Check if Pandoc command was successful and PDF was created
if [ $? -eq 0 ] && [ -f "$OUTPUT_PDF_NAME" ]; then
    echo "Successfully compiled PDF: $(pwd)/$OUTPUT_PDF_NAME"

    # Automatic cleanup of auxiliary files (if the PDF engine created them)
    echo "Cleaning up auxiliary files..."
    for ext in "${AUX_FILES_EXTENSIONS[@]}"; do
        # Deletes files matching the main tex file's basename and the extension
        find . -maxdepth 1 -name "$(basename "$MAIN_TEX_FILE" .tex).$ext" -delete
    done
    # Pandoc might create a temporary directory like `tex2pdf.*` if using certain engines or options.
    # This basic cleanup focuses on common LaTeX aux files.
    # For more robust cleanup of Pandoc temp files, you might need to identify them if they persist.
    rm -rf tex2pdf.* # Attempt to remove common pandoc temp dirs
    echo "Auxiliary files cleaned."
else
    echo "Error: Pandoc compilation failed or PDF was not created."
    echo "Check Pandoc output and any .log files for details."
    cd .. # Go back to the original directory
    exit 1
fi

# Navigate back to the original directory
cd ..
echo "Script finished."

exit 0
