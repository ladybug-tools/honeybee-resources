# interior

This in an optional folder for <u>interior-only</u> geometries. Naming convention is similar to scene folder. These files will only be included in view matrix calculation and will not be part of daylight matrix. Separating the files is helpful to relax radiance parameters for different phases of matrix-based studies.

<u>This folder is only useful for 3-Phase and 5-Phase studies</u>. For other recipes the files in `interior` folder will be part of the study just like any other geometry file in `scene` folder.
