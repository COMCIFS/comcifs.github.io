# Using `_audit_dataset.id` in a multi-block scheme

Version: 0.1

Authors: J Hester

Date: June 2023

Status: Draft for discussion

## Introduction

There are two interrelated problems that arise for a recipient of
multiple data blocks that are presumed to form a coherent data set:

1. How can we be sure that all these blocks belong together?
2. How can we be sure that identifiers have not accidentally collided?

If we can be certain that all blocks belong together, then we do not
need to worry about identifier collisions. On the other hand, if all
identifiers are universally unique, incorrect blocks have no serious
consequences, so if either of these problems is solved conclusively,
the other vanishes.

The above argument assumes good faith (and tools) on the part of the
CIF producer.

### Blocks belonging together

The current CIF consensus is that the problem of exhaustively linking
data blocks is too hard, and therefore, any mechanism for doing this
lies outside the CIF system. The main reason for the difficulty is
that some blocks could be created before the complete set of blocks in
the collection is known, for example, because data are still being
collected.  Another reason relates to standard blocks, e.g. those
containing calibration data, that belong to many data sets at once.

### Identifiers

It is convenient to use short identifiers for things like
samples. However, if blocks not forming part of a dataset are
mistakenly added, they may use the same short identifiers (think `1`,
`2`) to refer to different objects of the same type and thereby
introduce incorrect information. This error will only be detected if
the correct information is also present in the block collection,
leading to a contradiction.

## Solutions

### Block identifiers and pointers

A solution present in current CIF dictionaries is to assign a unique
block identifier to a data block. In pdCIF, data blocks with assigned
roles (e.g. the diffraction data) are pointed to by assigning the
block identifier as the value of a predefined data name. Cif core
provides a more versatile option where all related blocks can simply
be listed by id.

#### For

* An explicit list of blocks forming the dataset is available.

#### Against

* Adding data blocks requires the relevant part of the block(s)
containing the block list data names to be found and edited. 
* Only blocks containing a block identifier can be listed, which could be a
problem for non-CIF files and files that are not editable. 
* If the block list is contained in one block, then there is no
information within the other blocks indicating what collection they
belong to.
* If the block list is present in all blocks, they must all
be edited whenever a new block is added.

### UUIDs

All identifiers are UUIDs.

#### For

* Identifiers cannot conflict
* Incorrectly included blocks simply provide information that is irrelevant, as that information is not
linked to anything in the other blocks. 
* Missing blocks are detected due to the lack of some expected
  information for a given UUID.

#### Against

* UUIDs are annoyingly long, and it becomes difficult for a
human reader to rapidly understand otherwise simple
tabulations. Instead of samples `1` and `2`, there could be samples
`f6f49b02-5d58-4a9e-9a37-8dd94c34852e` and
`4aaad5ee-e415-42d2-91db-cbbe1be3a8a8`.
* software would have to be massively reconfigured to generate these IDs
in all cases.

### `_audit_dataset.id`

All datasets are assigned an `_audit_dataset.id`, which is stated in any
data blocks belonging to it.

#### For

* The group of blocks belonging to a dataset is easy to determine, as
they all have the same identifier. 
* Simple identifiers can be used within
each dataset, as the dataset identifier disambiguates them from any other
dataset. 
* Updating software to support this is relatively easy.

#### Against

* Some data blocks could belong to multiple datasets, for
example calibration and standard information. These would have to have
a dataset number edited into them, presumably when the final bundle
was being prepared. This is unwieldy, and given that CIF envisions
covering all data formats, sometimes impractical, for example if one
of the data blocks is a very large image file.

### Hybrid

Either UUIDs are used for identifiers within a given block, or an
`_audit_dataset.id` is provided.

#### For

* The combined pros of the above individual solutions
* Flexibility for CIF producers. 
* Non-dataset-id blocks can be converted to use simpler identifiers (where editing is feasible)
simply by adding the dataset identifier.

#### Against

* Datablocks without `_audit_dataset.id` values may not use simple ID
values from other data blocks as part of any keys, as that
reintroduces the possibility of collisions.
* Some non-dataset-id data blocks may not allow editing in order to insert UUIDs for
identifiers.
* Upgrading software may be challenging.

## Hybrid approach in practice

### CIF consumers

A recipient of a CIF block bundle who is concerned about integrity can
perform the following checks:

1. Do all blocks containing an `_audit_dataset.id` have the same value?
2. Do all blocks not containing an `_audit_dataset.id` use UUIDs for
   identifiers?
3. Are any UUIDs in the non-dataset-id blocks referred to by the other
   blocks?
   
### CIF producers

Where a data block is likely to be used by more than one user, it can
be prepared once with UUIDs. Adding `_audit_dataset.id` to the output
CIF is a relatively simple software upgrade operation, and would be
possible as a post-processing step in the case that existing software
is not upgradeable.

Logically, blocks that will become part of more than one dataset
("general" blocks) are independent of those datasets,
and therefore will not refer to identifiers within those datasets. Similarly,
if general blocks are relevant to the remainder of the dataset, the
remainder must refer to identifiers within the general blocks. Where
the information in the general blocks is available only after the
remainder have been produced (e.g. calibration after the main
dataset has been created) those identifiers will need to be edited
into the main data blocks. This would, however, have to be done
in any case.

## Discussion

The hybrid approach requires only the definition of a single new data
name. The remainder of the proposal is a requirement that CIF
consumers can choose to impose on CIF producers, perhaps with the
collaboration of COMCIFS in providing recommendations and/or CheckCIF.

CIF consumers can decide for themselves at what point to demand more
rigorous identifiers: if a single data file contains two data blocks,
none with a dataset identifier, is that the threshold? Or would it
be a whole directory of files of differing formats?

The above provides for an obvious transition pathway. CIF producers
can be encouraged to add dataset identifiers and use UUIDs for
"general" type data blocks by tools like CheckCIF whenever more than
one data block is provided as part of a submission. Rejection of data
block bundles that do not meet the above criteria would only start
occuring once there was wide usage of both UUIDs and dataset
identifiers, and such rejection is under the control of the CIF
consumer. As most current CIF applications limit themselves to a few
data blocks, the software that would be able to sensibly process
complex multi-data-block collections, and be concerned about
consistency, still lies in the future.

