#!/usr/bin/env bash

function main() {
  function setup_aliases() {
    alias ls="ls --color"
    alias sl="ls --color"
    alias vim="nvim"
    alias vi="nvim"
    alias ll="ls -al"
    alias gst="git status"
    alias gap="git add -p"
    alias k="kubectl"
  }

  function setup_environment() {
    export CLICOLOR=1
    export LSCOLORS exfxcxdxbxegedabagacad

    # go environment
    export GOPATH="${HOME}/go"

    export EDITOR="nvim"

    function _bgjobs() {
      local count
      count="$(jobs | wc -l | tr -d ' ')"

      if [[ "${count}" == "1" ]]; then
        printf "%s" "${count} job "
      elif [[ "${count}" != "0" ]]; then
        printf "%s" "${count} jobs "
      fi
    }

    function _gitstatus() {
      local branch
      branch="$(git branch 2>/dev/null | grep '^\*' | colrm 1 2)"

      if [[ "${branch}" != "" ]]; then
        local raw status val
        raw="$(git status --short 2>&1)"

        for t in M A D R C U ?; do
          val="$(echo "${raw}" | grep -c "^${t}\|^.${t}")"

          if [[ "${val}" != 0 ]]; then
            status="${status} ${val}${t}"
          fi
        done

        if [[ "${status}" != "" ]]; then
          local lightyellow reset
          lightyellow="\e[93m"
          reset="\e[0m"
          status=":${lightyellow}${status}${reset}"
        fi

        status="${branch}${status}"

        printf "[%s]" "${status}"
      fi
    }

    function _prompt() {
      local status="${?}"

      local reset lightblue lightgreen lightred
      reset="\e[0m"
      lightblue="\e[94m"
      lightgreen="\e[92m"
      lightred="\e[91m"

      if [[ "${status}" != "0" ]]; then
        status="$(printf "%s" " ☠️  ${lightred}{${status}}${reset}")"
      else
        status=""
      fi

      local gitstatus
      gitstatus="$(_gitstatus)"

      PS1="${lightblue}\\d${reset} \\t ${lightred}\$(_bgjobs)${reset}${lightgreen}\\w${reset} ${lightblue}${CODER_WORKSPACE_NAME}${reset} ${gitstatus}${status}\n ‣ "
    }

    if [[ "${PROMPT_COMMAND}" != *"_prompt"* ]]; then
      PROMPT_COMMAND="_prompt;$PROMPT_COMMAND"
    fi
  }

  function setup_colors() {
    local colorscheme
    colorscheme="${HOME}/.config/colorschemes/scripts/base16-tomorrow-night.sh"

    [[ -s "${colorscheme}" ]] && source "${colorscheme}"
  }

  function setup_completions() {
    [ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
  }

  local dependencies
    dependencies=(
        aliases
        environment
        colors
        completions
      )

  for dependency in "${dependencies[@]}"; do
    eval "setup_${dependency}"
    unset -f "setup_${dependency}"
  done
}

function reload() {
  source "${HOME}/.bash_profile"
}

function pullify() {
  git config --add remote.origin.fetch '+refs/pull/*/head:refs/remotes/origin/pr/*'
  git fetch
}

main
unset -f main
