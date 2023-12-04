# Building StageInstrument MSI Installer

## Needed programs:

 * [WiX](http://wixtoolset.org/) version 3.5 or later.
 * [MSBuild](https://docs.microsoft.com/en-us/visualstudio/msbuild/msbuild-reference?view=vs-2019). MSBuild is part of .NET 2.0 or later SDK.

## Installer script:

The main installer script is in `Installer\WixInstaller` folder: `StageInstrument.wxs`. This file includes other needed files.

## Folder structure and files needed:

First make sure you have all needed files compiled and available:

 * StageInstrument executables: `StageInstrument.exe`
 * Executable translations: `/Translations/StageInstrument/*.po`
 * Manual: `StageInstrument.chm`
 * ShellExtension: `ShellExtensionU.dll` and `ShellExtensionX64.dll`
 * Documents: `/Docs/Users/*`
 * Filters: `/Filters/*`

These files are produced by compiling StageInstrument, documentation etc, but that's not subject of this document.

In addition you will need Microsoft C- and MFC-runtime merge modules. Those files are not distributes with StageInstrument. By default we use VS2008 merge modules from the `%CommonProgramFiles%\Merge Modules` folder:

 * `Microsoft_VC90_CRT_x86.msm`
 * `Microsoft_VC90_MFC_x86.msm`
 * `Microsoft_VC90_CRT_x86_x64.msm`
 * `Microsoft_VC90_MFC_x86_x64.msm`

### Folder structure

Copy or move the files into the following layout:

 * `Manual/htmlhelp`
   * `StageInstrument.chm`
 * `Release/`
   * `ShellExtensionU.dll`
   * `StageInstrument.exe`
 * `ShellExtensionX64/`
   * `ShellExtensionX64.dll`
 * `Docs/`
   * `Users`
     * Copy the entire `Docs/Users` folder to here
 * `Filters/`
   * `FileFilter.tmpl`
   * `*.flt`
 * `Installer/`
   * `WIX/`
     * Copy the entire `Installer/WIX` folder to here
 * `Translations/`
   * `Docs`
     * `*.*`
   * `StageInstrument`
     * `*.po`

## Running WIX tools to create installer

`StageInstrument.wxs` is script used to create StageInstrument MSI installer. Other tools and IDEs can be used also. For example WixEdit or SharpDevelop.

### Building with MSBuild

Open the Visual Studio command prompt and CD to `Installer/WixInstaller`-folder. Run command: 

```
msbuild.exe StageInstrument.wixproj
```

There are two commonly used parameters: 

 * Platform: `/p:Platform=x86` or `/p:Platform=x64`
 * Version: `/p:ProductVersion=x.x.x`. If the version number is not given it is read from `Config.wxi`. But then filename does not contain version number.

For example:

```
msbuild.exe StageInstrument.wixproj /p:Platform=x86,ProductVersion=1.0.2
```

If the compile succeeds you have `StageInstrument-[platform]-Setup.msi` files in `Build\WiX\Release\` folder's subfolders. 

**Test installer!**
