# outdoor opaque geometries

`/0-model/etc/opaque/outdoor`

This in an optional folder for <u>outdoor-only</u> geometries. Naming convention is
the same as `./0-model/etc/opaque`. These files will only be included in daylight matrix
calculation and will not be part of the view matrix calculation. Separating the files
is helpful to relax radiance parameters for view matrix calculation by minimizing the
size of the scene.

<u>This folder is only useful for 3-Phase and 5-Phase studies</u>. For other recipes the
files in `outdoor` folder will be part of the study just like any other geometry file in
`/0-model/etc/opaque` folder.

In this sample case the ground floor and the neighbor building are included in `outdoor`
folder.

![context](https://user-images.githubusercontent.com/38131342/53503552-4803a700-3a7e-11e9-9083-29614294fa38.jpg)
