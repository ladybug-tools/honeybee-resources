# Project folder

This is a proposal folder/ file structure for daylight studies.

## GOAL

The ultimate goal of this project is to provide an input data folder/ file structure that
can be used both by Radiance users and software developers. Using an standard folder
structure will makes it easy to use different tools/ scripts regardless of the source of
the files.

```
└─project_folder
├───0-model
│   ├───aperture
│   │   ├───dynamic
│   │   └───static
│   ├───bsdf
│   └───etc
│       ├───opaque
│       │   ├───exterior
│       │   └───interior
│       └───non-opaque
│           ├───exterior
│           └───interior
├───1-lightsource
│   ├───ies
│   ├───sky
│   ├───sun
│   └───wea
├───2-sensorgrid
├───3-view
├───4-output
│   ├───matrix
│   └───temp
└───5-postprocess
```
