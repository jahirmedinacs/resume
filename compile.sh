#!/bin/bash

# Script to compile the LaTeX CV project using xelatex (for fontspec compatibility),
# output a named PDF, and automatically clean up auxiliary files.

# --- Configuration ---
PROJECT_DIR_NAME="CV_LaTeX"
MAIN_TEX_FILE="main_cv.tex"
OUTPUT_PDF_NAME="Jahir_Medina-CV_eng.pdf"
TARGET_PDF_IN_PROJECT_DIR="main_cv.pdf" # Default output name from xelatex (usually same as main .tex file)
LATEX_ENGINE="xelatex" # Changed from pdflatex to xelatex

# Number of LaTeX engine runs (2-3 is usually sufficient)
LATEX_RUNS=2 # XeLaTeX often needs fewer runs than pdflatex for simple docs, but 2 is safe.

# Auxiliary files to clean (extensions)
AUX_FILES_EXTENSIONS=("aux" "log" "out" "toc" "fls" "fdb_latexmk" "synctex.gz" "xdv") # Added .xdv for XeLaTeX

# --- Script Execution ---

echo "Starting LaTeX CV compilation with $LATEX_ENGINE..."

# Check if the project directory exists
if [ ! -d "$PROJECT_DIR_NAME" ]; then
    echo "Error: Project directory '$PROJECT_DIR_NAME' not found."
    echo "Please ensure this script is in the correct location or adjust PROJECT_DIR_NAME."
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

echo "Compiling '$MAIN_TEX_FILE' with $LATEX_ENGINE..."

# Run the LaTeX engine multiple times
for i in $(seq 1 $LATEX_RUNS); do
    echo "--- $LATEX_ENGINE Run #$i ---"
    "$LATEX_ENGINE" -interaction=nonstopmode -halt-on-error -synctex=1 "$MAIN_TEX_FILE"
    if [ $? -ne 0 ]; then
        echo "Error: $LATEX_ENGINE compilation failed on run #$i."
        echo "Check the log file ($MAIN_TEX_FILE.log) for details."
        cd .. # Go back to the original directory
        exit 1
    fi
done

echo "Compilation finished."

# Check if the default PDF was created and rename it
# XeLaTeX usually outputs main_cv.pdf directly from main_cv.tex
if [ -f "$(basename "$MAIN_TEX_FILE" .tex).pdf" ]; then
    TARGET_PDF_IN_PROJECT_DIR="$(basename "$MAIN_TEX_FILE" .tex).pdf" # Ensure correct target name
    echo "Renaming '$TARGET_PDF_IN_PROJECT_DIR' to '$OUTPUT_PDF_NAME'..."
    mv "$TARGET_PDF_IN_PROJECT_DIR" "$OUTPUT_PDF_NAME"
    if [ $? -eq 0 ]; then
        echo "Successfully renamed PDF to '$OUTPUT_PDF_NAME'."
        echo "Output PDF is available at: $(pwd)/$OUTPUT_PDF_NAME"

        # Automatic cleanup of auxiliary files
        echo "Cleaning up auxiliary files..."
        for ext in "${AUX_FILES_EXTENSIONS[@]}"; do
            find . -maxdepth 1 -name "$(basename "$MAIN_TEX_FILE" .tex).$ext" -delete
        done
        echo "Auxiliary files cleaned."

    else
        echo "Error: Could not rename '$TARGET_PDF_IN_PROJECT_DIR' to '$OUTPUT_PDF_NAME'."
    fi
else
    echo "Error: PDF file '$(basename "$MAIN_TEX_FILE" .tex).pdf' was not created. Check compilation logs."
fi

# Navigate back to the original directory
cd ..
echo "Script finished."

exit 0
