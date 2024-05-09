# Depends on the git plugin for work_in_progress()
(( $+functions[work_in_progress] )) || work_in_progress() {}

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[cyan]%}(%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[cyan]%}) "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Customized git status, oh-my-zsh currently does not allow render dirty status before branch
git_custom_status() {
  local branch=$(git_current_branch)
  [[ -n "$branch" ]] || return 0
  print "%{${fg_bold[yellow]}%}$(work_in_progress)%{$reset_color%}\
${ZSH_THEME_GIT_PROMPT_PREFIX}$(parse_git_dirty)${branch}\
${ZSH_THEME_GIT_PROMPT_SUFFIX}"
}
autoload -U colors && colors

#export VCS_PROMPT=hg_prompt_info
export VCS_PROMPT=git_custom_status

base_prompt="%{$fg[yellow]%}%m %{$fg[cyan]%}[%~% ]%(?.%{$fg[green]%}.%{$fg[red]%})%B"
custom_prompt=""
last_run_time=""
last_vcs_info=""
last_last="%{$fg[red]%}$%b "


# Combine it all into a final right-side prompt
# PROMPT='%{$fg[cyan]%}[%~% ]%(?.%{$fg[green]%}.%{$fg[red]%})%B$%b '
function preexec() {
    last_run_time=$(perl -MTime::HiRes=time -e 'printf "%.9f\n", time')
}

function duration() {
    local duration
    local now=$(perl -MTime::HiRes=time -e 'printf "%.9f\n", time')
    local last=$1
    local last_split=("${(@s/./)last}")
    local now_split=("${(@s/./)now}")
    local T=$((now_split[1] - last_split[1]))
    local D=$((T/60/60/24))
    local H=$((T/60/60%24))
    local M=$((T/60%60))
    local S=$((T%60))
    local s=$(((now_split[2] - last_split[2]) / 1000000000.))
    local m=$(((now_split[2] - last_split[2]) / 1000000.))

    (( $D > 0 )) && duration+="${D}d"
    (( $H > 0 )) && duration+="${H}h"
    (( $M > 0 )) && duration+="${M}m"

    if [[ $S -gt 5 ]]; then
        if ! [[ -z $duration ]] && printf "%s" "$duration"
        local sec_milli=$((S + s))
        printf "%.3fs" "$sec_milli"
    fi
}

function precmd() {
    local info=""

    if [ ! -z "$last_run_time" ]; then
        local elapsed=$(duration $last_run_time)
        if [ -z "$elapsed" ]; then
            info=$(printf "%s%s%s%s%s" "%{$fg[cyan]%}" "$RETVAL")
        else
            last_run_time=$(print $last_run_time | tr -d ".")
            if [ $(( $(perl -MTime::HiRes=time -e 'printf "%.9f\n", time' | tr -d ".") - $last_run_time )) -gt $(( 120 * 1000 * 1000 * 1000 )) ]; then
                local elapsed_color="%{$fg[magenta]%}"
            elif [ $(( $(perl -MTime::HiRes=time -e 'printf "%.9f\n", time' | tr -d ".") - $last_run_time )) -gt $(( 60 * 1000 * 1000 * 1000 )) ]; then
                local elapsed_color="%{$fg[red]%}"
            elif [ $(( $(perl -MTime::HiRes=time -e 'printf "%.9f\n", time' | tr -d ".") - $last_run_time )) -gt $(( 10 * 1000 * 1000 * 1000 )) ]; then
                local elapsed_color="%{$fg[yellow]%}"
            else
                local elapsed_color="%{$fg[green]%}"
            fi
            info=$(printf "%s%s%s%s%s" "%{$fg[cyan]%}[" "$elapsed_color" "$elapsed" "%{$fg[cyan]%}]")
        fi
        unset last_run_time
    fi

    if [ -z "$info" -a ! -z "$last_vcs_info" ]; then
        custom_prompt="$base_prompt$last_vcs_info$last_last"
        return;
    fi

    if (( ${+VCS_PROMPT} )); then
        last_vcs_info=$($VCS_PROMPT)
        if [ ! -z "$last_vcs_info" ]; then
            [ -z "$info" ] && info=$last_vcs_info || info="$last_vcs_info$info"
        fi
    fi

    [ -z "$info" ] && custom_prompt="$base_prompt$last_last" || custom_prompt="$base_prompt$info$last_last"
}


setopt PROMPT_SUBST
PROMPT='$custom_prompt'

