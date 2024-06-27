As this plugin is trivial there are no proper releases, and thus no real
release numbers.

For the purpose of publishing the script to [vimorg][] the release number is
simply the sequential number of the commit of which the uploaded archive was
generated from. The process is as follows:

    _base='https://git.netizen.se'
    _repo='vim-ipxe'
    _hash=$( git ls-remote "$_base/$_repo" HEAD | cut -c1-7 )
    _c_no=$( git log --oneline "$_hash" | wc -l )
    _date=$( date '+%Y, %B %d' )
    _name="${_repo%-main}"; _name="${_name#vim-}"
    wget "$_base/$_repo/snapshot/$_repo-main.zip"
    7zz rn "$_repo-main.zip" "$_repo-main" "$_name"
    mv "$_repo-main.zip" "$_name-$_c_no.zip"
    echo "Export of commit $_c_no ($_hash) from $_base/$_repo. $_date." \
        > "snapshot-$_hash.txt"
    7zz a "$_name-$_c_no.zip" "snapshot-$_hash.txt"
    unset _base _repo _name _hash _init _c_no _date

[vimorg]: https://www.vim.org/scripts/
