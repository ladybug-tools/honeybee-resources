# photon mapping

A folder that includes resources related to Radiance photon mapping!


## Links of interest

* Wikipedia: [Photon Mapping]( https://en.wikipedia.org/wiki/Photon_mapping (

> In computer graphics, photon mapping is a two-pass global illumination algorithm developed by Henrik Wann Jensen that approximately solves the rendering equation. Rays from the light source and rays from the camera are traced independently until some termination criterion is met, then they are connected in a second step to produce a radiance value. It is used to realistically simulate the interaction of light with different objects. Specifically, it is capable of simulating the refraction of light through a transparent substance such as glass or water, diffuse interreflection between illuminated objects, the subsurface scattering of light in translucent materials, and some of the effects caused by particulate matter such as smoke or water vapor. It can also be extended to more accurate simulations of light such as spectral rendering.
>
> Unlike path tracing, bidirectional path tracing, volumetric path tracing and Metropolis light transport, photon mapping is a "biased" rendering algorithm, which means that averaging many renders using this method does not converge to a correct solution to the rendering equation. However, since it is a consistent method, any desired accuracy can be achieved by increasing the number of photons.

