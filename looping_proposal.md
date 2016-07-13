# Proposal to allow looping of previously unlooped datanames

## Introduction

In the original DDL1 and the current version of DDLm, categories must
be explicitly labelled as loopable in order for their datanames to
appear in multi-row loops.  In DDL2, all categories are notionally
loopable, but datanames for which only one value is allowed per
datablock are restricted to single-row loops (or equivalently,
key-value pairs) by linking their category key to a
one-value-per-block 'entry' category.

In some situations, being able to loop a conventionally category is
desirable.  For example, structural data might be presented in both
standard and alternate space group settings, meaning multiple space
groups are included in the datablock.  While such a use of CIF
datanames may appear to be benign, it can easily lead to CIF-reading
software silently producing incorrect results.  The underlying reason
for this is that interpretation of looped dataname values often
depends on values of unlooped datanames (e.g. unit cell parameters are
needed to transform fractional coordinates into distances), and more
than one value for these unlooped datanames therefore leads to
ambiguity.

We here propose a mechanism that allows any dataname to appear
in a multi-row loop, while protecting current software from
inadvertent misinterpretation of such files.

## Proposal summary

A new dataname, `_audit.schema`, is defined and must be checked by all
CIF-reading software.  Values of this dataname are linked to special
categories that are used to loop and link other categories together.
All CIF-reading software should check this dataname.  CIF-writing
software need only set this dataname if a non-default value is
chosen.

## Definitions

For ease of discussion we adopt some terminology from relational databases:

* A *compound key* is a set of datanames whose values collectively
  determine a unique row in a loop
* A _key_ is a dataname that is part of a compound key
* A _child key_ is a key whose values are restricted to values taken
  by a _parent_ key.
* _Sibling keys_ are keys that have a common parent key

## Proposal in detail

This proposal affects only the domain dictionaries and dREL.

### Domain dictionaries

(i) Dataname `_audit.schema` is added to the core dictionary, and
all CIF reading software is expected, after a transitional period, to
check its value; if missing, the value defaults to `Base`,
corresponding to all current CIF datafiles.  See Appendix I for a
formal DDLm definition.

(ii) A 'master hub' Loop category is added to the cif_core dictionary,
corresponding to the default value of `_audit.schema`. The main role of
this category is to restrict datanames to a single value, which mimics
current CIF usage (see next point). This category contains a single
key dataname provided with a default value, meaning that the category
may be omitted from the datafile if only one packet is present (the
case for all currently valid CIF files). See Appendix II for a draft
definition.

(iii) All categories are provided with a 'master hub' child key. This
      is the only key provided for 'Set' categories in the core
      dictionary, thus restricting 'Set' categories to a single value
      for each dataname whenever the 'master hub' has a single entry
      (the default). The designation of a category as 'Set' is
      thus equivalent to stating that it has a single key which takes a
      single value in a datablock.

(v) Once `_audit.schema` checking is widespread, expansion dictionaries
are allowed to add keys to previously-defined categories.  Datafiles
written according to the expansion dictionaries must set _audit.schema
appropriately, and change the 'Set' designation of any categories that
can now be written with multiple loop packets.

### dREL

dREL expects methods that reference looped categories outside the
current category to explicitly construct the key to those
categories. In a situation where the list of keys for that category
and the current category may be altered by an expansion dictionary,
such explicit key construction requires duplication of functionally
identical code, clutters the definition and is generally unnecessary,
because, in most cases, a unique row for the external category can be
derived from the current values of the current category's keys.

In addition, dREL refers to external 'Set' categories without any
use of keys, although formally all categories now have keys.

dREL is therefore altered to behave as follows:

In non-category methods:

(1) All uses of the "dot" operator of the form `cat.name` implicitly
assume the values of any sibling compound keys for `cat` currently in
scope.

(2) All Loop operations restrict packets of the looped category
to those that have common values for any sibling compound keys in scope
(a 'pre-filter' operation)

(3) If rule (1) does not lift ambiguity, keys may be listed in the format
`cat[key1_val, key2_val].name` (a dREL syntax enhancement).

(4) (General style) Given that compound keys are directly accessed in
the above rules, so-called ID (primary) key datanames constructed from
the values of compound keys are avoided in dREL methods. In
particular, their values should never be deconstructed or assigned to
other datanames, and may only be constructed within category methods.

In category methods:

dREL category methods are required to set the values of all compound
keys in order to create the category.  In order for new keys to be added
without changing the method unnecessarily, the following rule
is adopted:

(4) The category method is repeatedly executed for every combination
     of those compound key values for which no values are explicitly
     set by the category method. Execution follows the rules for
     normal methods, with the compound key values described in the
     previous sentence placed in scope.

## Discussion

Although this proposal involves adding an extra key dataname to virtually
all categories, by giving a default value for these datanames they can
effectively be left out of datafiles (or ignored) as long as the
master hub has only one row. The default value of `_audit.schema` refers
to exactly this situation.  Minimal space will be occupied in the dictionary
file by these definitions due to use of the templating mechanism.

Each `_audit.schema` value refers to a distinct set of categories that can
have multiple packets. Software written for `_audit.schema` "A" will in general
only function correctly for a file written against `_audit.schema` "B" if
the set of multiple-packet categories for "B" is a subset of those for "A".

Note that `_audit.schema` is advisory and that the same information can
be determined from the dictionaries listed in `audit_conform`.

### Legacy issues

One category (`space_group`) in the DDL1 cif core dictionary was mistakenly
allowed to be looped without making corresponding alterations to the
many other categories that relied upon having a single space group. This
is fixed under the current proposal as follows:

(i) category `space_group` is, as for most other categories, given a
child key of the master hub key, thereby limiting it to a single value
in ordinary CIF data files;
(ii) `space_group.id`, `space_group_Wyckoff.sg_id` and
     `space_group_symop.sg_id` are removed

In a separate DDLm dictionary file (a successor to symCIF):

(iii) a new category, `space_group_tables` is defined, containing a
single default-valued (key) dataname;
(iv) all categories that previously assumed a single space group are provided
     with child keys of `space_group_tables`. In particular, the keys removed in
     step (ii) above are redefined as child keys of `space_group`.

Finally:
(v) a new enumerated value of `_audit.schema` is defined,
(e.g. 'space group tables') corresponding to a datablock possibly
containing multiple packets in the category `space_group_tables`.

## Appendix I: definition of `_audit.schema`
```
_definition.id       '_audit.schema'
_name.category_id    audit
_name.object_id      schema
_description.text
;

     This dataname identifies the type of information contained in the
     datablock. Software written for one schema will not, in general,
     correctly interpret datafiles written against a different schema.

     Specifically, each value of _audit.schema corresponds to a list
     of categories that were restricted to a single packet in the
     default Base schema, but which can contain multiple packets in
     the specified schema.  All categories containing child keys of
     the listed categories may also contain multiple packets and do
     not need to be listed.
     
     The category list for each schema may instead be determined from
     the list of dictionaries that this datablock conforms to (see
     _audit_conform.dictionary).

;
_type.contents          Text
_type.purpose           State
_type.container         Single
_type.source            Assigned
loop_
_enumeration_set.state
_enumeration_set.detail
    Base                'Original Core CIF schema'
   'Space group tables'  [ space_group_tables ]
    Custom              'Examine dictionaries provided in _audit_conform'
    Local               'Locally modified dictionaries. These datafiles should not be distributed'
_enumeration.default    Base
```

## Appendix II: Definitions of master hub category and sample key

```
save_ENTRY

_definition.id                          ENTRY
_definition.scope                       Category
_definition.class                       Loop
_description.text
;
    All categories in a datablock have a child key of this
    category.  This category makes explicit the links implied
    by the grouping together of categories in a datablock,
;
_name.category_id                       CIF_CORE
_name.object_id                         ENTRY
_category_key.name                      '_entry.id'

save_

save_entry.id

_definition.id                          '_entry.id'
_description.text
;
    A unique identifier for items in this category.
;

_name.category_id                       ENTRY
_name.object_id                         id
_type.purpose                           Key
_type.container                         Single
_type.contents                          Text
_type.source                            Assigned
_enumeration.default                    -

save_
```

## Example of a child key definition

```
save_space_group.entry_id

_definition.id                         '_space_group.entry_id'
_name.category_id                      'space_group'
_name.object_id                        'entry_id'
_description.text
;
    A child key of the entry category. This dataname may
    be omitted from a datafile if the entry category has only
    one packet.
;
_type.purpose                      Link
_type.container                    Single
_type.contents                     Text
_type.source                       Related
_name.linked_item_id               '_entry.id'

save_
```
