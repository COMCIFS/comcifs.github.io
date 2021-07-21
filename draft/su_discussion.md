# Proposal: treatment of SU in DDLM dictionaries

## Introduction

There is some residual ambiguity around the treatment of su in our
DDLm dictionaries.  Currently, if `_type.purpose` for a data name 
is `Measurand`, the DDLm attribute dictionary states:

```
       Used to type an item with a numerically estimated value
       that has been recorded by measurement or derivation. This
       value must be accompanied by its standard uncertainty
       (SU) value, expressed either as:
         1) appended integers, in parentheses (), at the
            precision of the trailing digits,       or
         2) a separately defined item with the same name as the
            measurand item but with an additional suffix '_su'.
```

This raises the following issues:

1. Option (1) presupposes CIF format. DDLm should be agnostic
regarding format

2. Should the `_su` form of the data name be explicitly defined in the
   dictionary?

3. Is it legal to provide both the `_su` form and the parenthetical
form for a data name?

4. Does the value of a `Measurand` data name for the purpose of
dREL include the SU?

5. Can the `_su` suffix be a requirement when the current DDLm
dictionaries contain data names that do not follow this?
(e.g. `_refln.F_sigma`).

The following proposal aims to clarify these questions.

## Proposal

1. That all `Measurand` data names have a corresponding
data name for their SU explicitly defined;

2. That the convention for IUCr dictionaries is that this
data name is formed by adding `_su` to the original data name;

3. That the parenthetical form of presentation of the su value
for CIF syntax is understood as a shorthand assignment of this
su value to the associated SU dataname;

4. That the definition for `Measurand` is therefore rewritten as:

```
       Used to type an item with a numerically estimated value
       that has been recorded by measurement or derivation. A 
       data name definition for the standard uncertainty (SU) 
       of this item must be provided in a separate definition
       with `_type.purpose` of `SU`.
```

The above questions are then answered as follows:

1. The new definition is format-agnostic

2. Yes, `_su` forms should be defined in the dictionary. Using 
`_su` as a suffix is purely an IUCr convention which is not
always followed (e.g. `_refln.F_sigma`) and therefore not
appropriate for the DDLm attribute dictionary to specify.

3. Yes, it is *syntactically* legal to have both forms, as the CIF
syntax can have no embedded understanding of the meaning of the data
names, including `*_su` data names, and therefore duplication cannot
be detected as a syntax error.  It is instead a semantic error in the
same way as a cell volume - cell parameter mismatch would be. Thus
if the two values provided agree, there is no error, and if they
disagree, the software can take steps based on the importance of 
the mismatch to the particular computation.

4. No, the value of a `Measurand` data name includes the main
value only.

## Discussion

In order for DDLm to be format-agnostic, each format needs to
associate some location in that format with a data name. The
appearance of a value in a CIF file without the data name appearing as
well (as is being proposed above) is thus not unusual in general,
simply for CIF this association is usually transparent due to the data
name appearing in the format itself.

### Compatibility

#### CIF authoring software

Authoring software remains free to append SU in parentheses.

#### CIF reading software

Legacy CIF reading software will have the same problems that it presumably has
with the new 'dotted' data names, in the sense that a data name that was
unknown at the time of software preparation has been used to provide a value. 
This is a cost that we have accepted. It seems unlikely that 

### Other comments

The su of a data item must always have been treated separately in
software, as software must handle the su differently to the main value
due at least to the differences in the way errors are propagated. 
The creation of a separate data name captures this fact.
