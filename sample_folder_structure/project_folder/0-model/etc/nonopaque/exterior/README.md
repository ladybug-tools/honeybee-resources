# exterior opaque geometries

`./model/non-aperture/opaque/exterior`

This in an optional folder for <u>exterior-only</u> geometries. Naming convention is similar to scene folder. These files will only be included in daylight matrix calculation and will not be part of the view matrix. Separating the files is helpful to relax radiance parameters for view matrix calculation by minimizing the size of the scene.

<u>This folder is only useful for 3-Phase and 5-Phase studies</u>. For other recipes the files in `exterior` folder will be part of the study just like any other geometry file in `model` folder.
