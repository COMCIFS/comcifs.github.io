# CIF presentation of powder data results

Authors: various
Date: Oct 2025
Version: 0.4
Status: Draft

## Introduction

Powder data results often include multiple phases (crystallographically
distinct compounds) collected at multiple temperatures and/or pressures,
and/or using multiple instruments. This situation is markedly different
to the original CIF approach of a single sample collected at a single wavelength on a
single instrument under a single set of environmental conditions, and has
resulted in the use of multiple CIF data blocks to hold full powder data
sets. [Toby, Von Dreele, and Larson (2003)](https://onlinelibrary.wiley.com/iucr/doi/10.1107/S0021889803016819)
recommended way of distributing such powder data amongst data blocks.

In the last two decades, new CIF standards have formalised multi-block
data presentations.  The present recommendations revisit the task set
by Toby _et al_ in the light of these changes, while aiming to follow the
descriptions in Section 3 of the original paper. An appendix outlines
differences.

It should be noted that redistribution of data between data blocks in
a multi-block data set can be carried out automatically in a way that
does not change the data content. Therefore, failure to follow these
recommendations does not, of itself, render a multi-block powder data
set incorrect or unusable. Nevertheless, as the following rules have
been designed to allow maximum backwards-compatibility for software
tools that do not understand multi-block data sets, conforming to them
is desirable. For example, structural information for a single phase
will be contained in a single data block, so that data sets including
multiple phases can be interpreted by naive software as two
independent structural descriptions.

## General rules for powder data

### Dividing data between data blocks

A more technical discussion of the following rules is presented after
the examples. Please refer to that discussion for the method of
determining which categories belong together for the purposes of Steps 1
and 2.

The distribution of data amongst data blocks can be worked out as follows:

1. Start with a set of data blocks obtained by allowing only one value
for data names from the categories in Column 1 of Table 1 in any given
data block. In other words, a single data block may only describe a
single instance of the concepts in the second column (e.g. one phase,
one structure, one diffractogram). Where there are multiple instances,
multiple blocks must be used, and the key data name with a unique value
must be provided associated with the given category.

**Table 1:** Non-exhaustive list of common items that might be spread over multiple data blocks

| Top category        | Explanation                     | Key data name           | Children                                                                                                                                                                                        |
|---------------------|---------------------------------|-------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `DIFFRN`            | (experimental conditions)       | `_diffrn.id`            |                                                                                                                                                                                                 |
| `DIFFRN_RADIATION`  | (radiation source)              | `_diffrn_radiation.id`  | `diffrn_radiation_wavelength`                                                                                                                                                                   |
| `EXPTL_CRYSTAL`     | (sample information)            | `_exptl_crystal.id`     |                                                                                                                                                                                                 |
| `PD_DIFFRACTOGRAM`  | (powder data measurements)      | `_pd_diffractogram.id`  | `pd_qpa_external_std` `pd_proc_overall` `pd_qpa_overall` `pd_meas_overall` `pd_proc_ls` `pd_calc_overall` `pd_data` `pd_meas` `pd_calc` `pd_background` `pd_calib_d_to_tof` `pd_proc` `pd_peak` |
| `PD_INSTR`          | (powder instrument description) | `_pd_instr.id`          | `pd_calib_incident_intensity`                                                                                                                                                                   |
| `PD_INSTR_DETECTOR` | (powder instrument description) | `_pd_instr_detector.id` | `pd_calib_detected_intensity`                                                                                                                                                                   |
| `PD_PEAK_OVERALL`   | (powder peak information)       | `_pd_peak_overall.id`   |                                                                                                                                                                                                 |
| `PD_PHASE`          | (compound name and ID)          | `_pd_phase.id`          | `pd_qpa_calib_factor` `pd_amorphous` `chemical` `chemical_conn` `chemical_conn_bond` `chemical_formula`                                                                                         |
| `PD_SPEC`           | (specimen description)          | `_pd_spec.id`           |                                                                                                                                                                                                 |
| `SPACE_GROUP`       | (symmetry information)          | `_space_group.id`       | `space_group_symop` `space_group_wyckoff` `space_group_generator`                                                                                                                               |
| `STRUCTURE`         | (structure description)         | `_structure.id`         | `cell` `cell_measurement` `atom_site` `atom_site_aniso` `cell_measurement_refln`                                                                                                                |

2. In addition to the blocks determined from Step 1, if there are
categories that are related to more than one Set category, a separate
data block is required for every distinct combination of these
categories. Currently defined categories that fall into this class are
listed in Table 2.

For example, as the `PD_PHASE_MASS` category depends on both the
phase and the diffractogram, a separate data block should be created for
every combination of phase and diffractogram.

These data blocks include the particular values of the key
data names for the combined categories as shown in the `Key data name`
column of Table 1.

**Table 2:** Non-exhaustive list of combined items

| Set categories                         | Children                                                                                                                                                                        |
|----------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `PD_DIFFRACTOGRAM` `PD_PHASE`          | `pd_pref_orient` `pd_qpa_internal_std` `pd_calc_component` `pd_qpa_intensity_factor` `pd_pref_orient_spherical_harmonics` `pd_pref_orient_march_dollase` `pd_phase_mass` `refln`|

3. Categories from Step 1 for which there is only a single value should
have their blocks combined into a single block.  This does
not violate the requirement stated in Step 1 as the combined data block
still contains only a single instance of each of the data items.

4. The following information should always be grouped together in a single
data block, even if that introduces repetition:
 - Measurement conditions (`DIFFRN*` categories) and the measurement
   (`PD_DIFFRACTOGRAM`) that was conducted under those conditions. Where multiple
   measurements are conducted under the same conditions, each measurement
   is in a separate data block and the `DIFFRN*` data names are repeated.
 - Space group details with other structural information (`CELL`) and overall
   phase information (`_pd_phase.id`, `_pd_phase.name`).

5. Any data blocks violating point (1) should set data name
`_audit.schema` to non-default value `Custom`. For example, summary
data listing all cell parameters as a function of temperature would
need to set this value, as cell parameters can only have single values
in a normal data block. Another common situation would be looping mass
content of phases for a diffractogram.

6. Loops for the Child categories (Table 1) and Combination categories
(Table 2) should only include those values relevant to the particular
values of the key data names for the data block in which they
appear. For example, only the measured points for the diffractogram
identified by `_pd_diffractogram.id` should appear in the same data
block.

### Identifying related data blocks

Data blocks belonging to the same dataset are distinguished by having
identical values for the `_audit_dataset.id` data name. Values should
be universally unique. Sources of universally unique values include
the original powder block id generation algorithm and
[RFC9562](https://datatracker.ietf.org/doc/html/rfc9562) as implemented
in many computing systems. Note that RFC9562 specifies case-insensitive
UUIDs, whereas `_audit_dataset.id` is case-sensitive.

An earlier scheme linking blocks using block ids and block pointers
may also be used to support legacy software.

## Examples

### One phase, two diffractograms

After Steps (1) - (3), we have five data blocks consisting of
the two measurement conditions, the two corresponding diffractograms,
and the remainder containing information about the sample and
jointly refined model for which there is only one of each.

According to Step (4), measurement conditions and the corresponding
diffractograms should be combined. Therefore we have
three data blocks: two containing the two diffractograms together with
their measurement conditions, and one containing everything else.

```
#\#CIF_2.0
#
# Example of using CIF to describe two data sets, one phase
#
#
# There are three data blocks:
# 2 x raw powder data using `_pd_diffractogram.diffrn_id` to
#     refer to the relevant diffraction conditions, which
# are included in the same data block.
# 1 x data block for everything else
#
data_PWDR_PBSO4.CWN_Bank_1

_audit_dataset.id d25aad62-effc-4920-a01a-568a2c2a350c

_diffrn.id	11158

_diffrn.ambient_pressure	0.1
_diffrn.ambient_temperature	300.0
_diffrn_radiation.probe	        neutron
_diffrn_radiation_wavelength.value    1.909

_pd_diffractogram.id	'PWDR PBSO4.CWN Bank 1'
_pd_diffractogram.diffrn_id   11158    # <-proposed
_pd_phase_mass.phase_id  pbso4
_pd_phase_mass.percent   100

    loop_
      _pd_data.point_id
      _pd_meas.2theta_scan
      _pd_meas.intensity_total
      _pd_meas.intensity_total_su
      1   10.0                          220.0             0.004
      2   10.05                         214.0             0.004
      3   10.1                          219.0             0.004
      4   10.15                         224.0             0.004
      5   10.2                          198.0             0.005
      6   10.25                         229.0             0.004
      7   10.3                          224.0             0.004

#...

data_PWDR_PBSO4.XRA_Bank_1

_audit_dataset.id d25aad62-effc-4920-a01a-568a2c2a350c

_diffrn.id	11080

_diffrn.ambient_pressure	0.1
_diffrn.ambient_temperature	300.0
_diffrn_radiation.probe	x-ray

loop_
      _diffrn_radiation_wavelength.id
      _diffrn_radiation_wavelength.value
     1   1.5405
     2   1.5443

_pd_diffractogram.id	'PWDR PBSO4.XRA Bank 1'
_pd_diffractogram.diffrn_id   11080    # <-proposed
_pd_phase_mass.phase_id  pbso4
_pd_phase_mass.percent   100

    loop_
      _pd_data.point_id
      _pd_meas.2theta_scan
      _pd_meas.intensity_total
      _pd_meas.intensity_total_su
      1   10.0                         179.0             0.005
      2   10.025                       147.0             0.006
      3   10.05                        165.0             0.006
      4   10.075                       172.0             0.005
      5   10.1                         150.0             0.006
      6   10.125                       165.0             0.006
#...

data_classic

_audit_dataset.id d25aad62-effc-4920-a01a-568a2c2a350c

_pd_phase.id          pbso4

# Following two could be elided as no ambiguity
_structure.id         pbso4_rt
_structure.phase_id   pbso4  # <- Proposed

_cell.angle_alpha	90.0
_cell.angle_beta	90.0
_cell.angle_gamma	90.0
_cell.length_a	         8.485
_cell.length_b	         5.402
_cell.length_c	         6.965
_cell.volume           319.305

_space_group.crystal_system	orthorhombic
_space_group.laue_class	        mmm
_space_group.name_h-m_ref	'P n m a'

loop_
      _atom_site.label
      _atom_site.fract_x
      _atom_site.fract_y
      _atom_site.fract_z
      _atom_site.type_symbol
   Pb1       0.1882            0.25             0.167       Pb
   S2        0.063             0.25             0.686       S
   O3        -0.095            0.25             0.6         O
   O4        0.181             0.25             0.543       O
   O5        0.085             0.026            0.806       O
```

### Multiple phases, single diffractogram

In this case a single diffractogram is modelled using multiple
structures (phases).

After Steps 1 - 3, we have five data blocks: one for each structure,
one for each set of space group information,
and one for everything else.

According to Step 4, we combine space group and structural information,
leaving us with three data blocks.

```
#\#CIF_2.0
#
# Example: using pdCIF to describe multiple phases in a single diffractogram
#
# The sample contains CuCr2O4 and CuO impurity. Each structure is listed in
# a separate block. Data items that can be listed in a single block are
# collected together in the "classic" block.
#
data_classic

_audit_dataset.id 6bdf3aa2-a2d9-41a3-ae76-36af9af8ab19
_diffrn.ambient_pressure	0.1
_diffrn.ambient_temperature	6.778
_diffrn_radiation.probe	        x-ray
_diffrn_radiation_wavelength.value     0.413263

_pd_diffractogram.id	'PWDR OH_00.fxye Bank 1'

loop_
      _pd_data.point_id
      _pd_meas.2theta_scan
      _pd_meas.intensity_total
      _pd_meas.intensity_total_su
      1   0.5           65.24          0.007
      2   0.502         91.16          0.005
      3   0.504         83.89          0.0055
      4   0.506         73.26          0.006
      5   0.508         73.95          0.0065
      6   0.51          68.76          0.007
      7   0.512         55.25          0.008
# Lines omitted...

data_CuCr2O4

_audit_dataset.id 6bdf3aa2-a2d9-41a3-ae76-36af9af8ab19

_structure.id	CuCr2O4
_structure.space_group_id	fddd
_structure.phase_id    cucr2o4   # <- proposed
_pd_phase.id           cucr2o4
_pd_phase_mass.diffractogram_id  'PWDR OH_00.fxye Bank 1'
_pd_phase_mass.percent         98.7

_space_group.crystal_system	orthorhombic
_space_group.id	fddd
_space_group.laue_class	mmm
_space_group.name_h-m_alt	'F d d d'
_space_group.name_Hall           '-F 2uv 2vw'
#symops could go here

_cell.angle_alpha	90.0
_cell.angle_beta	90.0
_cell.angle_gamma	90.0
_cell.length_a	7.712
_cell.length_b	8.543
_cell.length_c	8.536
_cell.volume	562.481

loop_

   _atom_site.label
   _atom_site.type_symbol
   _atom_site.fract_x
   _atom_site.fract_y
   _atom_site.fract_z
      Cu                  Cu   0.125                 0.125                 0.125
      Cr                  Cr   0.5                   0.5                   0.5
      O                   O    0.2457                0.2682                0.2674

data_CuO

_audit_dataset.id 6bdf3aa2-a2d9-41a3-ae76-36af9af8ab19

_structure.id	CuO
_structure.space_group_id	c2c
_structure.phase_id     cuo    # <- proposed
_pd_phase.id    cuo
_pd_phase_mass.diffractogram_id  'PWDR OH_00.fxye Bank 1'
_pd_phase_mass.percent       1.3

_space_group.crystal_system	monoclinic
_space_group.id	c2c
_space_group.name_h-m_alt	'C 2/c'
_space_group.name_Hall           '-C 2yc'
#symops could go here

_cell.angle_alpha	90.0
_cell.angle_beta	99.81
_cell.angle_gamma	90.0
_cell.length_a	4.684
_cell.length_b	3.422
_cell.length_c	5.095
_cell.volume	80.517

loop_
  _atom_site.label
  _atom_site.type_symbol
  _atom_site.fract_x
  _atom_site.fract_y
  _atom_site.fract_z
       Cu1       Cu+2  0.25         0.25           0.0
       O1         O-2  0.0          0.4184         0.25

```

### Multiple temperatures, multiple phases

In this example we have measured the previous sample at
multiple temperatures, and also wish to present our
modelled structure factors.

We have three sets of measurement
conditions, resulting in three diffractograms. We have
two phases belonging to different space groups, giving a
total of 3 x 2 structures.

When presenting the structure factors in the reflection table, we have separate
blocks for each combination of phase and diffractogram,
giving another 3 x 2 data blocks (Step 2). These blocks can also contain the
phase mass percentages, as these values also depend on the sam ecombination of
phase and diffractogram.

We also have a block describing the radiation source, which
can be included in the overall block as only one radiation
source was used.

As a result, after steps 1 - 3, there are 2 space
group blocks, 3 x 2 structural blocks, 3 diffractogram
blocks, 3 experimental condition blocks,
2 phase information blocks, and 3 x 2 reflection/phase mass
blocks, and one block for everything else,
making a total of 23 blocks.

Step 4 requires us to merge space group information in
with structural and phase information, even though in this case we
introduce repetition of space group information. The two separate space
group blocks and phase information blocks therefore disappear. Likewise,
the diffraction conditions for each measurement should be
merged with that measurement, removing the 3 experimental condition
blocks.

As a result we have 16 data blocks.

```
#\#CIF_2.0
#
# Example of a dataset containing measurements at
# multiple temperatures of a two-phase sample
#
#=============================================================================

# List all distinct radiations used. In this case this belongs in the
# overall data block.

data_classic

_audit_dataset.id c5c4b947-0708-411e-b44b-e157f645fd23

_diffrn_radiation.id                common
_diffrn_radiation_wavelength.value  0.41326
_diffrn_radiation.probe             x-ray
_diffrn_radiation.polarisn_ratio    0.9900

# Other general information here

#=============================================================================

# List all distinct structures, one per data block, including space group

data_cr2cuo4_7k

_audit_dataset.id c5c4b947-0708-411e-b44b-e157f645fd23

_structure.id                cr2cuo4_7K
_structure.diffrn_id         7K
_structure.space_group_id    fddd
_structure.phase_id          cr2cuo4

_pd_phase.id       cr2cuo4
_pd_phase.name     Cr2CuO4

_space_group.id            fddd
_space_group.name_H-M_alt  "F d d d"
_space_group.name_Hall  "-F 2uv 2vw"

loop_
    _space_group_symop.id
    _space_group_symop.operation_xyz
     1  x,y,z
     2  -x,1/4+y,1/4+z
     3  1/4+x,-y,1/4+z
     4  3/4-x,1/4-y,1/2+z
     5  -x,-y,-z
# ...

_cell.length_a  7.71270(3)
_cell.length_b  8.54329(4)
_cell.length_c  8.53643(4)
_cell.angle_alpha  90
_cell.angle_beta   90
_cell.angle_gamma  90
_cell.volume  562.481(6)

_chemical_formula.sum  "Cr2 Cu O4"
_chemical_formula.weight  231.53

loop_
   _atom_site.label
   _atom_site.type_symbol
   _atom_site.fract_x
   _atom_site.fract_y
   _atom_site.fract_z
   _atom_site.occupancy
   _atom_site.adp_type
   _atom_site.U_iso_or_equiv
   _atom_site.site_symmetry_multiplicity
Cu     Cu   0.12500     0.12500     0.12500     1.0000     Uiso 0.00003(22) 8
Cr     Cr   0.50000     0.50000     0.50000     1.0000     Uiso 0.00011(22) 16
O      O    0.24582(21) 0.2682(4)   0.2674(4)   1.0000     Uiso 0.0042(5) 32

data_cr2cuo4_17k

_audit_dataset.id c5c4b947-0708-411e-b44b-e157f645fd23

_structure.id                cr2cuo4_17K
_structure.diffrn_id         17K
_structure.space_group_id    fddd
_structure.phase_id          cr2cuo4

_pd_phase.id       cr2cuo4
_pd_phase.name     Cr2CuO4

_space_group.id            fddd
_space_group.name_H-M_alt  "F d d d"
_space_group.name_Hall  "-F 2uv 2vw"

loop_
    _space_group_symop.id
    _space_group_symop.operation_xyz
     1  x,y,z
     2  -x,1/4+y,1/4+z
     3  1/4+x,-y,1/4+z
     4  3/4-x,1/4-y,1/2+z
     5  -x,-y,-z
# ...

_cell.length_a  7.71286(3)
_cell.length_b  8.54321(4)
_cell.length_c  8.53651(4)
_cell.angle_alpha  90
_cell.angle_beta   90
_cell.angle_gamma  90
_cell.volume  562.493(6)

_chemical_formula_sum  "Cr2 Cu O4"
_chemical_formula_weight  231.53

loop_
   _atom_site.label
   _atom_site.type_symbol
   _atom_site.fract_x
   _atom_site.fract_y
   _atom_site.fract_z
   _atom_site.occupancy
   _atom_site.adp_type
   _atom_site.U_iso_or_equiv
   _atom_site.site_symmetry_multiplicity
Cu     Cu   0.12500     0.12500     0.12500     1.0000     Uiso 0.00062(21) 8
Cr     Cr   0.50000     0.50000     0.50000     1.0000     Uiso 0.00036(21) 16
O      O    0.24520(20) 0.2681(4)   0.2676(4)   1.0000     Uiso 0.0042(4) 32

data_cr2cuo4_47k

_audit_dataset.id c5c4b947-0708-411e-b44b-e157f645fd23

_structure.id                cr2cuo4_7K
_structure.diffrn_id         7K
_structure.space_group_id    fddd
_structure.phase_id          cr2cuo4

_pd_phase.id       cr2cuo4
_pd_phase.name     Cr2CuO4

_space_group.id            fddd
_space_group.name_H-M_alt  "F d d d"
_space_group.name_Hall  "-F 2uv 2vw"

loop_
    _space_group_symop.id
    _space_group_symop.operation_xyz
     1  x,y,z
     2  -x,1/4+y,1/4+z
     3  1/4+x,-y,1/4+z
     4  3/4-x,1/4-y,1/2+z
     5  -x,-y,-z
# ...

_cell.length_a  7.713768(29)
_cell.length_b  8.54289(3)
_cell.length_c  8.53669(4)
_cell.angle_alpha  90
_cell.angle_beta   90
_cell.angle_gamma  90
_cell.volume  562.550(5)

_chemical_formula.sum  "Cr2 Cu O4" # <- need to add ptr to _structure.id
_chemical_formula.weight  231.53   # <- need to add ptr to _structure.id

loop_
   _atom_site.label
   _atom_site.type_symbol
   _atom_site.fract_x
   _atom_site.fract_y
   _atom_site.fract_z
   _atom_site.occupancy
   _atom_site.adp_type
   _atom_site.U_iso_or_equiv
   _atom_site.site_symmetry_multiplicity
Cu     Cu   0.12500     0.12500     0.12500     1.0000     Uiso 0.00086(21) 8
Cr     Cr   0.50000     0.50000     0.50000     1.0000     Uiso 0.00020(20) 16
O      O    0.24566(20) 0.2674(4)   0.2676(4)   1.0000     Uiso 0.0032(4) 32

data_cuo_7K

_audit_dataset.id c5c4b947-0708-411e-b44b-e157f645fd23

_structure.id                cuo_7K
_structure.diffrn_id         7K
_structure.space_group_id    c2c
_structure.phase_id          cuo

_pd_phase.id       cuo
_pd_phase.name     CuO

_space_group.id            c2c
_space_group.name_H-M_alt  "C 2/c"
_space_group.name_Hall     "-C 2yc"

loop_
    _space_group_symop.id
    _space_group_symop.operation_xyz
     1  x,y,z
     2  -x,y,1/2-z
     3  -x,-y,-z
     4  x,-y,1/2+z
     5  1/2+x,1/2+y,z
     6  1/2-x,1/2+y,1/2-z
     7  1/2-x,1/2-y,-z
     8  1/2+x,1/2-y,1/2+z

_cell.length_a  4.677(4)
_cell.length_b  3.4188(11)
_cell.length_c  5.131(6)
_cell.angle_alpha  90
_cell.angle_beta   99.751(21)
_cell.angle_gamma  90
_cell.volume  80.860(18)

loop_
   _atom_site.label
   _atom_site.type_symbol
   _atom_site.fract_x
   _atom_site.fract_y
   _atom_site.fract_z
   _atom_site.occupancy
   _atom_site.adp_type
   _atom_site.U_iso_or_equiv
   _atom_site.site_symmetry_multiplicity
Cu1    Cu2+ 0.25000     0.25000     0.00000     1.0000     Uiso 0.0010     4
O1     O2-  0.00000     0.41840     0.25000     1.0000     Uiso 0.0010     4

data_cuo_17K

_audit_dataset.id c5c4b947-0708-411e-b44b-e157f645fd23

_structure.id                cuo_17K
_structure.diffrn_id         17K
_structure.space_group_id    c2c
_structure.phase_id          cuo

_pd_phase.id       cuo
_pd_phase.name     CuO

_space_group.id            c2c
_space_group.name_H-M_alt  "C 2/c"
_space_group.name_Hall     "-C 2yc"

loop_
    _space_group_symop.id
    _space_group_symop.operation_xyz
     1  x,y,z
     2  -x,y,1/2-z
     3  -x,-y,-z
     4  x,-y,1/2+z
     5  1/2+x,1/2+y,z
     6  1/2-x,1/2+y,1/2-z
     7  1/2-x,1/2-y,-z
     8  1/2+x,1/2-y,1/2+z

_cell.length_a  4.6779(31)
_cell.length_b  3.4196(10)
_cell.length_c  5.130(5)
_cell.angle_alpha  90
_cell.angle_beta   99.754(18)
_cell.angle_gamma  90
_cell.volume  80.871(16)

loop_
   _atom_site.label
   _atom_site.type_symbol
   _atom_site.fract_x
   _atom_site.fract_y
   _atom_site.fract_z
   _atom_site.occupancy
   _atom_site.adp_type
   _atom_site.U_iso_or_equiv
   _atom_site.site_symmetry_multiplicity
Cu1    Cu2+ 0.25000     0.25000     0.00000     1.0000     Uiso 0.0010     4
O1     O2-  0.00000     0.41840     0.25000     1.0000     Uiso 0.0010     4

data_cuo_47K

_audit_dataset.id c5c4b947-0708-411e-b44b-e157f645fd23

_structure.id                cr2cuo4_7K
_structure.diffrn_id         47K
_structure.space_group_id    c2c
_structure.phase_id          cuo

_pd_phase.id       cuo
_pd_phase.name     CuO

_space_group.id            c2c
_space_group.name_H-M_alt  "C 2/c"
_space_group.name_Hall     "-C 2yc"

loop_
    _space_group_symop.id
    _space_group_symop.operation_xyz
     1  x,y,z
     2  -x,y,1/2-z
     3  -x,-y,-z
     4  x,-y,1/2+z
     5  1/2+x,1/2+y,z
     6  1/2-x,1/2+y,1/2-z
     7  1/2-x,1/2-y,-z
     8  1/2+x,1/2-y,1/2+z

_cell.length_a  4.677(3)
_cell.length_b  3.4199(10)
_cell.length_c  5.131(5)
_cell.angle_alpha  90
_cell.angle_beta   99.771(20)
_cell.angle_gamma  90
_cell.volume  80.886(17)

loop_
   _atom_site.label
   _atom_site.type_symbol
   _atom_site.fract_x
   _atom_site.fract_y
   _atom_site.fract_z
   _atom_site.occupancy
   _atom_site.adp_type
   _atom_site.U_iso_or_equiv
   _atom_site.site_symmetry_multiplicity
Cu1    Cu2+ 0.25000     0.25000     0.00000     1.0000     Uiso 0.0010     4
O1     O2-  0.00000     0.41840     0.25000     1.0000     Uiso 0.0010     4

#=============================================================================

# List per-diffractogram information, one per block

data_0H_00

_audit_dataset.id c5c4b947-0708-411e-b44b-e157f645fd23

_diffrn.id                   7K
_diffrn.ambient_temperature  6.778
_diffrn.ambient_pressure     100
_diffrn.diffrn_radiation_id  common

_pd_diffractogram.id       0H_00
_pd_diffractogram.diffrn_id  7K
_pd_meas.2theta_range_min  0.50000
_pd_meas.2theta_range_max  26.09600
_pd_meas.2theta_range_inc  0.00200
_pd_meas.number_of_points  12799

loop_
   _pd_data.point_id
   _pd_meas.intensity_total
   _pd_calc.intensity_total
   _pd_proc.intensity_bkg_calc
   _pd_proc.ls_weight

  1 43.783814    41.795171    41.771237   0.0229313
  2 45.626478    41.851699    41.827565   0.0219996
  3 47.171463    41.908055    41.883717   0.021299
  4 36.951371    41.964215    41.939672   0.0272123
  5 33.266743    42.020211    41.99546    0.0301765
  6 40.981582    42.075989    42.051027   0.0246658
  7 41.683548    42.131611    42.106435   0.0245573
# ... measurements omitted

data_0H_04

_audit_dataset.id c5c4b947-0708-411e-b44b-e157f645fd23

_diffrn.id                   17K
_diffrn.ambient_temperature  16.702
_diffrn.ambient_pressure     100
_diffrn.diffrn_radiation_id  common

_pd_diffractogram.id       0H_04
_pd_diffractogram.diffrn_id   17K
_pd_meas.2theta_range_min  0.50000
_pd_meas.2theta_range_max  26.09600
_pd_meas.2theta_range_inc  0.00200
_pd_meas.number_of_points  12799

loop_
   _pd_data.point_id
   _pd_meas.intensity_total
   _pd_calc.intensity_total
   _pd_proc.intensity_bkg_calc
   _pd_proc.ls_weight
  1 29.898017    41.711299    41.687919   0.0335978
  2 39.768154    41.769158    41.745582   0.0253885
  3 39.527914    41.826837    41.803062   0.0253699
  4 46.349986    41.884328    41.860353   0.0218265
  5 42.403998    41.941639    41.91746    0.0240971
  6 47.876864    41.99877     41.974385   0.0210206
  7 40.335609    42.055705    42.031112   0.0249116
# ...omitted measurements

data_OH_09

_audit_dataset.id c5c4b947-0708-411e-b44b-e157f645fd23

_diffrn.id                   47K
_diffrn.ambient_temperature  46.97
_diffrn.ambient_pressure     100
_diffrn.diffrn_radiation_id  common

_pd_diffractogram.id          0H_09
_pd_diffractogram.diffrn_id   47K
_pd_meas.2theta_range_min  0.50000
_pd_meas.2theta_range_max  26.09600
_pd_meas.2theta_range_inc  0.00200
_pd_meas.number_of_points  12799

loop_
   _pd_data.point_id
   _pd_meas.intensity_total
   _pd_calc.intensity_total
   _pd_proc.intensity_bkg_calc
   _pd_proc.ls_weight
  1 42.173306    41.069518    41.047364   0.0238043
  2 48.964589    41.127992    41.105653   0.0205706
  3 45.8184      41.186308    41.163781   0.021942
  4 43.853758    41.244428    41.221709   0.0231165
  5 61.582546    41.302373    41.279462   0.0163382
  6 35.581044    41.360115    41.337009   0.0282443
  7 48.461362    41.417706    41.394402   0.0207815
# ...measurements omitted

#===============================================================

# Information that is per-phase, per histogram

data_0H_cr2cuo4

_audit_dataset.id c5c4b947-0708-411e-b44b-e157f645fd23

_pd_diffractogram.id       0H_00
_pd_phase.id               cr2cuo4
_pd_phase_mass.percent     98.88(4)

loop_
   _refln.id
   _refln.index_h
   _refln.index_k
   _refln.index_l
   _refln.F_squared_meas
   _refln.F_squared_calc
   _refln.phase_calc
   _refln.d_spacing
  a    1    1    1     2923.7101  1848.8118   0.0   4.75465
  b    0    2    2    50887.9824 44176.2312 180.0   3.01930
  c    2    2    0    41129.5142 38146.8191 180.0   2.86244
  d    2    0    2    40719.7976 38182.2594 180.0   2.86141
# ...

# preferred orientation information also goes here

data_0H_cuo

_audit_dataset.id c5c4b947-0708-411e-b44b-e157f645fd23

_pd_diffractogram.id       0H_00
_pd_phase.id               cuo
_pd_phase_mass.percent     1.12(4)

loop_
   _refln.id
   _refln.index_h
   _refln.index_k
   _refln.index_l
   _refln.F_squared_meas
   _refln.F_squared_calc
   _refln.phase_calc
   _refln.d_spacing
  a    1    1     0     4339.5540   527.9252  180.0   2.74595
  b    0    0     2     5381.1374  4772.3738    0.0   2.52848
  c    1    1    -1     7778.9105  6672.9552  180.0   2.52221
  d    1    1     1    10519.8297 10580.5215  180.0   2.31709
  e    2    0     0     6179.8194  4667.8699  180.0   2.30477
  f    1    1    -2     1570.8862   298.7972    0.0   1.96126
# ...

data_04_cr2cuo4

_audit_dataset.id c5c4b947-0708-411e-b44b-e157f645fd23

_pd_diffractogram.id       0H_04
_pd_phase.id               cr2cuo4
_pd_phase_mass.percent     98.85(4)

loop_
   _refln.id
   _refln.index_h
   _refln.index_k
   _refln.index_l
   _refln.F_squared_meas
   _refln.F_squared_calc
   _refln.phase_calc
   _refln.d_spacing
  i    1    1    1     2857.5850  1815.5648   0.0   4.75469
  ii   0    2    2    50066.2033 44075.8291 180.0   3.01930
  iii  2    2    0    40970.9520 37913.9619 180.0   2.86246
  iv   2    0    2    40623.1705 37934.3275 180.0   2.86146
  v    1    3    1    65233.6297 67538.1258 180.0   2.54953
# ...

data_04_cuo

_audit_dataset.id c5c4b947-0708-411e-b44b-e157f645fd23

_pd_diffractogram.id       0H_04
_pd_phase.id               cuo
_pd_phase_mass.percent     1.15(4)

loop_
   _refln.id
   _refln.index_h
   _refln.index_k
   _refln.index_l
   _refln.F_squared_meas
   _refln.F_squared_calc
   _refln.phase_calc
   _refln.d_spacing
  q    1    1     0    3027.3298   528.0777  180.0   2.74652
  w    0    0     2    5645.9302  4772.1111    0.0   2.52777
  e    1    1    -1    7984.2080  6673.2990  180.0   2.52253
  r    1    1     1   10367.4860 10581.1099  180.0   2.31726
  t    2    0     0    6208.4277  4668.0844  180.0   2.30514
# ...

data_09_cr2cuo4

_audit_dataset.id c5c4b947-0708-411e-b44b-e157f645fd23

_pd_diffractogram.id       0H_09
_pd_phase.id               cr2cuo4
_pd_phase_mass.percent     98.65(4)

loop_
   _refln.id
   _refln.index_h
   _refln.index_k
   _refln.index_l
   _refln.F_squared_meas
   _refln.F_squared_calc
   _refln.phase_calc
   _refln.d_spacing
  1    1    1    1     2866.3493  1806.1692   0.0   4.75488
  2    0    2    2    48243.5918 43869.8403 180.0   3.01927
  3    2    2    0    40547.2038 38008.3146 180.0   2.86260
  4    2    0    2    40068.9116 37989.4186 180.0   2.86167
  5    1    3    1    66629.5169 68307.3304 180.0   2.54949
# ...

data_09_cuo

_audit_dataset.id c5c4b947-0708-411e-b44b-e157f645fd23

_pd_diffractogram.id       0H_09
_pd_phase.id               cuo
_pd_phase_mass.percent     1.35(4)

loop_
   _refln.id
   _refln.index_h
   _refln.index_k
   _refln.index_l
   _refln.F_squared_meas
   _refln.F_squared_calc
   _refln.phase_calc
   _refln.d_spacing
  u    1    1     0     4614.5984   528.0627  180.0   2.74646
  v    0    0     2     5629.4996  4772.3673    0.0   2.52846
  w    1    1    -1     7957.5050  6673.6405  180.0   2.52285
  g    1    1     1    10650.5252 10580.9378  180.0   2.31721
  h    2    0     0     5809.4324  4667.7910  180.0   2.30463
# ...
```

## Appendix A: Technical

### Definitions

**Category**: a collection of data names that appear together in a
CIF loop. These form a table in a relational-database-sense.

**Set category**:  Data names belonging to a Set category
can only take a single value in each data block. Items in Set categories
are often presented as key-value pairs, but could be presented as
a single-row loop if desired.

**Loop category**:  Data names belonging to a Loop category
can take on multiple values in each data block. Items in Loop categories
are often presented as multi-row loops, but could be presented as
a key-value pair if there is only one value in a block.

**Child category**:  A category is a **child** of a Set category if
one of its key data names is linked to the Set category key data
name. This linkage is indicated using `_name.linked_item_id`
in the child key data name definition. A category may be the child
of more than one Set category if it has multiple key data names.

**Top category**: A Set category with a single key data name that
is not a child of any other Set Category.

### CIF for complex data

COMCIFS has accepted that multiple data blocks are necessary in order
to describe complex data, and have approved [a general approach for
such
cases](https://github.com/COMCIFS/comcifs.github.io/blob/master/accepted/multi-block-principles.md). Any
data names belonging to `Set` categories should only appear once
within any given data block, and multiple data blocks are therefore
needed to provide multiple values for those `Set` data names. By
applying these principles, a prescription for powder data can be
obtained based on the `Set` categories for core and powder CIF,
noting that `PD_PHASE` and `PD_DIFFRACTOGRAM` are `Set` categories.

### Technical description

The complete dataset may be represented as a collection of tables. Thus
if ten diffraction patterns are included, they will appear in a single
table, with the `_pd_diffractogram.id` column identifying which
diffractogram a given two theta and intensity value belong to. These
tables will include a great deal of repetition of the values of
the key data names. To avoid repetition, we use "scoping" and "projection"
to divide the dataset into blocks. After scoping and projection,
the dataset has been divided into chunks.

#### Scoping

A "data block" creates a scope within which a Set category
key data name's value can be used to "project" rows out of categories.

#### Projection

"Projection" is selecting only those rows of tables for which
key data names that are children of Set category key data names
take the values that are in scope. After projection, there is
no need to include values of the child key data names as their
values are just those of the Set category key data names.

In our example containing many diffractograms, each data block takes a
single value for `_pd_diffractogram.id`, leading to ten data blocks,
one for each diffractogram. Projection means selecting only those rows
of the overall data table that belong to the diffractogram identified
by `_pd_diffractogram.id`, leading to the obvious result that each
data block contains a diffractogram from a single experiment.

### Creating Tables 1 and 2

There are many ways to distribute powder data over data blocks and
conform to the general restrictions described in the previous
section. The following heuristic results in a single preferred
approach which should simplify the task of software authors.

To obtain the category lists in Table 1:

1. Make a list of Set categories that have a single key data name defined
2. For each category from Step 1, the "child" categories are
those that have a key data name that is linked (via
`_name.linked_item_id`) to the Set category key data name.

The category lists in Table 2 are obtained as follows:

1. Find all categories for which two or more key data names are linked
to Top category key data names via `_name.linked_item_id`
2. Sort these categories according to the particular combination of
Set categories that they relate to.

## Appendix B: Comparison with Toby et. al.

### Summary of TVDL approach

For brevity,
[Toby, Von Dreele, and Larson (2003)](https://onlinelibrary.wiley.com/iucr/doi/10.1107/S0021889803016819) is abbreviated as TVDL below. The TVDL prescription is given in terms
of `D` diffraction measurements and `P` phases.

Four kinds of data blocks are described:

1. A separate publication block

2. A separate overall information block

3. `P` Chemical species (phase) blocks

4. `D` Diffraction data blocks

Key points:

1. When either D > 1 or P > 1, all D and P are placed in separate blocks. When
D = P = 1, all the above blocks are merged into a single block. This is for
simplicity in implementation.

2. The chemical species blocks include structural and chemical information, as
would be seen in a single-crystal data block.

3. The diffraction data blocks include loops over the constituent phases,
loops for raw and calculated data, and potentially loops where the incident
beam contains more than one wavelength.

4. Relationships between blocks (e.g. which chemical species are present in
which diffraction data set) are indicated using block pointers and block
identifiers.

### Block identifiers/pointers

In TVDL, blocks are connected using block pointers. Nothing in the present
standard prevents the use of these pointers or identifiers in addition to
`_audit_dataset.id`.

### Separate blocks

The publication and overall information blocks would be combined into a
single block in the present guide. This is not strictly necessary.

### Chemical species blocks

Rule 4 combines categories that have child key data names of
`_structure.id` and `_pd_phase.id`. This results in the same contents.

### Diffraction data blocks

Diffraction data blocks are the most complex of those described in TVDL.
In terms of child key data names of Set categories, TVDL diffraction data
blocks contain:

1. Diffractograms, together with the measurement conditions and instruments -
children of `_pd_diffractogram.id`, `_diffrn.id`, and `_pd_instr.id`.

2. Phase table (TVDL 3.4.1). Combinations of children of `_pd_phase.id`
and `_pd_diffractogram.id` giving all categories in the second row of Table 2.

3. Wavelength table - `_diffrn_radiation_wavelength.id`. Our recommendations
would put this in a separate block.

4. Refln loop. TVDL includes `_pd_refln.phase_id` as a column in the loop,
so that hkl from all phases are contained in a single loop for a single
diffractogram.

The present guidelines reproduce only part 1 of the TVDL recommendations for
diffraction data blocks.



