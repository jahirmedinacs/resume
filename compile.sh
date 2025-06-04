#!/bin/bash

# Script to compile the LaTeX CV project using pdflatex,
# output a named PDF, and automatically clean up auxiliary files.

# --- Configuration ---
PROJECT_DIR_NAME="CV_LaTeX"
MAIN_TEX_FILE="main_cv.tex"
OUTPUT_PDF_NAME="Jahir_Medina-CV_eng.pdf"
TARGET_PDF_IN_PROJECT_DIR="main_cv.pdf" # Default output name from pdflatex

# Number of pdflatex runs (2-3 is usually sufficient for most documents)
LATEX_RUNS=3

# Auxiliary files to clean (extensions)
AUX_FILES_EXTENSIONS=("aux" "log" "out" "toc" "fls" "fdb_latexmk" "synctex.gz")

# --- Script Execution ---

echo "Starting LaTeX CV compilation..."

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

echo "Compiling '$MAIN_TEX_FILE' with pdflatex..."

# Run pdflatex multiple times
for i in $(seq 1 $LATEX_RUNS); do
    echo "--- pdflatex Run #$i ---"
    pdflatex -interaction=nonstopmode -halt-on-error "$MAIN_TEX_FILE"
    if [ $? -ne 0 ]; then
        echo "Error: pdflatex compilation failed on run #$i."
        echo "Check the log file ($MAIN_TEX_FILE.log) for details."
        # Optionally, still try to clean up before exiting on failure
        # echo "Cleaning up auxiliary files after error..."
        # for ext in "${AUX_FILES_EXTENSIONS[@]}"; do
        #    rm -f *."$ext"
        # done
        cd .. # Go back to the original directory
        exit 1
    fi
done

echo "Compilation finished."

# Check if the default PDF was created and rename it
if [ -f "$TARGET_PDF_IN_PROJECT_DIR" ]; then
    echo "Renaming '$TARGET_PDF_IN_PROJECT_DIR' to '$OUTPUT_PDF_NAME'..."
    mv "$TARGET_PDF_IN_PROJECT_DIR" "$OUTPUT_PDF_NAME"
    if [ $? -eq 0 ]; then
        echo "Successfully renamed PDF to '$OUTPUT_PDF_NAME'."
        echo "Output PDF is available at: $(pwd)/$OUTPUT_PDF_NAME"

        # Automatic cleanup of auxiliary files
        echo "Cleaning up auxiliary files..."
        for ext in "${AUX_FILES_EXTENSIONS[@]}"; do
            # Using find to delete files matching the main tex file's basename and the extension
            # This is safer than `rm -f *."$ext"` if other .tex files exist
            find . -maxdepth 1 -name "$(basename "$MAIN_TEX_FILE" .tex).$ext" -delete
        done
        echo "Auxiliary files cleaned."

    else
        echo "Error: Could not rename '$TARGET_PDF_IN_PROJECT_DIR' to '$OUTPUT_PDF_NAME'."
        # Decide if you want to clean up even if renaming failed
    fi
else
    echo "Error: '$TARGET_PDF_IN_PROJECT_DIR' was not created. Check compilation logs."
    # Decide if you want to clean up even if PDF wasn't created
fi

# Navigate back to the original directory
cd ..
echo "Script finished."

exit 0
