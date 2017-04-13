# JSON representation of CIF files (DRAFT)

## Introduction

JSON is a lightweight language for serialisation and transfer of data.  JSON is
often used as a "pipeline" language to transfer information between programs within
a single system, and also as a way of transferring information between 
internet applications.  Due to the wide availability of JSON libraries and
therefore the relative simplicity of implementing JSON input/output, a
standard way of converting CIF files to JSON would allow programs from different
authors to interoperate with minimal work.

## The JSON representation of a CIF file

In the following, *name* refers to a JSON name and *value* to a JSON value. A
JSON *object* is a collection of `name:value` pairs.

A CIF file is converted to JSON as follows:

1. A CIF file is represented as a single JSON object
2. The JSON file must be UTF-8 encoded
3. Each CIF block becomes a JSON object within the top-level object. The name of each 
of these block objects is the CIF data block name, that is, the characters following
`data_` in the CIF file. This object is referred to here as the *JSON datablock object*.
4. Each dataname in the CIF block is a name in that block's JSON datablock object. The JSON name
is the CIF dataname, including the underscore.

5. Datavalues are converted as follows:

   1. CIF string values are represented as JSON string values. The
  code-point sequence obtained *after* the text prefix protocol and line ending
  protocols have been applied to the CIF value will be the
  code-point sequence presented in the JSON file
  
   2. If the CIF datavalue should be interpreted as a number, it is
  that number obtained by parsing the character string found in the
  CIF according to the `<Number>` production in International Tables
  for Crystallography, Volume G, Section 2.2.7.3 paragraph 57. It is
  not an error to instead represent such a datavalue as a JSON string. Note that
  the CIF `<Number>` production is identical to the JSON number format.
   3. The special CIF value `.` (null) is represented as the JSON `null` value
   4. The special CIF value `?` (unknown) is represented as the JSON string `"\\?"`. Datanames
  with a CIF value of `?` may be omitted from the JSON datablock object.
   5. (CIF2 only).  CIF2 list datavalues are represented as JSON lists. The datavalues appearing
  in the list are converted in the same way as non-list datavalues.
   6. (CIF2 only).  CIF2 table datavalues are represented as JSON objects. The names in the object
  are the same as the names in the CIF2 table. The values in the CIF table are converted in the same
  way as other CIF datavalues
   7. (Looped values). The column of values corresponding to a looped
  CIF dataname is represented as a JSON list. This list is the value of
  the JSON name corresponding to that dataname. Each value in the list
  is converted as for unlooped datanames
   8. (Looped values). Treatment of numeric values in a single loop column must
  be consistent. Either all non-null values must be strings, or else all values must
  be JSON numbers.
  
6. A JSON datablock object may contain a special name: `loop tags`.  If this name
appears, its value will be a list of lists.  For each loop in the CIF block,
a list of the datanames appearing in the loop will be included in the `loop tags` value.
7. It is not an error to omit the `loop tags` name, even when the CIF data block contains
a loop. If the `loop tags` name appears, information on all loops in the datablock must be
included.
8. A JSON datablock object may contain a special name:
`uncertainties`.  This object contains a JSON name for each dataname
for which at least one value has an uncertainty appended and that
value has been presented as a JSON number. The JSON
name is the CIF dataname.  The value for each name is structured
identically to the name in the JSON datablock object.  If a dataname
takes multiple values (i.e. list, table or looped) any values for
which no uncertainty is available are assigned `null`.
9. If the CIF data block includes save frames (currently only used in dictionaries), 
the JSON datablock object must contain the special name `frames`. The value of this name
is a JSON object. Each name in this object is the name of a save frame
found in the datablock. The value for each of these names is a JSON datablock object, converted
as for normal CIF data blocks.
  
## Comments

1. A JSON list is used both for columns and CIF2 lists.  Where a
dataname is known to occur in a loop (either through the `loop tags` name
or as stated in the relevant CIF dictionary), the JSON parser may assume
that each entry in the outermost list level is the column entry.
1. Any list-valued name that does not appear in a loop is a CIF2 list.
1. The use of `"\\?"` to represent CIF `?` means that the actual two-character string
`<reverse solidus><question mark>` cannot be represented. Alternative suggestions welcome.
1. The order in which datanames appear in the JSON datablock object is not significant. In particular,
co-looped datanames do not have to appear together and the order in the JSON object
does not have to match the order of presentation in the CIF block.

## Example

### CIF file:


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
    ;<whatever>\
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

### Equivalent JSON:

```json
    {"example":
        {"_dataname.a":"syzygy",
         "_flight.vector":[0.25,1.2,-0.01],
         "_dataname.table":{"save":222, "mode":"full", "url":"http:/bit.ly/2"},
         "_flight.bearing":221.45,
         "_x.id":["1","2","3","4"],
         "_y":["4.23(14)","11.9(3)","0.2(4)",null],
         "_z":[["a","a","a","c"],
               ["c","a","c","a"],
               ["b","a","a","a"],
               null],
         "_alpha":[1.5e-6,2.1e-6,5.1e-3,"\\?"],
         "_q.key":["xxp","yyx"],
         "_q.access":[{"s":2,  "k":-5},{"s":1,  "k":-2}],
         "_dataname.chapter":"1.2",
         "_dataname.verylong":"This contains one very long line that we wrap around using the excellent CIF2 line expansion protocol.",
         "loop tags":[["_x.id","_y","_z"],["_q.key","_q.access"]],
         "uncertainties":{
             "_flight.vector":[null, 1.5, 0.12],
             "_alpha":[2e-7,1.1e-6,4e-4,null],
             "_flight.bearing":0.07}
         },
     "another_block":{
        "_abc":"xyz",
        "frames":
           {"internal":{"_abc":"yzx",
                        "_r.fruit":["apple","pear"],
                        "_r.colour":["red","green"]}
                        }
           }
    }
```
