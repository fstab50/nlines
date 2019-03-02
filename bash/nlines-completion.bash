#!/usr/bin/env bash


function current_branch(){
    ##
    ##  returns current working branch
    ##
    echo "$(git branch 2>/dev/null | grep '\*' | awk '{print $2}')"
}


function _git_root(){
    ##
    ##  determines full path to current git project root
    ##
    echo "$(git rev-parse --show-toplevel 2>/dev/null)"
}


function _filter_objects(){
    ##
    ##  returns file objects in pwd; minus exception list members
    ##
    declare -a container

    for object in $(ls $PWD); do
        if [[ $(echo "${exceptions[@]}" | grep $object) ]]; then
            continue
        else
            container=( "${container[@]}" "$object" )
        fi
    done
    echo "${container[@]}"
    return 0
}


function _complete_nlines_commands(){
    local cmds="$1"
    local split='6'       # times to split screen width
    local ct="0"
    local IFS=$' \t\n'
    local formatted_cmds=( $(compgen -W "${cmds}" -- "${COMP_WORDS[1]}") )

    for i in "${!formatted_cmds[@]}"; do
        formatted_cmds[$i]="$(printf '%*s' "-$(($COLUMNS/$split))"  "${formatted_cmds[$i]}")"
    done

    COMPREPLY=( "${formatted_cmds[@]}")
    return 0
    #
    # <-- end function _complete_nlines_commands -->
}


function _pathopt(){
    ##
    ##  bash v4.4 profile reference function
    ##
    local cur prev words cword split;

    _init_completion -s || return;

    case "${prev,,}" in
        --help | --usage | --version)
            return
        ;;
        --*dir*)
            _filedir -d;
            return
        ;;
        --*file* | --*path*)
            _filedir;
            return
        ;;
        --+([-a-z0-9_]))
            local argtype=$( LC_ALL=C $1 --help 2>&1 | command sed -ne                 "s|.*$prev\[\{0,1\}=[<[]\{0,1\}\([-A-Za-z0-9_]\{1,\}\).*|\1|p" );
            case ${argtype,,} in
                *dir*)
                    _filedir -d;
                    return
                ;;
                *file* | *path*)
                    _filedir;
                    return
                ;;
            esac
        ;;
    esac;
    $split && return;
    if [[ "$cur" == -* ]]; then
        COMPREPLY=($( compgen -W "$( LC_ALL=C $1 --help 2>&1 |             command sed -ne 's/.*\(--[-A-Za-z0-9]\{1,\}=\{0,1\}\).*/\1/p' | sort -u )"             -- "$cur" ));
        [[ $COMPREPLY == *= ]] && compopt -o nospace;
    else
        if [[ "$1" == @(rmdir|chroot) ]]; then
            _filedir -d;
        else
            [[ "$1" == mkdir ]] && compopt -o nospace;
            _filedir;
        fi;
    fi
}


function _nlines_completions(){
    ##
    ##  Completion structures for nlines exectuable
    ##
    local numargs numoptions cur prev prevcmd

    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    initcmd="${COMP_WORDS[COMP_CWORD-2]}"
    #echxo "cur: $cur, prev: $prev"

    # initialize vars
    COMPREPLY=()
    numargs=0
    numoptions=0

    # option strings
    declare -a exceptions
    exceptions=(
        'p3_env'
        'p3_venv'
        'venv'
        '.git'
    )

    objects=$(_filter_objects)


    case "${prev}" in

        "nlines")
            if [ "$cur" = "" ] || [ "$cur" = "-" ] || [ "$cur" = "--" ]; then
                # relative path given by user
                _complete_nlines_commands "${objects}"

            elif [ "$(echo "$cur" | cut -c 1)" = "/" ]; then
                # absolute path given by user
                _pathopt

            else
                _pathopt
            fi
            return 0
            ;;
    esac

    COMPREPLY=( $(compgen -W "${objects}" -- ${cur}) )

} && complete -F _nlines_completions nlines
