# Dictionary-driven aggregation of Data Blocks into Datasets

Version: 1.0

Authors: J Hester, J Bollinger, A Vaitkus 

Date: March 2022

Status: Accepted, Technical editing

## Introduction

Data described by CIF dictionaries can be spread between multiple data
containers. In more complex
scenarios, a number of choices exist as to how such data should be
distributed between data containers. Choice is generally undesirable
in standards, as it complicates the task of aligning reading and
writing software. Therefore, these principles have been developed to
describe how CIF writing software should distribute and describe data
dispersed over multiple data containers. 

For the purposes of this document the data container is assumed to be
a CIF data block. Note, however, that these principles apply to any data
presentation where data are encapsulated.

## Definitions

- **Data blocks**: A _data block_ is a collection of _data values_ , each of which is associated with a _data name_ defined in a CIF dictionary such that these _data items_ may be arranged into tables ("loops") as described by the CIF dictionary.
- **Data sets**: A _data set_ is a collection of _data blocks_
- **Conformance**: An aggregate _conforms_ to a relational schema (like those described by CIF dictionaries) if the data contained can, in principle, be assigned unambiguously and consistently to cells in that relational schema
- **Appearance**: A category _appears_ in a data block if any data name belonging to it is either present, or is referred to via `_name.linked_item_id` of a data name that is present
- **Dictionary compatibility**: Two dictionaries describing data blocks are _compatible_ if, for all categories that appear in those data blocks, the dictionaries prescribe the same set of key data names
- **Data block compatibility**: Data blocks are _compatible_ if either (1) their dictionaries are compatible or (2) a unique value can be determined or assigned for any key data names that are absent from one of the incompatible dictionaries
- **Set categories**: A _Set_ category is a table for which only one row may be presented in a data block

## Rules
1. Multiple _data blocks_ are aggregated into a _data set_ by being presented in the same data container (e.g. file, zip archive,directory).
2. Dictionary conformance of individual data blocks is specified either by `audit_conform` data names in each block, or as-yet-undefined dataset-level `audit_dataset` datanames in any block. Dataset-level dictionaries override block-level dictionaries.
3. If a data name appearing in a data block is not defined in the dictionary to which that data block conforms, it is considered absent for the purposes of these principles
4. The set of "Set" categories for a data block is determined by the dictionary to which that data block conforms
5. A "Set" category may only be aggregated from multiple data blocks if at least one key data name for the "Set" category has been provided in the dictionary to which those data blocks conform.
6. Where a "Set" category has been provided with a key data name in the dictionary as per (5), and that key data name is not itself a child data name of some other data name, all child data names must also be provided in the dictionary.
7. The value of "Set" category key data names for a given data block may be assigned arbitrarily if missing
8. Values for child data names of "Set" category key data names may always be elided.

## Discussion
The guiding principle in designing these rules is "can we uniquely assign the values in a given data block into cells of the relational structure describing the whole dataset?". Reasons for failure might include:
1. Not being able to determine a single relational schema for the
dataset (contradictory dictionaries)
2. Not knowing the values of all the key data names in a row
3. Contradictory attribute values for the same key data name values

The above conditions exclude these failure modes while also allowing maximum leeway in unambiguous situations 
(e.g. a category has only one value for a single key data name for the whole dataset, so the value is clear even 
for data blocks that don't explicitly allow for it in their dictionary).
