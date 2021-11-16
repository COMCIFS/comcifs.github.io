# Principles for reading and writing CIF information using multiple data blocks

Version: 0.1
Author: J Hester 
Date: November 2021
Status: Draft

## Introduction

Data described by CIF dictionaries can be spread between multiple data
containers. In some cases these data containers may be in a variety of
non-CIF formats (e.g. HDF5, columnar ASCII).  In more complex
scenarios, a number of choices exist as to how such data should be
distributed between data containers. Choice is generally undesirable
in standards, as it complicates the task of aligning reading and
writing software. Therefore, these principles have been developed to
describe how CIF writing software should distribute and describe data
dispersed over multiple data containers. 

For the purposes of this document, the data container is assumed to be
a CIF data block.

## Background

All CIF data names are defined in DDLm dictionaries to belong either 
to a `Set` or `Loop` category. Data names in a `Set` category are
by default single-valued within a single data block.

The value of data name `_audit.schema` can be used to determine the
list of `Set` categories in a given data block. The default value for
`_audit.schema` of `Base` corresponds to the `Set` categories defined
in the core CIF dictionary. Dictionaries building on the core CIF
dictionary may add further `Set` categories to this list. A
non-default value for `_audit.schema` will usually imply that some 
or all of these `Set` categories are looped within a data block.

In general, many `Loop` categories will have an implicit dependence on
items that appear in `Set` categories. For example, atomic positions
in an `atom_site` list depend on the space group and unit cell
information, which both appear in `Set` categories.  In relational
terms, there is an additional key data name in such `Loop` categories
that is a child of the (implicit) key data name for such `Set`
categories. If the parent value belongs to a `Set` category, this also
requires that the child data name for such loops takes only the
stated value of the parent, which allows child data names to be
dropped from the data block as their value is unambiguous. In the
following, "child data names" refers only to these child data names of
`Set` categories.

## Principles: Writing

1. Where that choice is available, all data blocks should be written
using the `Base` `_audit.schema`.  In other words, distinct values for
any items from `Set` categories and any child data names are placed
in separate data blocks.

2. Where multiple data blocks are used, categories whose values do not
depend on any of the `Set` category values (for example, an author
list) should be collected into a separate data block to avoid
unnecessary repetition in each data block.

3. The CIF standard does not stipulate how to identify data blocks
   belonging to a single data set.  Dictionaries may define data names
   that help in this task, or allow the context to determine aggregation.

4. Summary blocks: where desired, the information for one or more
`Set` categories that has been scattered over multiple data blocks may
be repeated in a summary loop in a separate data block, for example, a
list of powder phases with block pointers. In this case
`_audit.schema` *must* be changed from the default appropriately, and
the values listed in the summary loop *must* match the values provided
in each individual data block.

## Principles: Reading

1. Always check `_audit.schema` to ensure that the value is that
expected by your software. This is particularly important for
detecting and handling summary blocks (see above).

## Examples

### Powder diffraction

Consider the results of refining powder diffraction patterns from a
sample containing multiple compounds ("phases") measured at
multiple temperatures. In this case, the results for each phase 
at each temperature should be presented in a separate data block,
as both `pd_phase` and `diffrn` are `Set` categories in CIF core.
Optionally, the data block containing information that does not
vary with phase or diffraction conditions (e.g information about
the diffractometer) can also contain a list of the phases and
a list of the diffraction conditions, as long as `_audit.schema`
is set appropriately.

### Using imgCIF with cif_core

The imgCIF dictionary loops several categories that are `Set`
categories in CIF core.  One of those categories is `diffrn_detector`,
covering situations where multiple detectors are used to collect
data. According to the present principles, information about each
detector should be distributed over several data blocks. A separate
document is in preparation that goes into more detail.

## Implications for dictionary authors

1. A `Set` category may be equipped with a category key.
2. Child data names of `Set` category keys must be indicated "somehow"
   (see below)
3. If the desired presentation of data differs from that implied by
the `Set` categories, a new value of `_audit.schema` should be
created.

### A new DDLm data name?

If the above principles are accepted, it will become necessary to
indicate which `Loop` categories have implicit child keys of `Set`
categories. Previously, it was proposed that extension dictionaries
would explicitly add these keys at the same time as turning the `Set`
categories into `Loop` categories. However, this is in almost all
cases a mechanical exercise that simply identifies which `Loop`
categories depend on which `Set` categories, and almost all of the
resulting child data names, at least when the above principles are
followed, end up being dropped from data blocks.

DDL2 solves this inconvenience by listing the child data names
within the definition of the parent data name.

If the above principles are acceptable, we could do something 
similar by defining a new DDLm category attribute listing the
categories which implicitly depend on the defining category. When
using the `Base` `_audit.schema`, this would be sufficient. If using
a different schema, explicit data names would need to be defined
and in this case it would be appropriate to provide definitions
within the dictionary itself. 

If these principles are acceptable I will prepare such a proposal
for a new DDLm attribute.
