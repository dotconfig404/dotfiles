" Vim syntax file
" Language:	ipxe
" Maintainer:	cos <cos>, https://www.netizen.se/#contact
" Last Change:	2023 Oct 19
" Remark:	https://ipxe.org/scripting https://ipxe.org/cmd

" quit when a syntax file was already loaded
if exists('b:current_syntax')
  finish
endif

" On current master (ff0f860) there are commands not documented. Running this:
"
"     echo -n 'Missing commands: '
"     for _keyword in $( sed -n 's/.*\.name.*\"\(.*\)\".*/\1/p' < \
"         $_ipxe_src/src/hci/commands/* | tr '\n' ' ' )
"     do
"       grep -q sy\ keyword.\*$_keyword $_vim_rtp/vim-ipxe/syntax/ipxe.vim ||
"           echo -n $_keyword' '
"     done; echo ''
"
" Gives the following output
"
"     Missing commands: md5sum sha1sum ibstat imgmem iwstat iwlist
"
" No attempts have been made at investigate the syntax of those six commands.

hi! def link ipxeArg             Constant
hi! def link ipxeOnlyArg         Constant
hi! def link ipxeOnlyKey         Identifier
hi! def link ipxeKey             Identifier
hi! def link ipxeVal             Constant
hi! def link ipxeComment         Comment
hi! def link ipxeKeyword         Statement
hi! def link ipxeLabel           Identifier
hi! def link ipxeSpecial         Special
hi! def link ipxeVariable        Define
hi! def link ipxeIfconfArg       Constant
hi! def link ipxeIfconfOpt       Type
hi! def link ipxeIflinkwaitArg   Constant
hi! def link ipxeIflinkwaitOpt   Type
hi! def link ipxeVcreateArg      Constant
hi! def link ipxeVcreateOpt      Type
hi! def link ipxeChainArg        Constant
hi! def link ipxeChainOpt        Type
hi! def link ipxeImgfetchArg     Constant
hi! def link ipxeImgfetchOpt     Type
hi! def link ipxeKernelArg       Constant
hi! def link ipxeKernelOpt       Type
hi! def link ipxeImgargsArg      Constant
hi! def link ipxeImgargsOpt      Type
hi! def link ipxeImgtrustOpt     Type
hi! def link ipxeImgverifyArg    Constant
hi! def link ipxeImgverifyOpt    Type
hi! def link ipxeImgextractArg   Constant
hi! def link ipxeImgextractOpt   Type
hi! def link ipxeShimArg         Constant
hi! def link ipxeShimOpt         Type
hi! def link ipxeSanhookArg      Constant
hi! def link ipxeSanhookOpt      Type
hi! def link ipxeSanbootArg      Constant
hi! def link ipxeSanbootOpt      Type
hi! def link ipxeSanunhookArg    Constant
hi! def link ipxeSanunhookOpt    Type
hi! def link ipxeFcelsArg        Constant
hi! def link ipxeFcelsOpt        Type
hi! def link ipxeReadArg         Constant
hi! def link ipxeReadOpt         Type
hi! def link ipxeIncArg          Constant
hi! def link ipxeIncKey          Identifier
hi! def link ipxeIssetVariable   Define
hi! def link ipxeIseqLeft        Constant
hi! def link ipxeIseqRight       Constant
hi! def link ipxeGotoLabel       Identifier
hi! def link ipxeExitArg         Constant
hi! def link ipxeMenuArg         Constant
hi! def link ipxeMenuOpt         Type
hi! def link ipxeItemArg         Constant
hi! def link ipxeItemOpt         Type
hi! def link ipxeChooseArg       Constant
hi! def link ipxeChooseOpt       Type
hi! def link ipxeCertstatArg     Constant
hi! def link ipxeCertstatOpt     Type
hi! def link ipxeCertstoreArg    Constant
hi! def link ipxeCertstoreOpt    Type
hi! def link ipxeCertfreeArg     Constant
hi! def link ipxeCertfreeOpt     Type
hi! def link ipxeConsoleArg      Constant
hi! def link ipxeConsoleOpt      Type
hi! def link ipxeColourArg       Constant
hi! def link ipxeColourOpt       Type
hi! def link ipxeCpairArg        Constant
hi! def link ipxeCpairOpt        Type
hi! def link ipxeParamsArg       Constant
hi! def link ipxeParamsOpt       Type
hi! def link ipxeParamArg        Constant
hi! def link ipxeParamOpt        Type
hi! def link ipxeEchoArg         Constant
hi! def link ipxeEchoOpt         Type
hi! def link ipxePromptArg       Constant
hi! def link ipxePromptOpt       Type
hi! def link ipxeCpuidArg        Constant
hi! def link ipxeCpuidOpt        Type
hi! def link ipxeSyncArg         Constant
hi! def link ipxeSyncOpt         Type
hi! def link ipxePingArg         Constant
hi! def link ipxePingOpt         Type
hi! def link ipxeLotestArg       Constant
hi! def link ipxeLotestOpt       Type
" hi! def link ipxeArg   Constant
" hi! def link ipxeOpt   Type

sy cluster ipxeNext contains=ipxeSpecial,ipxeComment

sy match ipxeArg contained skipwhite /\(\S\+\)\+/ nextgroup=@ipxeNext,ipxeArg contains=ipxeVariable
sy match ipxeOnlyArg contained skipwhite /\S\+/ nextgroup=@ipxeNext contains=ipxeVariable
sy match ipxeOnlyKey contained skipwhite /\S\+/ nextgroup=@ipxeNext contains=ipxeVariable
sy keyword ipxeKeyword autoboot skipwhite nextgroup=@ipxeNext,ipxeArg
sy keyword ipxeKeyword ifstat skipwhite nextgroup=@ipxeNext,ipxeArg
sy keyword ipxeKeyword ifopen skipwhite nextgroup=@ipxeNext,ipxeArg
sy keyword ipxeKeyword ifclose skipwhite nextgroup=@ipxeNext,ipxeArg
sy keyword ipxeKeyword ifconf skipwhite nextgroup=@ipxeNext,ipxeIfconfOpt,ipxeIfconfArg
sy keyword ipxeKeyword dhcp skipwhite nextgroup=@ipxeNext,ipxeIfconfOpt,ipxeIfconfArg
sy match ipxeIfconfArg contained skipwhite /\S\+/ nextgroup=@ipxeNext,ipxeIfconfArg,ipxeIfconfOpt contains=ipxeVariable
" FIXME Ideally this file should properly take into account when the syntax
"       requires a specific format of the argument to an option, such as the
"       one to --timeout here being numeric.
sy match ipxeIfconfOpt contained skipwhite /--configurator\|--timeout/ nextgroup=@ipxeNext,ipxeIfconfArg contains=ipxeVariable
sy keyword ipxeKeyword iflinkwait skipwhite nextgroup=@ipxeNext,ipxeIflinkwaitOpt,ipxeIflinkwaitArg
sy match ipxeIflinkwaitArg contained skipwhite /\S\+/ nextgroup=@ipxeNext,ipxeIflinkwaitArg,ipxeIflinkwaitOpt contains=ipxeVariable
sy match ipxeIflinkwaitOpt contained skipwhite /--timeout/ nextgroup=@ipxeNext,ipxeIflinkwaitArg contains=ipxeVariable
sy keyword ipxeKeyword route skipwhite nextgroup=@ipxeNext
sy keyword ipxeKeyword nstat skipwhite nextgroup=@ipxeNext
sy keyword ipxeKeyword ipstat skipwhite nextgroup=@ipxeNext
" FIXME Ideally this file should properly take into account the fact that
"       --tag is a required option. There should also only be possible to give
"       one single argument to vcreate.
sy keyword ipxeKeyword vcreate skipwhite nextgroup=@ipxeNext,ipxeVcreateOpt,ipxeVcreateArg
sy match ipxeVcreateArg contained skipwhite /\S\+/ nextgroup=@ipxeNext,ipxeVcreateArg,ipxeVcreateOpt contains=ipxeVariable
sy match ipxeVcreateOpt contained skipwhite /--tag\|--priority/ nextgroup=@ipxeNext,ipxeVcreateArg contains=ipxeVariable
sy keyword ipxeKeyword vdestroy skipwhite nextgroup=@ipxeNext,ipxeOnlyArg
sy keyword ipxeKeyword imgstat skipwhite nextgroup=@ipxeNext,ipxeArg
" FIXME Ideally options without arguments such as --autofree should have
"       something like nextgroup=ipxe<command>Opt,@ipxeNext
sy keyword ipxeKeyword chain skipwhite nextgroup=@ipxeNext,ipxeChainArg,ipxeChainOpt
sy keyword ipxeKeyword imgexec skipwhite nextgroup=ipxeChainArg,ipxeChainOpt
sy keyword ipxeKeyword boot skipwhite nextgroup=@ipxeNext,ipxeChainArg,ipxeChainOpt
sy match ipxeChainArg contained skipwhite /\S\+/ nextgroup=@ipxeNext,ipxeChainArg,ipxeChainOpt contains=ipxeVariable
sy match ipxeChainOpt contained skipwhite /--name\|--timeout\|--autofree\|--replace/ nextgroup=@ipxeNext,ipxeChainArg,ipxeChainOpt contains=ipxeVariable
sy keyword ipxeKeyword imgfetch skipwhite nextgroup=@ipxeNext,ipxeImgfetchArg,ipxeImgfetchOpt
sy keyword ipxeKeyword module skipwhite nextgroup=@ipxeNext,ipxeImgfetchArg,ipxeImgfetchOpt
sy keyword ipxeKeyword initrd skipwhite nextgroup=@ipxeNext,ipxeImgfetchArg,ipxeImgfetchOpt
sy match ipxeImgfetchArg contained skipwhite /\S\+/ nextgroup=@ipxeNext,ipxeImgfetchArg,ipxeImgfetchOpt contains=ipxeVariable
sy match ipxeImgfetchOpt contained skipwhite /--name\|--timeout/ nextgroup=@ipxeNext,ipxeImgfetchArg contains=ipxeVariable
sy keyword ipxeKeyword kernel skipwhite nextgroup=@ipxeNext,ipxeKernelArg,ipxeKernelOpt
sy keyword ipxeKeyword imgselect skipwhite nextgroup=@ipxeNext,ipxeKernelArg,ipxeKernelOpt
sy keyword ipxeKeyword imgload skipwhite nextgroup=@ipxeNext,ipxeKernelArg,ipxeKernelOpt
sy match ipxeKernelArg contained skipwhite /\S\+/ nextgroup=@ipxeNext,ipxeKernelArg,ipxeKernelOpt contains=ipxeVariable
sy match ipxeKernelOpt contained skipwhite /--name\|--timeout/ nextgroup=@ipxeNext,ipxeKernelArg contains=ipxeVariable
sy keyword ipxeKeyword imgfree skipwhite nextgroup=@ipxeNext,ipxeOnlyArg
sy keyword ipxeKeyword imgargs skipwhite nextgroup=@ipxeNext,ipxeImgargsArg,ipxeImgargsOpt
sy match ipxeImgargsArg contained skipwhite /\S\+/ nextgroup=@ipxeNext,ipxeImgargsArg,ipxeImgargsOpt contains=ipxeVariable
sy match ipxeImgargsOpt contained skipwhite /--name/ nextgroup=@ipxeNext,ipxeImgargsArg contains=ipxeVariable
sy keyword ipxeKeyword imgtrust skipwhite nextgroup=@ipxeNext,ipxeImgtrustOpt
sy match ipxeImgtrustOpt contained skipwhite /--allow\|--permanent/ nextgroup=@ipxeNext,ipxeImgtrustOpt contains=ipxeVariable
sy keyword ipxeKeyword imgverify skipwhite nextgroup=@ipxeNext,ipxeImgverifyArg,ipxeImgverifyOpt
sy match ipxeImgverifyArg contained skipwhite /\S\+/ nextgroup=@ipxeNext,ipxeImgverifyArg,ipxeImgverifyOpt contains=ipxeVariable
sy match ipxeImgverifyOpt contained skipwhite /--signer\|--keep/ nextgroup=@ipxeNext,ipxeImgverifyArg contains=ipxeVariable
sy keyword ipxeKeyword imgextract skipwhite nextgroup=@ipxeNext,ipxeImgextractArg,ipxeImgextractOpt
sy match ipxeImgextractArg contained skipwhite /\S\+/ nextgroup=@ipxeNext,ipxeImgextractArg,ipxeImgextractOpt contains=ipxeVariable
sy match ipxeImgextractOpt contained skipwhite /--name\|--timeout\|--keep/ nextgroup=@ipxeNext,ipxeImgextractArg contains=ipxeVariable
" FIXME It seems wise to take <extra option> into account, but that might be a
"       fairly large task.
sy keyword ipxeKeyword shim skipwhite nextgroup=@ipxeNext,ipxeShimArg,ipxeShimOpt
sy match ipxeShimArg contained skipwhite /\S\+/ nextgroup=@ipxeNext,ipxeShimArg,ipxeShimOpt contains=ipxeVariable
sy match ipxeShimOpt contained skipwhite /--timeout/ nextgroup=@ipxeNext,ipxeShimArg contains=ipxeVariable
sy keyword ipxeKeyword sanhook skipwhite nextgroup=@ipxeNext,ipxeSanhookArg,ipxeSanhookOpt
sy match ipxeSanhookArg contained skipwhite /\S\+/ nextgroup=@ipxeNext,ipxeSanhookArg,ipxeSanhookOpt contains=ipxeVariable
sy match ipxeSanhookOpt contained skipwhite /--drive\|--no-describe/ nextgroup=@ipxeNext,ipxeSanhookArg contains=ipxeVariable
sy keyword ipxeKeyword sanboot skipwhite nextgroup=@ipxeNext,ipxeSanbootArg,ipxeSanbootOpt
sy match ipxeSanbootArg contained skipwhite /\S\+/ nextgroup=@ipxeNext,ipxeSanbootArg,ipxeSanbootOpt contains=ipxeVariable
sy match ipxeSanbootOpt contained skipwhite /--drive\|--filename\|--no-describe\|--keep/ nextgroup=@ipxeNext,ipxeSanbootArg contains=ipxeVariable
sy keyword ipxeKeyword sanunhook nextgroup=@ipxeNext,ipxeSanunhookArg,ipxeSanunhookOpt
sy match ipxeSanunhookArg contained skipwhite /\S\+/ nextgroup=@ipxeNext,ipxeSanunhookArg,ipxeSanunhookOpt contains=ipxeVariable
sy match ipxeSanunhookOpt contained skipwhite /--drive/ nextgroup=@ipxeNext,ipxeSanunhookArg contains=ipxeVariable
sy keyword ipxeKeyword fcstat skipwhite nextgroup=@ipxeNext
sy keyword ipxeKeyword fcels skipwhite nextgroup=@ipxeNext,ipxeFcelsArg,ipxeFcelsOpt
sy match ipxeFcelsArg contained skipwhite /\S\+/ nextgroup=@ipxeNext,ipxeFcelsArg,ipxeFcelsOpt contains=ipxeVariable
sy match ipxeFcelsOpt contained skipwhite /--port\|--id/ nextgroup=ipxeFcelsSpecial,ipxeFcelsArg contains=ipxeVariable
sy keyword ipxeKeyword config skipwhite nextgroup=@ipxeNext,ipxeOnlyArg
sy keyword ipxeKeyword show skipwhite nextgroup=@ipxeNext,ipxeOnlyKey
sy keyword ipxeKeyword set skipwhite nextgroup=ipxeKey
sy match ipxeKey contained skipwhite /\S\+/ nextgroup=ipxeVal contains=ipxeVariable
sy match ipxeVal contained skipwhite /\S\+/ nextgroup=@ipxeNext,ipxeVal contains=ipxeVariable
sy keyword ipxeKeyword clear skipwhite nextgroup=ipxeOnlyKey
sy keyword ipxeKeyword read skipwhite nextgroup=ipxeOnlyKey,ipxeReadOpt
sy match ipxeReadArg contained skipwhite /\S\+/ nextgroup=@ipxeNext,ipxeOnlyKey,ipxeReadOpt contains=ipxeVariable
sy match ipxeReadOpt contained skipwhite /--timeout/ nextgroup=ipxeReadArg contains=ipxeVariable
sy keyword ipxeKeyword inc skipwhite nextgroup=ipxeIncKey
sy match ipxeIncArg contained skipwhite /\d\+/ nextgroup=ipxeIncArg,@ipxeNext contains=ipxeVariable
sy match ipxeIncKey contained skipwhite /\S\+/ nextgroup=ipxeIncArg contains=ipxeVariable
sy keyword ipxeKeyword login skipwhite nextgroup=@ipxeNext
sy keyword ipxeKeyword isset skipwhite nextgroup=ipxeIssetVariable
sy match ipxeIssetVariable contained skipwhite /\${\S*}/ nextgroup=@ipxeNext
sy keyword ipxeKeyword iseq skipwhite nextgroup=ipxeIseqLeft
sy match ipxeIseqLeft contained skipwhite /\S\+/ nextgroup=ipxeIseqRight contains=ipxeVariable
sy match ipxeIseqRight contained skipwhite /\S\+/ nextgroup=@ipxeNext contains=ipxeVariable
sy keyword ipxeKeyword goto skipwhite nextgroup=ipxeGotoLabel
sy match ipxeGotoLabel contained skipwhite /\S\+/ nextgroup=@ipxeNext contains=ipxeVariable
sy keyword ipxeKeyword exit skipwhite nextgroup=ipxeExitArg,@ipxeNext
sy match ipxeExitArg contained skipwhite /\S\+/ nextgroup=@ipxeNext contains=ipxeVariable
sy keyword ipxeKeyword menu skipwhite nextgroup=@ipxeNext,ipxeMenuArg,ipxeMenuOpt
sy match ipxeMenuArg contained skipwhite /\S\+/ nextgroup=@ipxeNext,ipxeMenuArg,ipxeMenuOpt contains=ipxeVariable
sy match ipxeMenuOpt contained skipwhite /--name\|--delete/ nextgroup=ipxeMenuSpecial,ipxeMenuArg contains=ipxeVariable
sy keyword ipxeKeyword item skipwhite nextgroup=@ipxeNext,ipxeItemArg,ipxeItemOpt
sy match ipxeItemArg contained skipwhite /\S\+/ nextgroup=@ipxeNext,ipxeItemArg,ipxeItemOpt contains=ipxeVariable
sy match ipxeItemOpt contained skipwhite /--menu\|--key\|--default\|--gap/ nextgroup=@ipxeNext,ipxeItemArg contains=ipxeVariable
sy keyword ipxeKeyword choose skipwhite nextgroup=@ipxeNext,ipxeChooseArg,ipxeChooseOpt
sy match ipxeChooseArg contained skipwhite /\S\+/ nextgroup=@ipxeNext,ipxeChooseArg,ipxeChooseOpt contains=ipxeVariable
sy match ipxeChooseOpt contained skipwhite /--menu\|--default\|--timeout\|--keep/ nextgroup=ipxeChooseArg,ipxeChooseOpt contains=ipxeVariable
sy keyword ipxeKeyword certstat skipwhite nextgroup=@ipxeNext,ipxeCertstatArg,ipxeCertstatOpt
sy match ipxeCertstatArg contained skipwhite /\S\+/ nextgroup=@ipxeNext,ipxeCertstatArg,ipxeCertstatOpt contains=ipxeVariable
sy match ipxeCertstatOpt contained skipwhite /--subject/ nextgroup=@ipxeCertstatNext,ipxeCertstatArg contains=ipxeVariable
sy keyword ipxeKeyword certstore skipwhite nextgroup=@ipxeNext,ipxeCertstoreArg,ipxeCertstoreOpt
sy match ipxeCertstoreArg contained skipwhite /\S\+/ nextgroup=@ipxeNext,ipxeCertstoreArg,ipxeCertstoreOpt contains=ipxeVariable
sy match ipxeCertstoreOpt contained skipwhite /--subject\|--keep/ nextgroup=@ipxeNext,ipxeCertstoreArg,ipxeCertstoreOpt contains=ipxeVariable
sy keyword ipxeKeyword certfree skipwhite nextgroup=@ipxeNext,ipxeCertfreeArg,ipxeCertfreeOpt
sy match ipxeCertfreeArg contained skipwhite /\S\+/ nextgroup=@ipxeNext,ipxeCertfreeArg,ipxeCertfreeOpt contains=ipxeVariable
sy match ipxeCertfreeOpt contained skipwhite /--subject/ nextgroup=@ipxeNext,ipxeCertfreeArg contains=ipxeVariable
sy keyword ipxeKeyword console skipwhite nextgroup=@ipxeNext,ipxeConsoleArg,ipxeConsoleOpt
sy match ipxeConsoleArg contained skipwhite /\S\+/ nextgroup=@ipxeNext,ipxeConsoleArg,ipxeConsoleOpt contains=ipxeVariable
sy match ipxeConsoleOpt contained skipwhite /--x\|--y\|--left\|--right\|--top\|--bottom\|--depth\|--picture\|--keep/ nextgroup=@ipxeNext,ipxeConsoleArg,ipxeConsoleOpt contains=ipxeVariable
sy keyword ipxeKeyword colour skipwhite nextgroup=@ipxeNext,ipxeColourArg,ipxeColourOpt
sy match ipxeColourArg contained skipwhite /\S\+/ nextgroup=@ipxeNext,ipxeColourArg,ipxeColourOpt contains=ipxeVariable
sy match ipxeColourOpt contained skipwhite /--basic\|--rgb/ nextgroup=@ipxeNext,ipxeColourArg,ipxeColourOpt contains=ipxeVariable
sy keyword ipxeKeyword cpair skipwhite nextgroup=@ipxeNext,ipxeCpairArg,ipxeCpairOpt
sy match ipxeCpairArg contained skipwhite /\S\+/ nextgroup=@ipxeNext,ipxeCpairArg,ipxeCpairOpt contains=ipxeVariable
sy match ipxeCpairOpt contained skipwhite /--foreground\|--background/ nextgroup=@ipxeNext,ipxeCpairArg,ipxeCpairOpt contains=ipxeVariable
sy keyword ipxeKeyword params skipwhite nextgroup=@ipxeNext,ipxeParamsArg,ipxeParamsOpt
sy match ipxeParamsArg contained skipwhite /\S\+/ nextgroup=@ipxeNext,ipxeParamsArg,ipxeParamsOpt contains=ipxeVariable
sy match ipxeParamsOpt contained skipwhite /--name\|--delete/ nextgroup=@ipxeNext,ipxeParamsArg,ipxeParamsOpt contains=ipxeVariable
sy keyword ipxeKeyword param skipwhite nextgroup=@ipxeNext,ipxeParamArg,ipxeParamOpt
sy match ipxeParamArg contained skipwhite /\S\+/ nextgroup=@ipxeNext,ipxeParamArg,ipxeParamOpt contains=ipxeVariable
sy match ipxeParamOpt contained skipwhite /--params\|--header/ nextgroup=@ipxeNext,ipxeParamArg,ipxeParamOpt contains=ipxeVariable
sy keyword ipxeKeyword echo skipwhite nextgroup=@ipxeNext,ipxeEchoArg,ipxeEchoOpt
sy match ipxeEchoArg contained skipwhite /\S\+/ nextgroup=@ipxeNext,ipxeEchoArg contains=ipxeVariable
sy match ipxeEchoOpt contained skipwhite /-n/ nextgroup=@ipxeNext,ipxeEchoArg
sy keyword ipxeKeyword prompt skipwhite nextgroup=@ipxeNext,ipxePromptArg,ipxePromptOpt
sy match ipxePromptArg contained skipwhite /\S\+/ nextgroup=@ipxeNext,ipxePromptArg,ipxePromptOpt contains=ipxeVariable
sy match ipxePromptOpt contained skipwhite /--key\|--timeout/ nextgroup=@ipxeNext,ipxePromptArg,ipxePromptOpt contains=ipxeVariable
sy keyword ipxeKeyword shell skipwhite nextgroup=@ipxeNext
sy keyword ipxeKeyword help skipwhite nextgroup=@ipxeNext
sy keyword ipxeKeyword sleep skipwhite nextgroup=@ipxeNext,ipxeOnlyArg
sy keyword ipxeKeyword reboot skipwhite nextgroup=@ipxeNext
sy keyword ipxeKeyword poweroff skipwhite nextgroup=@ipxeNext
sy keyword ipxeKeyword cpuid skipwhite nextgroup=@ipxeNext,ipxeCpuidArg,ipxeCpuidOpt
sy match ipxeCpuidArg contained skipwhite /\S\+/ nextgroup=@ipxeNext,ipxeCpuidArg,ipxeCpuidOpt contains=ipxeVariable
sy match ipxeCpuidOpt contained skipwhite /--ext\|--ecx/ nextgroup=@ipxeNext,ipxeCpuidArg,ipxeCpuidOpt contains=ipxeVariable
sy keyword ipxeKeyword sync skipwhite nextgroup=@ipxeNext,ipxeSyncArg,ipxeSyncOpt
sy match ipxeSyncArg contained skipwhite /\S\+/ nextgroup=@ipxeNext,ipxeSyncArg,ipxeSyncOpt contains=ipxeVariable
sy match ipxeSyncOpt contained skipwhite /--timeout/ nextgroup=@ipxeNext,ipxeSyncArg,ipxeSyncOpt contains=ipxeVariable
sy keyword ipxeKeyword nslookup skipwhite nextgroup=ipxeKey
sy keyword ipxeKeyword ping skipwhite nextgroup=@ipxeNext,ipxePingArg,ipxePingOpt
sy match ipxePingArg contained skipwhite /\S\+/ nextgroup=@ipxeNext,ipxePingArg,ipxePingOpt contains=ipxeVariable
sy match ipxePingOpt contained skipwhite /--size\|--timeout\|--count/ nextgroup=@ipxeNext,ipxePingArg,ipxePingOpt contains=ipxeVariable
sy keyword ipxeKeyword ntp skipwhite nextgroup=@ipxeNext,ipxeOnlyArg
sy keyword ipxeKeyword pciscan skipwhite nextgroup=@ipxeNext,ipxeOnlyKey
sy keyword ipxeKeyword lotest skipwhite nextgroup=@ipxeNext,ipxeLotestArg,ipxeLotestOpt
sy match ipxeLotestArg contained skipwhite /\S\+/ nextgroup=@ipxeNext,ipxeLotestArg,ipxeLotestOpt contains=ipxeVariable
sy match ipxeLotestOpt contained skipwhite /--mtu\|--broadcast/ nextgroup=@ipxeNext,ipxeLotestArg,ipxeLotestOpt contains=ipxeVariable
sy keyword ipxeKeyword pxebs skipwhite nextgroup=@ipxeNext,ipxeArg
sy keyword ipxeKeyword time
sy keyword ipxeKeyword gdbstub skipwhite nextgroup=@ipxeNext,ipxeArg
sy keyword ipxeKeyword profstat skipwhite nextgroup=@ipxeNext

" FIXME Are ipxeSpecial allowed on the same line immediately after defining a
"       label?
sy match ipxeLabel /^:\S\+/
sy match ipxeSpecial contained /;\|&&\|||/
" FIXME Are ipxeSpecial really allowed to start a line like this?
"       Are they also valid to chain without anything in between them?
"       e.g. '; ; ; && && || ;'
sy match ipxeSpecial /^\s*\(;\|&&\|||\)/
sy match ipxeVariable /\${[^}]*}/
sy match ipxeComment /#.*/
