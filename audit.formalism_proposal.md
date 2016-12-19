# Proposal for new dataname and attribute to cover differing models

## Introduction

The following proposal implements part of a solution to incorporating
multiple models into CIF, discussed
[here](changing_meanings_discussion_paper.md).  It should be read in
conjunction with that document.

## New datanames: `_audit.formalism` and `_audit.formalism_version`

Each value of `_audit.formalism` corresponds to a particular way of
deriving some set of CIF datanames from other datanames defined in the
same, or imported, dictionaries.  For better interoperability, we
stipulate that datanames may only be redefined by dictionaries if, for
some values of the datanames from which the redefined datanames are
calculated, the derived dataname takes the values that the original
dataname would have taken. So, for example, if `_atom_site.moment` is
zero, `_refln.F_complex` has the same values as in core CIF, so it is
acceptable for a magnetic dictionary to redefine `_refln.F_complex`.

`_audit.formalism_version` is provided to allow secondary parameters
to be added to the model without changing the overall formalism. As a
guide, parameters are considered secondary if they do not require the
addition of new columns to any category, and do not significantly
change the final calculated values in "typical" cases.

All CIF datablocks should include these new datanames when they take
non-default values; the default values correspond to the
single-crystal model described in core CIF.  Most CIF reading programs
should check these datanames in order to avoid miscalculating derived
values.  

The choice of the word `formalism` is purely to avoid clashing with
the widespread use of `model` in core CIF to refer to the particular
arrangement of atoms. There may be a better word.  See the appendix
for formal DDLm definitions.

## New DDLm attributes: `_dictionary.formalism` and `_dictionary.formalism_version`

These attributes associate a dictionary with a particular formalism.

## Treatment of current dictionaries

### Modulated structures

The modulated structures dictionary is assigned formalism `modulated`
and redefines `_refln.F_complex`, `_refln.sin_theta_over_lambda` and
`_refln.symmetry_multiplicity`.

### Magnetism

The magnetism dictionary builds on the modulated structures dictionary.
It is assigned formalism `magnetic` and redefines `_refln.F_complex`
only.

### Powder

The powder dictionary calculates structure factors from information
that may be held in a different datablock.  It therefore redefines
`_refln.F_complex`.  `_refln.F_meas` is also redefined as the
determination of this from the powder observations is clearly
different to the way in which it is derived from single-crystal spots,
not least because of pervasive overlap.

Separate formalisms are necessary for each possible combination of
powder with other formalisms, for example `_audit.formalism` can
take values `powder-magnetic`, `powder-modulated` and
`powder-multipole`.

### Electron density

The electron density dictionary allows parameterisation of the
electron density around each atom in terms of multipoles.  With
appropriate choice of coefficients this reduces to the spherical atom
model used in core CIF, so is an acceptable redefinition.
`_refln.F_complex` is redefined, and a formalism of `multipole` is
assigned.

### Constraints and restraints

This dictionary relates only to the method of determination of the
final parameters and therefore does not affect the definitions of
the final datanames.

### Twinning

Twinning does not change the structural model, but it does change the
way of determining `_refln.F_meas` from the observations. A formalism
of `twinning` is assigned, and as for powder separate formalisms need
to be assigned for each distinct structural model.

### Image CIF

ImgCIF relates only to raw data and is not affected by these changes.

### mmCIF

mmCIF is based on the core CIF model and is therefore unaffected by
these changes.

## Treatment of other techniques

### Laue

A Laue experiment measures distinct spots, but each spot is produced
by a distinct wavelength, and spots sometimes overlap.
`_refln.wavelength` therefore becomes an additional key column in
`refln`. This change by itself is easily covered by defining a
different `_audit.schema`.  However, a Laue dictionary must also
redefine `_refln.F_meas` as the extraction of notional observed
intensities will depend on the model for wavelength distribution, and
so we must assign a separate `_audit.formalism`. As for powder and
twinning, there will be a separate `formalism` for each distinct
structural model.

## Discussion

### Mixing and matching not possible

It is tempting to define something like `_audit.technique` to cover
the technique-based differences, so that `_audit.technique` and
`_audit.formalism` could correspond to different dictionaries that
could be mixed and matched. So, instead of a `powder-magnetism`
formalism, there would simply be a `powder` technique combined with a
`magnetism` formalism, with both dictionaries being separately imported
and notionally orthogonal to one another.

However, any `formalism` that adds keys to the `refln` category will
also require the `technique` to be aware of those keys in order to
explain how `_refln.F_meas` is determined.  For example, a powder
experiment on a modulated structure will calculate the `_refln.F_meas`
value differently to a powder experiment on a non-modulated structure
as the calculations of peak position require different numbers of
indices.  Therefore, it is not possible to generally separate the
technique from the structural model, although it may be possible in
particular cases.

### Just use `_audit_conform`?

Core CIF has long provided the `_audit_conform_dict_*` tags to state which
dictionary or dictionaries a datablock conforms to.  This appears almost
as simple as the proposed `_audit.formalism` tag, so the need for a
separate tag may not be apparent.

However, while the `_audit_conform` mechanism must remain the
canonical source of information, the proposed dataname provides a
simplified route to the same information. In order for a CIF reading
program to confirm that none of the dictionaries listed in a CIF block
change any of the definitions relied upon by that program, it must in
general download the stated versions of the dictionary or dictionaries
from the canonical IUCr site, parse and merge them, and then find any
definitions that have (apparently) been replaced.  Compared to this
procedure, the `_audit.formalism` tag is a much simpler way for the
datablock writer to specify to the datablock reader a particular set
of dataname interpretations that may never change.

Notably, the `_audit_conform_*` mechanism is almost never used. As of
May 28, 2016, there were 195 modulated structures in the
Crystallographic Open Database (as determined by the presence of
`Fourier_wave_vector` in a file). Of these, zero had an
`_audit_conform` entry.  We conclude that introduction of
`_audit.formalism` should be accompanied by an education and outreach
program as well.

### Interaction with `_audit.schema`

`_audit.schema` essentially allows fixed parameters to vary. It
is therefore orthogonal to `_audit.formalism`: a given formalism
may have many possible schemas, and many schemas may apply to
multiple formalisms if they share the same parameters.

In other words, a suitably-written program can handle a variety of
schemas for a single formalism without needing to change the way in
which any dataname is calculated, whereas a program must change the way
in which the redefined datanames are calculated if the formalism
expands.

# Appendix I: New core definitions

## _audit.formalism

```
save_audit.formalism

_definition.id       '_audit.formalism'
_name.category_id    audit
_name.object_id      formalism
_description.text
;

     The CIF dictionaries listed in _audit.dictionary may redefine
     datanames. _audit.formalism is provided as an efficient
     alternative to parsing and checking those dictionaries. It
     identifies commonly-used sets of meanings for datanames. In
     general, each value taken by _audit.formalism is linked to a
     particular technique and/or structural approach.  The
     dictionaries for the datablock (see _audit.dictionary) must be
     compatible with the value of _audit.formalism.

;
_type.contents          Text
_type.purpose           State
_type.container         Single
_type.source            Assigned
loop_
_enumeration_set.state
_enumeration_set.detail
    Base                'Single crystal model from core CIF'
    Modulated           'Single crystal modulated structure'
    Magnetic            'Single crystal magnetic structure, potentially modulated'
    Powder              'Powder diffraction experiment'
    Twinned             'Twinned crystal using core CIF model'
    Multipole           'Single crystal model with multipole coefficients'
    Laue                'Laue experiment on single crystal'
    Powder-Modulated    'Powder experiment on a modulated structure'
    Powder-Magnetic     'Powder experiment on a modulated magnetic structure'
    Powder-Multipole    'Powder experiment modelled with multipoles'
    Laue-Magnetic       'Laue experiment on magnetic structure'
    Laue-Modulated      'Laue experiment on modulated non-magnetic structure'
    Laue-Multipole      'Laue experiment modelled with multipoles'
    Twinned-Magnetic    'Twinned magnetic single crystal structure'
    Twinned-Modulated   'Twinned modulated single crystal structure'
    Laue-Twinned        'Laue experiment on twinned single crystal'
    Laue-Twinned-Modulated 'Laue experiment on twinned modulated structure'
    Custom              'Examine dictionaries provided in _audit_conform'
    Local               'Locally modified dictionaries. These datafiles should not be distributed'
_enumeration.default    Base
save_
```

## _audit.formalism_version

```
save_audit.formalism_version

_definition.id       '_audit.formalism_version'
_name.category_id    audit
_name.object_id      formalism_version
_description.text
;

     The version of the given formalism (see `_audit.formalism`). The version
     number of a formalism is incremented when new model parameters are
     added that do not significantly affect the model values in typical cases.

;
_type.contents          Text
_type.purpose           State
_type.container         Single
_type.source            Assigned
_enumeration.default    1.0
save_
```

## _dictionary.formalism

```
save_dictionary.formalism

    _definition.id               '_dictionary.formalism'
    _definition.class            Attribute
    _definition.update           2016-12-17
    _description.text                   
;

     The value of this attribute is associated with the set of
     dataname meanings contained in this dictionary.

;
    _name.category_id            dictionary
    _name.object_id              formalism
    _type.purpose                Audit
    _type.source                 Assigned
    _type.container              Single
    _type.contents               Text

save_
```

# Appendix II: a full hybrid dictionary

A complete dictionary using the above mechanisms is presented below.

```
#\#CIF_2.0
####################################################
#                                                  #
#    Dictionary for modulated powder diffraction   #
#                                                  #
####################################################

data_MODPOW

_dictionary.title             MODPOW
_dictionary.formalism         Powder-Modulated
_dictionary.class             Instance
_dictionary.version           1.0
_dictionary.date              2016-12-19
_dictionary.ddl_conformance   3.12
_dictionary.namespace         MODPOW
_description.text
;

    The modulated powder diffraction dictionary redefines datanames
    for use when presenting the results of a powder diffraction
    experiment using a modulated structure model.  The remainder of the
    relevant definitions are found in the modulated structures
    dictionary and the powder diffraction dictionary.
    
;

save_MODPOW_GROUP

    _definition.id       MODPOW_GROUP
    _definition.scope    Category
    _definition.class    Head
    _definition.update   2016-12-19
    _description.text
;
    This category is the parent category for all definitions
    in the MODPOW dictionary
;

    _name.category_id     MODPOW
    _name.object_id       MODPOW_GROUP
    
    # The following import reads in and reparents all powder and
    # modulated structure definitions to the MODPOW_GROUP category. As cif_ms is
    # read second, the refln category will have the extra modulation indices
    # defined.
    
    _import.get           [{"file":"cif_pow.dic" "save":"PD_GROUP" "mode":"Full"}
                           {"file":"cif_ms.dic"  "save":"MS_GROUP" "mode":"Full"}]

save_

save__refln.F_complex

_definition.id                          '_refln.F_complex'
loop_
  _alias.definition_id
         '_refln.F_complex'  
         '_refln_F_complex' 
_definition.update                      2016-12-19
_description.text                       
;
     The structure factor vector for the reflection calculated from
     the modulated structure given in the datablock identified by
     _refln.phase_id
;
_name.category_id                       refln
_name.object_id                         F_complex
_type.purpose                           Measurand
_type.source                            Derived
_type.container                         Single
_type.contents                          Complex
_enumeration.default                    0.

save_

save__refln.F_meas

_definition.id                          '_refln.F_meas'
loop_
  _alias.definition_id
         '_refln.F_meas'     
         '_refln_F_meas' 
_definition.update                      2016-12-19
_description.text                       
;
     The structure factor amplitude for the modulated reflection based on
     partitioning of each observed powder diffraction intensity between
     contributing reflections in proportion to the model reflection contributions.
;
_name.category_id                       refln
_name.object_id                         F_meas
_type.purpose                           Measurand
_type.source                            Derived
_type.container                         Single
_type.contents                          Real
_enumeration.default                    0.

save_
