# etc

`./0-model/etc`

This folder includes all the geometry in model except for the apertures. The files should
be copied into one of the two subfolders:

1. `opaque`: Includes all geometries with opaque materials.
2. `nonopaque`: Includes all geometries with transparent/ translucent and any other modifiers that light can penetrate through.

In direct sunlight calculation the content in `opaque` folder will be blacked out but the
geometry in nonopaque folder will be used as is. 


In most cases there are only 3 files in this folder:

1. `geometry.rad`: This file includes only radiance surfaces and should not include any of the radiance modifiers/materials.
2. `material.rad`: This file includes all the modifiers for surfaces in `geometry.rad`.
3. `material.dir`: This file includes materials for surfaces in `geometry.rad` that will be used for direct calculation. In most of the cases the materials in `material.dir` are black plastic.

Honeybee uses `material.dir` and `geometry.rad` for direct calculation and uses `material.rad` and `geometry.rad` for other cases.

In case you want to separate files for different parts of the scene you should follow the below naming convention:
1. `*_geometry.rad`
2. `*_material.rad`
3. `*_material.dir`

`*_material.dir` file is optional. If not provided Honeybee will generate black material with the same name for every material in `*_material.dir`.


# Sub-folders

## ./opaque/interior

This in an optional folder for <u>interior-only</u> geometries. Naming convention is similar to scene folder. These files will only be included in view matrix calculation and will not be part of daylight matrix. Separating the files is helpful to relax radiance parameters for different phases of matrix-based studies.

<u>This folder is only useful for 3-Phase and 5-Phase studies</u>. For other recipes the files in `interior` folder will be part of the study just like any other geometry file in `scene` folder.

## ./non-opaque/exterior
This in an optional folder for <u>exterior-only</u> geometries. Naming convention is similar to scene folder. These files will only be included in daylight matrix calculation and will not be part of view matrix. Separating the files is helpful to relax radiance parameters for view matrix calculation by minimizing the size of the scene.

<u>This folder is only useful for 3-Phase and 5-Phase studies</u>. For other recipes the files in `exterior` folder will be part of the study just like any other geometry file in `scene` folder.
