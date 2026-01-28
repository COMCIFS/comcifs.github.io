# Dictionary naming conventions

Version 0.1.0 2025-11-24

This table establishes conventions for naming dictionaries and tracking their implementation. The first set of columns tracks historical usage; the last (in bold) indicate dictionaries on GitHub now conforming to the agreed requirements.

The target conventions for CIF data dictionaries are:
- Dictionary name: all caps, CIF_XXX
- Repository name: same, all lowercase, cif_xxx
- File name: lowercase, cif_xxx.dic
- Head group: all caps, CIF_XXX_HEAD
- Namespace: CifCore

Conventions for DDL dictionaries still to be confirmed.

| dictionary       | ITG1e   | ITG2e   | Website              | Logo           | File                     | DDLm _dictionary.title | _dictionary.title | Repository name   | Head group         | _dictionary.namespace | Comments                                         |
| --- | --- | --- | --- | --- | --- | ---  | --- | --- | --- | --- | --- |
| Core             | coreCIF | coreCIF | coreCIF              | CIF_core       | cif_core.dic             | CORE_DIC               | **CIF_CORE**      | **cif_core**       | **CIF_CORE_HEAD**  | **CifCore**           |                                                  |
| Powder           | pdCIF   | pdCIF   | pdCIF                | CIF_pd         | cif_pd.dic               |                        |                   | **cif_pd**         |                    |                       | Dictionary currently CIF_POW; CIF_PD preferred?  |
|                  |         |         |                      |                | cif_pow.dic (G)          | CIF_POW                |                   |                    |                    |                       |                                                  |
| Modulated struct | msCIF   | msCIF   | msCIF                | CIF_ms         | cif_ms.dic               | CIF_MS                 | **CIF_MS**        | **cif_ms**         | **CIF_MS_HEAD**    |                       |                                                  |
| Electron density | rhoCIF  | rhoCIF  | rhoCIF               | CIF_rho        | cif_rho.dic              | Cif_rho                | **CIF_RHO**       | **cif_rho**        | **CIF_RHO_HEAD**   | **CifCore**           |                                                  |
| Macromolecular   | mmCIF   | mmCIF   | mmCIF                | CIF_mm         | cif_mm.dic               | N/A                    |                   |                    |                    |                       |                                                  |
|                  |         |         |                      |                | mmcif_std.dic (P)        |                        |                   |                    |                    |                       |                                                  |
|                  |         |         |                      |                | mmcif_pdbx.dic (P)       |                        |                   |                    |                    |                       |                                                  |
| Image            | imgCIF  | imgCIF  | imgCIF               | CIF_img        | cif_img.dic              | Cif_img.dic            | **CIF_IMG**       |                    | **CIF_IMG_HEAD**   |                       |                                                  |
|                  |         |         |                      |                | mmcif_img.dic (P)        |                        |                   |                    |                    |                       |                                                  |
| Symmetry         | symCIF  | symCIF  | symCIF               | CIF_sym        | cif_sym.dic              | N/A                    |                   | N/A                |                    |                       | Dictionary merged into coreCIF                   |
| Restraints       | N/A     | .       | .                    | CIF_restraints | cif_core_restraints.dic  |                        | **CIF_RESTR**     | **cif_restr**      | **CIF_RESTR_HEAD** | **CifCore**           | Abbreviated logo cif_rstr needed                 |
|                  |         |         |                      |                | cif_rstr.dic (G)(!)      | CIF_RESTR              |                   |                    |                    |                       |                                                  |
| Twinning         | N/A     | twinCIF | .                    | CIF_twinning   | cif_twinning.dic         |                        | **CIF_TWIN**      | **cif_twin**       | CIF_TWIN_HEAD      | **CifCore**           | PR in progress; Abbreviated logo cif_twin needed |
|                  |         |         |                      |                | cif_twin.dic (G)         | CIF_TWIN               |                   |                    |                    |                       |                                                  |
| Magnetic         | N/A     | magCIF  |  magCIF              | CIF_mag        | cif_mag.dic              | MAGNETIC_CIF           | **CIF_MAG**       | **cif_mag**        | **CIF_MAG_HEAD**   | **CifCore**           |                                                  |
| Topology         | N/A     | .       | topoCIF              | CIF_topo       | cif_topology.dic         | TOPOLOGY_CIF           | **CIF_TOPO**      | **cif_topo**       | **CIF_TOPO_HEAD**  | **CifCore**           |                                                  |
|                  |         |         |                      |                | Topology.dic (G)         |                        |                   |                    |                    |                       |                                                  |
| Multiblock core  | N/A     | .       | "multiblock coreCIF" | .              | cif_multiblock.dic       | MULTIBLOCK_DIC         |                   | **cif_multiblock** |                    | **CifCore**           |                                                  |
|                  |         |         |                      |                | multi_block_core.dic (G) |                        |                   |                    |                    |                       |                                                  |
|                  |         |         |                      |                |                          |                        |                   |                    |                    |                       |                                                  |
|                  |
| DDL1             | .       | .       | .                    | CIF_DDL        | ddl_core.dic             | N/A                    |                   | N/A                |                    |                       |                                                  |
| DDL2             | .       | .       | .                    | CIF_DDL        | mmcif_ddl.dic            | N/A                    |                   | N/A                |                    |                       |                                                  |
|                  |         |         |                      |                | mmcif_ddl.dic (P)        |                        |                   |                    |                    |                       |                                                  |
| DDLm             | N/A     | .       | .                    | CIF_DDL        | ddl.dic                  | DDL_DIC                |                   | **DDLm**           |                    |                       |                                                  |
|                  |         |         |                      |                | DDLm.dic (G)             |                        |                   |                    |                    |                       |                                                  |

Legend:
- (G) means version on GitHub (sometimes corresponds to DDL1/DDLm versions).
- (P) refers to the current latest versions on the wwPDB site (over which COMCIFS has no say).
- (!) means that the value is likely to change

## CHANGELOG

| Version | Date       | Revision |
|--------:|-----------:|:---------|
|   0.1.0 | 2025-11-24 | Initial draft of the dictionary naming conventions. |
