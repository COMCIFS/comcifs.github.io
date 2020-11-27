Revised discussion paper for regulating markup of CIF text items
================================================================

Summary
=======

1. Data values containing backslash escapes for indicating non-ASCII
   characters are to be considered entirely equivalent to values
   obtained after all such substitutions and escapes have been applied.
   
2. Other mark-up (superscripts, subscripts, italic etc.) is given a
   new type, but is otherwise unspecified and needs to be discussed.

Introduction
============

From the very first publication describing CIF, markup conventions
have been provided in order to extend the range of characters and font
effects representable in ASCII.  Which data values these conventions
might apply to, and whether or not this is more properly a CIF syntax
or dictionary (semantic) issue, has been left implicit.

Marked-up text according to the ad-hoc definitions described in Vol G
appears both in CIF data files and in dictionary definitions. While
COMCIFS has control over the conventions applying within dictionaries,
it has far less control over data values in data files, which are
produced both by dedicated software, such as publCIF, and hand-editing
or local ad-hoc solutions.  Marked-up text in data files plays an
important role in the publication workflow.

Vol G (First Edition) notes in section 2.2.5.3: "It is hoped that in
future different types of such markup may be permitted so long as the
data values affected can be tagged with an indication of their content
type that allows the appropriate content handlers to be invoked". It is
not, however, clear that multiple alternative markups are desirable.

Moving forward
==============

The markup in use can be divided into two classes: 'character encoding'
and 'font effects'.  Under this proposal, each class is treated differently.

1. Character encoding

   Character encoding markup represents non-ASCII letters using a
   backslash followed by one or more ASCII characters, for example,
   '\a' is 'greek letter alpha'.  This is a format-specific method of
   allowing access to the full characterset used by the DDL textual
   types. From the point of view of the (format-agnostic) dictionary
   data model, how a particular format wishes to encode characters is
   irrelevant. Therefore, the set of character escapes is most
   appropriately documented as part of the description of CIF syntax,
   not within a DDL dictionary.  In other words, CIF1/2 data values with
   backslash character escapes are semantically identical to CIF2 data
   values where those escapes have had their Unicode equivalents
   substituted.
   
2. Font effects

   Font effects differ from character encodings in not having a DDLm
   type that they are a concrete realisation of. By analogy, then, we
   could create a DDLm type 'Marked-up text', whose contents contain
   marked-up text.  Particular implementations and syntaxes might then
   specify what particular convention(s) 'Marked up text' should
   conform to.

Notes
=====

1. An important function of the 'Marked-up text' type is to
   designate data values that are not intended to be machine-actionable.
   No DDLm functions or attributes are envisioned for manipulating the
   markup. The type could alternatively be something like 'Rich text'.
   
2. Enumerated values and identifiers must not be of type marked-up text.

3. The 'marked-up text' data value is obtained from a CIF syntax
   file after backslash character codes have been substituted.

Open questions
==============

The above proposal does not specify a particular markup convention. Leaving
anything unspecified is dangerous for a standard, as it invites the appearance
of multiple, incompatible solutions.  We should as a matter of urgency answer
the following questions:

(1) Should alternative markup conventions be possible?
(2) If yes, should the markup convention in use be
    (i) per dataname?
    (ii) per datavalue (maybe via an embedded flag)?
    (iii) per data block?
    (iv) per dictionary?
    (v) per syntax? (e.g. CIF/CIF-JSON/HDF5 etc.)
(3) If no, the current convention is the only possible one for reasons of
    backward compatibility. Should it be:
    (i) a feature of CIF syntax?
    (ii) a feature of CIF syntax when combined with a DDLm dictionary?
    (iii) defined in DDLm?

My answers to these questions would be
(1) No alternatives should be possible, in order to simplify publishing
    workflows and maintain the publCIF investment
(3) (ii)

Some explanation regarding (ii), which possibly sounds a bit
abstruse. A CIF syntax file can be used (in theory) with an
alternative dictionary language and associated data model. Likewise,
DDLm dictionaries can be used to describe non-CIF files.  In each
case, the way in which syntactical data values are constructed to
match the dictionary types may differ (for example, numbers may be a
text string or binary).  Each combination of syntax and dictionary
must explicitly state how each dictionary type is represented in that
syntax. So I am proposing that for the combination 'CIF + DDLm' that
we specify the current markup conventions to represent type 'Marked-up
text'.
