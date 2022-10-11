# Dictionary versioning process

Version 1.0.0 2020-03-18

The following document proposes a set of practices that should be adopted in Git repositories used for the maintenance and development of DDLm dictionaries.

## Dictionary development cycle

A single iteration of a dictionary development cycle starts with the creation of a development version of a dictionary and ends with a release of a stable dictionary version. A new development version is usually created immediately after the release of a stable version. Each iteration of a development dictionary is assigned a unique development version number to differentiate it from a stable release.  

## Creating a development dictionary version

A new development version of a dictionary can be created from the latest stable release version of a dictionary by applying the following changes:

* Replace the `_dictionary.version` data item value with a development version constructed by incrementing the `<update>` part of the current version by one and postfixing it with the `-dev.0` string (e.g. "3.4.5" to "3.4.6-dev.0");
* Update the `_dictionary.date` data item if needed;
* Register the development version in the `DICTIONARY_AUDIT` looped list. This is done by creating a new entry in which the `_dictionary_audit.version` data item value matches the the `_dictionary.version` data item value, the `_dictionary_audit.date` data item value matches the `_dictionary.date` data item value and the `_dictionary_audit.revision` data item value is set to an empty string.

## Tracking changes in a development dictionary

All changes applied to the development dictionary during the development cycle should preferably be documented inside the dictionary itself. Each incremental dictionary change (i.e. a pull request that implements a feature) should also contain the following changes:

* A short message describing the implemented changes should be appended to the `_dictionary_audit.revision` data item value associated with the development version;
* The dictionary version should be updated accordingly (see "Versioning a development dictionary"). Both the `_dictionary.version` and the `_dictionary_audit.version` data items should be updated;
* The dictionary update date should be changed to the date of the last relevant commit. Both the `_dictionary.date` and the `_dictionary_audit.date` data items should be changed;
* The `_definition.update` data item value of all modified definition save blocks should be updated to the appropriate change date.

## Versioning a development dictionary
Version number of a development dictionary is intended to uniquely identify an incremental step in the dictionary development process as well as provide information about the compatibility of the implemented changes. This is done by adopting version numbers of the `<planned-release-version>`-**dev**.`<increment>` form.

The `<planned-release-version>` part adheres to the standard `<major>`.`<version>`.`<update>` version format and stores the version number of the next stable version release (e.g. "3.2.7", "3.5.1"). As a result, it can be changed at most two times during a single dictionary development iteration:

* `<version>` change. In case a new feature is introduced, the `<version>` part must be incremented by one and the `<update>` part must be set to zero (e.g. "3.5.2" to "3.6.0"). Further introduction of new features or bugfixes during the same dictionary development iteration do not affect the `<planned-release-version>`.

* `<major>` change. In case an interface breaking change is introduced, the `<major>` part must be incremented by one and the rest of the parts must be set to zero (e.g. "3.7.1" to "4.0.0"). After a `<major>` version change, the version number remains unchanged until the end of a dictionary development iteration.

The `<increment>` part takes a form of an integer that gets incremented after each dictionary revision (e.g. "1", "2", "3").

An example of a version number change sequence that may occur during a single dictionary development iteration: "3.2.1-dev.0", "3.2.1-dev.1", "3.2.1-dev.2", "3.3.0-dev.4", "3.3.0-dev.5", ..., "4.0.0-dev.42".

## Releasing a stable dictionary version

The following changes should be applied to a development version in preparation for its release as a stable version:

1. The version number should be updated to reflect the stable release version. This should generally only require the removal of the '-dev.*n*' postfix from the development version number. The change should be applied both to the `_dictionary.version` data item and the `_dictionary_audit.version` data item;
2. The release date should be updated to reflect the release date of the stable version. The change should be applied both to the `_dictionary.date` data item and the `_dictionary_audit.date` data item;
3. The `_dictionary_audit.revision` data item value associated with the current release may should be reviewed and simplified if needed.

The release is considered finalised once the a stable version is placed in a separate Git tag. After this it can be distributed to other official IUCr resources (website, FTP).
