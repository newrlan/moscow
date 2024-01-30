" Hex colour conversion functions borrowed from the theme "QuietLight""

" Default GUI Colours
" let s:comment = "a5a9ad"
let s:comment = "7b7f85"
let s:line = "f7f8fa"
let s:background = "edebe9"
" let s:background = "ffffff"
let s:foreground = "000000"
let s:blue = "2962b3"
" let s:blue = "2a62b2"
let s:paleblue = "e2e8f2"
let s:red = "a9262f"
let s:palered = "fadfe3"
let s:selection = "dcdcdc"
let s:lightred = "cb3048"   " для жирных текстов
let s:window = "efefef"
let s:palegray = "e3e3e3"

set background=light
hi clear
syntax reset

let g:colors_name = "moscow"

if has("gui_running") || &t_Co == 88 || &t_Co == 256
	" Returns an approximate grey index for the given grey level
	fun <SID>grey_number(x)
		if &t_Co == 88
			if a:x < 23
				return 0
			elseif a:x < 69
				return 1
			elseif a:x < 103
				return 2
			elseif a:x < 127
				return 3
			elseif a:x < 150
				return 4
			elseif a:x < 173
				return 5
			elseif a:x < 196
				return 6
			elseif a:x < 219
				return 7
			elseif a:x < 243
				return 8
			else
				return 9
			endif
		else
			if a:x < 14
				return 0
			else
				let l:n = (a:x - 8) / 10
				let l:m = (a:x - 8) % 10
				if l:m < 5
					return l:n
				else
					return l:n + 1
				endif
			endif
		endif
	endfun

	" Returns the actual grey level represented by the grey index
	fun <SID>grey_level(n)
		if &t_Co == 88
			if a:n == 0
				return 0
			elseif a:n == 1
				return 46
			elseif a:n == 2
				return 92
			elseif a:n == 3
				return 115
			elseif a:n == 4
				return 139
			elseif a:n == 5
				return 162
			elseif a:n == 6
				return 185
			elseif a:n == 7
				return 208
			elseif a:n == 8
				return 231
			else
				return 255
			endif
		else
			if a:n == 0
				return 0
			else
				return 8 + (a:n * 10)
			endif
		endif
	endfun

	" Returns the palette index for the given grey index
	fun <SID>grey_colour(n)
		if &t_Co == 88
			if a:n == 0
				return 16
			elseif a:n == 9
				return 79
			else
				return 79 + a:n
			endif
		else
			if a:n == 0
				return 16
			elseif a:n == 25
				return 231
			else
				return 231 + a:n
			endif
		endif
	endfun

	" Returns an approximate colour index for the given colour level
	fun <SID>rgb_number(x)
		if &t_Co == 88
			if a:x < 69
				return 0
			elseif a:x < 172
				return 1
			elseif a:x < 230
				return 2
			else
				return 3
			endif
		else
			if a:x < 75
				return 0
			else
				let l:n = (a:x - 55) / 40
				let l:m = (a:x - 55) % 40
				if l:m < 20
					return l:n
				else
					return l:n + 1
				endif
			endif
		endif
	endfun

	" Returns the actual colour level for the given colour index
	fun <SID>rgb_level(n)
		if &t_Co == 88
			if a:n == 0
				return 0
			elseif a:n == 1
				return 139
			elseif a:n == 2
				return 205
			else
				return 255
			endif
		else
			if a:n == 0
				return 0
			else
				return 55 + (a:n * 40)
			endif
		endif
	endfun

	" Returns the palette index for the given R/G/B colour indices
	fun <SID>rgb_colour(x, y, z)
		if &t_Co == 88
			return 16 + (a:x * 16) + (a:y * 4) + a:z
		else
			return 16 + (a:x * 36) + (a:y * 6) + a:z
		endif
	endfun

	" Returns the palette index to approximate the given R/G/B colour levels
	fun <SID>colour(r, g, b)
		" Get the closest grey
		let l:gx = <SID>grey_number(a:r)
		let l:gy = <SID>grey_number(a:g)
		let l:gz = <SID>grey_number(a:b)

		" Get the closest colour
		let l:x = <SID>rgb_number(a:r)
		let l:y = <SID>rgb_number(a:g)
		let l:z = <SID>rgb_number(a:b)

		if l:gx == l:gy && l:gy == l:gz
			" There are two possibilities
			let l:dgr = <SID>grey_level(l:gx) - a:r
			let l:dgg = <SID>grey_level(l:gy) - a:g
			let l:dgb = <SID>grey_level(l:gz) - a:b
			let l:dgrey = (l:dgr * l:dgr) + (l:dgg * l:dgg) + (l:dgb * l:dgb)
			let l:dr = <SID>rgb_level(l:gx) - a:r
			let l:dg = <SID>rgb_level(l:gy) - a:g
			let l:db = <SID>rgb_level(l:gz) - a:b
			let l:drgb = (l:dr * l:dr) + (l:dg * l:dg) + (l:db * l:db)
			if l:dgrey < l:drgb
				" Use the grey
				return <SID>grey_colour(l:gx)
			else
				" Use the colour
				return <SID>rgb_colour(l:x, l:y, l:z)
			endif
		else
			" Only one possibility
			return <SID>rgb_colour(l:x, l:y, l:z)
		endif
	endfun

	" Returns the palette index to approximate the 'rrggbb' hex string
	fun <SID>rgb(rgb)
		let l:r = ("0x" . strpart(a:rgb, 0, 2)) + 0
		let l:g = ("0x" . strpart(a:rgb, 2, 2)) + 0
		let l:b = ("0x" . strpart(a:rgb, 4, 2)) + 0

		return <SID>colour(l:r, l:g, l:b)
	endfun

	" Sets the highlighting for the given group
	fun <SID>X(group, fg, bg, attr)
		if a:fg != ""
			exec "hi " . a:group . " guifg=#" . a:fg . " ctermfg=" . <SID>rgb(a:fg)
		endif
		if a:bg != ""
			exec "hi " . a:group . " guibg=#" . a:bg . " ctermbg=" . <SID>rgb(a:bg)
		endif
		if a:attr != ""
			exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr
		endif
	endfun

	" Vim Highlighting
	call <SID>X("Normal", s:foreground, s:background, "")
	call <SID>X("CursorLineNr", s:red, s:background, "")
	call <SID>X("LineNr", s:comment, s:background, "")
	call <SID>X("NonText", s:selection, "", "")
	call <SID>X("SpecialKey", s:selection, "", "")
	call <SID>X("Search", "", s:palered, "")
	call <SID>X("TabLineFill", s:window, s:foreground, "reverse")
	call <SID>X("StatusLine", s:blue, s:background, "reverse")
	call <SID>X("StatusLineNC", s:window, s:foreground, "reverse")
	call <SID>X("VertSplit", s:foreground, s:background, "none")
	call <SID>X("Visual", "", s:paleblue, "")
	call <SID>X("Directory", s:foreground, "", "")
	call <SID>X("ModeMsg", s:red, "", "bold")
	call <SID>X("MoreMsg", s:red, "", "")
	call <SID>X("Question", s:blue, "", "")
	call <SID>X("WarningMsg", s:red, "", "")
	call <SID>X("MatchParen", "", s:selection, "")
	call <SID>X("Folded", s:blue, s:palegray, "italic")
	call <SID>X("FoldColumn", s:paleblue, s:background, "bold")
	if version >= 700
		call <SID>X("CursorLine", "", s:line, "none")
		call <SID>X("CursorColumn", "", s:line, "none")
		call <SID>X("PMenu", s:foreground, s:selection, "none")
		call <SID>X("PMenuSel", s:foreground, s:selection, "reverse")
		call <SID>X("SignColumn", "", s:line, "none")
	end
	if version >= 703
		call <SID>X("ColorColumn", "", s:line, "none")
	end

	" Standard Highlighting
	call <SID>X("Comment", s:comment, "", "italic")
	call <SID>X("Todo", s:red, s:background, "bold")
	call <SID>X("Title", s:red, "", "bold")
	call <SID>X("Identifier", s:foreground, "", "italic")
	call <SID>X("Statement", s:foreground, "", "bold")
"       *Statement       any statement
"        Exception       try, catch, throw
	call <SID>X("Conditional", s:foreground, "", "bold")
	call <SID>X("Label", s:foreground, "", "")
	call <SID>X("Repeat", s:foreground, "", "bold")
	call <SID>X("Structure", s:foreground, "", "italic")
	call <SID>X("Function", s:foreground, "", "italic")
	call <SID>X("Constant", s:foreground, "", "")
	call <SID>X("Character", s:comment, "", "")
"       *Constant        any constant
"        Character       a character constant: 'c', '\n'
"        Number          a number constant: 234, 0xff
"        Boolean         a boolean constant: TRUE, false
	call <SID>X("Keyword", s:foreground, "", "bold")
	call <SID>X("String", s:blue, "", "italic")
	call <SID>X("Special", s:foreground, "", "")
	call <SID>X("SpecialComment", s:blue, "", "italic") " special things inside a comment
	call <SID>X("SpecialChar", s:foreground, "", "") " character that needs attention
	call <SID>X("PreProc", s:foreground, "", "")
	call <SID>X("Operator", s:foreground, "", "bold") " $ <- in not
	call <SID>X("Type", s:foreground, "", "")
	call <SID>X("Typedef", s:foreground, "", "")
	call <SID>X("Define", s:foreground, "", "")
	call <SID>X("Delimiter", s:blue, "", "")
	call <SID>X("Include", s:comment, "", "italic")
	call <SID>X("Underlined", s:blue, "", "italic")
	call <SID>X("Error", s:foreground, s:palered, "bold")
	call <SID>X("Ignore", s:foreground, "", "italic")

	" Vim Highlighting
	call <SID>X("vimCommand", s:foreground, "", "bold")
	"call <SID>X("LineNr", s:red, "", "bold")
    
    " Vim Plug
    call <SID>X("plugName", s:blue, "", "bold")

    " TeX Highlight
    " Основной файл в кором содержатся имена находится по адресу
    " ~/.vim/bundle/vim-tex-syntax/syntax/tex.vim
    " ~/.vim/plugged/vimtex/autoload/vimtex/syntax/core.vim
    call <SID>X("texMath", "", "", "italic")
    call <SID>X("texOpt", s:foreground, "", "italic")
    call <SID>X("texCmd", s:foreground, "", "italic")
    call <SID>X("texArg", s:blue, "", "bold")
    call <SID>X("texCmdEnv", s:foreground, "", "bold")
    call <SID>X("texCmdPart", s:red, "", "bold")
    call <SID>X("texMathOper", s:foreground, "", "")
    call <SID>X("texPartArgTitle", s:foreground, "", "bold")
    call <SID>X("texRefArg", s:red, "", "")
 
	" VimWiki Highlighting
	call <SID>X("VimwikiListTodo", s:blue, "", "bold")
	call <SID>X("VimwikiCheckBoxDone", s:comment, "", "italic")
	call <SID>X("VimwikiHeader1", s:foreground, "", "bold")
	call <SID>X("VimwikiHeader2", s:foreground, "", "bold")
	call <SID>X("VimwikiHeader3", s:foreground, "", "bold")
	call <SID>X("VimwikiHeader4", s:foreground, "", "bold")
	call <SID>X("VimwikiHeader5", s:foreground, "", "bold")
	call <SID>X("VimwikiHeader6", s:foreground, "", "bold")
	call <SID>X("VimwikiHeaderChar", s:red, "", "bold")

	" C Highlighting
	call <SID>X("cType", s:foreground, "", "italic")

	" PHP Highlighting
	call <SID>X("phpVarSelector", s:comment, "", "bold")
	call <SID>X("phpKeyword", s:foreground, "", "bold")
	call <SID>X("phpRepeat", s:foreground, "", "bold")
	call <SID>X("phpConditional", s:foreground, "", "")
	call <SID>X("phpStatement", s:foreground, "", "")
	call <SID>X("phpMemberSelector", s:foreground, "", "")

	" Ruby Highlighting
	call <SID>X("rubySymbol", s:foreground, "", "")
	call <SID>X("rubyConstant", s:foreground, "", "")
	call <SID>X("rubyAccess", s:foreground, "", "")
	call <SID>X("rubyAttribute", s:blue, "", "")
	call <SID>X("rubyInclude", s:blue, "", "")
	call <SID>X("rubyLocalVariableOrMethod", s:foreground, "", "")
	call <SID>X("rubyCurlyBlock", s:foreground, "", "")
	call <SID>X("rubyStringDelimiter", s:foreground, "", "")
	call <SID>X("rubyInterpolationDelimiter", s:foreground, "", "")
	call <SID>X("rubyConditional", s:foreground, "", "")
	call <SID>X("rubyRepeat", s:foreground, "", "")
	call <SID>X("rubyControl", s:foreground, "", "")
	call <SID>X("rubyException", s:foreground, "", "")

	" Crystal Highlighting
	call <SID>X("crystalSymbol", s:foreground, "", "")
	call <SID>X("crystalConstant", s:foreground, "", "")
	call <SID>X("crystalAccess", s:foreground, "", "")
	call <SID>X("crystalAttribute", s:blue, "", "")
	call <SID>X("crystalInclude", s:blue, "", "")
	call <SID>X("crystalLocalVariableOrMethod", s:foreground, "", "")
	call <SID>X("crystalCurlyBlock", s:foreground, "", "")
	call <SID>X("crystalStringDelimiter", s:foreground, "", "")
	call <SID>X("crystalInterpolationDelimiter", s:foreground, "", "")
	call <SID>X("crystalConditional", s:foreground, "", "")
	call <SID>X("crystalRepeat", s:foreground, "", "")
	call <SID>X("crystalControl", s:foreground, "", "")
	call <SID>X("crystalException", s:foreground, "", "")

	" Python Highlighting
	call <SID>X("pythonInclude", s:red, "", "italic")
	"call <SID>X("pythonStatement", s:foreground, "", "bold")
	"call <SID>X("pythonExtraOperator", s:red, "", "")
	"call <SID>X("pythonExtraOperator", s:foreground, "", "")
	call <SID>X("pythonExtraPseudoOperator", s:red, "", "")
	call <SID>X("pythonBrackets", s:red, "", "")

	" JavaScript Highlighting
	call <SID>X("javaScriptBraces", s:foreground, "", "")
	call <SID>X("javaScriptFunction", s:foreground, "", "")
	call <SID>X("javaScriptConditional", s:foreground, "", "")
	call <SID>X("javaScriptRepeat", s:foreground, "", "")
	call <SID>X("javaScriptNumber", s:foreground, "", "")
	call <SID>X("javaScriptMember", s:foreground, "", "")
	call <SID>X("javascriptNull", s:foreground, "", "")
	call <SID>X("javascriptGlobal", s:blue, "", "")
	call <SID>X("javascriptStatement", s:red, "", "")

	" CoffeeScript Highlighting
	call <SID>X("coffeeRepeat", s:foreground, "", "")
	call <SID>X("coffeeConditional", s:foreground, "", "")
	call <SID>X("coffeeKeyword", s:foreground, "", "")
	call <SID>X("coffeeObject", s:foreground, "", "")

	" HTML Highlighting
	call <SID>X("htmlTag", s:red, "", "")
	call <SID>X("htmlTagName", s:red, "", "")
	call <SID>X("htmlArg", s:red, "", "")
	call <SID>X("htmlScriptTag", s:red, "", "")

	" ShowMarks Highlighting
	call <SID>X("ShowMarksHLl", s:foreground, s:background, "none")
	call <SID>X("ShowMarksHLo", s:foreground, s:background, "none")
	call <SID>X("ShowMarksHLu", s:foreground, s:background, "none")
	call <SID>X("ShowMarksHLm", s:foreground, s:background, "none")

	" Lua Highlighting
	call <SID>X("luaStatement", s:foreground, "", "")
	call <SID>X("luaRepeat", s:foreground, "", "")
	call <SID>X("luaCondStart", s:foreground, "", "")
	call <SID>X("luaCondElseif", s:foreground, "", "")
	call <SID>X("luaCond", s:foreground, "", "")
	call <SID>X("luaCondEnd", s:foreground, "", "")

	" Cucumber Highlighting
	call <SID>X("cucumberGiven", s:blue, "", "")
	call <SID>X("cucumberGivenAnd", s:blue, "", "")

	" Go Highlighting
	call <SID>X("goDirective", s:foreground, "", "")
	call <SID>X("goDeclaration", s:foreground, "", "")
	call <SID>X("goStatement", s:foreground, "", "")
	call <SID>X("goConditional", s:foreground, "", "")
	call <SID>X("goConstants", s:foreground, "", "")
	call <SID>X("goTodo", s:foreground, "", "")
	call <SID>X("goDeclType", s:blue, "", "")
	call <SID>X("goBuiltins", s:foreground, "", "")
	call <SID>X("goRepeat", s:foreground, "", "")
	call <SID>X("goLabel", s:foreground, "", "")

	" Clojure Highlighting
	call <SID>X("clojureConstant", s:foreground, "", "")
	call <SID>X("clojureBoolean", s:foreground, "", "")
	call <SID>X("clojureCharacter", s:foreground, "", "")
	call <SID>X("clojureKeyword", s:foreground, "", "")
	call <SID>X("clojureNumber", s:foreground, "", "")
	call <SID>X("clojureString", s:foreground, "", "")
	call <SID>X("clojureRegexp", s:foreground, "", "")
	call <SID>X("clojureParen", s:foreground, "", "")
	call <SID>X("clojureVariable", s:foreground, "", "")
	call <SID>X("clojureCond", s:blue, "", "")
	call <SID>X("clojureDefine", s:foreground, "", "")
	call <SID>X("clojureException", s:red, "", "")
	call <SID>X("clojureFunc", s:blue, "", "")
	call <SID>X("clojureMacro", s:blue, "", "")
	call <SID>X("clojureRepeat", s:blue, "", "")
	call <SID>X("clojureSpecial", s:foreground, "", "")
	call <SID>X("clojureQuote", s:blue, "", "")
	call <SID>X("clojureUnquote", s:blue, "", "")
	call <SID>X("clojureMeta", s:blue, "", "")
	call <SID>X("clojureDeref", s:blue, "", "")
	call <SID>X("clojureAnonArg", s:blue, "", "")
	call <SID>X("clojureRepeat", s:blue, "", "")
	call <SID>X("clojureDispatch", s:blue, "", "")

	" Scala Highlighting
	call <SID>X("scalaKeyword", s:foreground, "", "")
	call <SID>X("scalaKeywordModifier", s:foreground, "", "")
	call <SID>X("scalaOperator", s:blue, "", "")
	call <SID>X("scalaPackage", s:red, "", "")
	call <SID>X("scalaFqn", s:foreground, "", "")
	call <SID>X("scalaFqnSet", s:foreground, "", "")
	call <SID>X("scalaImport", s:foreground, "", "")
	call <SID>X("scalaBoolean", s:foreground, "", "")
	call <SID>X("scalaDef", s:foreground, "", "")
	call <SID>X("scalaVal", s:foreground, "", "")
	call <SID>X("scalaVar", s:foreground, "", "")
	call <SID>X("scalaClass", s:foreground, "", "")
	call <SID>X("scalaObject", s:foreground, "", "")
	call <SID>X("scalaTrait", s:foreground, "", "")
	call <SID>X("scalaDefName", s:blue, "", "")
	call <SID>X("scalaValName", s:foreground, "", "")
	call <SID>X("scalaVarName", s:foreground, "", "")
	call <SID>X("scalaClassName", s:foreground, "", "")
	call <SID>X("scalaType", s:foreground, "", "")
	call <SID>X("scalaTypeSpecializer", s:foreground, "", "")
	call <SID>X("scalaAnnotation", s:foreground, "", "")
	call <SID>X("scalaNumber", s:foreground, "", "")
	call <SID>X("scalaDefSpecializer", s:foreground, "", "")
	call <SID>X("scalaClassSpecializer", s:foreground, "", "")
	call <SID>X("scalaBackTick", s:foreground, "", "")
	call <SID>X("scalaRoot", s:foreground, "", "")
	call <SID>X("scalaMethodCall", s:blue, "", "")
	call <SID>X("scalaCaseType", s:foreground, "", "")
	call <SID>X("scalaLineComment", s:comment, "", "")
	call <SID>X("scalaComment", s:comment, "", "")
	call <SID>X("scalaDocComment", s:comment, "", "")
	call <SID>X("scalaDocTags", s:comment, "", "")
	call <SID>X("scalaEmptyString", s:foreground, "", "")
	call <SID>X("scalaMultiLineString", s:foreground, "", "")
	call <SID>X("scalaUnicode", s:foreground, "", "")
	call <SID>X("scalaString", s:foreground, "", "")
	call <SID>X("scalaStringEscape", s:foreground, "", "")
	call <SID>X("scalaSymbol", s:foreground, "", "")
	call <SID>X("scalaChar", s:foreground, "", "")
	call <SID>X("scalaXml", s:foreground, "", "")
	call <SID>X("scalaConstructorSpecializer", s:foreground, "", "")
	call <SID>X("scalaBackTick", s:blue, "", "")

    call <SID>X("haskell_conceal", s:comment, s:background, "bold")
    call <SID>X("haskellOperators", s:red, s:background, "")
    " following is for the haskell-conceal plugin
    " the first two items don't have an impact, but better safe

	" Git
	call <SID>X("diffAdded", s:blue, "", "")
	call <SID>X("diffRemoved", s:red, "", "")
	call <SID>X("gitcommitSummary", "", "", "bold")

    " ctrlP
	call <SID>X("CtrlPMatch", s:red, "", "bold")

    " syntastic
	call <SID>X("SyntasticErrorSign", s:red, "", "")
	call <SID>X("SyntasticWarningSign", s:selection, "", "")

	" Delete Functions
	delf <SID>X
	delf <SID>rgb
	delf <SID>colour
	delf <SID>rgb_colour
	delf <SID>rgb_level
	delf <SID>rgb_number
	delf <SID>grey_colour
	delf <SID>grey_level
	delf <SID>grey_number
endif
