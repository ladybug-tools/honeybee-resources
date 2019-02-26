# aperture
This folder includes all the apertures in the scene including dynamic apertures (aka window group).

File names `apertures..static.000` and `apertures..static.blk` are kept for static windows.

Files for each dynamic aperture should be named as `<name>..<state_name>.<state_count>`. The blacked out file should be named as `<name>..<state_name>.blk` and the glowed version should be named as `<name>..<state_name>.glw`.

Each file should include material and geometry data and should be self-sufficient. `*.blk` file will be used during the calculation for other apertures to black out this aperture*. Keep in mind that glass surfaces like interior windows are not considered as apertures and should be included under scene folder.

<sub>* See [this post](https://github.com/ladybug-tools/honeybee/wiki/How-does-Honeybee%5B-%5D-set-up-the-input-files-for-multi-phase-daylight-simulation#how-does-honeybee-handles-such-cases) to read more on how Honeybee calculates the contribution from each window group separately.</sub>
