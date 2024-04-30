package.path = "/etc/nixos/dotfiles/nvim/lua/?/?.lua;" .. package.path
package.path = package.path .. ";./lua/?"
require("testing")
print("hello")
