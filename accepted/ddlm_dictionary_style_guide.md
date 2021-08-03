# Style Guide for DDLm Dictionaries

Version 1.1.0 2021-09-30

## Overview

The following rules describe the preferred layout of DDLm Reference
and Instance dictionaries. Following these rules should allow generic
dictionary manipulation software to ingest, semantically edit and
re-output dictionaries with minimal irrelevant changes to whitespace.

These rules are not intended to apply to CIF data files or Template
dictionaries.

These rules are not comprehensive, for example, they do not envisage
table values that are semicolon-delimited. They should cover all
situations typically encountered in DDLm dictionaries, and will be
expanded as new situations arise.

## Terminology

"Attribute" refers to a DDLm attribute (a "data name" in CIF syntax terms).
Columns are numbered from 1. "Starting at column x" means that the first
non-whitespace character (which may be a delimiter) appears in column x.
"Indent" refers to the number of whitespace characters preceding the first
non-whitespace value.

## Magic numbers

The following values are used in the description.

`line length`: 80
`text indent`: 4
`text prefix`: `>`
`value col`: 35
`value indent`: `text indent` + `loop step`
`loop indent`: 2
`loop align`: 10
`loop step`: 5
`min whitespace`: 2

## 1. Lines and padding

1. Lines are a maximum of `line length` characters long. Multi-line character strings should
be broken after the last whitespace character preceding this limit and trailing whitespace
removed.
2. Data values with no internal whitespace that would overflow the
line length limit if formatted according to the following rules should
be presented in semicolon-delimited text fields with leading blank
line, no indentation and folded, if necessary, so that the backslash
appears in column `line length`.
3. (No trailing whitespace) The last character in a line should not be whitespace.
4. Blank lines are inserted only as specified below. Blank lines do not accumulate,
that is, there should be no sequences of more than one blank line.
5. All lines are terminated by a newline character (`\n`) as per CIF2 specifications.
6. Tab characters may not be used either as whitespace or within data values, unless
part of the meaning of the data value.
7. No comments appear within, or after, the data block.
   
## 2. Value formatting

### 2.1 Text strings

In general multi-line text strings can include formatting like
centering or ASCII equations. The rules below aim to minimise
disruption to such formatting where present in the supplied
value. Note also that rule 1.2 overrides indentation rules below.

1. Values that can be presented undelimited should not be delimited,
   unless rule 9 applies.
2. Where a delimiter is necessary, the first delimiter in the
   following list that produces a syntactically correct CIF2 file
   should be used: (single quote `'`, double quote `"`,
   triple-single-quote `'''`, triple-double-quote `"""`, semicolon
   `\n;`).
3. Text fields containing newline characters are always semicolon-delimited.
4. If a text field contains the newline-semicolon sequence the text-prefix 
   protocol is used with `text prefix` as the prefix.
5. Each non-blank line of multi-line text fields not appearing as part of loops should
   contain `text indent` spaces at the beginning. Tab characters must not 
   be used for this purpose. Paragraphs are separated by a single blank line
   which must contain only a new line character. Lines may contain more than
   `text indent` spaces at the beginning, for example for ASCII equations or 
   centering purposes.
6. No tab characters may be used for formatting data values.
7. The first line of a semicolon-delimited text field should be blank, except
   for line folding and prefixing characters where necessary.
8. A new line character always follows the final semicolon of a semicolon-delimited text field.
9. Looped attributes should use the same delimiter for all items in the same column.
10. Category names in a category definition should be presented CAPITALISED in 
    `_name.category_id`, `_name.object_id` and `_definition.id`
11. Category and object names in data item definitions should be presented in "canonical" case.
    Canonical case follows the rules of English capitalisation where the first letter is not
    considered to start a sentence. In particular:
    1. Proper names and place names (e.g. Wyckoff, Cambridge) and
       their abbreviations (e.g. "H\_M" for "Hermann-Mauguin", "Cartn",
       "Lp\_factor") are capitalised.
    2. Symbols are capitalised according to crystallographic convention (e.g. Uij).
    3. Initialisms are capitalised (e.g. CSD, IT for International Tables).
12. Case-insensitive data items should be output with a leading
    capital letter unless convention dictates otherwise.
13. Values of attributes drawn from enumerated states should be capitalised in
    the same way as the definition of that attribute.
14. Function names defined in DDLm Function categories are CamelCased.

### 2.2 Lists

No DDLm attributes are currently defined that require more than one level of nesting.
If such attributes are defined, these rules will be extended.

1. The first and last values of a list are not separated from the delimiters by whitespace.
2. Each element of the list is separated by `min whitespace` from the next element.
3. Where application of the rules for loop or attribute-value layout require an internal 
   line break, the list should be presented as a multi-line compound object (see below).
4. These rules do not cover lists containing multi-line simple data values or lists
   with more than one level of nesting.

#### Examples

```
[112  128  144]

# One level of nesting, can stay on single line

[[t.11  t.12  t.13]  [t.21  t.22  t.23]  [t.31  t.32  t.33]]

# One level of nesting, can stay on a single line

    _import.get                   [{'file':templ_attr.cif  'save':aniso_UIJ}]
```

### 2.3 Tables

No DDLm attributes are currently defined that require more than one level of nesting.
If such attributes are defined, these guidelines will be extended.

1. Key:value pairs are presented with no internal whitespace around the `:` character.
2. The key is delimited by single quotes (`'`). If this is not possible, the rules
   for text strings (2.1) are followed.
3. Key:value pairs are separated by `min whitespace`.
4. Keys appear in alphabetical order.
5. There is no whitespace between the opening and closing braces and the first/last
   key:value pair.
6. Where application of the rules for loop or attribute-value layout require an 
   internal line break, the table should be presented as a multi-line compound object.
7. These rules do not cover tables containing multi-line simple data values or
   tables with more than one level of nesting.
   
#### Examples
```
{'save':orient_matrix  'file':templ_attr.cif}

[{'save':orient_matrix  'file':templ_attr.cif}]  #one level of nesting
```

### 2.4 Multi-line compound object

A multi-line compound object is a list or table containing
newlines. DDLm does not define attributes with more than one level of
nesting. These rules will be extended if and when such items are
defined. The indentation of the opening delimiter determined by rules
(1) and (2) is labelled `object indent`. Note that this refers to the
number of whitespace characters preceding the opening delimiter, so
the opening delimiter appears at column `object indent + 1`. The
intent of rule (1) is to minimise line breaks within any internal
compound objects.

1. The opening delimiter is placed at the maximum of (`value col`,
   the end of the previous value + `min whitespace`), as long as any
   internal compound values would not exceed the line length when
   formatted as non-multi-line values according to the following
   rules.
2. Otherwise, the opening delimiter is placed at `value indent + 1` on a new line.
3. Each subsequent value is formatted according to the present rules
   until the final character of the next value would be beyond `line length`.
4. The next value is placed on a new line indented by `object indent` + n, where
   n is the nesting level.
5. A nested opening delimiter followed immediately by a primitive value is placed on a
   new line indented by `object indent` + n, where n is the nesting
   level.
6. A closing delimiter immediately following a primitive value is placed on the
   same line.
7. Except when immediately following a primitive value, closing delimiters are
   placed on a separate line indented by the same amount as their corresponding
   opening delimiter.
8. A "corresponding value" is either a list entry at the same position
   in each list of a list of lists, or a table value with the same key
   in a list of tables. Corresponding values must be vertically
   aligned on their first character such that a minimum spacing of
   `min whitespace` is maintained, and at least one whitespace gap
   between each column is exactly `min whitespace` for at least one
   row.

#### Examples

```
# One level of nesting, but the nested data do not fit on a single line:

[
 [c.vector_a*c.vector_a  c.vector_a*c.vector_b  c.vector_a*c.vector_c]
 [c.vector_b*c.vector_a  c.vector_b*c.vector_b  c.vector_b*c.vector_c]
 [c.vector_c*c.vector_a  c.vector_c*c.vector_b  c.vector_c*c.vector_c]
]

# Alignment of internal values, nested opening delimiter

[
 {'file':cif_core.dic  'save':CIF_CORE  'mode':Full}
 {'file':cif_ms.dic    'save':CIF_MS    'mode':Full}
]

# Internal value doesn't fit when starting a value_col, so must start
# at value indent. Internal opening delimiter on new line

    _import.get
         [
          {"file":templ_attr.cif "save":Cromer_Mann_coeff}
          {"file":templ_enum.cif "save":Cromer_Mann_a1}
         ]

# Internal value fits using value_col as indent, but outer brackets are
# on separate lines by rule 5

    _import.get                   [
                                   {'file':templ_attr.cif  'save':Miller_index}
                                  ]

# Array item in loop starts at column 37 to maintain min whitespace

    loop_
      _dictionary_valid.application
      _dictionary_valid.attributes
         [Dictionary  Mandatory]    ['_dictionary.title'  '_dictionary.class'
                                     '_dictionary.version'  '_dictionary.date'
                                     '_dictionary.uri'
                                     '_dictionary.ddl_conformance'
                                     '_dictionary.namespace']
         [Dictionary  Recommended]  ['_description.text'
                                     '_dictionary_audit.version'
                                     '_dictionary_audit.date'
                                     '_dictionary_audit.revision']
 
```

## 3. Data items

### 3.1 Attribute-value pairs

Note the following rule assumes that no DDLm attributes are longer
than `value col` - `text indent` - `min whitespace`. The length of a
value includes the delimiters. The rules for attribute-value pairs
cover items from Set categories as well as items from single-packet
Loop categories.

1. DDLm attributes appear lowercased at the beginning of a line after
   `text indent` spaces.
2. A value with character length that is lesser or equal to
   `line length` - `value col` + 1 starts in column `value col`.
3. A value with character length that is greater than
   `line length` - `value col` + 1 and lesser or equal to
   `line length` - `value indent + 1` starts in column 
   `value indent + 1` of the next line.
4. A value with character length greater than 
   `line length - value indent + 1`
   is presented as a semicolon-delimited text string or as a multi-line
   compound object.
5. `_description.text` is always presented as a semicolon-delimited text string.
6. Attributes that take default values (as listed in `ddl.dic`) are
   not output, except:
   1. Those that participate in category keys
   2. The following attributes from category TYPE:
   `_type.purpose`, `_type.source`, `_type.container`,
   `_type.contents`
   3. Attributes used outside definitions (e.g. `_dictionary.class`)

#### Examples

```
    _definition.id                '_alias.deprecation_date'

# Maximum length value that can still appear on the same line (46 characters)

    _description_example.case     'Quoted value with padding: +++++++++++++++++'

# Minimum length value that must appear on the next line (47 characters)

    _description_example.case
        'Quoted value with padding: ++++++++++++++++++'

# Maximum length value that can appear on the next line (72 characters)

    _description_example.case
        'Quoted value with padding: +++++++++++++++++++++++++++++++++++++++++++'

# Minimum length value that requires semicolon delimiters (76 characters)

    _description_example.case
;
    Quoted value with padding: ++++++++++++++++++++++++++++++++++++++++++++
;

# Long values with no internal whitespaces that fit into a single line
# should be presented without indentation as specified in rule 2.1

    _description_example.case
;
InChI=1S/C6H12O6/c7-1-2-3(8)4(9)5(10)6(11)12-2/h2-11H,1H2/t2-,3-,4+,5-,6?/m1/s1
;

# Long values with no internal whitespaces that do not fit into a single
# line should be folded and presented without indentation as specified in
# rule 2.1

    _description_example.case
;\
InChI=1S/C40H60N10O12S2/c1-5-20(4)31-37(58)44-23(12-13-29(41)52)33(54)45-25(17-\
30(42)53)34(55)48-27(39(60)50-14-6-7-28(50)36(57)47-26(40(61)62)15-19(2)3)18-63\
-64-32(43)38(59)46-24(35(56)49-31)16-21-8-10-22(51)11-9-21/h8-11,19-20,23-28,31\
-32,51H,5-7,12-18,43H2,1-4H3,(H2,41,52)(H2,42,53)(H,44,58)(H,45,54)(H,46,59)(H,\
47,57)(H,48,55)(H,49,56)(H,61,62)/t20-,23+,24+,25?,26-,27-,28-,31+,32?/m1/s1
;
```

### 3.2 Loops

Loops consist of a series of packets. Corresponding items in each
packet should be aligned in the output to form visual columns. To
avoid confusion with "column" in the sense of "horizontal character
position", these visual columns are called "packet items" in the
following.  Note that loops in dictionaries rarely have more than 2
such packet items. The "width" of a packet item is the width of the
longest data value for the corresponding data name, including
delimiters. The rules below are designed to make sure that packet
items align on their first character, and that loops with only two
packet items are readable.

1. A loop containing a single data name and single packet is presented as an 
   attribute - value pair.
2. The lowercase `loop_` keyword appears on a new line after `text indent` spaces
   and is preceded by a single blank line.
3. The `n` lowercase, looped attribute names appear on separate lines starting at column 
   `text indent + loop indent + 1`.
4. Each packet starts on a new line. The final packet is followed by a single 
   blank line.
5. The first character of the first value of a packet is placed in column `loop align`.
6. Non-compound values that are longer than `line length - loop step`
   characters are presented as semicolon-delimited text strings.
7. Semicolon-delimited text strings in loops are formatted as for
   section 2.1, except that they are indented so that the first
   non-blank,non-prefix character of each line aligns with the first alphabetic
   character of the data name header, that is, the first non blank
   character appears in column `text indent` + `loop indent` + 2.
8. If the number of looped attributes `n` > 1, values in packets are
   separated by `min whitespace` together with any whitespace
   remaining at the end of the line distributed evenly between the
   packet items.  The following algorithm achieves this:
    1. Find largest integer `p` such that no data values before packet item
      `p` on the current line contain a new line and the sum of the widths
      of next `p` packet items, separated by `min whitespace` is not greater
      than `line length`. Call this total width.
    2. Calculate "remaining whitespace" as `floor((line length - total width)/(p-1))`.
    3. The start position of values for attribute number `d+1` is start position of attribute 
    `d` + width of data name `d + min whitespace + remaining whitespace + 1`.
    4. If p < n, the next value is placed in column `loop step` on a new line and
    procedure repeated from step 1.
    5. If any values for a data name contain a new line, data values following that
    data value start from step 4.
    6. Notwithstanding (4), the starting column for multi-line
    compound data values is that given in section 2.4.

9. If there are two values on a single line and the rules above would
   yield a starting column for the second value that is greater than
   `value col`, the calculated value is replaced by `value col` unless
   it would be separated by less than `min whitespace` from the first
   value in the packet.

10. If there are two values in a packet and the second value would
   appear on a separate line, `loop step` in rule 3.2.8.iv above is
   replaced by `loop align + text indent`. If one of the values is
   semicolon-delimited and the other is not, the semicolon-delimited
   value has an internal indent of `loop align - 1`.

#### Examples

```
# Alignment of semicolon-delimited text strings

    loop_
      _enumeration_set.state
      _enumeration_set.detail
         Attribute
;
         Item used as an attribute in the definition
         of other data items in DDLm dictionaries.
         These items never appear in data instance files.
;
         Functions
;
         Category of items that are transient function
         definitions used only in dREL methods scripts.
         These items never appear in data instance files.
;

# Alignment of semicolon-delimited text strings
# when both values are semicolon-delimited

    loop_
      _description_example.case
      _description_example.detail
;
       Example 1 in the first semicolon delimited field.
;
;
       Detail 1 in the second semicolon delimited field.
;
;
       Example 2 in the first semicolon delimited field.
;
;
       Detail 2 in the second semicolon delimited field.
;

# Alignment of single-line values

    loop_
      _enumeration_set.state
      _enumeration_set.detail
         Dictionary             'applies to all defined items in the dictionary'
         Category               'applies to all defined items in the category'
         Item                   'applies to a single item definition'

```
## 4. Ordering

### 4.1  Front matter and definitions

1. The first line contains the CIF2.0 identifier with no trailing whitespace.
2. Between the first line and the data block header is an arbitrary multi-line
comment, consisting of a series of lines commencing with a hash character.
The comment-folding convention is not used.
3. A single blank line precedes the data block header.
4. The final character in the file is a new line (`\n`).
5. A single blank line follows the data block header.
6. `data` is lowercase in the data block header.
7. The first definition is the `Head` category.
8. A category is presented in order: category definition, followed by
   all data names in alphabetical order, followed by child categories.
9. Categories with the same parent category are presented in alphabetical
   order.
10. Notwithstanding (8), SU definitions always follow the definitions of 
their corresponding Measurand data names.
11. Notwithstanding (9), categories with `_definition.class` of `Functions`
appear after all other categories.

### 4.2 Layout of non-save-frame information

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

2. All looped attributes describing the dictionary are presented as loops
appearing after the final save frame, in the following category order.
Looped data names appear in the order provided in brackets.
   1. DICTIONARY_VALID (scope, option, attributes)
   2. DICTIONARY_AUDIT (version, date, revision)

3. `_dictionary_audit.revision` is always presented as a semicolon-delimited
text string.

4. Non-looped attributes not covered in rule 4.2.1 appear in alphabetical order
after `_dictionary.namespace`.

5. Looped attributes not covered in rule 4.2.2 appear before
DICTIONARY_VALID in alphabetical order of category, with data names in
each loop provided in the order: key data names in alphabetical order,
followed by other data names in alphabetical order.

### 4.3 Definition layout

1. 1 blank line appears before and after the save frame begin and end codes.
The variable part of the save frame begin code is uppercase for categories
and lowercase for all others.
2. `_import.get` attributes are separated by 1 blank line above and below.
3. IMPORT_DETAILS attributes are not used.
4. Attributes in a definition appear in the following order, where
   present. The names in brackets give the order in which attributes
   in the given category are presented.
   1. DEFINITION(id, scope, class)
   2. DEFINITION_REPLACED(id, by)
   3. ALIAS (definition_id)
   4. `_definition.update`
   5. DESCRIPTION(text,common)
   6. NAME(category_id, object_id, linked_item_id)
   7. `_category_key.name`
   8. TYPE (purpose,source, container, dimension,contents,
            contents_referenced_id, indices, indices_referenced_id)
   9. ENUMERATION(range)
   10. ENUMERATION_SET(state, detail)
   11. `_enumeration.default`
   12. `_units.code`
   13. DESCRIPTION_EXAMPLE(case, detail)
   14. `_import.get`
   15. METHOD(purpose, expression)
   
5. Any attributes not included in this list should be treated as if they appear 
in alphabetical order after the last item already listed for their (capitalised)
categories above. If the category does not appear, the attributes are 
presented in alphabetical order of category and then `object_id` after 
DESCRIPTION_EXAMPLE.

## 5. Naming convention

1. Save frame codes must not start with an underscore symbol (`_`).
2. Save frame codes must not contain two consecutive underscore symbols.

## CHANGELOG

| Version | Date       | Revision |
|--------:|-----------:|:---------|
|   1.0.0 | 2021-07-20 | Initial release of the style guide. |
|   1.1.0 | 2021-09-30 | Added rules 5.1 and 5.2 that describe the use of underscores in save frame names. |
