# Draft guidelines for using imgCIF with core CIF

Version: 0.1
Date: January 2022
Authors: J R Hester

## Introduction

The following guidelines explain how to include raw image data in a 
chemical crystallography dataset using data names defined in the
imgCIF dictionary. These guidelines do *not* apply to datasets
conforming to the PDBx/mmCIF dictionaries.

## Summary

Tags from the imgCIF dictionary may be freely mixed with core CIF
tags.  In certain situations the dataset should be distributed over
multiple data blocks. It is essential for efficiency that
`_array_data.external_*` tags are used to refer to image data rather 
than incorporating the image data into the imgCIF file.

## Definitions

For clarity, the following terms are used:

* "Dataset": a collection of data objects, including images, metadata, and
potentially reduced data and results
* "Data collection": a set of diffraction data, usually in the form of images,
obtained from a single sample under constant conditions
* "Data block": a data object that can be transformed into a CIF data block
* "(Data) item": a data name and associated value(s)
* "Set category": a category for which a DDLm dictionary specifies that data names 
in that category should take a single value in a single data block.

## Details

1. Data blocks conforming to these guidelines should always include the line 
```
_audit_conform.dict_name        CORE_DIC
```

2. The only practical way to use imgCIF with raw data is to point to the raw data 
themselves using `_array_data.external_*` tags.

3. Where a single data collection is reported using a single detector
and goniometer, all imgCIF tags may be mixed freely with cif core data
names in a single data block.

4. Where more than one data collection was performed, each data collection
is placed in its own separate block, with a distinct value of `_diffrn.id`
provided.

5. If more than one detector has been used to collect data:

    * Individual detectors must be identified using a unique, arbitrary value for 
    `_diffrn_detector.id`
    * Data and metadata for each detector are presented in separate
    data blocks, one per detector. Only data items in categories
    `diffrn_detector_axis`,
    `diffrn_scan_frame_monitor`,`_diffrn_detector_element`, and
    `diffrn_data_frame` should be included in these data blocks.
    * Each set of detectors has to be
    respecified for every data collection. So for 2 detectors
    used at 3 temperatures, 2*3 = 6 separate blocks are required to specify
    detectors, instead of 2 + 3 = 5.

6. If more than one sample has been used to collect the data:

 * Individual samples are assigned a unique, arbitrary value for
 `_exptl_crystal.id`
 * Information for each sample is placed in separate data blocks,
 one for each value of `_exptl_crystal.id`.
 * According to the core dictionary, the categories containing child data names for
 `_exptl_crystal.id` are `exptl_crystal_face` and
 `exptl_crystal_appearance`.
 * Each crystal is associated with a separate data collection. Each
 of these data collections should be presented as described in (2). 
 Use `_diffrn.crystal.id` to link data collection to crystal.
 
7. Other, less common situations to be aware of:
   * Multiple orienting devices (`diffrn_measurement`) should be treated
   the same as multiple detectors.
    * The `exptl_absorpt` category calculates absorption for a
   particular crystal, which depends on wavelength (and radiation
   type). When this category is present, it should be placed in a
   separate data block for each combination of crystal and diffraction
   conditions.

8. Where more than one of the items in (4-6) vary for a single
dataset, each distinct combination of items is placed in a separate
data block, together with a single block containing those items that
do not depend on any of the variable items. So a dataset consisting of
2 wavelengths (i.e. 2 data collections) from a 4-detector instrument
using a different crystal at each wavelength would contain 2 data
collections x 4 detectors + 2 crystals + 1 overall = 11 datablocks.

## Questions and Answers

Q: How should I present data from a single data set
collected on different instruments, or in a different instrument
configuration, if there is only a single block used to describe
instrument and detector layout?

A: Where the difference in configuration is due to an axis movement,
that is accommodated by providing the axis positions for each distinct
value of `_diffrn.id` and (if necessary) `_scan.id` in the usual
imgCIF way. Where the difference is due to a complete change of
instrument, distinct axes for each instrument should be provided in
the `_axis.id` list and then referred to in the appropriate data
block.

## Complex Example

In the following example, data were collected at two wavelengths and two temperatures
for each wavelength, with different crystals used at each wavelength.

```
data_wav1_temp1

# Core items
_diffrn.id            expt1
_diffrn.crystal_id    crystal1
_diffrn.ambient_temperature 296
_diffrn_radiation.probe  x-ray
_diffrn_radiation_wavelength.value  1.54

_cell.length_a        4.1
_cell.length_b        4.1
_cell.length_c        4.1

loop_
_diffrn_refln.h
_diffrn_refln.k
_diffrn_refln.l
_diffrn_refln.counts_net
1 0 1   25
# many more reflections...

# imgCIF items: anything starting with `_diffrn`

_diffrn_detector.id                  det1
_diffrn_detector.number_of_axes      1
_diffrn_detector_axis.axis_id        trans

loop_
      _diffrn_data_frame.id
      _diffrn_data_frame.binary_id
      _diffrn_data_frame.array_id
           1  ext1    1
           2  ext2    1
           3  ext3    1
# more frame - binary data links here

_diffrn_scan.id                          SCAN1
_diffrn_scan.frames                      3600
_diffrn_scan_axis.axis_id                omega
_diffrn_scan_axis.angle_start            0.0
_diffrn_scan_axis.displacement_start     0
_diffrn_scan_axis.angle_increment        0.1

loop_
    _diffrn_scan_frame.frame_id
    _diffrn_scan_frame.scan_id
    _diffrn_scan_frame.frame_number
           1  SCAN1    1
           2  SCAN1    2
           3  SCAN1    3
# more frame - scan links here

# could also include model refinement results
# here (atom_site etc.)

data_wav1_temp2
_diffrn.id            expt2
_diffrn.crystal_id    crystal1
_diffrn.ambient_temperature 89
_diffrn_radiation_wavelength.value  1.54

# imgCIF items
# 
# See first data block for full example. If
# scans, detector set up identically, only difference will
# be links to binary data:

loop_
      _diffrn_data_frame.id
      _diffrn_data_frame.binary_id
      _diffrn_data_frame.array_id
           1  ext3601    1
           2  ext3602    1
           3  ext3603    1
# more frame - binary data links here


data_wav2_temp1
_diffrn.id            expt3
_diffrn.crystal_id    crystal2
_diffrn.ambient_temperature 296
_diffrn_radiation_wavelength.value  0.71

# See first block for full example

data_wav2_temp2
_diffrn.id            expt4
_diffrn.crystal_id    crystal2
_diffrn.ambient_temperature 89
_diffrn_radiation_wavelength.value  0.71

# See first block for full example

data_cryst1
_exptl_crystal.id              crystal1
_exptl_crystal.density_meas    1.2(1)
_exptl_crystal.preparation     'mounted on loop with oil'
_exptl_crystal.size_length     0.011(1)

data_cryst2
_exptl_crystal.id crystal2
_exptl_crystal.density_meas    1.1(1)
_exptl_crystal.preparation     'mounted on loop with oil'
_exptl_crystal.size_length     0.009(1)

# If EXPTL_ABSORPT items present, should be provided in
# separate data blocks, in this case 2 crystals x 4 diffraction
# conditions = 8 blocks.

data_overall

# imgCIF items not depending on wavelength/temperature/crystal
 loop_
      _axis.id
      _axis.type
      _axis.equipment
      _axis.depends_on
      _axis.vector[1]
      _axis.vector[2]
      _axis.vector[3]
      _axis.offset[1]
      _axis.offset[2]
      _axis.offset[3]
         phi        rotation  goniometer  chi   -1 0 0  0  0  0
         chi        rotation  goniometer  sam_x  0 0 1  0  0  0
         omega      rotation  goniometer  .     -1 0 0  0  0  0
         two_theta  rotation     detector    .         -1   0  0   0  0  0
         trans      translation  detector    two_theta  0   0  1   0  0  287.22
         detx       translation  detector    trans      1   0  0  -2224.98  0  0
         dety       translation  detector    trans      0  -1  0   0  2299.96  0

 loop_
      _array_structure_list_axis.axis_id
      _array_structure_list_axis.axis_set_id
      _array_structure_list_axis.start
      _array_structure_list_axis.displacement_increment
         detx                    1                    0                  0.075
         dety                    2                    0                  0.075

    loop_
      _array_structure_list.axis_set_id
      _array_structure_list.direction
      _array_structure_list.index
      _array_structure_list.precedence
      _array_structure_list.dimension
         1             increasing             1             1       4148
         2             increasing             2             2       4362

 loop_
      _array_data.id
      _array_data.external_format
      _array_data.external_location_uri
        ext1    CBF https://zenodo.org/record/123456/files/s01f0001.cbf
        ext2    CBF https://zenodo.org/record/123456/files/s01f0002.cbf
# and many more raw data frames for all of the measurements...

# Core CIF items
loop_
_audit_author.name
_audit_author.email

'Alex Zoot' 'alex@zoot.com'
'Chris Tooz' 'chris@uni.zz'
```

## Technical Appendix

These recommendations are based on the draft guidelines for multi-block datasets. All
core CIF `Set` categories are distributed over multiple data blocks. For the purposes of
the above, `Set` categories are:

`DIFFRN`
`EXPTL_CRYSTAL`
`DIFFRN_DETECTOR`
`DIFFRN_MEASUREMENT`

In certain cases currently missing key data names are assumed, for
example, `EXPTL_ABSORPT` must have key data names pointing to
`diffrn_radiation` and `exptl_crystal`.

An automatically-generated DDLm version of the DDL2 imgCIF dictionary is
available at xxxx.
