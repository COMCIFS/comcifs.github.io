# A Guide to Using Formalisms and Schemas in CIF

## Introduction

The CIF framework provides two datanames for signalling changes in the
way datanames in the datablock should be interpreted.  These datanames
summarise information found in the dictionaries to which a given
datablock conforms. They are intended as labour-saving devices for
CIF-reading software authors who do not wish to parse and interpret
the dictionaries in order to determine whether or not a given
datablock will be correctly understood by their software.

## Formalism

Ideally, a dataname's meaning never changes. If we adopt this rule,
any changes in the way that derived datanames are calculated would
require a new dataname to be defined. Such an approach rapidly becomes
unwieldy when multiple models for dataname calculation are
available. For example, an observed reflection intensity can be
modelled using magnetic, modulated structure, multipole and twinning
models, and many combinations thereof.  Defining new datanames for
every single combination both obscures the relationships between the
datanames, and creates a large burden for dictionary creators and
readers.

CIF therefore associates derived datanames with 'formalisms'. Within a
given formalism, all derived datanames are guaranteed to have a
constant meaning, that is, they are calculated from other datanames
according to a particular, unchanging specification.  So, for example,
within the 'magnetism' formalism, the calculated structure factor is
determined according to the definition provided in the magnetic
structures dictionary. This definition is different from the core
dictionary, which does not include magnetic effects.

Note that a dataname may only be redefined in this way if the original
calculation method is a special case of the new method, that is, the
new method in some way builds upon the previous method.

The formalism to which a datablock conforms is signalled by setting
the value of dataname `_audit.formalism` within that datablock.  The
definition of `_audit.formalism` in the core dictionary lists all
formalisms currently recognised by COMCIFS.

## Schema

In presenting data, some set of datanames is often assumed to take
constant values.  Some data applications wish to include multiple
values for these normally single-valued datanames; in this case, we
say that the 'schema' is different, which means that the calculation
methods remain the same (the same formalism) but that some datanames
(which may or may not be involved in calculations) take multiple
values.  For example, if multiple samples are involved in a standard
single-crystal diffraction experiment, we can use a 'multi-crystal'
schema to list the various samples. If we wish to present a structure
using multiple alternative spacegroups, we might use the 'Space group
tables' schema.

## Formalism or schema?

A given schema corresponds to a set of datanames that can take multiple
values. Different schema may exist within a single formalism as long
as the actual calculation methods for each dataname do not vary.  Likewise,
many different ways of calculating a single dataname may be defined,
each corresponding to a different formalism. These derived datanames
will depend on other datanames, which will be single-valued or looped
depending upon the schema.  Therefore, a single schema can be used in
multiple formalisms, and a single formalism can be associated with
multiple schema.

## Advice for software authors

### CIF Reading software

Your software should always check the value of `_audit.formalism` to
verify that it is one of those formalisms that your software
understands.  If this check is not done, calculations and assumptions
in your program may be incorrect: for example, you may calculate
incorrect cell densities or agreement factors.  If you have not
written your software to expect that any dataname may be looped, then
you should also check that the value of `_audit.schema` is one that
your software is able to handle.

### CIF Writing software

If you are using a non-default formalism and/or schema you *must* at
minimum provide values of `_audit.formalism` and/or
`_audit.schema`. Failure to do this will almost certainly cause CIF
reading software to misinterpret your file contents. As a matter of
good practice, you should also include datanames from the
`_audit_dictionary` category.

## Advice for dictionary authors

### New formalism

You should create a new formalism when you add new dataname(s) that
modify the way in which some other already-defined dataname is
calculated or derived. In particular

1. You add a new key dataname to a pre-existing loop, *and* this
dataname is linked to a dataname that is also newly defined in your
dictionary.  But note that if the only dataname in the loop that
depends upon the new key dataname for interpretation is also
newly-defined by you, then do not need a new formalism.

### New schema

You should create a new schema if a dataname from a 'Set' category
has now become looped in your new dictionary.  Note that looping of
a previously single-valued dataname will probably entail the addition
of linked datanames to multiple loops, but this in itself does not
mean that a new formalism is required as interpretation of the
datanames in those loops already implicitly depended upon your
previously single-valued dataname.

Examples
--------

Powder CIF
----------

A powder CIF data block contains the point-by-point diffractogram
together with the modelled intensities at each point. As part of this
modelling, structure factors are calculated from the structural model.
Up to this point, no datanames have been redefined relative to the
core dictionary as the method of structure factor calculation is
unchanged and the powder CIF datanames relate to quantities not covered 
by the core dictionary.

However, powder diffraction patterns often contain contributions from
more than one 'phase', or substance. All such phases need to be
included in the model in order to best fit the pattern.  One
alternative is to include these phases in the reflection loop by using
a different `schema` to allow multiple space groups, unit cells and
unit cell contents to be listed, and then the particular phase could
be identified in the `refln` loop listing all structure factors for
all phases.  However, as the original powder CIF did not have access
to `schema` separate phases are stored in separate data blocks and so
the method of calculation of structure factors in multi-phase
compounds is different and we therefore need a new formalism for
multi-phase powder CIFs.

Note that we are in any case forced to move to a new formalism because
the *measured* structure factor is now derived in a different
way. Instead of being determined from a measured diffraction spot, it
is back-calculated from a powder diffraction peak (which in general
can consist of multiple overlapping peaks) according to the relative
contribution of each phase's model structure factor to each point of
the diffraction peak.  The question remains as to whether we can
consider `F_meas` as an elaboration of the single crystal `F_meas`;
the original `F_meas` is recovered in the limit of zero overlap, even
if this situation never occurs in practice. 

Do we still need a different `schema`?  Because the powder diffraction
dictionary defines a new 'phase id' dataname, which may be looped, we
do not, in fact, need a new schema as no previously single-valued
dataname that was involved in determining or interpreting a
previously-defined, derived dataname has become looped.  The 'phase
id' dataname can be considered to be virtually present with a default
value 'current block' in core CIF datablocks, but it was not involved
in structure factor calculations so is irrelevant.

Therefore, we assign a new `_audit.formalism` to the powder CIF dictionary,
but do not require a new schema.
