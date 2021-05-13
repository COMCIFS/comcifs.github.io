# Style Guide for DDLm Dictionaries

## Overview

The following rules describe the preferred layout of DDLm dictionaries.  Following
these rules should allow generic dictionary manipulation software to ingest,
edit and re-output dictionaries with minimal irrelevant changes to whitespace. 
Columns are numbered from 1. Note that these rules do not apply to CIF data files.

## Magic numbers

The following values are used in the description.

`<line length>`: 80
`<text indent>`: 4
`<text prefix>`: `>`
`<tab size>`: 4
`<value col>`: 40
`<value indent>`: 5
`<loop indent>`: 3
`<loop align>`: 10
`<loop step>`: 5
`<min whitespace>`: 2

## Lines

1. Lines are a maximum of `<line length>` characters long. Multi-line character strings should
be broken after the last whitespace character preceding this limit
2. Data values with no internal whitespace that would overflow the line length limit
should be presented in semicolon-delimited text fields and folded so that the 
backslash appears in column `<line length>`, except for dREL expressions.
3. (No trailing whitespace) The last character in a line should not be whitespace, 
except where the whitespace is part of a multi-line data value
4. Blank lines are inserted only as specified below. Blank lines do not accumulate,
that is, there should be no sequences of more than one blank line.
   
## Value formatting

### Text strings

1. Values that can be presented undelimited should not be delimited
2. The default delimiter for single-line values is the single quote (`'`)
3. Where a single-line value contains a quote, the double quote (`"`) is used
4. Where a single-line value contains both quote and double-quote, the
   triple-quote is used
5. Where a single-line value contains both a double-quote and triple-quote,
   triple-double-quote is used
6. Otherwise, semicolon delimiters are used
7. Where necessary, the text-prefix protocol character is `<text prefix>`
8. Multi-line text fields should contain at least `<text indent>` spaces at the beginning of
   each new line. Tab characters must not be used for this purpose.
9. No tab characters may appear in data values. Where they appear, they
   should be transformed to `<tab size>` spaces.
10. The first line of a semi-colon delimited text field should be blank, except
   for line folding and prefixing characters where necessary
11. An EOL always follows the final semicolon of a semicolon-delimited text field
12. Looped data names should use the same delimiter for all items in the same column

### Lists

1. The first and last values of a table are not separated from the delimiters by whitespace
2. Each element of the table is separated by `<min whitespace>` from the next element
3. Where application of the rules for loop or attribute-value layout require a internal 
   line break, the list should be presented as a multi-line compound object.
4. Where more than one level of nesting is present, the list must be presented as a
   multi-line compound object

### Tables

1. Key:value pairs are presented with no internal whitespace around the `:` character
2. Key:value pairs are separated by `<min whitespace>`.
3. There is no whitespace between the opening and closing braces and the first/last
   key:value pair
4. Where application of the rules for loop or attribute-value layout require an 
   internal line break, the list should be presented as a multi-line compound object.
5. Where more than one level of nesting is present, the list must be presented as a
   multi-line compound object

### Multi-line compound object

A multi-line compound object is a list or table containing newlines.

1. The opening delimiter is placed on a new line at `<value indent>`.
2. Each subsequent value is formatted according to the present rules
   until the final character of the next value would be beyond `<line length>`
3. The next value is placed on a new line indented by `<value indent>` + n
4. The closing delimiter of a compound value is placed on a new line with
   the same indentation as its opening delimiter immediately followed by a
   new line character.

## Data items

### Attribute-value pairs

1. Attributes appear at the beginning of a line with no indentation
2. A value with character length <= `<line length>` - `<value col>` starts 
   in column `<value col>`
3. A value with character length between `<line length>` - `<value col>` and
   `<line length>` - `<value indent>` begins in column `<value indent>` of
   the next line
4. A value with character length greater than `<line length>` - `<value indent>` 
   is presented as a semicolon-delimited text string or as a multi-line compound
   object.

### Loops

Note that loops in dictionaries rarely have more than 2 columns. The "length"
of a column is the length of the longest data value for the corresponding
data name, including delimiters.

1. The `loop_` keyword appears on a new line with no indentation.
2. The looped data names appear on separate lines starting at column `<loop indent>`
3. Each packet starts on a new line
4. The first character of the first value of a packet is placed in column `<loop align>'`
5. The second column begins at the first multiple of `<loop align>` following the end of
   the first column + `<min whitespace>`, or 2 * `<loop align>`, whichever is greater.
5. However, if the resulting line length would be greater than `<line length>`, the first 
   character of the second column is placed on a new line with first character 
   in column `<loop step>`
7. If the second column is longer than `<line length>` - `<loop step>` 
   characters, it is presented as a semicolon-delimited text string.
8. Subsequent columns follow the rules for the second column

## Ordering

1. The first line contains the CIF2.0 identifier with no trailing whitespace
2. Between the first line and the data block header is an arbitrary multi-line
comment, consisting of a series of lines commencing with a hash character
3. A single blank line precedes the data block header
4. The final character is a new line (`\n`).
5. The first definition is the `Head` category
6. A category is presented in order of category definition, followed by
   all data names in alphabetical order, followed by child categories
7. Categories with the same parent category are presented in alphabetical
   order

### Layout of non-save-frame information

1. All non-looped attributes describing the dictionary appear before the
first save frame, in the following order:
   1. `_dictionary.title`
   2. `_dictionary.class`
   3. `_dictionary.version`
   4. `_dictionary.date`
   5. `_dictionary.uri`
   6. `_dictionary.ddl_conformance`
   7. `_dictionary.namespace`
   8. `_description.text`

2. All looped attributes describing the dictionary appear after the final
save frame, in the following category order:
   1. DICTIONARY_VALID (application, attributes)
   2. DICTIONARY_AUDIT (version, date, revision)
  
### Definition layout

1. 1 blank line appears before and after the save frame begin and end codes
2. _import.get attributes are separated by 1 blank line above and below.
3. Attributes in a definition appear in the following order, where present:
   1. DEFINITION(id, scope, class)
   2. ALIAS (definition_id)
   3. `_definition.update`
   4. `_description.text`
   5. NAME(category_id,object_id,linked_item_id)
   6. `_category_key.name`
   7. TYPE (purpose,source,container,contents)
   8. ENUMERATION(range)
   9. ENUMERATION_SET(state,detail)
   9. `_enumeration.default`
   9. `_units.code`
   9. DESCRIPTION_EXAMPLE(case,detail)
   10. `_import.get`
   11. METHOD(purpose, expression)
   
4. Any attributes not included in this list appear in alphabetical order after
the last item in their category provided above, or else in alphabetical order
of category and then `object_id` after DESCRIPTION_EXAMPLE.
