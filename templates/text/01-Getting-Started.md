# Getting Started

Welcome to Verku! Verku is the esperanto command to compose/write, and this little gem of an application is intended to help you do just that. This short guide is designed for you as a beginner to get started with Verku.

Verku tries to get styling out of your way so you can just write. To accomplish this, it uses [Markdown](https://daringfireball.net/projects/markdown/) (specifically [Kramdown](kramdown.gettalong.org/syntax.html)) to give you just enough formatting to write. It then uses a LaTeX variant to create a PDF suitable for printing; or HTML, ePUB and Mobi for electronic distribution.

First you will need to install some prerequisites:

* The [Ruby](http://ruby-lang.org) interpreter version 2.0.0 or greater.
* The [XeTeX](hhttps://en.wikipedia.org/wiki/XeTeX) typesetting engine.
* The [KindleGen](http://www.amazon.com/gp/feature.html?docId=1000765211) converter.

## Installing Ruby

To install Ruby, consider using [RVM](http://rvm.io) or [rbenv](http://rbenv.org), both available for Mac OSX and Linux distros. If you're running a Windows, well, I can't help you. I don't even know if Verku runs over Windows boxes, so if you find any bugs, make sure you [let me know](https://github.com/Merovex/verku/issues).

## Installing XeTeX

[XeTeX](hhttps://en.wikipedia.org/wiki/XeTeX) is a TeX typesetting engine using Unicode and supporting modern font technologies such as OpenType, Graphite and Apple Advanced Typography (AAT). We're using XeTeX because TeX is one of the best ways of formatting a beautiful hard-copy book.

* On Mac: To install on a Mac, you will want to install the [MacTEX distribution](https://tug.org/mactex/).

## Installing KindleGen

KindleGen is the command-line tool that allows you to convert e-pubs into `.mobi` files. Once you've done that, then you can make your work available via [CreateSpace](https://www.createspace.com/pub/member.dashboard.do).

If you're running [Homebrew](http://brew.sh) on the Mac OSX, you can install it with `brew install kindlegen`. Go to [KindleGen's website](http://www.amazon.com/gp/feature.html?docId=1000765211) and download the appropriate installer otherwise.