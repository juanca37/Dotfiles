# Function to get installed extensions
get_installed_extensions() {
    code --list-extensions
}

# Read and parse extensions.txt (ignore comments and empty lines)
DESIRED_EXTENSIONS=()
while IFS= read -r line; do
    # Strip comments and trim whitespace
    clean_line="${line%%#*}"         # Remove everything after #
    clean_line="${clean_line## }"    # Remove leading whitespace
    clean_line="${clean_line%% }"    # Remove trailing whitespace
    
    if [[ -n "$clean_line" ]]; then
        DESIRED_EXTENSIONS+=("$clean_line")
    fi
done <  ./extensions.txt

# Install extensions from manifest
echo "=== Installing extensions from manifest ==="
for ext in "${DESIRED_EXTENSIONS[@]}"; do
    echo "• Installing: $ext"
    code --install-extension "$ext" --force
done

# Compare installed vs desired
echo -e "\n=== Extension Comparison ==="
INSTALLED_EXTENSIONS=($(get_installed_extensions))
EXTRA_EXTENSIONS=()

# Find extra extensions (installed but not in manifest)
echo ${INSTALLED_EXTENSIONS[@]}
for installed in "${INSTALLED_EXTENSIONS[@]}"; do
    found=0
    for desired in "${DESIRED_EXTENSIONS[@]}"; do
        if [[ "$installed" == "$desired" ]]; then
            found=1
            break
        fi
    done
    
    if [[ $found -eq 0 ]]; then
        EXTRA_EXTENSIONS+=("$installed")
    fi
done

# Report results
if [[ ${#EXTRA_EXTENSIONS[@]} -gt 0 ]]; then
    echo "Extensions installed but not in manifest:"
    for extra in "${EXTRA_EXTENSIONS[@]}"; do
        echo "  - $extra"
    done
else
    echo "No extra extensions found (all installed extensions are in manifest)"
fi

echo -e "\n=== Summary ==="
echo "Desired extensions in manifest: ${#DESIRED_EXTENSIONS[@]}"
echo "Currently installed extensions: ${#INSTALLED_EXTENSIONS[@]}"
echo "Extra extensions found: ${#EXTRA_EXTENSIONS[@]}"
