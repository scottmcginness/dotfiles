" Exit if :Abolish isn't available.
if !exists(':Abolish')
    finish
endif

Abolish imp{rot,rto} import
Abolish nskip raise nose.SkipTest()
Abolish itskip it<SPACE>\"xxx\":<CR>raise nose.SkipTest()<CR>
