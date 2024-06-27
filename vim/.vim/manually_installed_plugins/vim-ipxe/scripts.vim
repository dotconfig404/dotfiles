" This detects the presence of the ipxe file magic string on the first line
" of a file whenever vim opens it.

if did_filetype()   " filetype already set..
    finish      " ..don't do these checks
endif
if getline(1) =~? '^#!ipxe'
    setfiletype ipxe
    set filetype=ipxe
endif
