# Advice to CIF programmers regarding important new data names

## Summary

COMCIFS have defined two new data names that enable easy communication
of alterations to the standard data name meanings given in the core
CIF dictionary.  Programmers are therefore strongly advised to
consider writing and/or checking these data names. Note that these new
data names are not relevant to software that works exclusively with
mmCIF/PDBx data files.

## Changes to CIF reading software

Software that reads data files containing data names defined in IUCr
CIF dictionaries should now check the values of `_audit.schema` and
`_audit.formalism`.  If these data names are absent, or present with
values of `Base` and `Base` respectively, no further software changes
are required.  If the values of either of these data names is not
`Base`, the meanings of certain data names may be different and it is
possible that your software will therefore misinterpret the contents
of the CIF file. You should read the specifications [1],[2] in detail
to determine further actions.

## Changes to CIF writing software

Software that outputs files containing data names that conform to the
definitions in the CIF core, twinning and constraints/restraints
dictionary need do nothing. If your software outputs data names from
the powder, magnetism, electron density or modulated structures
dictionaries you should include data name `_audit.formalism` in your
data block to communicate to the reading software that some data names
have a different meaning.  Consult the `_audit.formalism`
specification document [1] for the appropriate value for this data
name.

Software that outputs data files that give multiple values for data
names that are normally single-valued (e.g. multiple crystals or
multiple space groups in CIF core) should include a non-default value
of `_audit.schema` in the data block.  Consult the `_audit.schema`
specification [2] for further information.

## Frequently asked questions

1. What changes in behaviour of data names are we talking about?

`_audit.schema` covers the effect of allowing previously unlooped data
names to become looped. While the meaning of these data names does not
change per se, other loops will need to include an extra looped data
name to disambiguate which of the newly-looped data name's values apply
to each row of the loop. This can affect calculations in surprising ways.

Redefinitions flagged by `_audit.formalism` keep the type and usage of
the values for the new data name, but change the way in which values
of the data name are obtained. For example, the formula for d-spacing
for a modulated structure is different to the one used in the core
dictionary (more indices are present), but once calculated those
values can be used wherever the original d-spacing values were used.

1. My software already handles powder/modulated structures/magnetism data without
problems, what difference will this make?

There are indeed other ways to communicate the data name meaning
changes, but they are either labour intensive (parsing CIF
dictionaries given in the `_audit_conform` loop) and almost never
used, or non-standard and fragile (e.g. checking for particular data
names, using context, relying on user choices, telling the receiver
what to do).

`_audit.formalism` provides a simple, extensible way to achieve the
same result that does not rely on e.g. some prior agreement between
the file producer and consumer or a user following instructions
correctly.

1. I only ever use core CIF data names, do I really need to do anything?

Certain users of CIF wish to include multiple crystals or multiple
space groups in a single data block. This potentially leads to an
expansion in e.g. atom site listings to give the atomic position in
each space group. If your software will not detect this behaviour, and
instead decide e.g. that there are twice as many atoms in the unit cell,
then you will derive a benefit from checking `_audit.schema`.

1. How soon should I change my software?

These data names have only just been introduced, and so no current
data files contain them. As a suggestion, including checking/writing of
these data names in your next software release would be sufficient.

1. These data names have periods in them. Do they apply to data blocks that
only have data names that do not contain periods (i.e. from DDL1 dictionaries)?

Yes they do. These data names should be treated just like data names that do not
contain periods.

1. Why did you bother adding these data names?

As the CIF approach becomes more popular, attempts to apply it to
a broader range of experiments (e.g. Laue, magnetic structures
from powder diffraction) run into the need to expand the meanings
of some data names.  Without the mechanism provided by these data names,
it would be difficult to coherently expand the coverage of CIF.

1. I can't find a value for `_audit.schema`/`_audit.formalism` that
   covers my planned use.

Please advise COMCIFS (secretary: bm@iucr.org) or use the `Custom` value.
