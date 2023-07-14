function! asyncomplete#sources#vsnip#get_source_options(opts) abort
    return extend({
                \ 'name': 'vsnip',
                \ 'allowlist': ['*'],
                \ 'completor': function('asyncomplete#sources#vsnip#completor'),
                \ },  a:opts)
endfunction

function! asyncomplete#sources#vsnip#completor(opts, ctx) abort
    let l:before_line = getline('.')
    let l:idx = min([strlen(l:before_line), col('.') - 2])
    let l:idx = max([l:idx, 0])
    let l:before_line =  l:before_line[0 : l:idx]

    if len(matchstr(l:before_line, s:get_keyword_pattern() . '$')) < 1
        return
    endif

    call asyncomplete#complete(
                \ a:opts.name,
                \ a:ctx,
                \ a:ctx.col - strlen(matchstr(a:ctx.typed, '\k*$')),
                \ vsnip#get_complete_items(a:ctx['bufnr'])
                \ )
endfunction

function! s:get_keyword_pattern() abort
    let l:keywords = split(&iskeyword, ',')
    let l:keywords = filter(l:keywords, { _, k -> match(k, '\d\+-\d\+') == -1 })
    let l:keywords = filter(l:keywords, { _, k -> k !=# '@' })
    let l:pattern = '\%(' . join(map(l:keywords, { _, v -> '\V' . escape(v, '\') . '\m' }), '\|') . '\|\w\)*'
    return l:pattern
endfunction
