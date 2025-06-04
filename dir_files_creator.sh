#!/bin/bash

# Script to create the directory structure and empty files for a LaTeX CV project
# It accepts a base directory as a command-line argument.

# --- CONFIGURATION ---

# Define the fixed project directory name
PROJECT_NAME="CV_LaTeX"

# Define the sections subdirectory name
SECTIONS_DIR="sections"

# Define the main TeX file
MAIN_TEX_FILE="main_cv.tex"

# Define the TeX files within the sections directory
SECTION_FILES=(
    "00_personal_info.tex"
    "01_experience.tex"
    "02_education.tex"
    "03_skills.tex"
    "04_academic_experience.tex"
    "05_awards_achievements.tex"
    "06_certifications_courses.tex"
    "07_languages.tex"
    "08_research_topics.tex"
)

# --- SCRIPT EXECUTION ---

# Check if a base directory argument is provided
if [ -z "$1" ]; then
    echo "Error: No base directory provided."
    echo "Usage: $0 <base_directory_path>"
    exit 1
fi

BASE_DIRECTORY="$1"
PROJECT_DIR="$BASE_DIRECTORY/$PROJECT_NAME" # Full path to the CV_LaTeX project directory

echo "Base directory set to: $BASE_DIRECTORY"
echo "Creating LaTeX CV project structure in '$PROJECT_DIR'..."

# Check if the base directory exists, if not, offer to create it or exit
if [ ! -d "$BASE_DIRECTORY" ]; then
    echo "Warning: Base directory '$BASE_DIRECTORY' does not exist."
    read -p "Do you want to create it? (y/n): " create_base_dir
    if [[ "$create_base_dir" == "y" || "$create_base_dir" == "Y" ]]; then
        mkdir -p "$BASE_DIRECTORY"
        if [ $? -eq 0 ]; then
            echo "Created base directory: $BASE_DIRECTORY"
        else
            echo "Error: Could not create base directory '$BASE_DIRECTORY'. Exiting."
            exit 1
        fi
    else
        echo "Exiting script as base directory does not exist and was not created."
        exit 1
    fi
fi

# Create the main project directory (CV_LaTeX)
if [ -d "$PROJECT_DIR" ]; then
    echo "Project directory '$PROJECT_DIR' already exists. Skipping creation."
else
    mkdir "$PROJECT_DIR"
    if [ $? -eq 0 ]; then
        echo "Created project directory: $PROJECT_DIR"
    else
        echo "Error: Could not create project directory '$PROJECT_DIR'. Exiting."
        exit 1
    fi
fi

# Create the main TeX file in the project directory
MAIN_TEX_FILE_PATH="$PROJECT_DIR/$MAIN_TEX_FILE"
touch "$MAIN_TEX_FILE_PATH"
if [ $? -eq 0 ]; then
    echo "Created file: $MAIN_TEX_FILE_PATH"
else
    echo "Error: Could not create file '$MAIN_TEX_FILE_PATH'."
fi

# Create the sections subdirectory
SECTIONS_FULL_PATH="$PROJECT_DIR/$SECTIONS_DIR"
if [ -d "$SECTIONS_FULL_PATH" ]; then
    echo "Directory '$SECTIONS_FULL_PATH' already exists. Skipping creation."
else
    mkdir "$SECTIONS_FULL_PATH"
    if [ $? -eq 0 ]; then
        echo "Created directory: $SECTIONS_FULL_PATH"
    else
        echo "Error: Could not create directory '$SECTIONS_FULL_PATH'. Exiting."
        exit 1
    fi
fi

# Create the TeX files within the sections subdirectory
for file in "${SECTION_FILES[@]}"; do
    FILE_PATH="$SECTIONS_FULL_PATH/$file"
    touch "$FILE_PATH"
    if [ $? -eq 0 ]; then
        echo "Created file: $FILE_PATH"
    else
        echo "Error: Could not create file '$FILE_PATH'."
    fi
done

echo ""
echo "CV project structure and empty files created successfully in '$PROJECT_DIR'."
echo "You can now populate these files with your LaTeX content."

exit 0
