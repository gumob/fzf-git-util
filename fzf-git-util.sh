function fzf-git-util() {
  ######################
  ### Option Parser
  ######################

  local __parse_options (){
    local prompt="$1" && shift
    local option_list
    if [[ "$SHELL" == *"/bin/zsh" ]]; then
      option_list=("$@")
    elif [[ "$SHELL" == *"/bin/bash" ]]; then
      local -n arr_ref=$1
      option_list=("${arr_ref[@]}")
    fi

    ### Select the option
    selected_option=$(printf "%s\n" "${option_list[@]}" | fzf --ansi --prompt="${prompt} > ")
    if [[ -z "$selected_option" || "$selected_option" =~ ^[[:space:]]*$ ]]; then
      return 1
    fi

    ### Normalize the option list
    local option_list_normal=()
    for option in "${option_list[@]}"; do
        # Remove $(tput bold) and $(tput sgr0) from the string
        option_normalized="${option//$(tput bold)/}"
        option_normalized="${option_normalized//$(tput sgr0)/}"
        # Add the normalized string to the new array
        option_list_normal+=("$option_normalized")
    done
    ### Get the index of the selected option
    index=$(printf "%s\n" "${option_list_normal[@]}" | grep -nFx "$selected_option" | cut -d: -f1)
    if [ -z "$index" ]; then
      return 1
    fi

    ### Generate the command
    command=""
    if [[ "$SHELL" == *"/bin/zsh" ]]; then
      command="${option_list_normal[$index]%%:*}"
    elif [[ "$SHELL" == *"/bin/bash" ]]; then
      command="${option_list_normal[$index-1]%%:*}"
    else
      echo "Error: Unsupported shell. Please use bash or zsh to use fzf-git-util."
      return 1
    fi
    echo $command
    return 0
  }

  ######################
  ### Git Fuzzy
  ######################

  local __git-fuzzy() {
    local option_list=(
      "git fuzzy status:     Interact with staged and unstaged changes."
      "git fuzzy branch:     Search for, checkout and look at branches."
      "git fuzzy log:        Look for commits in git log. Typing in the search simply filters in the usual fzf style."
      "git fuzzy reflog:     Look for entries in git reflog. Typing in the search simply filters in the usual fzf style."
      "git fuzzy stash:      Look for entries in git stash. Typing in the search simply filters in the usual fzf style."
      "git fuzzy diff:       Interactively select diff subjects. Drilling down enables searching through diff contents in a diff browser."
      "git fuzzy pr:         Interactively select and open/diff GitHub pull requests."
    )
    command=$(__parse_options "git fuzzy" ${option_list[@]})
    if [ $? -eq 1 ]; then
        zle accept-line
        zle -R -c
        return 1
    fi
    case "$command" in
      "git fuzzy status") BUFFER="git fuzzy status";;
      "git fuzzy branch") BUFFER="git fuzzy branch";;
      "git fuzzy log") BUFFER="git fuzzy log";;
      "git fuzzy reflog") BUFFER="git fuzzy reflog";;
      "git fuzzy stash") BUFFER="git fuzzy stash";;
      "git fuzzy diff") BUFFER="git fuzzy diff";;
      "git fuzzy pr") BUFFER="git fuzzy pr";;
      *) BUFFER="echo \"Error: Unknown command '$command\"";;
    esac
  }

  ######################
  ### gh-f
  ######################

  local __git-f() {
    local option_list=(
      "gh f adds:      Adds files to the staging area"
      "gh f runs:      Shows GitHub workflow runs and filters logs"
      "gh f greps:     Greps in files in revision history"
      "gh f prs:       Views, diffs, and checkouts open PRs"
      "gh f branches:  Checkouts and diffs branches"
      "gh f diffs:     Diffs files by extension"
      "gh f logs:      Selects commits and shows diffs"
      "gh f tags:      Checkouts and diffs version tags"
      "gh f search:    Searches issues in any repository"
      "gh f myissue:   Searches issues you opened somewhere"
      "gh f pick:      Cherrypicks files from one branch to the other"
      "gh f envs:      Shows git config list"
    )
    command=$(__parse_options "git f" ${option_list[@]})
    if [ $? -eq 1 ]; then
        zle accept-line
        zle -R -c
        return 1
    fi
    case "$command" in
      "gh f adds") __gh-f-adds;;
      "gh f runs") __gh-f-runs;;
      "gh f greps") __gh-f-greps;;
      "gh f prs") __gh-f-prs;;
      "gh f branches") __gh-f-branches;;
      "gh f diffs") __gh-f-diffs;;
      "gh f logs") __gh-f-logs;;
      "gh f tags") __gh-f-tags;;
      "gh f search") __gh-f-search;;
      "gh f myissue") __gh-f-myissue;;
      "gh f pick") __gh-f-pick;;
      "gh f envs") __gh-f-envs;;
      *) echo "Error: Unknown command '$command'" ;;
    esac
  }
  local __gh-f-adds() { BUFFER="gh f adds"; }
  local __gh-f-runs() { BUFFER="gh f runs"; }
  local __gh-f-greps() { BUFFER="gh f greps"; }
  local __gh-f-prs() { BUFFER="gh f prs"; }
  local __gh-f-branches() { BUFFER="gh f branches"; }
  local __gh-f-diffs() { BUFFER="gh f diffs"; }
  local __gh-f-logs() { BUFFER="gh f logs"; }
  local __gh-f-tags() { BUFFER="gh f tags"; }
  local __gh-f-search() { BUFFER="gh f search"; }
  local __gh-f-myissue() { BUFFER="gh f myissue"; }
  local __gh-f-pick() { BUFFER="gh f pick"; }
  local __gh-f-envs() { BUFFER="gh f envs"; }

  ######################
  ### Entry Point
  ######################

  local init() {
    local option_list=(
      "$(tput bold)ghq:$(tput sgr0)          Run ghq commands."
      "$(tput bold)git fuzzy:$(tput sgr0)    Run git fuzzy commands."
      # "$(tput bold)gh f:$(tput sgr0)        Run gh f commands."
    )
    if command -v fzf-opencommit &> /dev/null; then
      option_list+=("$(tput bold)opencommit:$(tput sgr0)   Run opencommit commands.")
    fi
    local command=$(__parse_options "git" ${option_list[@]})
    if [ $? -eq 1 ]; then
        zle accept-line
        zle -R -c
        return 1
    fi
    case "$command" in
      "ghq") fzf-ghq;;
      "git fuzzy") __git-fuzzy;;
      # "gh f") __git-f;;
      "opencommit") fzf-opencommit;;
      *) echo "Error: Unknown command '$command'" ;;
    esac

    zle accept-line
    zle -R -c
  }

  init
}

zle -N fzf-git-util
if [[ "$SHELL" == *"/bin/zsh" ]]; then
  bindkey "${FZF_GIT_UTIL_KEY_BINDING}" fzf-git-util
elif [[ "$SHELL" == *"/bin/bash" ]]; then
  bind -x "'${FZF_GIT_UTIL_KEY_BINDING}': fzf-git-util"
fi