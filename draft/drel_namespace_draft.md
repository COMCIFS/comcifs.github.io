# Proposal to add namespaces to dREL

## Summary

It is proposed that the new construction `<namespace> "|" <identifer>`
be added to dREL to allow disambiguation of `<identifier>` when
necessary. Note this is not relevant to the way in which data names are
written in data files.

## Introduction

dREL methods operate within a relational context. Tables
("categories") from this context are automatically bound to variables
within the dREL method. Occasionally, contexts may identify tables using a
two-part name: for example, if the table names are drawn from
different domains which happen to use the same table identifier, a
label associated with the domain itself could be used for
disambiguation.

dREL currently does not have syntax to allow for such two-part
names.

## New syntax

Currently 
[the formal grammar for dREL](https://github.com/COMCIFS/dREL/blob/master/annotated-grammar.rst)
contains the following line defining an identifier:

```
ident = ID ;
```

where `ID` is defined by a suitable regular expression. The proposal is to change this to
the following:

```
    ident = ID ;
    nspace = ID BAR ;
    nident = [ nspace ] ident ;
```

and replacing `ident` by `nident` in those productions that may refer to categories.
In the following productions any appearances of `nident` were previously `ident`:

```
call = nident  LEFTPAREN [expression_list] RIGHTPAREN ;
dotlist_assign = nident "("  dotlist  ")" ;
att_primary = nident | attributeref | subscription | call ;
loop_stmt =  LOOP ident AS nident [ COLON  ident  [restricted_comp_operator  ident]] suite ;
with_stmt = WITH  ident  AS  nident  suite ;
```

## Example

Code to transform dictionary information from ddl2 to ddlm.

```
loop dd as ddl2|dictionary {
    ddlm|dictionary(.title = dd.title,
                    .version = dd.version
                    )
}
```

## Comments

1. Use of a namespace for a table identifier is optional (`nident = [ nspace ] ident`)
1. Vertical bar `|` has been chosen as the separator as this leads to an unambiguous grammar.
The only appearance of vertical bar in the grammar is as `||` meaning "bitwise or". `:` (colon)
leads to ambiguity due to its widespread use in other places in the grammar.
1. Namespaces are made available for function calls as DDLm dictionaries can define functions,
which may therefore have namespaces associated with them.
1. DDLm dictionaries already include a `_dictionary.namespace` attribute.
1. This proposal has no implications for the structure or appearance of data names 
in data files.
1. Use of this facility is only likely (i) when interoperating with outside
domains, over which we have no naming control, or (ii) categories are named identically,
even if the data name as a whole is distinct.
1. The productions above have been tested using the [Lerche grammar parser](https://github.com/jamesrhester/Lerche.jl) to create Julia code that successfully transforms between DDL2
and DDLm dictionaries using dREL expressions, disambiguating the "dictionary" and
"category_key" categories that appear in both.
