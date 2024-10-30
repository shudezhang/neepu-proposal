%---------------------------------------------------------------------------%
%-                                                                         -%
%-                           Document Class                                -%
%-                                                                         -%
%---------------------------------------------------------------------------%
%- Copyright (C) Huangrui Mo <huangrui.mo@gmail.com> 
%- This is free software: you can redistribute it and/or modify it
%- under the terms of the GNU General Public License as published by
%- the Free Software Foundation, either version 3 of the License, or
%- (at your option) any later version.
%---------------------------------------------------------------------------%
%->> Identification
%---------------------------------------------------------------------------%
\NeedsTeXFormat{LaTeX2e}%
\newcommand*\@iflatexlater{\@ifl@t@r\fmtversion}%
\@iflatexlater{2017/01/01}{}{%
    \ClassError{neepuproposal}{TeXLive/MikTex >= 2017 is required ...}{}%
}
\ProvidesClass{neepuproposal}[2014/10/01 v1.0 LaTeX document class]%
%---------------------------------------------------------------------------%
%->> Declare options
%---------------------------------------------------------------------------%
%-
%-> Layout
%-
\DeclareOption{oneside}{%
    \PassOptionsToClass{oneside}{ctexart}%
}
\DeclareOption{twoside}{%
    \PassOptionsToClass{twoside}{ctexart}%
}
\newif\ifneepu@print \neepu@printfalse
\DeclareOption{print}{%
    \PassOptionsToClass{twoside}{ctexart}%
    \neepu@printtrue%
}
%-
%-> Language
%-
\newif\ifneepu@plain \neepu@plainfalse
\DeclareOption{scheme=plain}{% enable plain writing style
    \PassOptionsToClass{scheme=plain}{ctexart}%
    \neepu@plaintrue%
}
%-
%-> Draft version info
%-
\newif\ifneepu@versioninfo \neepu@versioninfofalse
\DeclareOption{draftversion}{%
    \neepu@versioninfotrue%
}
%-
%-> Handle non-implemented options
%-
\DeclareOption*{%
    \PassOptionsToClass{\CurrentOption}{ctexart}%
}
%-
%-> Terminates all options processing
%-
\ProcessOptions\relax%
%---------------------------------------------------------------------------%
%->> Load class information
%---------------------------------------------------------------------------%
\LoadClass[UTF8,a4paper,zihao=-4]{ctexart}%
\@ifclasslater{ctexart}{2017/01/01}{}{%
    \ClassError{neeputhesis}{ctex >= 2017/01/01 is required ...}{}%
}
%---------------------------------------------------------------------------%
%->> Required packages
%---------------------------------------------------------------------------%
\RequirePackage{ifxetex}% LaTeX engine detection
\RequirePackage{expl3}% LaTeX3 programming environment
\ExplSyntaxOn
\newcommand{\neepulntotab}[2][1pt]{% convert lines into table lines
    \seq_set_split:NnV \l_tmpa_seq {\\} {#2}
    \clist_set_from_seq:NN \l_tmpa_clist \l_tmpa_seq
    \clist_clear:N \l_tmpb_clist
    \clist_map_inline:Nn \l_tmpa_clist
      {%
        \clist_put_right:Nn \l_tmpb_clist 
          { \ulenhance[#1]{\ulextend{##1}} }
      }
    %\clist_show:N\l_tmpb_clist% show the content of comma list
    \clist_use:Nn \l_tmpb_clist { \\ & }
}
\ExplSyntaxOff
%---------------------------------------------------------------------------%
%->> Load class configuration
%---------------------------------------------------------------------------%
\AtEndOfPackage{% class cfg loaded after package to make preamble commands take effect
    \makeatletter
    \InputIfFileExists{Style/neepuproposal.cfg}{}{}
    \makeatother
}
%---------------------------------------------------------------------------%
%->> Page layout
%---------------------------------------------------------------------------%
%- use \topmargin insead of \voffset to shift the complete text vertically
%- use \<odd|even>sidemargin insead of \hoffset to shift text horizontally
%- part one -- horizontal widths
%- left side width + textwidth + right side width = paperwidth
%- binding side width + textwidth + nonbinding side width = paperwidth
%- binding side width of [odd, even] page = [left, right] side width
%- left side width of [odd, even] page = 1.0in (fixed) + hoffset + [odd, even]sidemargin
%- assuming A4 paper (210mm x 297mm)
\setlength{\textwidth}{146.6mm}% set required text width first
\setlength{\hoffset}{0mm}% set horizontal offset
\ifneepu@print% if print layout enabled
    \setlength{\oddsidemargin}{12.6mm}% binding side margin
    \setlength{\evensidemargin}{0mm}% ensure uniform binding side width for printing
\else
    \setlength{\oddsidemargin}{6.3mm}% left side margin
    \setlength{\evensidemargin}{6.3mm}% ensure uniform left side width for EThesis
\fi
\setlength{\marginparwidth}{35pt}% width of margin notes
\setlength{\marginparsep}{10pt}% width of space between body text and margin notes
%- part two -- vertical heights
%- top height + textheight + bottom height = paperheight
%- top height = 1.0in (fixed) + voffset + topmargin + headheight + headsep 
\setlength{\textheight}{246.2mm}% set required text height first
\setlength{\voffset}{0mm}% set vertical offset
\setlength{\topmargin}{-10.4mm}% vertical margin above header
\setlength{\headheight}{12pt}% header height
\setlength{\headsep}{17.5pt}% vertical margin between header and body text
\setlength{\footskip}{10.4mm}% vertical margin between footer and body text
%- specifies the amount of space between paragraphs.
\setlength{\parskip}{0.5ex plus 0.25ex minus 0.25ex}
%- line spacing
\linespread{1.4}% line space setting
\raggedbottom% prevent adding vertical white space in strange places
%- default pagestyle is page number at bottom without headers and footers
\pagestyle{plain}
%---------------------------------------------------------------------------%
%->> Style control commands
%---------------------------------------------------------------------------%
%- redefine cleardoublepage to have page style argument
\renewcommand{\cleardoublepage}[1][plain]{%
    \clearpage\if@twoside\ifodd\c@page\else%
    \thispagestyle{#1}%
    \hbox{}\newpage\if@twocolumn\hbox{}\newpage\fi\fi\fi%
}
%- underline
\ifxetex%
    \RequirePackage{ulem}%
\else%
    \RequirePackage{ulem}%
\fi
\newcommand{\ulunify}[1]{\uline{#1}}% unified name
\newcommand{\ulenhance}[2][1pt]{% enhanced underline
    \def\ULthickness{#1}% set thickness
    \setlength{\ULdepth}{0.3em}% set depth
    \expandafter\ulunify\expandafter{#2}% linebreak fix
}
\newcommand{\ulhshift}{-3em}% horizontal shift on underline
\newcommand{\ulextend}[2][350pt]{% extend underline length
    \hbox to #1{\hfill\hspace*{\ulhshift}#2\hfill}}
%- special cell
%- \specialcell[<align2>]{align1}{text1\\text2};
%- <align1>: t,c,b; <align2> l,c,r; @{} suppress spaces before and after text 
\newcommand{\specialcell}[3][c]{%
    \begin{tabular}[#2]{@{}#1@{}}#3\end{tabular}}
%---------------------------------------------------------------------------%
%->> Titlepage
%---------------------------------------------------------------------------%
%-
%-> Chinese item commands
%-
\def\neepu@value@ch@schoollogo{}
\newcommand{\schoollogo}[2]{\def\neepu@value@ch@schoollogo{\includegraphics[#1]{#2}}}
\def\neepu@value@ch@title{}
\def\neepu@value@ch@titlemark{}
\renewcommand{\title}[2][\neepu@value@ch@title]{%
  \def\neepu@value@ch@title{#2}
  %\def\neepu@value@ch@titlemark{\MakeUppercase{#1}}}
  \def\neepu@value@ch@titlemark{#1}}
\def\neepu@value@ch@author{}
\renewcommand{\author}[1]{\def\neepu@value@ch@author{#1}}
\def\neepu@value@ch@authorid{}
\newcommand{\authorid}[1]{\def\neepu@value@ch@authorid{#1}}
\def\neepu@value@ch@advisor{}
\newcommand{\advisor}[1]{\def\neepu@value@ch@advisor{#1}}
\def\neepu@value@ch@advisortitle{}
\newcommand{\advisortitle}[1]{\def\neepu@value@ch@advisortitle{#1}}
\def\neepu@value@ch@degree{}
\newcommand{\degree}[1]{\def\neepu@value@ch@degree{#1}}
\def\neepu@value@ch@degreetype{}
\newcommand{\degreetype}[1]{\def\neepu@value@ch@degreetype{#1}}
\def\neepu@value@ch@major{}
\newcommand{\major}[1]{\def\neepu@value@ch@major{#1}}
\def\neepu@value@ch@field{}
\newcommand{\field}[1]{\def\neepu@value@ch@field{#1}}
\def\neepu@value@ch@institute{}
\newcommand{\institute}[1]{\def\neepu@value@ch@institute{#1}}
\def\neepu@value@ch@date{}
\newcommand{\chinesedate}[1]{\def\neepu@value@ch@date{#1}}
%-
%-> English item commands
%-
\def\neepu@value@en@titlemark{\neepu@value@ch@titlemark}
\def\neepu@value@en@author{\neepu@value@ch@author}
%-
%-> Redefine Chinese style
%-
\renewcommand{\maketitle}{%
    \cleardoublepage
    \thispagestyle{empty}
    \begin{center}
        \linespread{1.3}
        \zihao{-3}\bfseries
        \vspace*{40pt}

        {\neepu@value@ch@schoollogo}

        \vspace*{21pt}

        % 博士学位论文开题报告
        {\zihao{-1}\bfseries \neepu@label@ch@thesis}
        \vspace*{35pt}

        % 报告题目
        {\zihao{-2}\bfseries \neepu@label@ch@title： \neepu@value@ch@title}
        \vspace*{25pt}

        % 个人信息
        \def\tabcolsep{1pt}
        
        \def\arraystretch{1.55}
        \begin{tabular}{lc}
            \neepu@label@ch@institute & \ulenhance{\ulextend[200pt]{\hspace*{-\ulhshift}\neepu@value@ch@institute}}\\ % 学院
            \neepu@label@ch@major & \ulenhance{\ulextend[200pt]{\hspace*{-\ulhshift}\neepu@value@ch@major}}\\         % 学科
            \neepu@label@ch@advisor & \ulenhance{\ulextend[200pt]{\hspace*{-\ulhshift}\neepu@value@ch@advisor}}\\     % 导师
            \neepu@label@ch@author & \ulenhance{\ulextend[200pt]{\hspace*{-\ulhshift}\neepu@value@ch@author}}\\       % 作者
            \neepu@label@ch@authorid & \ulenhance{\ulextend[200pt]{\hspace*{-\ulhshift}\neepu@value@ch@authorid}}\\   % 学号
            \neepu@label@ch@date & \ulenhance{\ulextend[200pt]{\hspace*{-\ulhshift}\neepu@value@ch@date}}             % 日期
      \end{tabular}
      \vspace*{108pt}

      % 编制单位
      {\zihao{3}\bfseries \neepu@label@ch@mark}
    \end{center}

    \clearpage
    \if@twoside
        \thispagestyle{empty}
        \ifneepu@versioninfo
            \vspace*{\stretch{1}}
            \begin{footnotesize}
                \noindent
                Draft Version (\today)
            \end{footnotesize}
        \fi
        \cleardoublepage[empty]
    \else
        \ifneepu@versioninfo
            \thispagestyle{empty}
            \vspace*{\stretch{1}}
            \begin{footnotesize}
                \noindent
                Draft Version (\today)
            \end{footnotesize}
            \cleardoublepage[empty]
        \fi
    \fi
    \ifneepu@print%
        \hypersetup{% set hyperlinks
            hidelinks,% remove link color and border
        }
    \fi
}
%---------------------------------------------------------------------------%
%->> Structure elements
%---------------------------------------------------------------------------%
\ifneepu@plain%
    \def\contentsname{\centerline{\neepu@label@en@tocname}}  % 目录标题居中
    \def\listfigurename{\neepu@label@en@lsfigname}
    \def\listtablename{\neepu@label@en@lstabname}
    \def\bibname{\neepu@label@en@bibname}
    \def\refname{\neepu@label@en@bibname}
    \def\algname{\neepu@label@en@algname}
    \def\bibetal{\neepu@label@en@bibetal}
    \def\biband{\neepu@label@en@biband}
    \def\axiomname{\neepu@label@en@axiomname}
    \def\theoremname{\neepu@label@en@theoremname}
    \def\lemmaname{\neepu@label@en@lemmaname}
    \def\corollaryname{\neepu@label@en@corollaryname}
    \def\assertionname{\neepu@label@en@assertionname}
    \def\propositionname{\neepu@label@en@propositionname}
    \def\conjecturename{\neepu@label@en@conjecturename}
    \def\definitionname{\neepu@label@en@definitionname}
    \def\examplename{\neepu@label@en@examplename}
    \def\remarkname{\neepu@label@en@remarkname}
    \def\proofname{\neepu@label@en@proofname}
    \def\@title{\neepu@value@en@titlemark}
    \def\@author{\neepu@value@en@author}
\else
    \def\contentsname{\centerline{\zihao{-2}\bfseries \neepu@label@ch@tocname}}  % 目录标题居中
    \def\listfigurename{\neepu@label@ch@lsfigname}
    \def\listtablename{\neepu@label@ch@lstabname}
    \def\algname{\neepu@label@ch@algname}
    \def\bibname{\neepu@label@ch@bibname}
    \def\refname{\neepu@label@ch@bibname}
    \def\bibetal{\neepu@label@ch@bibetal}
    \def\biband{\neepu@label@ch@biband}
    \def\axiomname{\neepu@label@ch@axiomname}
    \def\theoremname{\neepu@label@ch@theoremname}
    \def\lemmaname{\neepu@label@ch@lemmaname}
    \def\corollaryname{\neepu@label@ch@corollaryname}
    \def\assertionname{\neepu@label@ch@assertionname}
    \def\propositionname{\neepu@label@ch@propositionname}
    \def\conjecturename{\neepu@label@ch@conjecturename}
    \def\definitionname{\neepu@label@ch@definitionname}
    \def\examplename{\neepu@label@ch@examplename}
    \def\remarkname{\neepu@label@ch@remarkname}
    \def\proofname{\neepu@label@ch@proofname}
    \def\@title{\neepu@value@ch@titlemark}
    \def\@author{\neepu@value@ch@author}
\fi
%---------------------------------------------------------------------------%
%->> Structure elements configuration
%---------------------------------------------------------------------------%
%- section
\ctexset {
    section = {
        format = \zihao{-3}\sffamily\heiti,
        numberformat = \rmfamily,
        % number = {\chinese{section}},
        aftername = \quad,
        beforeskip = {12pt},
        afterskip = {12pt},
    }
}
%- subsection
\ctexset {
    subsection = {
        format = \zihao{4}\sffamily\heiti,
        numberformat = \rmfamily,
        aftername = \quad,
        beforeskip = {6pt},
        afterskip = {6pt},
    }
}
%- subsubsection
\ctexset {
    subsubsection = {
        format = \zihao{-4}\sffamily\heiti,
        numberformat = \rmfamily,
        aftername = \quad,
        beforeskip = {0pt},
        afterskip = {0pt},
    }
}
%---------------------------------------------------------------------------%
%->> Configure table of contents
%---------------------------------------------------------------------------%
%- the table of contents is specified by defining \l@chapter, \l@section, ...
%- most commands are then defined with the \@dottedtocline:
%- \@dottedtocline{⟨level⟩}{⟨indent⟩}{⟨numwidth⟩}{⟨title⟩}{⟨page⟩}
%- ⟨level⟩    an entry is produced only if ⟨level⟩ <= value of the tocdepth counter
%-            note, \chapter is level 0, \section is level 1, etc
%- ⟨indent⟩   indentation from the outer left margin of the start of the contents line
%- ⟨numwidth⟩ width of a box in which the section number is to go
%- <title>    title
%- <page>     page number

%- parameters for spacing and length in toc
\def\@dotsep{1.5mu}% separation between dots in mu units
\def\@pnumwidth{2em}% width of a box in which the page number is put
\def\@tocrmarg{2em}% right margin for multiple line entries, \@tocrmarg ≥ \@pnumwidth
\def\@sectionvspace{1ex}% vertical space between section titles

% 改变 subsection 的样式
%- redefine dottedtocline from classes.dtx and latex.LaTeX
\renewcommand*{\@dottedtocline}[5]{% [<level>,<indent>,<numwidth>,<title>,<page>]
    \ifnum #1>\c@tocdepth \else
        \vskip \z@ \@plus.2\p@
        {\leftskip #2\relax \rightskip \@tocrmarg \parfillskip -\rightskip
        \parindent #2\relax\@afterindenttrue
        \interlinepenalty\@M
        \leavevmode \zihao{-4}%\bfseries\sffamily
        \@tempdima #3\relax
        \advance\leftskip \@tempdima \null\nobreak\hskip -\leftskip
        {#4}\nobreak
        \leaders\hbox{$\m@th\mkern \@dotsep \cdot\mkern \@dotsep$}\hfill
        \nobreak
        \hb@xt@\@pnumwidth{\hfil \normalfont \normalcolor #5}%
        \par\penalty\@highpenalty}%
    \fi
}
%- redefine l@part from article.cls to add dotted toc line
\renewcommand*{\l@part}[2]{% [<title>,<page>]
    \ifnum \c@tocdepth >-2\relax
        \addpenalty\@secpenalty
        \addvspace{2.25em \@plus\p@}%
        \setlength\@tempdima{3em}%
        \begingroup
            \parindent \z@ \rightskip \@pnumwidth
            \parfillskip -\@pnumwidth
            {\leavevmode
            \zihao{-4}%\bfseries%\sffamily 
            #1
            \leaders\hbox{$\m@th\mkern \@dotsep \cdot\mkern \@dotsep$}% add dotted toc line
            \hfil \hb@xt@\@pnumwidth{\hss #2}}\par
            \nobreak
            \if@compatibility
                \global\@nobreaktrue
                \everypar{\global\@nobreakfalse\everypar{}}%
            \fi
        \endgroup
    \fi
}
% 修改 section 的样式
%- redefine l@section from article.cls to add dotted toc line
\renewcommand*\l@section[2]{% [<title>,<page>]
    \ifnum \c@tocdepth >\z@
        \addpenalty\@secpenalty
        \addvspace{\@sectionvspace \@plus\p@}%
        \setlength\@tempdima{1.5em}%
        \begingroup
            \parindent \z@ \rightskip \@pnumwidth
            \parfillskip -\@pnumwidth
            \leavevmode \zihao{-4}\sffamily\heiti
            \advance\leftskip\@tempdima
            \hskip -\leftskip
            #1\nobreak
            \leaders\hbox{$\m@th\mkern \@dotsep \cdot\mkern \@dotsep$}% add dotted toc line
            \hfil \nobreak\hb@xt@\@pnumwidth{\hss #2}\par
        \endgroup
    \fi
}
%- redefine indentation for others
%\renewcommand*\l@section{\@dottedtocline{1}{0em}{1em}}
\renewcommand*\l@subsection{\@dottedtocline{2}{1em}{1.8em}}
\renewcommand*\l@subsubsection{\@dottedtocline{3}{2em}{2.8em}}
\renewcommand*\l@paragraph{\@dottedtocline{4}{3em}{3.8em}}
\renewcommand*\l@subparagraph{\@dottedtocline{5}{4em}{4.8em}}
\renewcommand*\l@figure{\@dottedtocline{1}{0em}{0.8em}}
\renewcommand*\l@table{\@dottedtocline{1}{0em}{0.8em}}
%---------------------------------------------------------------------------%
\endinput

