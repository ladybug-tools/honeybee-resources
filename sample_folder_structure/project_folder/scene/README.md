# Scene folder

This folder includes all the geometry and material files for the study.

# Sub-folders

## ./aperture
This folder includes all the apertures in the scene including dynamic apertures (aka window group).

File names `apertures..static.000` and `apertures..static.blk` are kept for static windows.

Files for each dynamic aperture should be named as `<name>..<state_name>.<state_count>`. The blacked out file should be named as `<name>..<state_name>.blk` and the glowed version should be named as `<name>..<state_name>.glw`.

Each file should include material and geometry data and should be self-sufficient. `*.blk` file will be used during the calculation for other apertures to black out this aperture*. Keep in mind that glass surfaces like interior windows are not considered as apertures and should be included under scene folder.

<sub>* See [this post](https://github.com/ladybug-tools/honeybee/wiki/How-does-Honeybee%5B-%5D-set-up-the-input-files-for-multi-phase-daylight-simulation#how-does-honeybee-handles-such-cases) to read more on how Honeybee calculates the contribution from each window group separately.</sub>

## ./bsdf
This folder includes \*.xml BSDF files. This folder will be empty unless you are using a BSDF material as a part of the study.

## ./scene
This folder includes all **non** aperture surfaces in the scene. In most cases there are only 3 files in this folder:

1. `geometry.rad`: This file includes only radiance surfaces and should not include any of the radiance modifiers/materials.
2. `material.rad`: This file includes all the modifiers for surfaces in `geometry.rad`.
3. `material.dir`: This file includes materials for surfaces in `geometry.rad` that will be used for direct calculation. In most of the cases the materials in `material.dir` are black plastic.

Honeybee uses `material.dir` and `geometry.rad` for direct calculation and uses `material.rad` and `geometry.rad` for other cases.

In case you want to separate files for different parts of the scene you should follow the below naming convention:
1. `*_geometry.rad`
2. `*_material.rad`
3. `*_material.dir`

`*_material.dir` file is optional. If not provided Honeybee will generate black material with the same name for every material in `*_material.dir`.

## ./scene/interior

This in an optional folder for <u>interior-only</u> geometries. Naming convention is similar to scene folder. These files will only be included in view matrix calculation and will not be part of daylight matrix. Separating the files is helpful to relax radiance parameters for different phases of matrix-based studies.

<u>This folder is only useful for 3-Phase and 5-Phase studies</u>. For other recipes the files in `interior` folder will be part of the study just like any other geometry file in `scene` folder.

## ./scene/exterior
This in an optional folder for <u>exterior-only</u> geometries. Naming convention is similar to scene folder. These files will only be included in daylight matrix calculation and will not be part of view matrix. Separating the files is helpful to relax radiance parameters for view matrix calculation by minimizing the size of the scene.

<u>This folder is only useful for 3-Phase and 5-Phase studies</u>. For other recipes the files in `exterior` folder will be part of the study just like any other geometry file in `scene` folder.


# Minimum scene folder
This folder structure is designed to accommodate all possible daylight recipes but it doesn't mean that all the files are necessary to run a simulation. Here is the minimum files that are needed to create a Honeybee scene which can be used for point in time studies.

### ./scene
1. `geometry.rad`
2. `material.rad`

### ./aperture
1. `apertures..static.000`
