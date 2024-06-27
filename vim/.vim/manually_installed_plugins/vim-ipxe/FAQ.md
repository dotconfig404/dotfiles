**Q: I get 'fatal: dumb http transport does not support shallow capabilities'**

**A:** If this is when using vim-plug, it's because it needs to be configured
with `let g:plug_shallow = 0` for that plugin manager to work. You could also
switch protocol by cloning from _ssh://anonymous@git.netizen.se/vim-ipxe_ which
does support shallow repository operations.
