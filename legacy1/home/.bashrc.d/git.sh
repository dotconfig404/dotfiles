

git_status() {
    echo "["
    untracked=$(git status | grep 'ntracked files' 2> /dev/null)
    if [ -n "$untracked" ]; then
        echo  "+"
    fi
    to_commit=$(git status | grep 'Changes not staged for commit' 2> /dev/null)
    if [ -n "$to_commit" ]; then
        echo "~"
    fi
    is_ahead=$(git status | grep 'Your branch is ahead of' 2> /dev/null)
    if [ -n "$is_ahead" ]; then
        echo "->"
    else
        is_behind=$(git status | grep 'Your branch is behind' 2> /dev/null)
        if [ -n "$is_behind" ]; then
            echo "<-"
        fi
    fi
    echo "]"
}

parse_git_branch()
{
    branch=$(git branch 2> /dev/null | grep -e '\* ' | sed 's/^..\(.*\)/[\1]/')
    if [ -n "$branch" ]; then
        echo $branch$(git_status)
    fi
}
export PS1='\[\033[01;34m\]\w\[\033[00m\]$(parse_git_branch)\$ '


