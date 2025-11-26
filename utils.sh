# Utility functions extracted from install-invoke.sh

# Append a line to a file if not present
append_line() {
    set -e
    local update line file pat lno
    update="$1"
    line="$2"
    file="$3"
    pat="${4:-}"
    echo "Update $file (append):"
    echo "  - $line"
    [ -f "$file" ] || touch "$file"
    if [ $# -lt 4 ]; then
        lno=$(\grep -nF "$line" "$file" | sed 's/:.*//' | tr '\n' ' ')
    else
        lno=$(\grep -nF "$pat" "$file" | sed 's/:.*//' | tr '\n' ' ')
    fi
    if [ -n "$lno" ]; then
        echo "    - Already exists: line #$lno"
    else
        if [ $update -eq 1 ]; then
            echo "$line" >> "$file"
            echo "    + Added"
        else
            echo "    ~ Skipped"
        fi
    fi
}

# Delete a line from a file if present
delete_line() {
    set -e
    local update line file pat lno
    update="$1"
    line="$2"
    file="$3"
    pat="${4:-}"
    echo "Update $file (delete):"
    echo "  - $line"
    [ -f "$file" ] || touch "$file"
    if [ $# -lt 4 ]; then
        lno=$(\grep -nF "$line" "$file" | sed 's/:.*//' | tr '\n' ' ')
    else
        echo "  - pattern: $pat"
        lno=$(\grep -nF "$pat" "$file" | sed 's/:.*//' | tr '\n' ' ')
    fi
    if [ -n "$lno" ]; then
        echo "    - Already exists: line #$lno"
        if sed --version >/dev/null 2>&1 ; then
            # GNU sed
            sed -i --follow-symlinks "${lno}d" $file
        else
            # BSD sed
            sed -i '' -E "${lno}d" $file
        fi
        echo "    - Deleted."
    else
        echo "    ~ Line is not exists. Skipped."
    fi
}

# Insert a line at the beginning of a file if not present
insert_line() {
    set -e
    local update line file pat lno
    update="$1"
    line="$2"
    file="$3"
    pat="${4:-}"
    echo "Update $file (insert):"
    echo "  - $line"
    [ -f "$file" ] || touch "$file"
    if [ $# -lt 4 ]; then
        lno=$(\grep -nF "$line" "$file" | sed 's/:.*//' | tr '\n' ' ')
    else
        echo "  - pattern: $pat"
        lno=$(\grep -nF "$pat" "$file" | sed 's/:.*//' | tr '\n' ' ')
    fi
    if [ -n "$lno" ]; then
        echo "    - Already exists: line #$lno"
    else
        if [ $update -eq 1 ]; then
            if [ -s "$file" ]; then
                if sed --version >/dev/null 2>&1 ; then
                    # GNU sed
                    sed -i --follow-symlinks "1s/^/$line\n/" $file
                else
                    # BSD sed
                    sed -i '' -E "1s/^/$line\n/" $file
                fi
            else
                echo $line > $file
            fi
            echo "    + Added"
        else
            echo "    ~ Skipped"
        fi
    fi
}

# Remove a symlink or file safely
remove_rcfiles_symlink() {
    if [[ -L $1 ]]; then
        echo "Removing symlink: $1"
        \unlink $1
    elif [[ -f $1 ]]; then
        echo "Removing normal file: $1"
        \rm -f $1
    else
        echo "$1 does not exists. Doing nothing."
    fi
}

# Backup a file with rotating backups
backup_file() {
    # .~rc exists
    if [[ -e "$1" ]]; then
        # .~rc.bak0 exists
        if [[ -e "$1.bak0" ]]; then
            # .~rc differs from .~rc.bak0
            if [[ $(diff "$1" "$1.bak0") ]]; then
                for idx in $(seq 3 -1 0); do
                    if [[ -e "$1.bak$idx" ]]; then
                        echo "Renaming exist backup"
                        echo "  from: $1.bak$idx"
                        echo "  to:   $1.bak$(($idx+1))"
                        mv "$1.bak$idx" "$1.bak$(($idx+1))"
                    fi
                done
            fi
        fi
        if [[ ! -d $1 ]]; then
            echo "Making backup"
            echo "  from: $1"
            echo "  to:   $1.bak0"
            cp $1 $1.bak0
        fi
    fi
}
