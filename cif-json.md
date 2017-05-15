# JSON representation of CIF information (DRAFT)

## Introduction

The Crystallographic Information Framework (CIF) is a set of specifications for describing
scientific information.  One or more *datavalues* are attached to *datanames* to form
*dataitems*. Dataitems are collected together into *datablocks*.  Datablocks are in turn
collected into *datafiles*.  Datanames, the possible values that can be attached to
them, and dataname membership in *categories* (tabulations), are described in CIF 
*dictionaries*. In the following standard, *CIF information* refers to any scientific
information that can be defined and encapsulated using the above model.  The CIF1 and CIF2
syntaxes describe closely related file formats for expressing CIF information in a
form suitable for long-term archiving and transfer.

JSON is a lightweight language for serialisation and transfer of data.
JSON is often used as a "pipeline" language to transfer information
between programs within a single system, and also as a way of
transferring information between internet applications.  JSON
libraries are widely available and therefore it is relatively simple
implement parsing and output of JSON.

A standard way of expressing CIF information in JSON would allow
programs from different authors running within a single context (such
as a web browser or operating system) to interoperate with minimal work. The following
CIF-JSON standard is intended to facilitate such interoperability.

## The JSON representation of CIF information

In the following, *name* refers to a JSON name and *value* to a JSON value. A
JSON *object* is a collection of `name:value` pairs. CIF-related datastructures
are described in the introduction.

CIF information is represented in JSON as follows:

1. A CIF datafile is represented as a single JSON object
1. The JSON file must conform to the i-JSON standard [RFC7493](https://tools.ietf.org/html/rfc7493)
1. A CIF datablock is represented by a JSON object within the top-level object. This object is referred 
to here as the *JSON datablock object*.  The name of this object must be in Unicode case-normal form (which
means lower-case for Western scripts), and 
conform to the characterset restrictions of the CIF2 syntax for datablock names.
1. A CIF dataname is a name in the JSON datablock object. The JSON name
is the CIF dataname, including the underscore.
1. The value attached to the JSON name is a JSON list (referred to as the "JSON list datavalue" below).
1. The JSON list datavalue contains the one or more CIF datavalues associated with the CIF dataname. 
1. Entries at the same position in JSON list datavalues correspond to one another if the datanames belong to the same
category.
1. CIF datavalues are represented within JSON list datavalues as follows:
   1. CIF string values are represented as JSON string values
   1. CIF number values are represented as JSON string values formatted according to the 
   `<Numeric>` production in International Tables
   for Crystallography, Volume G, Section 2.2.7.3 paragraph 57. 
    3. The special CIF value `.` (null) is represented as JSON `false`.
    4. The special CIF value `?` (unknown) is represented as JSON `null`.
    5. (CIF2 only).  CIF2 list datavalues are represented as JSON lists. The datavalues appearing
  in the list are represented in the same way as non-list datavalues.
    6. (CIF2 only).  CIF2 table datavalues are represented as JSON objects. The names in the object
  are the same as the names in the CIF table. The values in the CIF table are represented in the same
  way as other CIF datavalues

9. If the CIF data block includes save frames (currently only used in dictionaries), 
the JSON datablock object must contain the special name `frames`. The value of this name
is a JSON object. Each name in this object is the name of a save frame
found in the datablock. The value for each of these names is a JSON datablock object, represented
as for normal CIF data blocks.
10. An optional object named `Metadata` may be present in the top-level object. The object name
must begin with a capital 'M' to distinguish it from a normal datablock name. The `Metadata` object contains
information that is useful for conversion of CIF-JSON objects to other syntaxes
(for example, CIF syntax files) and information about the CIF-JSON version.  The following names are defined for the `Metadata` object:
    1. `cif-version`: a JSON string giving the minimum CIF syntax version required to express the contents of the object; currently `1.1` or `2.0` are available
    1. `schema-name`: always `CIF-JSON`
    1. `schema-version`: a JSON string giving the version of the CIF-JSON schema that this JSON object conforms to. CIF-JSON
    versioning follows [semantic versioning priniciples](http://semver.org/spec/v2.0.0.html).
    1. `schema-uri`: a URI for the CIF-JSON schema.
10. (Reserved names). All JSON names starting with an upper-case letter are reserved for future development.

## Comments

1. Unlooped datavalues are treated as belonging to single-row
loops. Note that CIF syntax files allow similar behaviour for datanames defined by DDL2 
and DDLm dictionaries.
1. This specification contains some features to allow straightforward
conversion to JSON from files in CIF syntax. However, round-tripping
through CIF-JSON will not preserve features of CIF syntax that are not
used by CIF dictionaries. In particular, block and dataname order, and
the type of delimiters used, if any, are not expressed in CIF-JSON. If
such high-fidelity transformation is required (for example, for CIF
syntax validation) the COD-JSON format used by the freely available
[COD tools](http://wiki.crystallography.net/cod-tools/) is
recommended.
1. JSON numbers are not used to represent CIF numbers as it is generally
impossible to determine whether 
or not an arbitrary datavalue appearing in a CIF syntax file is a number. Future
versions of this standard may offer a mechanism for selective encoding of CIF 
datavalues as numbers.
1.  Implementers should always check `schema-version` when reading CIF-JSON objects. 
Any changes in the major version number imply changes that may cause software written
against previous versions to function incorrectly.

## Example

### CIF syntax file:


    #\#CIF_2.0
    data_example
      _dataname.a   syzygy
      _flight.vector    [0.25 1.2(15) -0.01(12)]
      _dataname.table   {"save":222 "mode":full "url":"http:/bit.ly/2"}
      _flight.bearing  221.45(7)
      loop_
        _x.id
        _y
        _z
        _alpha
        1    4.23(14)     [a a a c]    1.5e-6(2)
        2   11.9(3)       [c a c a]    2.1e-6(11)
        3    0.2(4)       [b a a a]    0.0051(4)
        4     .              .             ?
        
      loop_
        _q.key
        _q.access
        xxp     {"s":2  "k":-5}
        yyx     {"s":1  "k":-2}
        
      _dataname.chapter   1.2
      _dataname.verylong
    ;<whatever>\\
    <whatever>This contains one very long line \
    <whatever>that we wrap around using the \
    <whatever>excellent CIF2 line expansion protocol.
    ;
 
     data_another_block
       _abc    xyz
       save_internal
          _abc   yzx
          loop_
             _r.fruit
             _r.colour
             apple    red
             pear     green
       save_

### Equivalent CIF-JSON:

```json
    {"Metadata":{"cif-version":"2.0",
                 "schema-name":"CIF-JSON",
                 "schema-version":"1.0",
                 "schema-uri":"http://www.iucr.org/resources/cif/cif-json.txt"
                 },
     "example":
        {"_dataname.a":["syzygy"],
         "_flight.vector":["0.25","1.2(15)","-0.01(12)"],
         "_dataname.table":[{"save":"222", "mode":"full", "url":"http:/bit.ly/2"}],
         "_flight.bearing":["221.45(7)"],
         "_x.id":["1","2","3","4"],
         "_y":["4.23(14)","11.9(3)","0.2(4)",false],
         "_z":[["a","a","a","c"],
               ["c","a","c","a"],
               ["b","a","a","a"],
               false],
         "_alpha":["1.5e-6(2)","2.1e-6(11)","5.1e-3(4)",null],
         "_q.key":["xxp","yyx"],
         "_q.access":[{"s":"2",  "k":"-5"},{"s":"1",  "k":"-2"}],
         "_dataname.chapter":["1.2"],
         "_dataname.verylong":["This contains one very long line that we wrap around using the excellent CIF2 line expansion protocol."],
         },
     "another_block":{
        "_abc":["xyz"],
        "frames":
           {"internal":{"_abc":["yzx"],
                        "_r.fruit":["apple","pear"],
                        "_r.colour":["red","green"]}
                        }
           }
    }
```
