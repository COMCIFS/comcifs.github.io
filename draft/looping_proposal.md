# Proposal to allow looping of previously unlooped datanames

## Introduction

In the original DDL1 and the current version of DDLm, categories must
be explicitly labelled as loopable in order for their datanames to
appear in multi-row loops. 

In some situations, being able to loop a conventionally single-row
category is desirable.  For example, structural data might be
presented in both standard and alternate space group settings, meaning
multiple space groups are included in the datablock.  While such a use
of CIF datanames may appear to be benign, it can easily lead to
CIF-reading software silently producing incorrect results.  The
underlying reason for this is that interpretation of looped dataname
values often depends on values of unlooped datanames (e.g. unit cell
parameters are needed to transform fractional coordinates into
distances), and more than one value for these unlooped datanames
therefore leads to ambiguity.

We here propose a mechanism that allows any dataname to appear
in a multi-row loop, while protecting current software from
inadvertent misinterpretation of such files.

## Proposal summary

A new dataname, `_audit.schema`, is defined.  Values of this dataname
are linked to special categories that are used to loop and link other
categories together.  All CIF-reading software should check this
dataname.  CIF-writing software need only set this dataname if a
non-default value is chosen. All current CIF usage corresponds to the
default value.

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

(ii) A 'datablock equivalent' expansion dictionary is defined, which
would allow information from multiple (core CIF) datablocks to be
presented in a single datablock (see definition in Appendix II).

(iii) Once `_audit.schema` checking is widespread, expansion dictionaries
are allowed to add keys to previously-defined categories.  Datafiles
written according to the expansion dictionaries must set `_audit.schema`
appropriately, and change the 'Set' designation of any categories that
can now be written with multiple loop packets.

(iv) Most datanames currently in child categories of `cell` (e.g.
`cell_length.a` is in category `cell_length`) are returned to the
`cell` category (so `cell_length.a` becomes `cell.length_a`).
In the current draft cif_core dictionary, datanames for
describing the unit cell are split between the `cell_angle`,
`cell_length`, `cell_reciprocal_*` etc.  categories.  These categories
are all single row (i.e. 'Set') categories and would vary together,
that is, it is unlikely that one of these categories would have
multiple rows while the others contained only a single row.  The
reason for separating these datanames into separate categories
therefore appears to be to allow the dREL expressions to become more
compact: for example, cell volume can be written as `v.a * ( v.b ^
v.c)` instead of the lengthier `c.vector_a * (c.vector_b ^
c.vector_c)`.  Under the current proposal, we would need to create a
child key for every single `cell_` category, even though all datanames
could instead be contained in a single category and only a single key
created.  Note also that the DDL2 datanames all belong to the `cell`
category, so that the DDLm datanames are distinct from both the DDL2
and DDL1 datanames because the period occurs in a different position.
On balance, the proliferation of child keys and harmonisation with
DDL2 is considered to outweigh the concision of the dREL expressions.
Therefore, it is proposed that the current cif_core is altered so that
all the `cell_` datanames return to a single `cell` category. Note
that this does not include the `cell_measurement` and
`cell_measurement_reflns` categories, which is clearly separate.

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

## Example

For a simple example, consider the 'datablock equivalent' expansion
dictionary sketched out in Appendix II.  This dictionary imports the
core dictionary, in the process adding a single category ('ENTRY') and
child keys of this category to every core dictionary category.  As
there is a default value for the ENTRY category key, the overall
dictionary remains a valid basis for interpreting 'normal' datablocks,
as any missing ENTRY key and child keys simply take the default value.

Should an application wish to present in a single datablock data that
normally requires several datablocks, that application can adopt the
'entry' schema, under which multiple values of entry.id are
possible. The ENTRY category then has multiple values of entry.id, and
so all other categories must also specify for each packet which value
of entry.id that information relates to by explicitly setting the
value of their ENTRY child key.

For a further example, an annotated symCIF dictionary using the above
mechanisms is provided [here](cif_sym.dic.annotated.md).

## Discussion

Each `_audit.schema` value refers to a distinct set of categories that can
have multiple packets. Software written for `_audit.schema` "A" will in general
only function correctly for a file written against `_audit.schema` "B" if
the set of multiple-packet categories for "B" is a subset of those for "A".

Note that `_audit.schema` is advisory and that the same information can
be determined from the dictionaries listed in `audit_conform`.

An earlier version of this proposal suggested including the 'datablock
equivalent' expansion dictionary mentioned above into the core
dictionary. This category ('ENTRY') and keys have been moved to an
expansion dictionary in this version of the proposal to reduce clutter
in the core dictionary. Appendix II is an excerpt from this
dictionary.

### Legacy issues

#### Space_group

One category (`space_group`) in the DDL1 cif core dictionary was mistakenly
allowed to be looped without making corresponding alterations to the
many other categories that relied upon having a single space group. This
is fixed under the current proposal as follows:

(i) category `space_group` is reverted to a Set category;

(ii) `space_group.id`, `space_group_Wyckoff.sg_id` and
     `space_group_symop.sg_id` are removed

In a separate DDLm dictionary file (a successor to symCIF):

(iii) the `space_group` category is provided with an additional key dataname

(iv) _all_ categories that previously assumed a single space group are provided
     with child keys of `space_group`, as done previously in the old symCIF
     dictionary. In particular, the keys removed in
     step (ii) above once again become child keys of `space_group`.

Finally:
(v) a new enumerated value of `_audit.schema` is defined,
(e.g. 'space group tables') corresponding to a datablock possibly
containing multiple packets in the category `space_group`.

Note that [the example symCIF dictionary](cif_sym.dic.annotated.md) instead defines
a new category, `space_group_hub` that `space_group` is a child of, for demonstration purposes.

#### Exptl_crystal

The DDL1 dictionaries define `exptl_crystal_id` with child keys in
`diffrn_refln` and `refln`.  However, `_diffrn_refln_crystal_id` does
not appear in a looped context in the 380,000 file COD corpus, and
`_exptl_crystal_id` appears only once as a looped dataitem in 3
incorrectly constructed files from the same high pressure experiment.
`refln_crystal_id` never appears. From this we conclude that current
software assumes a single value for `exptl_crystal_id`. In going from
DDL1 to DDLm we must decide whether a category listed as 'both' for
looping in DDL1 should be Set or Loop: given that current usage is to
treat `exptl_crystal` as a Set category, we define `_exptl_crystal_id`
in a `exptl_crystal` Set category and remove all child keys into a
separate 'multi-crystal' dictionary in which `exptl_crystal` is
looped.

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
     of categories that were (potentially implicitly) restricted to a
     single packet in the default Base schema, but which can contain
     multiple packets in the specified schema.  All categories
     containing child keys of the listed categories may also contain
     multiple packets and do not need to be listed.
     
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
    Entry                [ entry ]   #information from multiple datablocks in one block
    Custom              'Examine dictionaries provided in _audit_conform'
    Local               'Locally modified dictionaries. These datafiles should not be distributed'
_enumeration.default    Base
```

## Appendix II: Definitions of master hub category and sample key

```
save_ENTRY

_definition.id                          ENTRY
_definition.scope                       Category
_definition.class                       Set
_description.text
;

    All other categories are provided with keys that are linked to
    the key of this category. In this way, this category can be used
    to replace the implicit linking that exists when datanames appear
    in the same data block, and as a result multiple rows in this
    category allow the data content from multiple data blocks to
    be instead presented in a single data block.

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
