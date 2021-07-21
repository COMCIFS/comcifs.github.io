# How To Create a DDLm Dictionary

## Introduction

This document explains how to create a dictionary within the
Crystallographic Information Framework (CIF).  There is nothing
especially crystallographic about the language used to construct CIF
dictionaries; the CIF dictionary description language (DDL) has the
same level of generality as relational databases and other metadata
formalisms.

## Step 1: Collect your concepts

Create a list of concepts that you want to have data associated with
in your data block.  Write a clear, human-readable definition for each
concept similar to those you might find in glossary for a textbook in
your field. For convenience, attach a dataname to each concept - you
may edit these later on.  Clearly identify the type of each concept
(text, integer, real, vector of reals, etc.).

## Step 2: Identify single-valued datanames

Identify any concepts that should remain constant or are fixed for the
data you wish to present in your datablock. If a data block is
intended to contain information about a single experiment, anything
that is always held constant during the experiment is a candidate.
For example, the instrument used and the location are usually fixed.
Some experiments operate at constant energy/wavelength or with a
single sample. Note that your data block is essentially defined by the
set of single-valued datanames, so you are at this step defining what
your data block "means".

## Step 3: Identify dependencies for multi-valued names

Each of your remaining (i.e. potentially multi-valued) datanames can
be associated with a list of all other datanames whose values are
required in order to completely understand each value of the
target dataname. For example, in order to understand and thus
reproduce an experimental measurement, a description of the
experimental setup (e.g. all the motor positions) and environmental
conditions is required.

At this point, you will probably uncover other datanames that are
necessary for complete description of your data. Repeat Step 2 for
each of these values. Note that it is not fatal to inadvertently leave
out a concept, as long as it implicitly takes a generally-understood
fixed value for this type of data.

## Step 4: Group into tables

CIF `loops` are simply collections of datanames that all depend on
the same set of multi-valued datanames.

