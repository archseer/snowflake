#
# Smart URLs
#

# This logic comes from an old version of zim. Essentially, bracketed-paste was
# added as a requirement of url-quote-magic in 5.1, but in 5.1.1 bracketed
# paste had a regression. Additionally, 5.2 added bracketed-paste-url-magic
# which is generally better than url-quote-magic so we load that when possible.
autoload -Uz bracketed-paste-url-magic
zle -N bracketed-paste bracketed-paste-url-magic

# TODO: obsolete?
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

#
# General
#

setopt COMBINING_CHARS      # Combine zero-length punctuation characters (accents)
                            # with the base character.
setopt INTERACTIVE_COMMENTS # Enable comments in interactive shell.
setopt RC_QUOTES            # Allow 'Henry''s Garage' instead of 'Henry'\''s Garage'.
unsetopt MAIL_WARNING       # Don't print a warning message if a mail file has been accessed.

# Allow mapping Ctrl+S and Ctrl+Q shortcuts
[[ -r ${TTY:-} && -w ${TTY:-} && $+commands[stty] == 1 ]] && stty -ixon <$TTY >$TTY

#
# Jobs
#

setopt LONG_LIST_JOBS     # List jobs in the long format by default.
setopt AUTO_RESUME        # Attempt to resume existing job before creating a new process.
setopt NOTIFY             # Report status of background jobs immediately.
unsetopt BG_NICE          # Don't run all background jobs at a lower priority.
unsetopt HUP              # Don't kill jobs on shell exit.
unsetopt CHECK_JOBS       # Don't report on jobs when shell exit.

#
# History
#

setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.

HISTFILE="${HISTFILE:-${ZDOTDIR:-$HOME}/.zhistory}"  # The path to the history file.
HISTSIZE=10000                   # The maximum number of events to save in the internal history.
SAVEHIST=10000                   # The maximum number of events to save in the history file.

#
# Directory
#

setopt AUTO_CD              # Auto changes to a directory without typing cd.
setopt AUTO_PUSHD           # Push the old directory onto the stack on cd.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.
setopt PUSHD_TO_HOME        # Push to home directory when no argument is given.
setopt CDABLE_VARS          # Change directory to a path stored in a variable.
setopt MULTIOS              # Write to multiple descriptors.
setopt EXTENDED_GLOB        # Use extended globbing syntax.
# unsetopt CLOBBER            # Do not overwrite existing files with > and >>.
#                             # Use >! and >>! to bypass.

#
# Prompt
#
# Load and execute the prompt theming system.
autoload -Uz promptinit && promptinit f

# function +vi-git_status {
#   # Check for untracked files or updated submodules since vcs_info does not.
#   if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
#     hook_com[unstaged]='*'
#   fi
# }

function prompt_hyrule_precmd {
  vcs_info
}

# setopt LOCAL_OPTIONS
# unsetopt XTRACE KSH_ARRAYS
prompt_opts=(cr percent sp subst)

# Load required functions.
autoload -Uz add-zsh-hook
autoload -Uz vcs_info

# Add hook for calling vcs_info before each command.
add-zsh-hook precmd prompt_hyrule_precmd

# Set vcs_info parameters.
zstyle ':vcs_info:*' enable git hg svn
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr '*'
zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vcs_info:*' formats '[%b%c%u]'
zstyle ':vcs_info:*' actionformats "[%b%c%u|%a]"
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b|%r'
zstyle ':vcs_info:git*+set-message:*' hooks git_status

# zstyle ':prezto:module:editor:info:keymap:primary' format 'λ'
# zstyle ':prezto:module:editor:info:keymap:primary:insert' format 'I'
# zstyle ':prezto:module:editor:info:keymap:primary:overwrite' format 'O'
# zstyle ':prezto:module:editor:info:keymap:alternate' format '∆'
# zstyle ':prezto:module:editor:info:completing' format '...'

# Define prompts.
PROMPT=$'%F{blue}┌─%f%F{magenta}%n@%m%f%F{green}[%c]%f%F{blue}${vcs_info_msg_0_}%f\n %F{blue}└─ λ %f'

