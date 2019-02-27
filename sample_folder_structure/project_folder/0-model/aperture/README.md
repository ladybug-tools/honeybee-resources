# aperture

`/0-model/aperture`

`aperture` folder includes all the apertures in your model. An aperture is a geometry
that allows the light from sky and sunlight to enter into your space. Apertures are
either dynamic or static.

![apertures](https://user-images.githubusercontent.com/2915573/53457677-434cdd80-3a01-11e9-8fda-c9154dae0f34.jpg)

The root directory should stay empty and the aperture files should be copied to one of
the `static` or `dynamic` sub-folders.

Dynamic apertures have different `states`. A very common case is windows with dynamic
blinds. In such case each state of dynamic blind should be defined as a separate state.
You can have as many as dynamic aperture as needed in your model. Keep in mind that the
contribution from each dynamic aperture will be calculated separately.

Static apertures are represented by a single state which is the default material of the
aperture. All the static apertures in the scene should be inside `/0-model/aperture/static`
folder. The contribution from all the static aperture will be calculated together.

In this sample model the `south window` is the only dynamic aperture in the model with
two states.

![Dynamic aperture](https://user-images.githubusercontent.com/2915573/53457693-4cd64580-3a01-11e9-821c-0ac767090059.jpg)

The `skylight` and `south_window_top` are the two static apertures.

![Static aperture](https://user-images.githubusercontent.com/2915573/53457736-66778d00-3a01-11e9-9595-4bea03a66522.jpg)

### Important NOTE:

**Interior transparent/ translucent geometries are <u>not</u> apertures** and should be
included in `etc` folder. This is critical since during the calculation of separate
contributions from apertures all the other apertures will be blacked out. This is not
the case for interior glass.

See [this post](https://github.com/ladybug-tools/honeybee/wiki/How-does-Honeybee%5B-%5D-set-up-the-input-files-for-multi-phase-daylight-simulation#how-does-honeybee-handles-such-cases)
to read more on how Honeybee calculates the contribution from each aperture separately.
