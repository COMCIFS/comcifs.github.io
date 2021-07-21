# A Proposal for Improving Management of Alternative Models and Experiments in CIF #

## Summary

IUCr CIF dictionaries have developed over the last 20 years to cover a
growing range of experimental approaches and paradigms.  Upon close
inspection, it turns out that several dictionaries implicitly redefine
several datanames, and some dictionaries do not mix well with one
another, despite their combination describing a well-defined
experimental approach. By allowing controlled dataname redefinition
and introducing a category designed solely for comparison of model and
observation, these issues can be removed.

## Introduction

(NB in the following "model" refers to a generic approach to calculating
values intended to match some observations, rather than the more
narrow core CIF definition of a particular arrangement of atoms).

The original core CIF provides tags for describing the conduct of a
single crystal experiment, together with tags describing the
structural model that has been fitted to the observed diffraction
peaks.  Experiment meets model in the `refln` category, which lists
(among other things) the model and observed structure factors.

After core CIF, further dictionaries were developed covering twinned
crystals, modulated structures, powder diffraction, and magnetism.  In
each case the model is different, and in some cases a single
observation can no longer be associated with a particular h,k,l value.
These differences lead to ad-hoc variations in the interpretation and
use of the `refln` category.

The way in which these models and experiments are treated in current
dictionaries is reviewed below, and then improvements are proposed.

## Current dictionary approaches

### Modulated structures

Structural modulation introduces "satellite" peaks requiring
additional reciprocal space dimensions for identification of observed
peaks.  In parallel, the structural model for calculating peak
intensity is extended.  Extra dimensions are added to the `refln`
category, but no new definitions for `refln.F_calc` or `d_spacing` are
provided. Note that it is not possible to split the modulated
structure factor into a non-modulated part calculated as for core CIF
(e.g. for the main reflections) and an additional modulated part, so
the method of determining `refln.F_calc` in the core dictionary is
irrelevant.

### Magnetic structures

The magnetic dictionary introduces additional parameters required to
model the intensity of neutron diffraction peaks due to magnetic
ordering.  Observations are still associated with unique indices
(possibly extended using the modulated structures dictionary).  Again,
no description of the new way of calculating `_refln.F_calc` is
(currently) presented.

### Powder

A powder diffraction experiment is usually unable to refine a
structural model against individual hkl peaks as observed peaks will
overlap, making assignment of intensity to a particular hkl
model-dependent.  Instead, intensities from the structural model are
fed into a model that includes the peak shapes and background and the
entire powder pattern is fitted (the Rietveld approach). Therefore, in
the powder dictionary, the `refln` category can no longer be used as a
location where model and experiment are compared.  Instead, `refln` is
treated as a place to list the model h,k,l for each sample constituent
("phase").  A corresponding "measured" intensity can often be
extracted using the fit parameters, but is no longer an independent
measurement.  The presence of sample phase id means that the
calculation method for `_refln.F_calc` is strictly different to the
core CIF situation.

### Twinning

Twinning allows an observed peak to have contributions from more than
one h,k,l.  Just as for powders, the `refln` category can no longer
tabulate observed structure factors, as in this case there is not
necessarily a unique h,k,l that can be assigned to an observed spot.
Structure factors for a given HKL are calculated using the core CIF
model.  The twinning dictionary tabulates the actual observed and
calculated values in the `twin_refln` category.

## Problems with the current approach

### Silent redefinition

In all of the cases listed above, the `_refln.F_calc` dataname is not
redefined within the dictionary, despite the presence of new
parameters that affect how it is calculated.  If F\_calc is intended
to be calculated differently, software written without knowledge of
the new dictionaries and therefore new parameters *will* miscalculate
model-dependent quantities, starting with F_calc and continuing
downstream to refinement statistics and difference densities. If, as
seems unlikely, F\_calc is meant to be calculated as per the original
core CIF definition, then by analogy with core CIF, additional
datanames should be defined that capture the expected model values and
agreement statistics.

A fundamental principle of CIF has been to disallow redefinition of
datanames, in contrast to what would appear to be happening with
`_refln.F_calc`.  Presumably, F\_calc has avoided scrutiny because it
may be characterised in all cases as "the model structure factor".
However, the point of disallowing redefinition is to ensure that
current software is not rendered invalid at some point in the future,
and as CIF does not provide software with a general way to determine
"the model", the constancy of the F_calc definition is illusory.  A
further example is provided by `_refln.d_spacing`: the d spacing
calculated from the h,k,l and cell values is incorrect for modulated
structures, and no other calculation for `_refln.d_spacing` is
provided in the dictionary.

### Difficulty in combining models

No specific mechanism is available for mixing models together, beyond
the flawed assumption that datanames may appear together without
restriction.  As a stark example, consider a twinned modulated
magnetic structure: as the `_twin_refln` category has no additional
modulation indices defined (neither dictionary being "aware" of the
other), the comparison with experiment is absent and the assignment
of hklmn.. and twin individual to satellite peaks is impossible.

Multi-phase, modulated magnetic powder diffraction structural analysis
(something that is routine at neutron facilities) is almost covered by
the current approach.  The core, modulated, magnetic and powder
dictionaries provide all of the necessary tags to *describe* the
solution, and definitions in the powder dictionary allow the fit to
each point to be tabulated, but the way in which `_refln.F_calc`
should be calculated from the relevant tags is not available, and the
`refine_ls` values are no longer the least squares values relevant to
any actual refinement.

Obviously ad-hoc solutions can be created for any given combination,
but a recommended approach is desirable to handle the combinatorial
increases with each additional model (additional models might include
multipole, polarisation analysis...)

### No consistent presentation of model vs data

There is no category that consistently tabulates calculated model
values against observations, which means that the `refine_ls`
datanames are also derived differently in each case, or else have a
different meaning. Powder datasets use the `pd_data` category for this
purpose, and twinning uses `twin_refln`.  While the twin dictionary
does not redefine `refine_ls`, the powder dictionary does provide
`pd_proc_ls` to hold refinement statistics.

## Solutions

The status quo solution would be to continue to disallow any
redefinition, which means that we must have separate datanames for
every combination of models. To cover twinning, modulation and
magnetic structures this would involve 7 extra sets of datanames for
(at least) the `refln`, `refine_ls` and `refine_diff` categories.  The
addition of further models would lead to a combinatorial increase in
datanames for each new scenario (e.g. twinned-multipole-modulated is
distinct from multipole-modulated).  Clearly, this approach does not
scale in either dataname space or in terms of dictionary writer
workload and so we seek something more economical.

### Solution part I: create a generic model-observation category

This change removes the need to redefine `refine_ls` for each model,
and provides a single focal point for future dictionary authors.

A category is created (which I'll call `refine_agreement` here) that
always holds the calculated and observed values for whatever model the
dictionary introduces, tabulated against observation id.  This
separates out the "agreement with model" role of the `refln` category.
Values in the `refine_ls` category will then always refer to the
agreement between items in this new category.

The values of `_refln.F_calc` and `_refln.F_meas` can now be viewed as
being derived via two distinct paths that cross over in the
`_refine_agreement` category. `_refln.F_calc` is calculated from the
structural model, with the final value tabulated in the `refln`
category and then potentially further processed to appear as the
calculated value in the `_refine_agreement` category.  Our raw
observations are corrected before appearing in the `_refine_agreement`
category, and then may be (potentially) further processed to determine a
notional "measured" h,k,l structure factor in the `refln` category.

### Solution part II: allow controlled category replacement

This change captures what has been happening for 20 years, and puts
some guidelines into the process.

Dictionaries are allowed to redefine datanames, in concert with new
`_audit.model` and `_audit.model_version` datanames that *must* be
included in a datablock to flag that a non-core-CIF model is in
operation.

To avoid random or contrary redefinitions, datanames in a category may
be redefined if and only if, for specified values of some other
datanames introduced in the same dictionary, the redefined datanames
take the values that they would have taken before the category was
replaced.  In other words, the old datanames are special cases of the
new datanames. For example, a magnetic model reduces to the core model
when the atomic moments are all zero, or a modulated model reduces to
the core model when the modulation waves have zero period. It follows
from this stipulation that datanames whose values do not depend on
other datanames may not be redefined.

One or more items in both the `refln` category and the
`refine_agreement` category will require redefinition when the model
or experiment changes.  In general, any category to which extra key
datanames are added will require redefinition of at least one non-key
dataname if no new datanames are introduced.

### Usage example: core CIF

The `refine_agreement` category in core CIF would contain key dataname
`observation_id`, and then `hkl` datanames to link the
`observation_id` with an entry in the `refln` table. Two further
datanames, which I'll call `observed` and `calculated`, record the
respective values.  In order to populate the `refine_agreement`
category observed reflection is assigned an arbitrary observation id
and the corrected measured structure factor listed against that id.
For each unique hkl appearing in the `refine_agreement` list, a model
structure factor is calculated and included in the `refln` category.
Then, for each item in the `refine_agreement` list, the observation id
is used to find the hkl and the corresponding structure factor copied
into the `refine_agreement` list from the `refln` category.

Clearly, for core CIF the `refine_agreement` category is largely
superfluous given a one-to-one match between observation and hkl,
although it does now allow duplicate hkl observations (which area
detectors routinely produce) to be tabulated, which was (strictly
speaking) not allowed in the original dictionary.

### Usage Example: modulation

The modulated structures dictionary redefines `_refln.F_calc` to
include the contributions of the modulation waves, and the `refln` and
`refine_agreement` categories gain the extra superspace indices as well.
The links between `refine_agreement` and `refln` work identically to
the core CIF case.

### Usage example: magnetism

The magnetic structure dictionary redefines `_refln.F_calc` to include
the magnetic contributions. The remaining categories and datanames are
unaffected.

### Usage example: twinning

When twinning is introduced each observation can now be associated
with one or more twin individuals, each with a different h,k,l.  We
define a separate loop that maps (h,k,l,twin id) to observation id -
that is, for any given (h,k,l,twin id) there will be a unique (merged)
observation id.  `observed` is populated as for core CIF, after
applying various corrections to the raw data. Insofar as these
corrections do not depend on hkl, they will be identical to core
CIF. `_refln.F_calc` is also calculated identically to core CIF.
`calculated` is found by weighting the structure factors that
contribute to a given observation (found from the loop described
above) by twin individual mass proportion, and `_refln.F_meas` is
back-calculated from `observed` in a way that makes it compatible with
the value that would have been obtained for a single individual of the
same overall mass.

### Usage example: powder

`_refln.F_calc` is redefined to be as for the core CIF case, but with
the particular core CIF parameters determined by the phase ID column,
which may point to a separate datablock.  Observation ID in
`refine_agreement` now corresponds to individual diffraction angles (a
new dataname in this category), and so the path from `_refln.F_calc`
to `_refine_agreement.calculated` involves several further calculation
steps involving peak shape and background terms.
`_refine_agreement.observed` is the corrected observed intensity at a
given angle.

Note that redefinition of `refine_agreement` stretches our concept of
a "special case", in that a calculation for a single powder
observation is only a special case of a single crystal observation if
we imagine that a single crystal peak is a powder peak contracted to
cover a single measurement position.  We may wish to discuss whether
or not it is reasonable to use `refine_agreement` in a powder context,
especially given that the powder dictionary already offers an
alternative category.

### Usage Example: combining magnetism and modulation

A dictionary describing modulated magnetic structures is built on the
modulated structures dictionary by adding datanames for the atomic
moment modulation waves, and then redefining F\_calc with an
additional term for the magnetic modulation wave contributions.  This
satisfies our formal criterion for replacing a dataname, as a zero
atomic moment will return us to the non-magnetic modulated
situation. This is how the recently approved magCIF dictionary could
be seen to operate, despite not including explicit `_refln.F_calc`
definitions.

`refine_agreement` requires no changes.

### Usage example: Modulated structure twinning

A modulated twinned dictionary builds on the modulated dictionary by
taking the `_refln.F_calc` definition of the modulated dictionary, the
`_refln.F_meas` definition of the twinned dictionary, the
`refine_agreement` of the twinned dictionary, and extending the
mapping of observation id to (h,k,l,twin id) with superspace indices.
If twinning can occur in more than three dimensions, then the
`refine_agreement` category would need enhancement as well.

### Usage example: Magnetic modulated structure twinning

This combines the previous example by redefining `_refln.F_calc`
as per the magnetic modulated dictionary.  All other definitions
would come from the modulated structure twinning dictionary.

### Powder and any model

The powder versions of any given model (but not twinning, obviously)
are created by taking the `refine_agreement` category from the powder
dictionary, and most of the `refln` definitions from the dictionary
for the particular model. `_refln.F_meas` must be redefined in each
case separately, as the way in which it is determined depends on both
the model and the powder experiment.

## Discussion

  * While the suggestion that we allow redefinition of datanames may
    appear to go against established CIF principles, this proposal in
    fact simply formalises an approach that has been implicit in CIF
    ever since the powder dictionary inserted a phase ID into the
    `refln` loop.

  * A dictionary is still necessary for every distinct combination of
    models. However, in contrast to the 'no redefinition' approach,
    only the `refln` and/or `_refine_agreement` categories need to be
    redefined, and some or all of the derived dataname definitions can
    remain unchanged (such as refinement statistics and difference
    density).

  * Any addition of new model parameter datanames to a dictionary
    after publication must by definition change the way in which model
    values are calculated, and therefore would in theory require a new
    model name to be defined.  The `_audit.model_version` dataname is
    provided in order to avoid proliferation of dictionaries
    containing incremental adjustments to an initial model.

  * The redefinition procedure is generically applicable to all
    datanames whose values are dependent on other datanames, where the
    nature of that dependency might be changed through a more exact or
    comprehensive specification.

  * The move to capture raw data brings with it a need to precisely
    describe how the processed data are obtained from the raw data.
    While the current proposal addresses the way in which the model is
    calculated, there is probably even more room for variation in the
    way that single crystal data are reduced from images, including
    determination of background, peak integration algorithms,
    rescaling and adjustment of sigma(I).  If CIF is to accommodate
    more than one approach to performing data reduction, some
    mechanism such as the one described here will be essential. 
    
  * The DDLm import mechanism may prove highly useful in allowing
    synthetic dictionaries to be created by importing specific
    categories from different dictionaries.  So
    modulated-twinned-magnetic experiments using data reduction path A
    could be described by a dictionary that imported the magnetic
    dictionary, then imported the twinning `refine_agreement`
    category, then imported the data reduction description for path A
    to replace `refine_agreement.observed`.  Such dictionaries serve
    as a precise description of how a particular experiment has
    adjusted the basic approach.
    
