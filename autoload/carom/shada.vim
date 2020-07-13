" Returns the shadafile name for use with 'nvim -i <shadafile>'
fun! carom#shada#write() abort
    let save_shada = &shada
    let tmpname = tempname()
    " !        | save whatever globals we can
    " '0       | Don't save marks for previous files
    " /10000   | save the past 10000 searches to match default 'history'
    " :10000   | save the past 10000 cmds to match default 'history'
    " <        | excluded to save the full registers
    " @10000   | match the default 'history'. But tbh I dunno wtf 'input-line history' is...
    " f0       | don't save marks, editing a tmpfile so doesn't really work.
    "          |   In the future, this could be implemented rather trivially,
    "          |   although quite tediously.
    " h        | no funny business with 'hlsearch'
    " n <tmpf> | use a tmpfile to avoid surprising the user with a change to
    "          |   their 'shadafile'
    " s10      | seems like a good default for now
    let &shada = "!,'0,/10000,:10000,@10000,f0,h,s10,n".tmpname
    wshada
    let &shada = save_shada
    return tmpname
endfun
