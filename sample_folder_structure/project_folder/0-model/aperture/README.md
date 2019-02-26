# aperture

`/0-model/aperture`

This folder includes all the apertures in your model. An aperture is a geometry that
allows the light from sky and sunlight to enter into your space.

Dynamic apertures are also known as `window groups` and have different states. Each state
can be identified by a different material or add geometry. Each dynamic aperture can have
one or more `State`. In each state the aperture can be defined with several files for
different purposes.

| name | description | use case |
| --- | --- | --- |
| default | Radiance representation as normal geometry | 2-Phase |
| direct | Radiance representation for direct sunlight/ sky calculation. | 2-Phase and 5-Phase |
| blk | Blacked-out Radiance representation to remove the aperture from the study. | 2-Phase and 5-Phase |
| tmtx | Transmission matrix. Most of the time it is a BSDF file. | 3-Phase and 5-Phase |
| inmtx | A glowed representation of the model for inwards matrix calculations. | 3-Phase and 5-Phase |
| outmtx | A glowed representation of the model for outwards matrix calculations. | 3-Phase and 5-Phase |

Static aperture only need to have default, direct and blacked-out representation.

Use a mapping.yaml file to map the location of files for each representation. Here is an
example:

```yaml
south_window:
  state_0:
    name: clear
    default: south_window..default..000.rad
    direct: south_window..direct..000.rad
    blk: south_window..blk..000.rad
    tmtx: .../bsdf/clear.xml
    inmtx: south_window..glw..000.rad
    outmtx: south_window..glw..000.rad
  state_1:
    name: diffuse
    default: south_window..default..001.rad
    direct: south_window..direct..001.rad
    blk: south_window..blk..001.rad
    tmtx: .../bsdf/diffuse.xml
    inmtx: south_window..glw..001.rad
    outmtx: south_window..glw..001.rad
skylight:
  state_0:
    name: diffuse
    default: skylight..default..000.rad
    direct: skylight..direct..000.rad
    blk: skylight..blk..000.rad
    tmtx: .../bsdf/diffuse.xml
    inmtx: skylight..glw..000.rad
    outmtx: skylight..glw..000.rad
```

NOTE:
Interior transparent/ translucent materials are not apertures and should be included in
`etc` folder.

<sub>* See [this post](https://github.com/ladybug-tools/honeybee/wiki/How-does-Honeybee%5B-%5D-set-up-the-input-files-for-multi-phase-daylight-simulation#how-does-honeybee-handles-such-cases) to read more on how Honeybee calculates the contribution from each window group separately.</sub>
