# kindle-seforim
kindle-seforim is a collection of seforim in kindle ebook format, based on [toratemetfreeware](http://www.toratemetfreeware.com).

This is a work in progress so there will be updates and changes coming.

Currently only shnaim mikra was converted.

## Ebooks
To download just the finished ebooks look in the output folder.

## Dependency
to format the seforim kindle-seforim requires:
- calibre
- iconv
- GNU grep
- GNU sed

## Setup
- download the html version of [toratemetfreeware](http://www.toratemetfreeware.com/?dbases;1;) and extract to the `source` folder.
- run `sort_files.sh` to sort into `sorted`
- run the scripts to parse the html and save to `intermediate` then convert the html to a kindle ebook (.azw3) in `output`


## Acknowledgements
kindle-seforim uses the following libraries:

- [toratemetfreeware](http://www.toratemetfreeware.com) source of the seforim.
licensed under the CC BY-NC-SA 2.5 license
- [calibre](https://calibre-ebook.com/) ebook conversion library.
Copyright (c) Kovid Goyal
licensed under the GNU GPL v3 license

Thank you

## License
kindle-seforim is Copyright (c) 2018 [Yparitcher](https://github.com/yparitcher)

ebooks licensed under [CC BY-NC-SA 2.5](https://creativecommons.org/licenses/by-nc-sa/2.5/legalcode)

scripts source code licensed under [The MIT License (MIT)](http://opensource.org/licenses/mit-license.php)
