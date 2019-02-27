# aperture

`/0-model/aperture/dynamic`

Dynamic apertures are apertures with one or more states. Each state is represented by
several Radiance files. Each file should contain all the information needed to represent
the aperture at that state. Here is the list of files that should be provided to describe
a single state.

| Name | Description | Use case | Note |
| --- | --- | --- | --- |
| default | Radiance representation with default materials. | sky contribution calculation in ray-tracing and 2-phase |
| direct | Radiance representation for direct sunlight/ sky contribution calculation. | 2-Phase and 5-Phase | For 2-phase calculation this will be the same as default field. In 5-phase, this field will be used for the 5th phase. In most cases you should be using the original geometry or the higher resolution BSDF file. |
| black | Blacked-out Radiance representation to remove the aperture from the study. | All cases with multiple window groups | If this field is not provided, Honeybee will replace the materials in default field with black glass. |
| tmtx | Transmission matrix. A BSDF file with Klemns subdivision. | 3-Phase and 5-Phase | This matrix will be used for matrix multiplication. |
| inmtx | Inwards matrix. The Radiance representation of the model for calculating inwards matrix calculations. | 3-Phase and 5-Phase | The polygon that will be used for inwards matrix calculation should look inwards. The common practice is to use the `glow` material. If this field is empty Honeybee will change the material of default field to glow. It will also reverse the order of the vertices. In 3-phase and 5-phase documentation this step is known as view-matrix calculation. `inmtx` is a more inclusive name as in cases such as modeling a pipeline `inmtx` calculation can happen between two polygons and will not called view matrix. |
| outmtx | Outwards matrix. The Radiance representation of the model for calculating outwards matrix calculations. | 3-Phase and 5-Phase | In most cases the `outmtx` representation will be the same as `inmtx` representation.

The only required field for 2-phase is `default`. For 3-phase study `tmtx` is the required
field. For 5-phase both `default` and `tmtx` are required.

The good-practice is to provide all the different fields unless you are sure that
Honeybee automated methods satisfy the needs for your case.

You should use a mapping.yaml file to indicate the files for each field. In this sample
case we only have a single dynamic aperture: `south_window`.

![Dynamic aperture](https://user-images.githubusercontent.com/2915573/53457693-4cd64580-3a01-11e9-821c-0ac767090059.jpg)

The `yaml` file will look like this:

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
```

You can add more than one aperture to the yaml file. For instance if we wanted to add
another dynamic aperture named skylight we could have add the lines below to the file:

```yaml
# ...
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

## Naming convention
