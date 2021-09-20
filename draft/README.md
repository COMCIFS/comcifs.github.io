# Draft COMCIFS Documents

This area is for preparation and discussion of COMCIFS documents prior
to official publication on the IUCr website.  Please be cautious about
relying on statements made in documents in this repository.

## Creating new documents

Draft documents should include the following information after the
heading:

1. Status.  Usually "Draft" but "Abandoned", "Early draft" etc. also fine.
2. Version. Please use Semantic versioning (semver). For draft
documents the version should be less than 1.0.
3. Date. The month and year of the most recent revision

For example:

```markdown
# Dictionary Working Group Guide

Status: Draft
Version: 0.1
Date: Sept 2021
```

To prepare a new draft document, please clone this repository, create
the draft document, and then submit a pull request. This will initiate
discussion.

## Information about particular documents

[looping_proposal.md](looping_proposal.md): A proposal for a mechanism
to allow categories whose datanames conventionally have a single value
to take multiple values.

[cif_sym.dic.annotated.md](cif_sym.dic.annotated.md): An annotated
example of how an extension dictionary using the mechanism described
in [looping_proposal.md](looping_proposal.md) would be constructed.

[cif_sym.dic](cif_sym.dic): A raw version of the [annotated
example](cif_sym.dic.annotated.md).
