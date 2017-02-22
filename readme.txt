Selecting box mode:
1. The selecting box mode is the default mode, which is the mode used when starting the app;
2. The you can draw a selecting box in this mode to highlight the data lines in the box, lines selected by the box are highlighted in blue.
3. You can click the arrows under the parallel coordinates to flip the order of each column (decreasing and increasing), the dimension coloring direction will also changed when you flip the dimension chosen to do the coloring.
4. Hovering is implemented in this mode, lights being hovered will be colored in purple. To make hovering easier for users, the app takes vague hovering, and if several lines are very closed to the mouse point, they will all be highlighted.
5. In this mode, all lines are colored by the selected dimension, the default dimension used to decide the coloring is the first column in the css file.

(Extra credit part)Dimension selector mode:
1. You could enable/disable this mode by clicking the square on the bottom right of the page. If this mode is enabled, it will be colored in green.
2. You could drag the arrows on each dimension bar to adjust the range to put on this dimension. If a row of data matches the ranges of all dimension, it is highlighted in dark red.
3. The default setting of this mode is include all lines in the range, so all the lines are colored in dark red initially.
4. If you disable the mode and reenable it, the status of ranges of all dimensions will be kept.
5. In this mode, the selecting box and the dimension coloring functions are disabled, but the hovering and dimension flipper is still available.

Data:
(Extra credit part) 1. The default csv data used “real_population_USA.csv” is the real world data of the 50 cities with top population in 2010 in USA.
2. I also wrote a small application to generate some data randomly (data_generator also in the zip file), you could also find an csv of already generated file (generated_data.csv in data folder), the only problem is the name of each column is not readable :( To run the generator, try run “./data_generator -column 5 -row 10”, and you will find a “data.csv” under the same folder.
3. A simple data.csv is hard-coded for simple test in data folder
