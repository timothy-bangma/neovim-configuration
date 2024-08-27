This is a simple neovim configuration with support for:
- LSPs
- treesitter syntax highlighting
- (minimal) custom package management


Things I use sometimes:
```lua

	-- scheme, lisp, lua REPL.
	'https://github.com/olical/conjure',

	local scheme_client = 'conjure#client#scheme#stdio#'
	vim.g["conjure#mapping#doc_word"] = false
	vim.g[scheme_client .. 'command'] = "chibi-scheme"
	vim.g[scheme_client .. 'value_prefix_pattern'] = false
	vim.g[scheme_client .. 'prompt_pattern'] = "> "

	require('conjure-chibi').setup {}


	-- fzf and its various integrations
	'https://github.com/junegunn/fzf',
	'https://github.com/junegunn/fzf.vim',


```
