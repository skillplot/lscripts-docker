
## execute all bash scripts in the given diectory;
find . -type f -name "*.sh" -exec bash -c 'echo "Executing script: {}"; bash {}' \;
