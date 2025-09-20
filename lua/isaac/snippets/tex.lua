local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

return {
	-- inline math
	s("inline", fmt("\\( {} \\)", { i(1) })),

	-- Piecewise functions expanded
	s(
		"piecewise",
		fmt(
			[[
      \begin{{cases}}
        {}, & {}, \\
        {}, & \text{{otherwise}}.
      \end{{cases}}
      ]],
			{
				i(1, "exp1"),
				i(2, "cond"),
				i(3, "exp2"),
			}
		)
	),

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

	s(
		"starter",
		fmt(
			[[
      \documentclass[11pt, answers]{{exam}}  % Change to 'noanswers' to hide solutions
      \usepackage{{amssymb, amsmath}} % For maths support
      \usepackage{{hyperref}}
      % \usepackage[authoryear]{{natbib}}
      \usepackage[square, numbers]{{natbib}}
      \usepackage[nameinlink]{{cleveref}}
      \usepackage{{bbm}}
      \usepackage{{listings, xcolor}} % `listings` for including code, `xcolor`  for syntax highlighting
      \usepackage{{minted}}
      \usepackage{{booktabs}}
      \usepackage{{footnote}}
      \usepackage{{bm}}
      %\usepackage{{tikz}} % tikz library is famous for slowing down compilation, uncomment if needed
      \usepackage{{standalone}}
      % \usepackage{{physics}} % This package have some very useful macros, but I don't like it.
      
      % Some useful definition for Exam environment and cleveref package
      \crefname{{question}}{{question}}{{questions}}
      \Crefname{{question}}{{Question}}{{Questions}}
      \crefname{{partno}}{{part}}{{parts}}
      \Crefname{{partno}}{{Part}}{{Parts}}
      \crefname{{subpartno}}{{subpart}}{{subparts}}
      \Crefname{{subpartno}}{{Subpart}}{{Subparts}}

      % Allow hyperref to break links into two lines
      \hypersetup{{breaklinks=true}}
      % Allow for footnote in solution
      \makesavenoteenv{{solution}}
      
      % Useful custom command
      \newcommand{{\abs}}[1]{{\left\lvert #1 \right\rvert}}
      \newcommand{{\size}}[1]{{\left\lVert #1 \right\rVert}}
      \newcommand{{\set}}[2]{{\left\{{ #1 \; \middle\vert \; #2 \right\}}}}
      \newcommand{{\diag}}{{\mathrm{{diag}}}}
      \newcommand{{\inner}}[2]{{\left\langle #1, #2 \right\rangle}}
      \newcommand{{\vtr}}[1]{{\mathbf{{#1}}}}
      \newcommand{{\algomin}}[1]{{\text{{minimize}} \quad #1}}
      \newcommand{{\gradvec}}[1]{{\nabla_{{\vtr{{#1}}}}}}
      \newcommand{{\prob}}[1]{{\mathbb{{P}}\!\left(#1\right)}}
      \newcommand{{\expect}}[1]{{\mathbb{{E}}\!\left(#1\right)}}
      \newcommand{{\pdv}}[2]{{\frac{{\partial #1}}{{\partial#2}}}}
      \newcommand{{\pdvexp}}[2]{{\frac{{\partial}}{{\partial#2}}\!\left(#1\right)}}
      \newcommand{{\tr}}[1]{{\mathchoice
        {{\text{{tr}}\!\left(#1\right)}}     % displaystyle
        {{\text{{tr}}\!\left(#1\right)}}     % textstyle
        {{\text{{tr}}\left(#1\right)}}       % scriptstyle
        {{\text{{tr}}\left(#1\right)}}       % scriptscriptstyleleft(#1\right)
      }}
      
      % Typeset listing format
      \lstset{{
        basicstyle=\ttfamily\footnotesize,
        keywordstyle=\color{{blue}},
        commentstyle=\color{{gray}},
        stringstyle=\color{{red}},
        showstringspaces=false,
        breaklines=true
      }}

      % Define colors (optional)
      \definecolor{{bg}}{{rgb}}{{0.95,0.95,0.95}}
      \definecolor{{mygreen}}{{rgb}}{{0,0.6,0}}
      \definecolor{{mygray}}{{rgb}}{{0.5,0.5,0.5}}
      \definecolor{{myblue}}{{rgb}}{{0.2,0.2,0.6}}

      % Set minted default style
      \usemintedstyle{{default}}

      % Global minted config
      \setminted{{
        bgcolor=bg,
        linenos=true,
        numbersep=10pt,
        frame=lines,
        framesep=2mm,
        baselinestretch=1.1,
        fontsize=\footnotesize,
        tabsize=2,
        breaklines=true,
        breakautoindent=true,
        style=colorful
      }}

      \begin{{document}}

      \title{{{}}}
      \author{{Isaac Leong}}
      \date{{\today}}
      \maketitle

      \begin{{questions}}

      \question {}
      \end{{questions}}

      \bibliographystyle{{abbrvnat}}
      \bibliography{{reference}}

      \end{{document}}
      ]],
			{
				i(1, "Title"),
				i(2, "\\textbf{Question Briefs... } First Question..."),
			}
		)
	),

	s(
		"snippet",
		fmt(
			[[
            \begin{{minted}}[fontsize=\small, bgcolor=gray!10]{{text}}
              Some code...
            \end{{minted}}

      ]],
			{}
		)
	),
}
