local people_macro = [[:set noignorecase
:%s/^\D.*\n//g
gg^/ [a-z]
G^dwGD:%s/\s*$//g
gg^GI"$:%s/$/",/g
gg^i$people = @(G$C)Vgg"+y]]

local people2_macro = [[:set noignorecase
gg^/ [a-z]
G^dwGD:%s/\s*$//g
gg^GI"$:%s/$/",/g
gg^i$people = @(G$C)Vgg"+y]]

vim.fn.setreg('p', people_macro)
vim.fn.setreg('s', people2_macro)
