# Proposal for new DDLm attribute 'category_implicit.link'

Version: 0.1
Authors: J Hester
Status: WITHDRAWN
Date: December 2021

## Reason for withdrawal

As there is now a style guide, updating of dictionaries can be eased by
automatic tools. Thus there is no particular advantage to dictionary
authors in providing a mechanism for easy specification of category
links. On the other hand, dictionary readers need more knowledge in order
to understand that implicit key data names are present. Explicitly
adding key data names that are explicitly linked to parent data names as
done at present is easier for dictionary readers to understand.

## Introduction

The values of data names in a given category often depend implicitly
on the values found in other categories.  For example, atomic
positions (`atom_site`) will change if the cell parameters (`cell`)
and/or space group (`space_group`) change, but there is no
machine-readable information in the `atom_site` category to indicate
this link. This is not a problem when only one cell and space group is
listed in the data block, as the particular cell that a row of the
atom site loop refers to is unambiguous.

This inter-category dependence information does become important when 
information is spread over multiple data blocks. In such circumstances,
the preferred approach is to separate information relating to a
particular value of data names in certain categories into separate
data blocks. In order to understand which categories are affected,
the implicit links should be available. For example, if a powder
diffraction result is spread over multiple data blocks depending on
which phase (compound) is being described, it is important to describe
in a machine-readable way which categories should be presented in
each data block, and which categories can be collected together in a
single additional data block.

This proposal suggests a new data name `_category_implicit.link`
that would list the categories that the present category depends
on.

## Definition

```
save_category_implicit.link
    _definition.id              '_category_implicit.link'
    _definition.class           Loop
    _description.text
;
    Values for the category being defined will in general depend
    on the values found in the Set categories listed under this
    data name.  As dependency is transitive, only those 
    categories that are sufficient to derive a full list need
    to be listed.
    
    In relational terms, the defining category has an implicit
    data name that is a child data name of the key data name
    of each of the listed Set categories.
    
    Categories listed here are in addition to, and may
    duplicate, explicit relationships defined using
    `_name.linked_item_id` and `_category_key.name`.
;
    _name.category_id           category_implicit
    _name.object_id             link

    _type.container             Single
    _type.contents              Word
    loop_
    _description_example.case
    _description_example.detail
;
    loop_
      _category_implicit.link
      CELL
;

;
    The list of parent categories of ATOM_SITE.  As the cell
    depends on the chosen space group, only CELL needs to
    be listed.
;

save_
```

## Discussion

The mechanism for defining category relationships described here
is mostly useful where `_audit.schema` is `Base`.  In this case,
multi-valued `Set` categories are split over multiple data blocks,
so any child key data names have a single, unambiguous value and
may be omitted. Similarly, the `Set` category key data name may
also be omitted. Thus the attribute serves to link the categories
without the need to define extra data names that will be largely
unused.

Conversely, if `_audit.schema` is not `Base`, in at least some
cases explicit data names will need to be defined in order
to allow looping over those key data names and to remove ambiguity
about which of those key data values is being referred to in
loops.

## Next steps

If the present proposal is acceptable, test versions of the CIF
core dictionary and CIF powder dictionary will be prepared to
make sure these ideas work in practice.
