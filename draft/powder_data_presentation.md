# CIF presentation of powder data results

Authors: various
Date: August 2022
Version: 0.2
Status: Draft

## Introduction

Powder data results often cover multiple phases (compounds) collected
at multiple temperatures and/or pressures, and/or using multiple instruments.  
This situation is markedly different to the original CIF approach of a
single sample collected at a single wavelength on a single instrument
under a single set of environmental conditions. The present document
describes how CIF should be used to express these more complex powder
results.

## Definitions

**Category**: a collection of data names that appear together in a 
CIF loop (a table)

**Set category**: A category for which only one row of the loop can appear
in a single data block, that is, each of the data names in the category
can only take a single value. The concept of a Set category was introduced in
the DDLm dictionary language and is roughly equivalent to a collection
of data names with attribute `list no` in DDL1. Items in Set categories
are often presented as key-value pairs.

## CIF for complex data

COMCIFS has accepted that multiple data blocks are necessary in order
to describe complex data, and have approved [a general approach for 
such cases](https://github.com/COMCIFS/comcifs.github.io/blob/master/accepted/multi-block-principles.md). In essence,
any data names belonging to `Set` categories should only appear once
within any given data block, and multiple data blocks are needed
to provide multiple values for those `Set` data names. By applying the
principles in the above document, a prescription for powder data
can be obtained based on the `Set` categories for core CIF and 
stipulating that `PD_PHASE` and `PD_HISTOGRAM` are `Set` categories.

## Rules for powder data

1. A single data block may contain information pertaining to one 
and only one (i) phase, (ii) histogram, (iii) set of experimental 
conditions (iv) experimental setup (v) sample

1. A single data block may combine information from different
items in the above list, as long as only one item of each type
is present.

1. Any data blocks violating point (1) should set data name
`_audit.schema` to a defined non-default value `Powder_Summary`

## Examples

TODO: Provide a few examples.
