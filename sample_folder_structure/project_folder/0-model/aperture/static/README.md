# static aperture

`/0-model/aperture/static`

Static apertures have a single state which is the default material of the aperture.
All the static apertures in the scene should be inside `/0-model/aperture/static`
folder. The contribution from all the static aperture will be calculated together.

In this sample case `south_window_top` and `skylight` are both static and will be grouped
together. Including all the files together is optional as long as you follow the naming
convention.

![Static aperture](https://user-images.githubusercontent.com/2915573/53457736-66778d00-3a01-11e9-9595-4bea03a66522.jpg)

## Naming convention

The files in this folder should be named as:

1. `<filename>.rad`: Includes Radiance geometries/ surfaces.
2. `<filename>.mat`: Includes Radiance materials/ modifiers.
3. `<filename>.blk`: Includes the blacked version of materials in `<filename>.mat` file. This file is needed to black out the static aperture from the scene when calculating the contribution from other apertures in the scene. If the file is not provided Honeybee generates this file from `.mat` file.
