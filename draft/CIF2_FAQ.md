# CIF2 Frequently Asked Questions

## What is CIF2? 

CIF2 is a revision and improvement of the IUCr's 20 year old CIF format ('CIF1'). 

## How does CIF2 improve on CIF1?

CIF2 allows Unicode characters, and matrices and arrays as
datavalues. It provides the more familiar triple quote (`'''`)
alternative to semicolons as multi-line string delimiters, and it
disallows embedded quotes in delimited strings,
simplifying parsing.

## I don't need that new stuff. Can't I just stick with CIF1?

Absolutely. CIF1 was developed and promoted as an archival format, and the 
IUCr are committed to supporting CIF1 in perpetuity, as are the leading
crystallographic database services such as the Protein Data Bank (wwPDB), 
CCDC, COD and ICSD.
What approach your software ultimately takes will depend upon
what your ecosystem of CIF providers and CIF consumers do. 
We will provide some tools for conversion between CIF2 and CIF1 so that you can
continue to use CIF1 within your program.

## What tools are available for CIF2?

The upcoming C-language CIFAPI implementation developed by John Bollinger is fully conversant with
CIF1 and CIF2. Once bindings to popular programming languages are made available (or using
SWIG) it would be a good choice for many projects.  Other CIF2-conversant software
is listed on [this page](cif2_software.html).

## Can I read a CIF2 format file with my CIF1 parser?

Reading a CIF2 file with a CIF1 parser will not always succeed, due to
the addition of unicode characters and new types of datavalues (tables, lists,
additional string delimiters) in
CIF2.  

However, if none of the new features are
present in the CIF2 format file, a CIF1 parser will succeed.  A
CIF datafile containing only datanames defined in current dictionaries and not using
`'''` or `"""` as delimiters will read in correctly as long
as there are no undelimited datavalues starting with `[` or `{`.

## Can I write a parser that will read both CIF1 and CIF2 files?

Yes, because CIF2 files are required to begin with the characters `#\#CIF_2.0`. You can
choose which set of parsing rules to use depending on this string.

## Can I read a CIF1 format file with my strict CIF2 parser?

No, due to the header string mentioned above, and see the answer to the next question.

## Can I read a CIF1 format file with my liberal CIF2 parser?

If you ignore the header string mentioned above, your chances are good of being
able to read in a CIF1 file correctly.  The key differences to watch out for are
strings with embedded delimiters, like `'CA'T'`, which are forbidden in CIF2, 
and non-delimited strings that start with `{` characters, which are used
to start CIF2 'Table' datavalues. Neither of these types of datavalues are particularly common.

## How do I make my software CIF2-ready?

See the next questions for information specific to reading and writing CIFs.

## My software outputs CIF1 files.  What changes should I make when outputting CIF2 files?

Firstly you should begin your files with the string `#\#CIF2.0`. Then
you should adjust your string datavalue output to use delimiters in
most cases. See the [separate document](simple_steps.html) for the simple steps you need to
take.  At a future date, when matrix or table-valued datanames are
defined, you should be ready to output them with correct syntax.

## My software reads CIF files. How do I become CIF2 ready?

You will need to enhance your old CIF1 parser with the ability to read
(possibly nested) matrix and table datastructures, to recognise
triple-quoted strings, and to accept Unicode.  
