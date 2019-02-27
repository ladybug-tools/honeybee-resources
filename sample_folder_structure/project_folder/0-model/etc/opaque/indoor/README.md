# interior opaque geometries

`/0-model/etc/opaque/interior`

This in an optional folder for <u>indoor-only</u> geometries. Naming convention is
the same as `./0-model/etc/opaque`. These files will only be included in view matrix
calculation and will not be part of daylight matrix. Separating the files is helpful to
relax radiance parameters for different phases of matrix-based studies.

<u>This folder is only useful for 3-Phase and 5-Phase studies</u>. For other recipes the
files in `indoor` folder will be part of the study just like any other geometry file in
`/0-model/etc/opaque` folder.

In this sample case the indoor partition are included in `indoor` folder.

![opaque_indoor](https://user-images.githubusercontent.com/38131342/53503555-489c3d80-3a7e-11e9-9679-1b0284243be8.jpg)
