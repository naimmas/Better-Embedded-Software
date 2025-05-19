_makefile_completions()
{
    if [ ! -e ./Makefile ] && ! compgen -G "./*.mk" > /dev/null; then
        return
    fi

    # filter out flag arguments
    filtered_comp_words=()
    for comp_word in ${COMP_WORDS[@]}; do
        if [[ $comp_word != -* ]]; then
            filtered_comp_words+=("$comp_word")
        fi
    done

    # do nothing if a non-flag argument has already been added
    if [[ "${#filtered_comp_words[@]}" -gt 2 ]]; then
        return
    fi

    word_list=()
    # If a Makefile exists in the current directory
    if [ -e ./Makefile ]; then
        # runs 'make -d' to output debug information and 
        # uses 'sed' to extract the paths of the makefiles that are being read.
        for filepath in $(make -d 2>/dev/null | sed -n "s/^Reading makefile ['\`]\(.*\)['\`].*/\1/p"); do
            # For each extracted file path, it greps for lines that seem to define a make target
            # lines starting with valid target characters and ending with a colon).
            # It then cleans up the extracted target names using 'sed' to remove everything
            # after the colon and ensures uniqueness with 'uniq', appending them to 'word_list'.
            word_list+="$(grep '^[^.%][-a-zA-Z\.0-9_\/]*:' "$filepath" | sed 's/:.*//g' | uniq) "
        done
    # If no Makefile exists but files with the '.mk' extension are present,
    # it processes each '.mk' file using a similar method to extract target names.
    elif compgen -G "./*.mk" > /dev/null; then
        for filepath in ./*.mk; do
            word_list+="$(grep '^[^.%][-a-zA-Z\.0-9_\/]*:' "$filepath" | sed 's/:.*//g' | uniq) "
        done
    fi

    COMPREPLY=($(compgen -W "${word_list}" "${filtered_comp_words[1]}"))
}

complete -o nospace -F _makefile_completions make
