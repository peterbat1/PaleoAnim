# PaleoAnim
An R Shiny app animating several environmental variables over the past 800k years using the data set published in Krapp *et al.* 2021. A statistics-based reconstruction of high-resolution global terrestrial climate for the last 800,000 years. *Scientific Data* 8:228.  doi:10.1038/s41597-021-01009-3

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

If you do close the browser or browser tab, or close the R console, or RStudio, you will have to download a new copy too run it again.

### Permanent download method
Make sure that the *shiny*, *shinydashboard*, and *stringr* R packages have been installed in your local R installation.
