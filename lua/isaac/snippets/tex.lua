local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

return {
	-- inline math
	s("inline", fmt("\\( {} \\)", { i(1) })),

	-- Matrices and Vectors
	s(
		"mat2",
		fmt(
			[[
      \begin{{{}}}
        {} & {} \\
        {} & {} \\
      \end{{{}}}
      ]],
			{
				i(1, "bmatrix"),
				i(2, "a_{11}"),
				i(3, "a_{12}"),
				i(4, "a_{21}"),
				i(5, "a_{22}"),
				rep(1),
			}
		)
	),

	s(
		"mat3",
		fmt(
			[[
      \begin{{{}}}
        {} & {} & {} \\
        {} & {} & {} \\
        {} & {} & {} \\
      \end{{{}}}
      ]],
			{
				i(1, "bmatrix"),
				i(2, "a_{11}"),
				i(3, "a_{12}"),
				i(4, "a_{13}"),
				i(5, "a_{21}"),
				i(6, "a_{22}"),
				i(7, "a_{23}"),
				i(8, "a_{31}"),
				i(9, "a_{32}"),
				i(10, "a_{33}"),
				rep(1),
			}
		)
	),

	-- matrix skeleton
	s(
		"matn",
		fmt(
			[[
      \begin{{{}}}
        {}     & {}     & \cdots & {}     \\
        {}     & {}     & \cdots & {}     \\
        \vdots & \vdots & \ddots & \vdots \\
        {}     & {}     & \cdots & {}     \\
      \end{{{}}}
      ]],
			{
				i(1, "bmatrix"), -- matrix type
				i(2, "a_{11}"),
				i(3, "a_{12}"),
				i(4, "a_{1n}"),
				i(5, "a_{21}"),
				i(6, "a_{22}"),
				i(7, "a_{2n}"),
				i(8, "a_{n1}"),
				i(9, "a_{n2}"),
				i(10, "a_{nn}"),
				rep(1),
			}
		)
	),

	s(
		"matdiag",
		fmt(
			[[
      \begin{{{}}}
        {}     & 0      & \cdots & 0      \\
        0      & {}     & \cdots & 0      \\
        \vdots & \vdots & \ddots & \vdots \\
        0      & 0      & \cdots& {}      \\
      \end{{{}}}
      ]],
			{
				i(1, "bmatrix"),
				i(2, "d_1"),
				i(3, "d_2"),
				i(4, "d_n"),
				rep(1),
			}
		)
	),

	s(
		"colvec3",
		fmt(
			[[
      \begin{{{}}}
        {} \\
        {} \\
        {} \\
      \end{{{}}}
      ]],
			{
				i(1, "bmatrix"),
				i(2, "x_1"),
				i(3, "x_2"),
				i(4, "x_3"),
				rep(1),
			}
		)
	),

	s(
		"rowvec3",
		fmt(
			[[
      \begin{{{}}}
        {} & {} & {}
      \end{{{}}}
      ]],
			{
				i(1, "bmatrix"),
				i(2, "x_1"),
				i(3, "x_2"),
				i(4, "x_3"),
				rep(1),
			}
		)
	),
	s(
		"colvecn",
		fmt(
			[[
      \begin{{{}}}
        {}     \\
        {}     \\
        \vdots \\
        {}     \\
      \end{{{}}}
      ]],
			{
				i(1, "bmatrix"),
				i(2, "x_1"),
				i(3, "x_2"),
				i(4, "x_n"),
				rep(1),
			}
		)
	),
	s(
		"rowvecn",
		fmt(
			[[
      \begin{{{}}}
        {} & {} & \cdots & {}
      \end{{{}}}
      ]],
			{
				i(1, "bmatrix"),
				i(2, "x_1"),
				i(3, "x_2"),
				i(4, "x_n"),
				rep(1),
			}
		)
	),
	s(
		"gradexpand",
		fmt(
			[[
      \begin{{{}}}
        \frac{{\partial {}}}{{ \partial {}_1}} & \frac{{\partial {}}}{{ \partial {}_2}} & \cdots & \frac{{\partial {}}}{{ \partial {}_{}}}
      \end{{{}}}
      ]],
			{
				i(1, "bmatrix"),
				i(2, "f"),
				i(3, "x"),
				rep(2),
        rep(3),
        rep(2),
        rep(3),
        i(4, "n"),
				rep(1),
			}
		)
	),

	-- Common Space and Sets
	s(
		"real",
		fmt(
			[[
       \mathbb{{R}}
      ]],
			{}
		)
	),
	s(
		"realvecspace",
		fmt(
			[[
      \mathbb{{R}}^{{{}}}
      ]],
			{
				i(1, "n"),
			}
		)
	),
	s(
		"realmatspace",
		fmt(
			[[
      \mathbb{{R}}^{{{} \times {}}}
      ]],
			{
				i(1, "n"),
				i(2, "n"),
			}
		)
	),
	s("complex", fmt([[\mathbb{{C}}]], {})),
	s(
		"complexvecspace",
		fmt(
			[[
      \mathbb{{C}}^{{{}}}
      ]],
			{
				i(1, "n"),
			}
		)
	),
	s(
		"complexmatspace",
		fmt(
			[[
      \mathbb{{C}}^{{{} \times {}}}
      ]],
			{
				i(1, "n"),
				i(2, "n"),
			}
		)
	),

  -- ML
	s(
		"optstat",
		fmt(
			[[
      \begin{{align*}}
        \text{{{}}} \quad & {} \\
        \text{{subject to}} \quad & {}
      \end{{align*}}
      ]],
			{
				i(1, "minimise"),
				i(2, "exp"),
				i(3, "constraints"),
			}
		)
	),
}
