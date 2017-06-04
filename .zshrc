# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="jaischeema"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git apache2-macports git-extras macports osx web-search zsh-syntax-highlighting)

# source
# http://code.tutsplus.com/tutorials/how-to-customize-your-command-prompt--net-24083
# http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
# http://usefulshortcuts.com/downloads/ALT-Codes.pdf
# http://stackoverflow.com/questions/1348842/what-should-i-set-java-home-to-on-osx

source $ZSH/oh-my-zsh.sh

function virtualenv-info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`')'
}

# Get current day/Time
function henryh-date {
    date '+%a %Y-%m-%d %T'
}

# Add space between 
function put_spacing {
    # ${COLUMNS}: a size of a terminal window
    local term_width
    (( term_width = ${COLUMNS} - 1 ))

    local fill_bar=""
    local pwd_len=""

    local user="%n"
    local host="%M"
    local current_dir="%~"
    local date="$(henryh-date)"

    local left_left_prompt_size=${#${(%):-╭╔ ${user}@${host} $(virtualenv-info) ${current_dir}}}

    local left_right_prompt_size=${#${(%):-${date}}}
    local left_prompt_size
    (( left_prompt_size = ${left_left_prompt_size} + ${left_right_prompt_size} ))

    if [[ "$left_prompt_size" -gt $term_width ]]; then
        ((pwd_len=$term_width - $left_prompt_size))
    else
        fill_bar="${(l.(($term_width - $left_prompt_size - 5)).. .)}"
    fi
    
    echo "%{$fg[white]%} ${fill_bar} %{$reset_color%}"
}

# Git variables
ZSH_THEME_GIT_PROMPT_PREFIX="%{$terminfo[bold]$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$terminfo[bold]$fg[red]%} ✘"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$terminfo[bold]$fg[yellow]%} °"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$terminfo[bold]$fg[green]%} ✔"

# Login information - source <http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html>
# %n username / %M the full machine hostname / %m the hostname up to the first '.' / %~ the current working directory starts with $HOME, that part is replaced by a ‘~’
# %B%b start(stop) bold-faced mode
local user_host='%{$terminfo[bold]$fg[green]%}%n%{$fg[white]%}@%{$fg[red]%}%M%{$reset_color%}'
local virtual_env_info='$(virtualenv-info)'
local current_dir='%{$terminfo[bold]$fg[blue]%}%~%{$reset_color%}'
local more_space='$(put_spacing)'
local date_time='%{$terminfo[bold]$fg[cyan]%}$(henryh-date)%{$reset_color%}'
local return_code="%(?..%{$terminfo[bold]$fg[red]%}%? ↵%{$reset_color%})"

PROMPT="
╭╔ ${user_host} ${virtual_env_info} ${current_dir} ${more_space} ${date_time}
╰╚%B%b "

RPROMPT='${return_code} $(git_prompt_info) '

# Some useful alias
alias sd="sudo shutdown -h now"
alias rs="sudo shutdown -r now"

# PATH
export PATH=/usr/share/python:$PATH
export PATH=$PATH:/usr/local/mysql/bin # MySql path

# UTF8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Determine platform
local unamestr=$(uname)
local platform="" 
if [[ $unamestr == "Linux" ]]; then
    platform="Linux"
elif [[ $unamestr == "Darwin" ]]; then
    platform="Mac"
fi

# Some config
if [[ $platform == "Linux" ]]; then
    # show details for ls command
    alias ls='ls -aCFho --color=auto'
elif [[ $platform == "Mac" ]] then
    #GNU version commands
    export PATH=/opt/local/libexec/gnubin:$PATH

    # Macports-home path
    export PATH=$HOME/macports/bin:$HOME/macports/sbin:$PATH
    export MANPATH=$HOME/macports/share/man:$MANPATH
    export PATH=$HOME/bin/macports/libexec/gnubin:$PATH
    export PERL5LIB=$HOME/macports/lib/perl5/5.12.4:$HOME/macports/lib/perl5/vendor_perl/5.12.4:$PERL5LIB

    # Macports-system path
    export PATH=$PATH:/opt/local/bin:/opt/local/sbin

    # Some useful alias
    alias port-home='$HOME/macports/bin/port'
    alias port-system='sudo /opt/local/bin/port'
    alias wifion="networksetup -setairportpower en1 on"
    alias wifioff="networksetup -setairportpower en1 off"
    alias wifirs="networksetup -setairportpower en1 off && networksetup -setairportpower en1 on"
    
    # ls alias when macports and no macports
    if [ -f $HOME/bin/macports/libexec/gnubin/ls ]; then
        alias ls='ls -aCFho --color=auto'
    else
        alias ls='ls -aCFho -G'
    fi
fi

# Unused
# export DHIS2_HOME="/Volumes/Data/apple/DHIS_HOME" # Point to a DHIS directory
# export MAVEN_OPTS="-Xmx512m -XX:MaxPermSize=512m" # Increased memory for Maven
# export CATALINA_OPTS="-Xms10m -Xmx1024m"          # Increased memory for Tomcat
# export JAVA_HOME=$(/usr/libexec/java_home) # Declare Java_home
