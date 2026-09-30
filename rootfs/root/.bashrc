# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias vi='vim'
alias cp='cp -i '
alias listbigfile='find . -type f -size +5M -exec ls -lh {} + | sort -hr'
alias bigfile='find . -type f -size +5M ! -path "*/build/*" ! -path "*/out/*" -exec ls -lh {} + | sort -hr'
alias myfind='find ./ -type f -name "*" -print | xargs grep -nH '
alias myfindinc='find ./ -name "*.c" -print | xargs grep -nH '
alias myfindinh='find ./ -name "*.h" -print | xargs grep -nH '
alias myfindinjava='find ./ -name "*.java" -print | xargs grep -nH '
alias myfindincpp='find ./ -name "*.cpp" -print | xargs grep -nH '
alias myfindincc='find ./ -name "*.cc" -print | xargs grep -nH '
alias myfindincxx='find ./ -name "*.cxx" -print | xargs grep -nH '

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export PS1='[\u@\h \W]\$ '
export XDG_RUNTIME_DIR=/tmp/xdg-runtime-${UID}
mkdir -p "$XDG_RUNTIME_DIR" 2>/dev/null
chmod 700 "$XDG_RUNTIME_DIR" 2>/dev/null
