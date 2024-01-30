# VFPX Framework

Thor, GoFish, Project Explorer, and every other VFPX project has a different set of UI classes, subclasses of the VFP base classes. Many projects have common functionality: for example, Thor, FoxGet, and DeployFox all have functions to download and unzip files. Until now, there hasn't been a common shared set of classes and libraries for VFPX projects. Now there is: the VFPX Framework.

VFPX Framework provides base UI classes and commonly used functions such reading from or writing to INI files and the Window Registry, getting a filename from the user using a better dialog than GETFILE(), recursive file operations with a dialog such as copying files and deleting folders, and so on. Not only does VFPX Framework eliminate duplicated functionality for VFPX projects, it can also be used in your own non-VFPX applications.

**Note**: this project has not been released to the public yet.

## Documentation
See the [documentation](Doc/Documentation.md) for the classes and utility programs for information on what's provided and usage.

## Helping with this project

See [How to Contribute to VFPX Framework](.github/CONTRIBUTING.md) for details on how to help with this project.

## Releases

See the [change log](ChangeLog.md) for release information.
