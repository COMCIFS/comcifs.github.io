# Dictionary Working Group Guide

Status: Draft
Version: 0.1
Date: Sept 2021

## Introduction

A new CIF dictionary is created by a dictionary working group.
These guidelines for running such a working group will be updated
with feedback on what works and doesn't work.

## Forming a working group

The working group should contain representatives of all those with a
likely stake in the dictionary. Typically this includes:

1. subject-matter experts
2. software authors
3. journal editors
4. repository representatives if repositories exist

Inclusion of representatives of these groups will help the success of
the standard. The relevant IUCr commission, where one exists, may be
a good source of members.

When a group is formed, please notify the COMCIFS secretary
(comcifs.secretary@iucr.org). This will ensure that you can be linked
up with any work that is already ongoing and gives COMCIFS a chance to
provide you with information, as well as follow up on your
progress. COMCIFS are also able to provide you with a repository on
Github as a collaboration space.

## Running a working group

* Aim to meet regularly, typically either once or twice a month for
  1-2 hours.
* Make sure somebody is tasked with chairing the meetings and checking
  on progress.
* Set a target finish date. Six months of twice-monthly meetings
  should be sufficient for a typical dictionary.
* Expect the bulk of the work to be done between meetings.

## Finished product

The working group should provide COMCIFS with:

* A CIF dictionary conforming to the DDLm standards
* A guide to the dictionary in the style of Volume G of International
  Tables, including examples.
* A plan for dictionary adoption and maintenance

## Milestones

Suggested milestones in the development of a dictionary are provided
below. The time estimates assume that concepts in the domain are
already well-understood, so that no conceptual development work is
necessary. In practice new data names will continue to be added
throughout stages 1-4.

1. Collection of concepts (1-2 meetings)

   Specification of what you want to have in the dictionary. Suitable
   stimulus questions include:
    - What information would you expect to see reported in a journal
      article?
    - What information would software need in order to process the
      data?
    - What items are repositories already ingesting and/or providing?
    - What contextual information would a long-term archive require?
  
2. Clarification of concepts (1-2 meetings)
    
    For each of the concepts identified above, assign a temporary data
    name and a written definition, including units, types and
    enumerated lists as necessary.
    
3. Organisation into tables (CIF loops) (1 meeting)

    Some new data names may simply be additional columns in loops
    defined in already-existing CIF dictionaries, such as an extra
    atomic property. Others may require completely new loops, which
    require naming the "category" the looped data names belong
    to. Data names should now be written in their final form
    `<category>.<object>`. At this point including a CIF expert in the
    working group is a good idea.
    
4. Creation of CIF dictionary

    A fully-compliant CIF dictionary is drafted and any technical
    issues ironed out. At this point the group may choose to move
    development to Github, communicating via "issues" instead of
    having frequent meetings. The group may publicise this draft and
    invite participants to contribute via Github.
    
5. Creation of accompanying material

    The dictionary is documented in the style of International
    Tables. A long-term plan for dictionary maintenance is created.
    
6. Submission and approval by COMCIFS
   
    The dictionary and accompanying documents are reviewed and
    approved by COMCIFS. COMCIFS may choose to send this material to
    specialist reviewers.

## Suggestions

1. Develop the dictionary initially using a plain-text file and convenient
   short-hand notation. 
   
   For example, each definition can be separated by two blank
   lines. Instead of `_definition.id`, a line starting "#D" could be
   used, and so on for other attributes. The reasoning for this advice
   is that a lot of tedious typing is avoided, the plain text file can
   be semi-automatically transformed to CIF syntax, and is easily
   monitored and manipulated using Github (or other version-control)
   tools.
   
   After this file has been translated to CIF, the shorthand notation
   should no longer be used.
   
2. COMCIFS have developed Github-based workflow checkers that can
   automatically check CIF dictionaries and data files for conformance
   with syntax and semantic standards. These can be activated on your
   COMCIFS Github repository to give instant feedback on any technical
   problems.

3. In the later stages of work, familiarise yourself with some simple
   Github processes. In particular, you may wish to take advantage of
   "pull requests" for proposed changes. These allow proposed changes
   to be reviewed and improved before updating the master file.
   
   Another useful concept is the "branch". This is a branch of
   development that is separate from the main branch and can be used
   to explore particular topics. It can be merged back into the main
   branch (or any other branch) at any time.
   
   COMCIFS are preparing some useful documentation for dictionary
   development using Github.
