
if command -v "brew" &> /dev/null; then
    ialias bulo='brew update && brew outdated'
    ialias bucu='brew upgrade && brew cleanup'
    ialias bli='brew list -1'
fi

