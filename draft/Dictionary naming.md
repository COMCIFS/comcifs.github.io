# Dictionary naming conventions

Version 0.2.0 2026-01-28

This table establishes conventions for naming dictionaries and tracking their implementation. The first set of columns tracks historical usage; the last (in bold) indicate dictionaries on GitHub now conforming to the agreed requirements.

The target conventions for CIF data dictionaries are:
- Dictionary name: all caps, CIF_XXX
- Repository name: same, all lowercase, cif_xxx
- File name: lowercase, cif_xxx.dic
- Head group: all caps, CIF_XXX_HEAD
- Namespace: CifCore

Conventions for DDL dictionaries still to be confirmed.

| dictionary       | ITG1e   | ITG2e   | Website              | Logo           | File                     | historical _dictionary.title | _dictionary.title | Repository name   | Head group         | _dictionary.namespace | Comments                                         |
| --- | --- | --- | --- | :---: | --- | ---  | --- | --- | --- | --- | --- |
| Core             | coreCIF | coreCIF | coreCIF              | CIF_core <img src="logos/CIF_core.jpg" alt="coreCIF logo" height="60">      | cif_core.dic             | CIF_CORE               | **CIF_CORE**      | **cif_core**       | **CIF_CORE_HEAD**  | **CifCore**           |                                                  |
| Powder           | pdCIF   | pdCIF   | pdCIF                | CIF_pd <img src="logos/CIF_pd.jpg" alt="pdCIF logo" height="60">          | cif_pd.dic               | CIF_POW (!)            |                   | **cif_pd**         | **PD_GROUP** (!)   | **CifPow** (!)        | Dictionary currently CIF_POW; CIF_PD preferred?  |
|                  |         |         |                      |                | cif_pow.dic (G) (!)      |                        |                   |                    |                    |                       |                                                  |
| Modulated struct | msCIF   | msCIF   | msCIF                | CIF_ms <img src="logos/CIF_ms.jpg" alt="msCIF logo" height="60">          | cif_ms.dic               | CIF_MS                 | **CIF_MS**        | **cif_ms**         | **CIF_MS_HEAD**    | **ModStruct** (!)     |                                                  |
| Electron density | rhoCIF  | rhoCIF  | rhoCIF               | CIF_rho <img src="logos/CIF_rho.jpg" alt="rhoCIF logo" height="60">        | cif_rho.dic              | CIF_RHO                | **CIF_RHO**       | **cif_rho**        | **CIF_RHO_HEAD**   | **CifCore**           |                                                  |
| Macromolecular   | mmCIF   | mmCIF   | mmCIF                | CIF_mm <img src="logos/CIF_mm.jpg" alt="mmCIF logo" height="60">          | cif_mm.dic               | N/A                    |                   |                    |                    | N/A                   |                                                  |
|                  |         |         |                      |                | mmcif_std.dic (P)        |                        |                   |                    |                    |                       |                                                  |
|                  |         |         |                      |                | mmcif_pdbx.dic (P)       |                        |                   |                    |                    |                       |                                                  |
| Image            | imgCIF  | imgCIF  | imgCIF               | CIF_img <img src="logos/CIF_img.jpg" alt="imgCIF logo" height="60">        | cif_img.dic              | CIF_IMG                | **CIF_IMG**       | **imgCIF** (!)     | **CIF_IMG_HEAD**   | **Ddlm** (!)          |                                                  |
|                  |         |         |                      |                | mmcif_img.dic (P)        |                        |                   |                    |                    |                       |                                                  |
| Symmetry         | symCIF  | symCIF  | symCIF               | CIF_sym        | cif_sym.dic              | N/A                    |                   | N/A                | N/A                | N/A                   | Dictionary merged into coreCIF                   |
| Restraints       | N/A     | .       | .                    | CIF_restr <img src="logos/CIF_restr.jpg" alt="restrCIF logo" height="60">    | cif_core_restraints.dic  |                        | **CIF_RESTR**     | **cif_restr**      | **CIF_RESTR_HEAD** | **CifCore**           | |
|                  |         |         |                      |                | cif_rstr.dic (G) (!)     | CIF_RESTR              |                   |                    |                    |                       |                                                  |
| Twinning         | N/A     | twinCIF | .                    | CIF_twin <img src="logos/CIF_twin.jpg" alt="twinCIF logo" height="60">     | cif_twinning.dic         |                        | **CIF_TWIN**      | **cif_twin**       | CIF_TWIN_HEAD      | **CifCore**           | |
|                  |         |         |                      |                | cif_twin.dic (G)         | CIF_TWIN               |                   |                    |                    |                       |                                                  |
| Magnetic         | N/A     | magCIF  | magCIF               | CIF_mag <img src="logos/CIF_mag.jpg" alt="magCIF logo" height="60">        | cif_mag.dic              | CIF_MAG                | **CIF_MAG**       | **cif_mag**        | **CIF_MAG_HEAD**   | **CifCore**           |                                                  |
| Topology         | N/A     | .       | topoCIF              | CIF_topo <img src="logos/CIF_topo.jpg" alt="topoCIF logo" height="60">      | cif_topology.dic         | CIF_TOPO               | **CIF_TOPO**      | **cif_topo**       | **CIF_TOPO_HEAD**  | **CifCore**           |                                                  |
|                  |         |         |                      |                | Topology.dic (G)         |                        |                   |                    |                    |                       |                                                  |
| Multiblock core  | N/A     | .       | "multiblock coreCIF" | CIF_multiblock <img src="logos/CIF_multiblock.jpg" alt="multiblockCIF logo" height="60">    | cif_multiblock.dic       | MULTIBLOCK_DIC (!)     |                   | **cif_multiblock** |                    | **CifCore**           |                                                  |
|                  |         |         |                      |                | multi_block_core.dic (G) |                        |                   |                    |                    |                       |                                                  |
|                  |         |         |                      |                |                          |                        |                   |                    |                    |                       |                                                  |
|                  |
| DDL1             | .       | .       | .                    | CIF_DDL <img src="logos/CIF_DDL.jpg" alt="DDL logo" height="60">        | ddl_core.dic             | N/A                    |                   | N/A                |                    | N/A                   |                                                  |
| DDL2             | .       | .       | .                    | CIF_DDL <img src="logos/CIF_DDL.jpg" alt="DDL logo" height="60">        | mmcif_ddl.dic            | N/A                    |                   | N/A                |                    | N/A                   |                                                  |
|                  |         |         |                      |                | mmcif_ddl.dic (P)        |                        |                   |                    |                    |                       |                                                  |
| DDLm             | N/A     | .       | .                    | CIF_DDL <img src="logos/CIF_DDL.jpg" alt="DDL logo" height="60">        | ddl.dic                  | DDL_DIC                |                   | **DDLm**           |                    | **DDLm**              |                                                  |

Legend:
- (G) means version on GitHub (sometimes corresponds to DDL1/DDLm versions).
- (P) refers to the current latest versions on the wwPDB site (over which COMCIFS has no say).
- (!) means that the value should be reviewed and is likely to be changed.

## CHANGELOG

| Version | Date       | Revision |
|--------:|-----------:|:---------|
|   0.1.0 | 2025-11-24 | Initial draft of the dictionary naming conventions. |
|   0.2.0 | 2026-01-28 | Added legend, update table values.                  |
|   0.2.1 | 2026-01-29 | Added CIF logo files.                               |
