# PaleoAnim
An R Shiny app animating several environmental variables over the past 800k years using the data set published in:

> Krapp *et al.* 2021. A statistics-based reconstruction of high-resolution global terrestrial climate for the last 800,000 years. *Scientific Data* 8:228.  doi:10.1038/s41597-021-01009-3

The environmental variables include:
* Land and Land-ice
* Mega-biomes
* Mean annual temperature
* Annual precipitation

## Running the app
There are two ways to run the app: temporary download using the function *runGitHub()* in the R shiny package, and permanently downloading the full archive to your computer and runing it locally.

> Note: The total volume of files associated with the app is about 190MB

### Temporary download method
Make sure that the *shiny*, *shinydashboard*, and *stringr* R packages have been installed in your local R installation. 

Enter the following commands in the R console or the console panel of RStudio:

    library(shiny)
    runGitHub("peterbat1/PaleoAnim")

The app will be downloaded (be patient, it's a big data set!) and should open in a browser tab. **The app will run as long as you do not close your browser or browser tab.**

If you do close the browser or browser tab, or close the R console, or RStudio, you will have to download a new copy to run it again.

### Permanent download method
Make sure that the *shiny*, *shinydashboard*, and *stringr* R packages have been installed in your local R installation.

Click on the "Code" button and select "Download ZIP" option.

When it has downloaded, place the file in a folder *above* the level you would like the program folder to be located.

Extract the zipped archive which will create the folder "PaleoAnim".

Within PaleoAnim you will see the file app.R which can be loaded and run in RStudio by clicking on the "Run app" option.

Alternatvely, you can run it in the R console by typing the command:

    runApp("/path/to/PaleoAnim/app.R")

substituting, of course, the path to the PaleoAnim folder on your computer for "/path/to".


