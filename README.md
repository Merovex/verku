bookmaker
=========

Bookmaker provides authors a free, ruby-based production toolchain for self-published paper and electronic books using the [LaTeX](http://www.latex-project.org/) document preparation system. The code base borrows heavily from [Kitabu](https://github.com/fnando/kitabu), while replacing [Prince](http://princexml.com) as the PDF generator (due to licensing issues).

Bookmaker requires familiarity with LaTeX. Many TeX features are lacking when exporting to HTML, EPUB or MOBI.

What Does Bookmaker Provide?
----------------------------

* Write using LaTeX
* Paper Support: Book-quality PDF output (6"x9") using [Memoir](http://www.ctan.org/tex-archive/macros/latex/contrib/memoir), suitable for publishing via [Createspace](https://www.createspace.com).
* Electronic Support: HTML, Epub and Mobi output (using [kindlegen](http://kindlegen.s3.amazonaws.com)).
* Table of Contents automatically generated from chapter titles

Installation
-------------

To install Bookmaker, you’ll need a working [Ruby](http://www.ruby-lang.org) 1.9+ installation.

    $ gem install bookmaker

<!--

After installing Bookmaker, run the following command to check your external
dependencies.

  $ bookmaker check

  KindleGen: Converts ePub e-books into .mobi files.
  Installed.

  html2text: Converts HTML documents into plain text.
  Not installed.

  pygments.rb: A generic syntax highlight. If installed, replaces CodeRay.
  Not installed.

There's no requirements here; just make sure you cleared the correct dependency based
on the formats you want to export to.

-->

How to Use Bookmaker
--------------------

To create a new Bookmaker project, execute the following on the command line:

    $ bookmaker new mybook

This command creates a directory <tt>mybook</tt> with the following structure:

    mybook
    ├── _bookmaker.yml
    ├── output
    ├── templates
    │   ├── epub
    │   │   ├── cover.erb
    │   │   ├── cover.png
    │   │   ├── page.erb
    │   │   └── user.css
    │   └── html
    │       ├── layout.css
    │       ├── layout.erb
    │       ├── syntax.css
    │       └── user.css
    └── text
        └── 01_Chapter
            └──01_Welcome.md

The <tt>_bookmaker.yml</tt> file holds the project's metadata. Update the relevant fields.

Now it's time to write your e-book. All your book content will be placed on the text directory. Bookmaker requires you to separate your book into chapters. A chapter is nothing but a directory that holds lots of text files. The e-book will be generated using every folder/file alphabetically. So be sure to use a sequential numbering as the name. Here's a sample:

  * text
    * 01_Introduction
      * 01_introduction.tex
    * 02_What_is_Ruby_on_Rails
      * 01_MVC.tex
      * 02_DRY.tex
      * 03_Convention_Over_Configuration.tex
    * 03_Installing_Ruby_on_Rails
      * 01_Installing.tex
      * 02_Mac_OS_X_instructions.tex
      * 03_Windows_instructions.tex
      * 04_Ubuntu_Linux_instructions.tex

Please note, **Kitabu** allows multiple file formats. **Bookmaker** only allows <tt>.tex</tt>.

You'll want to see your progress eventually; it's time for you to generate the book PDF. Run the command <tt>bookmaker export</tt> and your book will be created on the <tt>output</tt> directory.

When you're ready to view your progress, the commands below will compile the book into the appropriate format:

Compile into: PDF, HTML, Epub, Mobi

    $ bookmaker export

Compile into a specific format:

    $ bookmaker export --only [pdf|html|epub|mobi]

When compiling into HTML, Epub or Mobi, **Bookmaker** generates the Table of Contents (TOC) based on the h2-h6 tags. The h1 tag is discarded because it's meant to be the book title.

To print the TOC, you need to print a variable called +toc+, using the eRb tag.

    <%= toc %>

### Dependencies

**Bookmaker** needs the following dependencies satisfied:

* [xelatex](en.wikipedia.org/wiki/XeTeX), available on via MacTeX (Mac) and MiKTex (Windows, unconfirmed).
* LaTex to HTML conversion done within the gem itself.
* HTML to EPUB via [Merovex-EeePub](https://github.com/Merovex/eeepub). Install it directly from Github
* EPUB to Mobi via [Kindlegen](http://kindlegen.s3.amazonaws.com)
* Patience - This was developed for my own writing purposes, and is likely incomplete as of this writing.

### References

* [LaTeX](http://en.wikipedia.org/wiki/LaTeX) [http://www.latex-project.org/](http://www.latex-project.org/)

## Samples

## Maintainer

* Ben Wilson [http://dausha.net](http://dausha.net)

## License

(The MIT License)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.