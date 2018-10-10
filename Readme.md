# kindle-seforim
kindle-seforim is a collection of seforim in kindle ebook format, based on [toratemetfreeware](http://www.toratemetfreeware.com) and [Orayta-Books](https://github.com/MosheWagner/Orayta-Books).

This is a work in progress so there will be updates and changes coming.

Please file an issue if there are any mistakes or if you need a different format or sefer.

## Ebooks
To download just the finished ebooks [click on releases](https://github.com/yparitcher/kindle-seforim/releases/latest). to use the embedded font make sure that `use publisher font` is set to on in your kindle

## Status
- Shnaim mikra
- Rambam

## TODO
- add epub support.
- add more seforim.
- add makefile

## Setup
- download the html version of [toratemetfreeware](http://www.toratemetfreeware.com/?dbases;1;) and extract to the `source` folder.
- you may need to run `git submodules init` and `git submodules update` to get the submodule libraries.
- run `sort_files.sh` to sort into `sorted`
- run the scripts to parse the html and save to `intermediate` then convert the html to a kindle ebook (.azw3) in `output`


## Acknowledgements
kindle-seforim uses the following libraries:

- [toratemetfreeware](http://www.toratemetfreeware.com) source of the seforim.
licensed under the CC BY-NC-SA 2.5 license
- [Orayta-Books](https://github.com/MosheWagner/Orayta-Books) source of the seforim.
licensed under the CC and or GDPL licenses
- [wikisource](https://he.wikisource.org) source of the seforim.
licensed under the CC 3.0 license
- [calibre](https://calibre-ebook.com/) ebook conversion library.
Copyright (c) Kovid Goyal
licensed under the GNU GPL v3 license

Thank you

## License
kindle-seforim is Copyright (c) 2018 [Yparitcher](https://github.com/yparitcher)

ebooks licensed under [CC BY-NC-SA 2.5](https://creativecommons.org/licenses/by-nc-sa/2.5/legalcode)

for font licenses look in the fonts folder

scripts source code licensed under [The MIT License (MIT)](http://opensource.org/licenses/mit-license.php)
