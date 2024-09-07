# Text adapting 3D model

There are use cases where it would be nice to have a 3D model adapt to the text it encapsules and with the `textmetrics` function in [OpenSCAD](https://openscad.org/) this is possible.

For example:

<image src="./Screenshot 2024-09-07 at 07.29.58.png" width="300" />

This model is rendered by the code in [text-test.scad](./text-test.scad) and the cube containing the text adapts to the size of the text so that it is always just a bit bigger.

I had to install OpenSCAD with `brew install openscad@snapshot` for this to work as the `textmetrics` were only available in the development snapshots.

## References
* [Text Metrics/Font Metrics](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/WIP#Text_Metrics_/_Font_Metrics)