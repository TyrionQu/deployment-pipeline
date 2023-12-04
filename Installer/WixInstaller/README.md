# Building StageInstrument MSI Installer

## Needed programs:

 * [WiX](http://wixtoolset.org/) version 3.5 or later.
 * [MSBuild](https://docs.microsoft.com/en-us/visualstudio/msbuild/msbuild-reference?view=vs-2019). MSBuild is part of .NET 2.0 or later SDK.

## Installer script:

The main installer script is in `Installer\WixInstaller` folder: `StageInstrument.wxs`. This file includes other needed files.

## Folder structure and files needed:

First make sure you have all needed files compiled and available:

 * StageInstrument executables: `StageInstrument.exe`
 * Executable updater: `/Updater/updater.exe`
 * Manual: `StageInstrument.chm`
 * Documents: `/Docs/Users/*`
 * Plugins: `/Plugins/*`
                           
These files are produced by compiling StageInstrument, documentation etc, but that's not subject of this document.

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
