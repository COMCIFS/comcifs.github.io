Annotated version of Example Symmetry CIF dictionary
===

The header is standard for DDLm dictionaries.

```
################################################################################
#                                                                              #
#                      SYMMETRY CIF DICTIONARY                                 #
#                                                                              #
#               Converted from DDL2 to DDLm  12 Jun 2014                       #
#               Updated by J Hester July 2016                                  #
#                                                                              #
################################################################################

data_CIF_SYM

    _dictionary.title           CIF_SYM
    _dictionary.class           Instance
    _dictionary.version         2.0.01
    _dictionary.date            2016-xx-xx
    _dictionary.uri             www.iucr.org/cif/dic/cif_sym.dic
    _dictionary.ddl_conformance 3.11.09
    _dictionary.namespace       CifSym
    _description.text         
;
     The CIF_SYM dictionary expands the core dictionary symmetry definitions to
     allow tabulation of space group relationships and presentation of structural
     data in alternative space groups or space group settings.
;

#==============================================================================

```

The head category (which acts as the parent of all categories in the
dictionary) imports the core dictionary in `Full` mode, which means
that the categories in the core dictionary are reparented to the
symmetry dictionary, and that the symmetry dictionary definitions
replace any identical definitions in the core dictionary.

```
save_SYMMETRY   
    _definition.id              SYMMETRY
    _definition.scope           Category
    _definition.class           Head
    _definition.update          2014-06-12
    _description.text
;
     The parent category of all other categories.
;
    _name.category_id           CIF_SYM
    _name.object_id             SYMMETRY
    _include.get {["file":cif_core.dic "save":CORE_CIF "mode":Full]}
    
save_
#-------------------------------------------------------------------------------
```

We define a category that other categories can have child keys of; if this
category has multiple rows, then the other categories can have multiple
values of the child key and thereby contain information for more than one
space group. By adding a child key of this category to other categories,
we signal that datanames in those other categories depend on knowledge of
the space group in order to be correctly interpreted.

Note that, in the particular case of `SPACE_GROUP`, the `SPACE_GROUP`
category itself could become the 'Hub' category. The only changes to
this example would be the removal of the `SPACE_GROUP_HUB` category
and the parent of all child keys (the one specified in
`_name.linked_item_id`) being changed to the `SPACE_GROUP` key.  The
separate hub category has been left in this example to demonstrate how
the system works for concepts that have no existing category in the
dictionary.

```

save_SPACE_GROUP_HUB
    _definition.id              SPACE_GROUP_HUB
    _definition.scope           Category
    _definition.class           Loop
    _definition.update          2016-xx-xx
    _description.text
;
        This category must be present in order to loop items from the
        SPACE_GROUP category. Categories that need to reference a 
        particular space group provide a child key of this category's
        key.
;
    _name.category_id           SYMMETRY
    _name.object_id             SPACE_GROUP_HUB
    _category.key_id          '_space_group_hub.id'
    loop_
       _category_key.name       '_space_group_hub.id'

save_

save_space_group_hub.id
    _definition.id              '_space_group_hub.id'
    _definition.update          2016-xx-xx
    _description.text
;
     This is a unique identifier for items in the space_group_hub category.
     Categories that depend upon particular values in the SPACE_GROUP
     category should include a child key of this dataname
;

```

The following definitions replace those found in the core
dictionary. `SPACE_GROUP` is redefined to be a `Loop` category and a
child key of `space_group_hub` is added to the list of keys and a
definition provided.

```
save_SPACE_GROUP
    _definition.id              SPACE_GROUP
    _definition.scope           Category
    _definition.class           Loop
    _definition.update          2016-xx-xx
    _description.text
;
     Contains all the data items that refer to the space group as a
     whole, such as its name, Laue group etc. It may be looped, for
     example in a list of space groups and their properties.

     Space-group types are identified by their number as listed in
     International Tables for Crystallography Volume A, or by their
     Schoenflies symbol. Specific settings of the space groups can
     be identified by their Hall symbol, by specifying their
     symmetry operations or generators, or by giving the
     transformation that relates the specific setting to the
     reference setting based on International Tables Volume A and
     stored in this dictionary.

     The commonly used Hermann-Mauguin symbol determines the
     space-group type uniquely but several different Hermann-Mauguin
     symbols may refer to the same space-group type. A
     Hermann-Mauguin symbol contains information on the choice of
     the basis, but not on the choice of origin.

     Ref: International Tables for Crystallography (2002). Volume A,
          Space-group symmetry, edited by Th. Hahn, 5th ed.
          Dordrecht: Kluwer Academic Publishers.
;
    _name.category_id           SYMMETRY
    _name.object_id             SPACE_GROUP
    _category.key_id          '_space_group.id'
    loop_
        _category_key.name       '_space_group.id'

save_space_group.id
    _definition.id             '_space_group.id'
    _description.text
;
     This item uniquely identifies an entry in the space_group table.
     It must be one of the values provided in space_group_hub.id
;
     _name.category_id         space_group
     _name.object_id           id
     _name.linked_item_id      '_space_group_hub.id'
     _type.purpose             Link
     _type.source              Related
     _type.container           Single
     _type.contents            Text

save_
```

These datanames come from the old symCIF dictionary. They were not
included in the core dictionary as they make no sense in the context
of a single space group.

```
save_space_group.reference_setting
    _definition.id             '_space_group.reference_setting'
    _definition.update          2014-06-12
    _description.text
;
     The reference setting of a given space group is the setting
     chosen by the International Union of Crystallography as a
     unique setting to which other settings can be referred
     using the transformation matrix column pair given in
     _space_group.transform_Pp_abc and _space_group.transform_Qq_xyz.

     The settings are given in the enumeration list in the form
     '_space_group.IT_number:_space_group.name_Hall'. The
     space-group number defines the space-group type and the
     Hall symbol specifies the symmetry generators referred to
     the reference coordinate system.

     The 230 reference settings chosen are identical to the settings
     listed in International Tables for Crystallography Volume A
     (2002). For the space groups where more than one setting is
     given in International Tables, the following choices have
     been made.

     For monoclinic space groups: unique axis b and cell choice 1.

     For space groups with two origins: origin choice 2 (origin at
     inversion centre, indicated by adding :2 to the Hermann-Mauguin
     symbol in the enumeration list).

     For rhombohedral space groups: hexagonal axes (indicated by
     adding :h to the Hermann-Mauguin symbol in the enumeration list).

     Based on the symmetry table of R. W. Grosse-Kunstleve, ETH,
     Zurich.

     The enumeration list may be extracted from the dictionary
     and stored as a separate CIF that can be referred to as
     required.

     In the enumeration list, each reference setting is identified
     by Schoenflies symbol and by the Hermann-Mauguin symbol,
     augmented by :2 or :h suffixes as described above.

     Ref: International Tables for Crystallography (2002). Volume A,
          Space-group symmetry, edited by Th. Hahn, 5th ed.
          Dordrecht: Kluwer Academic Publishers.

          Grosse-Kunstleve, R. W. (2001). Xtal System of
          Crystallographic Programs, System Documentation.
          http://xtal.crystal.uwa.edu.au/man/xtal3.7-228.html
          (or follow links to Docs->Space-Group Symbols from
          http://xtal.sourceforge.net).
;
    _name.category_id           space_group
    _name.object_id             reference_setting
    _type.purpose               State
    _type.source                assigned
    _type.container             Single
    _type.contents              Code
    _import.get       [{"file":'templ_enum.cif',"save":'ref_set'}]
     save_


save_space_group.transform_Pp_abc
    _definition.id             '_space_group.transform_Pp_abc'
    _definition.update          2014-06-12
    _description.text
;
     This item specifies the transformation (P,p) of the basis
     vectors from the setting used in the CIF (a,b,c) to the
     reference setting given in _space_group.reference_setting
     (a',b',c'). The value is given in Jones-Faithful notation
     corresponding to the rotational matrix P combined with the
     origin shift vector p in the expression:

          (a',b',c') = (a,b,c)P + p.

     P is a post-multiplication matrix of a row (a,b,c) of column
     vectors. It is related to the inverse transformation (Q,q) by:

          P = Q^-1^
          p = Pq = -(Q^-1^)q.

     These transformations are applied as follows:

     atomic coordinates  (x',y',z') = Q(x,y,z) + q
     Miller indices      (h',k',l') = (h,k,l)P
     symmetry operations         W' = (Q,q)W(P,p)
     basis vectors       (a',b',c') = (a,b,c)P + p

     This item is given as a character string involving the
     characters a, b and c with commas separating the expressions
     for the a', b' and c' vectors. The numeric values may be
     given as integers, fractions or real numbers. Multiplication
     is implicit, division must be explicit. White space within
     the string is optional.
;
    _name.category_id           space_group
    _name.object_id             transform_Pp_abc
    _type.purpose               Describe
    _type.source                Assigned
    _type.container             Single
    _type.contents              Text
     loop_
    _description_example.case
    _description_example.detail
         'R3:r to R3:h'      '-b+c, a+c, -a+b+c'  
         'Pnnn:1 to Pnnn:2'  'a-1/4, b-1/4, c-1/4'  
         'Bbab:1 to Ccca:2'  'b-1/2, c-1/2, a-1/2'  
     save_


save_space_group.transform_Qq_xyz
    _definition.id             '_space_group.transform_Qq_xyz'
    _definition.update          2014-06-12
    _description.text
;
     This item specifies the transformation (Q,q) of the atomic
     coordinates from the setting used in the CIF [(x,y,z) referred
     to the basis vectors (a,b,c)] to the reference setting given in
     _space_group.reference_setting [(x',y',z') referred to the
     basis vectors (a',b',c')].

     The value given in Jones-Faithful notation corresponds to the
     rotational matrix Q combined with the origin shift vector q in
     the expression:

         (x',y',z') = Q(x,y,z) + q.

     Q is a pre-multiplication matrix of the column vector (x,y,z).
     It is related to the inverse transformation (P,p) by:

         P = Q^-1^
         p = Pq = -(Q^-1^)q,

     where the P and Q transformations are applied as follows:

     atomic coordinates  (x',y',z') = Q(x,y,z) + q
     Miller indices      (h',k',l') = (h,k,l)P
     symmetry operations         W' = (Q,q)W(P,p)
     basis vectors       (a',b',c') = (a,b,c)P + p

     This item is given as a character string involving the
     characters x, y and z with commas separating the expressions
     for the x', y' and z' components. The numeric values may be
     given as integers, fractions or real numbers. Multiplication
     is implicit, division must be explicit. White space within
     the string is optional.
;
    _name.category_id           space_group
    _name.object_id             transform_Qq_xyz
    _type.purpose               Describe
    _type.source                Assigned
    _type.container             Single
    _type.contents              Text
     loop_
    _description_example.case
    _description_example.detail
         'R3:r to R3:h'      '-x/3+2y/3-z/3, -2x/3+y/3+z/3, x/3+y/3+z/3'  
         'Pnnn:1 to Pnnn:2'  'x+1/4,y+1/4,z+1/4'  
         'Bbab:1 to Ccca:2'  'z+1/2,x+1/2,y+1/2'  
     save_

#-------------------------------------------------------------------------------
```

The `SPACE_GROUP_SYMOP` and `SPACE_GROUP_WYCKOFF` definitions have an
extra key added pointing to the `SPACE_GROUP_HUB` definition.

```
save_SPACE_GROUP_SYMOP
    _definition.id              SPACE_GROUP_SYMOP
    _definition.scope           Category
    _definition.class           Loop
    _definition.update          2016-xx-xx
    _description.text
;
     Contains information about the symmetry operations of the
     space group.
;
    _name.category_id           SYMMETRY
    _name.object_id             SPACE_GROUP_SYMOP
#    _category.key_id          '_space_group_symop.id'
    loop_
       _category_key.name       '_space_group_symop.id' '_space_group_symop.sg_id'

save_

save_space_group_symop.sg_id
    _definition.id             '_space_group_symop.sg_id'
    _definition.update         2016-xx-xx
    _description.text
;
    The hub identifier for the space group containing this symmetry operator.
;
     _name.category_id         space_group_symop
     _name.object_id           sg_id
     _name.linked_item_id      '_space_group_hub.id'
     _type.purpose             Link
     _type.source              Related
     _type.container           Single
     _type.contents            Text

     save_

#-------------------------------------------------------------------------------

save_SPACE_GROUP_WYCKOFF
    _definition.id              SPACE_GROUP_WYCKOFF
    _definition.scope           Category
    _definition.class           Loop
    _definition.update          2016-xx-xx
    _description.text
;
     Contains information about Wyckoff positions of a space group.
     Only one site can be given for each special position but the
     remainder can be generated by applying the symmetry operations
     stored in _space_group_symop.operation_xyz.
;
    _name.category_id           SYMMETRY
    _name.object_id             SPACE_GROUP_WYCKOFF
#    _category.key_id          '_space_group_Wyckoff.id'
    loop_
        _category_key.name     '_space_group_Wyckoff.id' '_space_group_Wyckoff.sg_id'

save_

save_space_group_Wyckoff.sg_id
    _definition.id             '_space_group_Wyckoff.sg_id'
    _definition.update          2016-xx-xx
    _description.text
;
      A child of _space_group_hub.id allowing the Wyckoff position
      to be identified with a particular space group.
;
    _name.category_id           space_group_Wyckoff
    _name.object_id             sg_id
    _name.linked_item_id        '_space_group_hub.id'
    _type.purpose               Link
    _type.source                Related
    _type.container             Single
    _type.contents              Text
     save_
```

The following categories are changed to 'Loop' categories and/or supplied
with an extra child key of the `SPACE_GROUP_HUB` category. This allows
them to indicate which space group the dataname values are to be interpreted
relative to.

How do we determine if a category requires a key from a newly-looped
category?

Mathematically, our category datanames are functions from the keys to
the dataname values. If absence of the key would make it impossible to
assign a unique value to even one dataname (ontologically, i.e. according
to our understanding of the scientific discipline) then the key is
required.

```
save_REFLN

_definition.id                          REFLN
_definition.scope                       Category
_definition.class                       Loop
_definition.update                      2016-xx-xx
_description.text                       
;
     The CATEGORY of data items used to describe the reflection data
     used in the refinement of a crystallographic structure model.
;
_name.category_id                       DIFFRACTION
_name.object_id                         REFLN
#_category.key_id                        '_refln.key'
loop_
  _category_key.name
         '_refln.index_h'    
         '_refln.index_k'    
         '_refln.index_l' 
         '_refln.sg_id'
save_

save_refln.sg_id
    _definition.id             '_refln.sg_id'
    _definition.update          2016-xx-xx
    _description.text
;
      A child of _space_group_hub.id allowing the reflection
      to be explicitly associated with a particular space group.
;
    _name.category_id           refln
    _name.object_id             sg_id
    _name.linked_item_id        '_space_group_hub.id'
    _type.purpose               Link
    _type.source                Related
    _type.container             Single
    _type.contents              Text
     save_
```

Strictly speaking, a unique atomic site cannot be associated with an
atom label, so it would appear that there is no functional
relationship between the label and the fractional coordinates in even
the cif core dictionary. In fact, the fractional coordinates when
combined with the symmetry operators yield a unique set of coordinates
(the orbit).  So the fractional coordinates are used as proxies for an
orbit, however, this is only possible if the symmetry operators are
known - thus the need to explicitly specify the space group if there
is more than one.

```

save_ATOM_SITE

_definition.id                          ATOM_SITE
_definition.scope                       Category
_definition.class                       Loop
_definition.update                      2016-07-25
_description.text                       
;
     The CATEGORY of data items used to describe atom site information
     used in crystallographic structure studies.
;
_name.category_id                       ATOM
_name.object_id                         ATOM_SITE
_category.key_id                        '_atom_site.key'
loop_
  _category_key.name
         '_atom_site.label'
         '_atom_site.sgt_id'

save_

save_atom_site.sgt_id
    _definition.id             '_atom_site.sgt_id'
    _definition.update          2016-xx-xx
    _description.text
;
      A child of _space_group_hub.id allowing the atom site
      to be explicitly associated with a particular space group.
;
    _name.category_id           atom_site
    _name.object_id             sgt_id
    _name.linked_item_id        '_space_group_hub.id'
    _type.purpose               Link
    _type.source                Related
    _type.container             Single
    _type.contents              Text
     save_

```

`ATOM_SITE_ANISO` is a child loop category of `ATOM_SITE`.  Therefore, it must
also contain a child key of each `atom_site` key. By extension of the
original DDLm rule, the parent-child relationship means that only those
combinations of key values that are present in the parent may be present
in the child.

```

save_ATOM_SITE_ANISO

_definition.id                          ATOM_SITE_ANISO
_definition.scope                       Category
_definition.class                       Loop
_definition.update                      2013-09-08
_description.text                       
;
     The CATEGORY of data items used to describe the anisotropic
     thermal parameters of the atomic sites in a crystal structure.
;
_name.category_id                       ATOM_SITE
_name.object_id                         ATOM_SITE_ANISO
loop_
  _category_key.name
         '_atom_site_aniso.label' 
         '_atom_site_aniso.sgt_id'
save_

save_atom_site_aniso.sgt_id
    _definition.id             '_atom_site_aniso.sgt_id'
    _definition.update          2016-xx-xx
    _description.text
;
      A child of _space_group_hub.id allowing the atom site
      to be explicitly associated with a particular space group.
;
    _name.category_id           atom_site_aniso
    _name.object_id             sgt_id
    _name.linked_item_id        '_atom_site.sgt_id'
    _type.purpose               Link
    _type.source                Related
    _type.container             Single
    _type.contents              Text
     save_

```

The addition of an explicit `space group hub` id flows through to any
categories that work with the atom site list.  As a unique atom can
appear more than once (once for each space group) other categories in
turn must provide the space group hub id in order to reference a
particular atom site row, so must have a child key of space group hub
as one of their keys.  In particular, `model_site` must do this, and
then all of the `geom` categories that access `model_site` do the same
in turn.

The dREL category method has been omitted for brevity.

```

save_MODEL_SITE

_definition.id                          MODEL_SITE
_definition.scope                       Category
_definition.class                       Loop
_definition.update                      2013-09-08
_description.text                       
;
     The CATEGORY of data items used to describe atomic sites and
     connections in the proposed atomic model.
;
_name.category_id                       MODEL
_name.object_id                         MODEL_SITE
_category.key_id                        '_model_site.key'
loop_
  _category_key.name
         '_model_site.label'           
         '_model_site.symop'
         '_model_site.sgt_id'

save_

save_model_site.sgt_id
    _definition.id             '_model_site.sgt_id'
    _definition.update          2016-xx-xx
    _description.text
;
      A child of _space_group_hub.id allowing the model site
      to be explicitly associated with a particular space group.
;
    _name.category_id           model_site
    _name.object_id             sgt_id
    _name.linked_item_id        '_space_group_hub.id'
    _type.purpose               Link
    _type.source                Related
    _type.container             Single
    _type.contents              Text
     save_

```

Only a definition for `GEOM_ANGLE` is provided in this example, as
the construction of the remaining categories would be identical.

```

save_GEOM_ANGLE

_definition.id                          GEOM_ANGLE
_definition.scope                       Category
_definition.class                       Loop
_definition.update                      2016-xx-xx
_description.text                       
;
     The CATEGORY of data items used to specify the geometry angles in the
     structural model as derived from the atomic sites.
;
_name.category_id                       GEOM
_name.object_id                         GEOM_ANGLE
loop_
  _category_key.name
         '_geom_angle.sgt_id'
         '_geom_angle.atom_site_label_1'         
         '_geom_angle.atom_site_label_2'         
         '_geom_angle.atom_site_label_3'         
         '_geom_angle.site_symmetry_1'           
         '_geom_angle.site_symmetry_2'           
         '_geom_angle.site_symmetry_3' 
save_

save_geom_angle.sgt_id
    _definition.id             '_geom_angle.sgt_id'
    _definition.update          2016-xx-xx
    _description.text
;
      A child of _space_group_hub.id allowing the model site
      to be explicitly associated with a particular space group.
;
    _name.category_id           geom_angle
    _name.object_id             sgt_id
    _name.linked_item_id        '_space_group_hub.id'
    _type.purpose               Link
    _type.source                Related
    _type.container             Single
    _type.contents              Text
     save_
```

Note that the original draft cif core dictionary had all `CELL_*` categories as
children of the `CELL` category.  It is proposed to move all the datanames back
into the `CELL_` category in the core dictionary.

`CELL_MEASUREMENT` remains as separate category, which is also provided with
a space group hub child key to indicate which space group the reflection
indices are relative to.

```

save_CELL

_definition.id                          CELL
_definition.scope                       Category
_definition.class                       Loop
_definition.update                      2016-xx-xx
_description.text                       
;
     The CATEGORY of data items used to describe the parameters of
     the crystal unit cell and their measurement.
;
_name.category_id                       EXPTL
_name.object_id                         CELL
_category_key.name
    '_cell.sgt_id'
save_

save_cell.sgt_id
    _definition.id             '_cell.sgt_id'
    _definition.update          2016-xx-xx
    _description.text
;
      A child of _space_group_hub.id allowing the model site
      to be explicitly associated with a particular space group.
;
    _name.category_id           cell
    _name.object_id             sgt_id
    _name.linked_item_id        '_space_group_hub.id'
    _type.purpose               Link
    _type.source                Related
    _type.container             Single
    _type.contents              Text
save_
```

As the reflection hkl may depend on the space group chosen, we must also add
a link in `cell_measurement_refln`
```

save_CELL_MEASUREMENT_REFLN

_definition.id                          CELL_MEASUREMENT_REFLN
_definition.scope                       Category
_definition.class                       Loop
_definition.update                      2016-xx-xx
_description.text                       
;
     The CATEGORY of data items used to describe the reflection data
     used in the measurement of the crystal unit cell.
;
_name.category_id                       EXPTL
_name.object_id                         CELL_MEASUREMENT_REFLN
loop_
  _category_key.name
         '_cell_measurement_refln.index_h'       
         '_cell_measurement_refln.index_k'       
         '_cell_measurement_refln.index_l'
         '_cell_measurement_refln.sgt_id'

save_

save_cell_measurement_refln.sgt_id
    _definition.id             '_cell_measurement_refln.sgt_id'
    _definition.update          2016-xx-xx
    _description.text
;
      A child of _space_group_hub.id allowing the model site
      to be explicitly associated with a particular space group.
;
    _name.category_id           cell_measurement_refln
    _name.object_id             sgt_id
    _name.linked_item_id        '_space_group_hub.id'
    _type.purpose               Link
    _type.source                Related
    _type.container             Single
    _type.contents              Text
save_
```

Final comments
===

Note `exptl_crystal.F_000`: number of electrons in the unit cell. This
does depend on the unit cell chosen, unlike the other `exptl_crystal`
items, so would entail `exptl_crystal` having an `sgt_id` value.

Further categories requiring the addition of an extra space group key
dataname are `atom_sites_cartn_transform`,
`atom_sites_fract_transform`, `exptl_crystal_face`. These have been
omitted as they are identical in approach to the above categories
and involve no new ideas.
