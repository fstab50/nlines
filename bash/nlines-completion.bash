#!/usr/bin/env bash

# GPL v3 License
#
# Copyright (c) 2018-2019 Blake Huber
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the 'Software'), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


# option strings
declare -a exceptions
exceptions=(
    'p3_env'
    'p3_venv'
    'venv'
    '.git'
    '__pycache__'
)


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
    declare -a container objects

    mapfile -t objects < <(ls $PWD)

    for object in "${objects[@]}"; do
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
    local split='4'       # times to split screen width
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


function _filedir(){
    local i IFS='
' xspec;
    _tilde "$cur" || return 0;
    local -a toks;
    local quoted x tmp;
    _quote_readline_by_ref "$cur" quoted;
    x=$( compgen -d -- "$quoted" ) && while read -r tmp; do
        toks+=("$tmp");
    done <<< "$x";
    if [[ "$1" != -d ]]; then
        xspec=${1:+"!*.@($1|${1^^})"};
        x=$( compgen -f -X "$xspec" -- $quoted ) && while read -r tmp; do
            toks+=("$tmp");
        done <<< "$x";
    fi;
    [[ -n ${COMP_FILEDIR_FALLBACK:-} && -n "$1" && "$1" != -d && ${#toks[@]} -lt 1 ]] && x=$( compgen -f -- $quoted ) && while read -r tmp; do
        toks+=("$tmp");
    done <<< "$x";
    if [[ ${#toks[@]} -ne 0 ]]; then
        compopt -o filenames 2> /dev/null;
        COMPREPLY+=("${toks[@]}");
    fi
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
        --+[-a-z0-9_])
            local argtype=$( LC_ALL=C $1 --help 2>&1 | command sed -ne "s|.*$prev\[\{0,1\}=[<[]\{0,1\}\([-A-Za-z0-9_]\{1,\}\).*|\1|p" );
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
        COMPREPLY=($( compgen -W "$( LC_ALL=C $1 --help 2>&1 | command sed -ne 's/.*\(--[-A-Za-z0-9]\{1,\}=\{0,1\}\).*/\1/p' | sort -u )" -- "$cur" ));
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
    local options numargs numoptions cur prev initcmd

    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    initcmd="${COMP_WORDS[COMP_CWORD-2]}"

    # initialize vars
    COMPREPLY=()
    numargs=0
    numoptions=0

    commands='--help --exclusions --configure --sum --version'

    function _is_sum(){
        if [[ "$(echo "${COMP_WORDS[@]}" | grep '\-\-sum')" ]]; then
            is_sum='yes'
        else
            is_sum='no'
        fi
    }

    case "${prev}" in

        '--help' | '--exclusions' | '--configure')
            return 0
            ;;

        'nlines')
            if [ "$cur" = "" ] || [ "$cur" = "--" ]; then

                _complete_nlines_commands "${commands}"
                return 0

            fi
            ;;

        '--sum')
            _pathopt
            return 0
            ;;

        '--version')
            return 0
            ;;

        *)
            _pathopt
            return 0
            ;;

    esac

    COMPREPLY=( $(compgen -W "${commands}" -- ${cur}) )

} && complete -F _nlines_completions nlines
