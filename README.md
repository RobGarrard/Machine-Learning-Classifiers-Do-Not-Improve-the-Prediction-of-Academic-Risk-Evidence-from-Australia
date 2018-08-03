# A Machine Learning Approach for Detecting Students at Risk of Low Academic Achievement

R codes for <font style="font-variant:small-caps">Cornell-Farrow and Garrard</font> (2018). <i>A Machine Learning Approach for Detecting Students at Risk of Low Academic Achievement</i>. arXiv preprint. <a href='https://arxiv.org/abs/1807.07215'>arXiv:1807.07215</a>


## Data Availability
The data used in this paper are the de-identified individual-level NAPLAN data from 2013 and 2014. This data set is confidential but may be obtained by researchers through ACARA's Data Access Program at <a href="http://www.acara.edu.au/contact-us/acara-data-access">http://www.acara.edu.au/contact-us/acara-data-access</a>.

Researchers must submit a data request form, outlining the project for which the data will be used. Obtaining the individual-level data also requires passing an ethics clearance from your institution. Queries about ACARA's Data Access Program may be directed to <a href="mailto:datarequest@acara.edu.au">datarequest@acara.edu.au</a>. The authorised user of the data set and contact for this project is Sarah Cornell-Farrow, <a href="mailto:sarah.cornell-farrow@adelaide.edu.au">sarah.cornell-farrow@adelaide.edu.au</a>.

ACARA provided two files with the following names:

student\_deidentified\_2013.csv

student\_deidentified\_2014.csv


## Construction of Readrisk and Mathrisk variables

The above data contains raw NAPLAN scores for each student who sat it in 2013-14. In order to turn these raw scores into a 0/1 variable corresponding to a student performing 'below standard', we followed the cutoffs published by ACARA at <a href="http://nap.edu.au/results-and-reports/how-to-interpret/score-equivalence-tables">http://nap.edu.au/results-and-reports/how-to-interpret/score-equivalence-tables</a>. 

In order to process the raw data into the variables used in our study, place the .csv files obtained from ACARA into a folder. Open the Stata file 'createdata.do' and edit the third line (cd "\\...") such that it sets the working directory as the folder in which the ACARA data is stored. Execute the file in Stata. The code will output a Stata data file 'NAPLAN\_data.dta'.

## Estimating the Classifiers

The analysis is split into grade 3, and grades 5 and above. There are 4 Jupyter notebooks, corresponding to: literacy grade 3; numeracy grade 3; literacy grades 5 and above; and numeracy grades 5 and above. Tables and figures in the paper were imported from these outputs. Each time a classifier is run, the random seed is reset to 2718, so the notebooks should produce exactly the same output each time they are excuted.


For any questions or clarifications, contact <a href="mailto:robert.garrard@csiro.au">robert.garrard@csiro.au</a>.



