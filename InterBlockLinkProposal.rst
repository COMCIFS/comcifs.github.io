Proposal to Improve Inter Block Linking
***************************************

Introduction
============

A number of current CIF dictionaries rely on pointers to other
data blocks. In particular:

* A powder sample can consist of multiple components (perhaps
  confusingly called "phases").  Each of these materials is described
  in a separate data block and then referenced from the block in which
  the overall fit to the data is described.  Powder diffraction patterns may
  also be referenced in the same way.

* The modulated structures dictionary (msCIF) allows for composite
  structures, with the space group and cell of each member of the
  composite described in separate data blocks

* The new magnetic structures dictionary envisions that alternative
  descriptions of the same magnetic structure could be described in
  separate data blocks.

In addition, cif core defines the ``_audit_link.*`` data names, which allow listing of
datablock identifiers together with some plain text description of the nature of
the relationship between the blocks.

Each scheme is different, expects different contents for the linked
data blocks, and varies in the degree to which computers can use the
linking information.

In addition, work on 'CheckCIF for raw data' requires some way of
working with the many different ways of arranging image frames into
files and directories.

This proposal therefore suggests formalising data block linkages in a
way that allows arbitrary expansion as well as making the precise
nature of the relationships between data blocks machine-readable in
all situations.

General idea
============

First a definition:

**projection**
   choosing a single value for a key data name, and then
   selecting only those rows of categories that correspond to that
   particular value, ignoring any categories for which that data name
   is irrelevant.

Any data collection can be split by projecting over the individual
values of a data name that forms part of a key, and putting the result
for each projection into a separate block.  These projected blocks do
not have to include the projected dataname within loops, as the
dataname is constant within a data block.

If multiple blocks belonging to the same data collection are able to
be described as projections of one or more data names we have
completely defined their relationship.

Proposal for a Universal System for Linking Data Blocks
=======================================================

In order to completely define data block interrelationships, data
blocks resulting from projection over a key value must be:

(1) linked and
(2) the key data name used for the projection indicated and correct values assigned.

Linkage
-------

This is accomplished by including a dataname which has the same,
unique value in all linked blocks.  I propose calling this dataname
``_audit_dataset.id``

Key values
----------

Each data block must explicitly state the value of the parent key
against which it has been projected, by providing the parent key's
data name and value.


Effect on existing dictionaries
===============================

The following examines changes or enhancements required to implement
this approach in those dictionaries that already use inter-block
references. In no case do existing data names require redefinition or
removal; the new system can exist alongside the old system.

Comparison for msCIF
--------------------

The current msCIF arrangement splits the information for composite
structures over a number of data blocks. The 'master' block contains a
loop indexed by ``_cell_subsystem.code``, the value of which is used to
find structural data in a separate data block that has an
``_audit_link.block_code`` identifier composed as
``<arbitrary>REFRNCE_<code>``. 
``<arbitrary>`` is a string common to all linked blocks and ``<code>`` is the
value of ``_cell_subsystem.code`` appearing in a row of the
``_cell_subsystem`` loop. If the word MOD is used instead of REFRNCE, the
data block contains a description of the modulated structure of this
component. If no trailing ``<code>`` is present, the data block contains
either common structural features (REFRNCE) or the whole modulated
structure (MOD). If neither REFRNCE or MOD are present, the data block
contains common data items. In this approach, the links between data blocks
are created through the ``_audit_link.block_code`` value matching, and
the nature of the link is signalled by the reserved words MOD and
REFRNCE.

In the proposed approach (see example at end):

1. ``<arbitrary>`` becomes the value of ``_audit_dataset.id``
2. ``_cell_subsystem.code`` should be given in each data block for which
   it is relevant
3. the loop over ``_cell_subsystem.code`` in the "master" block should
   either be removed, or else a new child data name defined for use
   in projection (choice of dictionary authors).
4. The msCIF dictionary should include child data names of ``_cell_subsystem.code``
   in the ``space_group``, ``cell`` and all ``_atom_site_*`` categories

Comparison for pdCIF
--------------------

pdCIF defines a ``_pd.block_id`` and then links to blocks via this ID
in three distinct ways: (Vol G p 124):

(1) To refer to a block containing a diffraction measurement
(2) To refer to a block containing a structure description
(3) To refer to a block containing calibration information

In the proposed approach:

1. ``_audit_dataset.id`` can be used instead, or alongside, ``_pd.block_id``. Whereas
   ``_pd.block_id`` is different for every block, ``_audit_dataset.id`` is identical for
   blocks belonging to a single dataset.
2. A new (key) data name, e.g. ``_pd_diffractogram.id`` is created and stated in any
   data blocks containing diffractograms.
3. The value of ``_pd.phase_id`` is stated in any data blocks containing structures
4. New child key data names are added to any categories that could appear in the
   separate ``_pd.phase_id`` or ``_pd_diffractogram.id`` blocks
5. Calibration: an external calibration dataset is a combination of a
   diffractogram and a phase. A ``_pd_calib_std_external.phase_id`` and
   ``_pd_calib_std_external.diffractogram_id`` should be additionally
   defined. (1),(2) and (3) are carried out as relevant for the
   calibration dataset and phase. If calibrations involve more than
   powder diffraction measurements, further data names describing
   these measurements should be defined.

magCIF
------

The magnetic structures dictionary wishes to link to alternative descriptions of
the same magnetic structure in separate data blocks. In this case:

1. ``_audit.dataset_id`` is set to be identical in all relevant data
   blocks
2. a dataname along the lines of ``_magn_structure_transform.id`` is set in each of
   these data blocks
3. Child data names of ``_magn_structure_transform.id`` are added to all categories
   that might be used in describing an alternative structure.

Advantages
==========

1. To a large extent, data can be added to datasets by simply creating
   a new data block with the same ``_audit_dataset.id``.  For example,
   an extra measurement on a new sample of the same compound will
   automatically be (semantically) incorporated into a dataset simply
   by becoming present, whether in a separate file or an appended block
2. dREL methods can be written in complete ignorance of the way in
   which data have been distributed over data blocks. In effect, a dREL
   method operates in the context of all data available for a given value of
   ``_audit_dataset.id``.
3. The effects of unexpected looping over 'Set' datanames that ``_audit.schema``
   addresses can be reduced by using separate data blocks. So the choice
   exists to split multiple crystals, multiple space-groups etc. over
   multiple data blocks, without changing the underlying semantics.
4. Formats which collate many files to form the dataset are easy to
   describe in this paradigm: for example, image frames in separate
   files are simply assigned to the same dataset, with each file
   including the value of the image identifier data name used to
   'project' the data file from the notional loop of images.
5. The system is open-ended in terms of allowing disparate items of information
   to be collated together with well-defined relationships.  This means it
   can essentially cover all ways of aggregating data into datasets.
6. The old block linkage systems can remain in place and can be used to provide
   double-checking where possible.

Disadvantages
=============


1. Flexibility in how data from complex datasets is distributed over
   data blocks may cause unnecessary work for data reading software
   programmers attempting to cover all situations.  This could be
   remedied by individual dictionaries recommending particular
   approaches.

Interaction with ``_audit.schema``
==================================

We have recently defined a data name, ``_audit.schema``, that signals
when 'Set' categories have become looped in a data block. The present
proposal allows 'Set' categories to be always single-valued in a
single data block, yet take multiple values for the dataset as a
whole.  We must therefore choose between alternative meanings of
``_audit.schema``: does it mean that 'Set' categories are looped
semantically or both semantically and syntactically (obviously if Set
categories are looped in a single data block (syntactically) then they
are also semantically looped)?  I propose that, even if all data
blocks conform to the default schema, at least some values in related
data blocks are likely to be materially significant for interpretation
of one another (for example, multiple crystal measurements feed into
final values of I_meas) and so ``_audit.schema`` should indicate
semantic looping, i.e.

* ``_audit.schema`` **must** take a non-default value where Set categories
  can take multiple values **and** a data block contains loops over
  these Set categories.

* ``_audit.schema`` **must** take the appropriate non-default value if
  information for a dataset has been spread over several data blocks.

* ``_audit.schema`` **must** only take the default value if the dataset
  consists of a single block conforming to the core CIF dictionary.

On datasets
===========

Note that a single data block can belong to multiple data sets, for example
calibration information may be relevant to multiple data collections, or a single
measurement may be relevant to different modelling exercises (e.g. joint or
single refinement of X-ray and neutron data) and therefore have different
dataset identifiers in each case.

Discussion
==========

This approach is close in spirit to the work of Nick Spadaccini and
Syd Hall in creating DDLm Ref-loops, which were projections of specified
Set categories into save frames. The current proposal removes the
syntactical element, exposes the behaviour of the keys, and adopts a
global relational view of the underlying semantics.

Example
=======

The following example shows part of a CIF for a modulated structure
composed of two components, LaS and NbS2. (based on `Example 3, p 271,
It Vol
G<http://it.iucr.org/Ga/ch4o3v0001/Catom_site_displace_Fourier.html>`_)
::

    # Common data
    data_LaSNbS2
    # The common dataset identifier
    _audit_dataset.id  1997-07-24|LaSNbS2|G.M.
    # Signal which categories are split across datablocks
    _audit.schema      'Modulated'
    # Signal the type of calculations used
    _audit.formalism   'Modulated Single Crystal'
    # The actual dictionary that this conforms to
    _audit_conform.dict_name 'msCIF.dic'
    # Old linkage data may be kept. Not all following blocks included in
    # this example for brevity
    loop_
             _audit_link_block_code
             _audit_link_block_description
    1997-07-24|LaSNbS2|G.M.|
                      'common experimental and publication data'
    1997-07-24|LaSNbS2|G.M.|_REFRNCE
                             'reference structure (common data)'
    1997-07-21|LaSNbS2|G.M.|_MOD
                             'modulated structure (common data)'
    1997-07-24|LaSNbS2|G.M.|_MOD_NbS2
                           'modulated structure (1st subsystem)'
    1997-07-24|LaSNbS2|G.M.|_REFRNCE_LaS
                           'reference structure (2nd subsystem)'
    1997-07-21|LaSNbS2|G.M.|_MOD_LaS
                           'modulated structure (2nd subsystem)'

    _cell_subsystems_number                  2
    # The following loop is now split across data blocks
    # or retained with a child data name used for projection
    #loop_
    #     _cell_subsystem_code
    #     _cell_subsystem_description
    #     _cell_subsystem_matrix_W_1_1
    #     _cell_subsystem_matrix_W_1_4
    #     _cell_subsystem_matrix_W_2_2
    #     _cell_subsystem_matrix_W_3_3
    #     _cell_subsystem_matrix_W_4_1
    #     _cell_subsystem_matrix_W_4_4
    #             NbS2            '1st subsystem'  1 0 1 1 0 1
    #             LaS             '2nd subsystem'  0 1 1 1 1 0

    # Common experimental and publication data elided ...
    
    # Items concerning the modulated structure of the first
    # subsystem

    data_LaSNbS2_MOD_NbS2
         # Old block identifier
         _audit_block_code         1997-07-24|LaSNbS2|G.M.|_MOD_NbS2
         # Common dataset identifier
         _audit_dataset.id         1997-07-24|LaSNbS2|G.M.
         # Signal which categories are split across datablocks
         _audit.schema      'Modulated'
         # Signal the type of calculations used
         _audit.formalism   'Modulated Single Crystal'
         # The actual dictionary that this conforms to
         _audit_conform.dict_name 'msCIF.dic'
         # Projected key data name
         _cell_subsystem_code      NbS2
         # Projected information for value = NbS2 of key data name
         _cell_subsystem_description  '1st subsystem'
         _cell_subsystem_matrix_W_1_1   1
         _cell_subsystem_matrix_W_1_4   0
         _cell_subsystem_matrix_W_2_2   1
         _cell_subsystem_matrix_W_3_3   1
         _cell_subsystem_matrix_W_4_1   0
         _cell_subsystem_matrix_W_4_4   1

         loop_
             _atom_site_Fourier_wave_vector_seq_id
             _atom_site_Fourier_wave_vector_x
             _atom_site_Fourier_wave_vector_description
                  1      0.568     'First harmonic'
                  2      1.136     'Second harmonic'

         loop_
             _atom_site_displace_Fourier_id
             _atom_site_displace_Fourier_atom_site_label
             _atom_site_displace_Fourier_axis
             _atom_site_displace_Fourier_wave_vector_seq_id
                  Nb1z1   Nb1     z       1
                  Nb1x2   Nb1     x       2
                  Nb1y2   Nb1     y       2
                  S1x1    S1      x       1
                  S1y1    S1      y       1
                  S1z1    S1      z       1
                  S1x2    S1      x       2
                  S1y2    S1      y       2
                  S1z2    S1      z       2

    #### End of modulated structure first subsystem data ######

    # Items concerning the modulated structure of the second
    # subsystem

    data_LaSNbS2_MOD_LaS
         # Old block identifier
         _audit_block_code         1997-07-24|LaSNbS2|G.M.|_MOD_LaS
         # Common dataset identifier
         _audit_dataset.id         1997-07-24|LaSNbS2|G.M.
         # Signal which categories are split across datablocks
         _audit.schema      'Modulated'
         # Signal the type of calculations used
         _audit.formalism   'Modulated Single Crystal'
         # The actual dictionary that this conforms to
         _audit_conform.dict_name 'msCIF.dic'
         # Projected key data name
         _cell_subsystem_code      LaS
         # Projected information for value = LaS of key data name
         _cell_subsystem_code      LaS
         _cell_subsystem_description  '2nd subsystem'
         _cell_subsystem_matrix_W_1_1   0
         _cell_subsystem_matrix_W_1_4   1
         _cell_subsystem_matrix_W_2_2   1
         _cell_subsystem_matrix_W_3_3   1
         _cell_subsystem_matrix_W_4_1   1
         _cell_subsystem_matrix_W_4_4   0

         loop_
             _atom_site_Fourier_wave_vector_seq_id
             _atom_site_Fourier_wave_vector_x
             _atom_site_Fourier_wave_vector_z
             _atom_site_Fourier_wave_vector_description
                  1      1.761   0.5   'First harmonic'
                  2      3.522   1.0   'Second harmonic'

         loop_
             _atom_site_displace_Fourier_id
             _atom_site_displace_Fourier_atom_site_label
             _atom_site_displace_Fourier_axis
             _atom_site_displace_Fourier_wave_vector_seq_id
                  La1x1   La1     x       1
                  La1y1   La1     y       1
                  La1z1   La1     z       1
                  La1x2   La1     x       2
                  La1y2   La1     y       2
                  La1z2   La1     z       2
                  S2x1    S2      x       1
                  S2y1    S2      y       1
                  S2z1    S2      z       1
                  S2x2    S2      x       2
                  S2y2    S2      y       2
                  S2z2    S2      z       2

    ### End of modulated structure second subsystem data ######
