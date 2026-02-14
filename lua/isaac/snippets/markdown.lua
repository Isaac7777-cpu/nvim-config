local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

return {
	-- arrows
	s("->", fmt("$\\rightarrow$ ", {}), {}),
	s("<-", fmt("$\\leftarrow$ ", {}), {}),
}
