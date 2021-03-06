# kindle-seforim
kindle-seforim is a collection of seforim in kindle ebook format, and in epub format, based on [Orayta-Books](https://github.com/MosheWagner/Orayta-Books) & [sefaria](https://www.sefaria.org).

This is a work in progress so there will be updates and changes coming.

Please file an issue if there are any mistakes or if you need a different format or sefer.

## Ebooks
To download just the finished ebooks [kindleseforim.paritcher.com](https://kindleseforim.paritcher.com).

## Status
- Shnaim Mikra
- Rambam with marks for 3 chapter
- Chumash with Rashi
- Nach
- Talmud with Rashi
- Steinsaltz talmud hebrew/english

## TODO
- add more seforim.

## Setup
- clone the reository.
- you may need to run `git submodules init` and `git submodules update` to get the submodule libraries.

##Usage
- run the scripts using `make script_name` for example `make rambam` to parse the html and save to `intermediate` then convert the html to a kindle ebook (.azw3) in `output`
- to zip up the completed files for release `make release`

## Acknowledgements
kindle-seforim uses the following libraries:

- [Orayta-Books](https://github.com/MosheWagner/Orayta-Books) source of the seforim.
licensed under the CC and or GDPL licenses
- [wikisource](https://he.wikisource.org) source of the seforim.
licensed under the CC 3.0 license
- [sefaria](https://www.sefaria.org) source of the seforim.
licensed under the CC license
- [calibre](https://calibre-ebook.com/) ebook conversion library.
Copyright (c) Kovid Goyal
licensed under the GNU GPL v3 license

Thank you

## License
kindle-seforim is Copyright (c) 2018 [Yparitcher](https://github.com/yparitcher)

ebooks licensed under the authors license mostly [CC BY-NC-SA](https://creativecommons.org/licenses/by-nc-sa/2.5/legalcode)

for font licenses look in the fonts folder

scripts source code licensed under [The MIT License (MIT)](http://opensource.org/licenses/mit-license.php)
