# Machine Learning Classifiers Do Not Improve the Prediction of Academic Risk: Evidence from Australia

R codes for <font style="font-variant:small-caps">Cornell-Farrow and Garrard</font> (2018). <a href='https://arxiv.org/abs/1807.07215'>arXiv:1807.07215</a>


## Data Availability
The data used in this paper are the de-identified individual-level NAPLAN data from 2013 and 2014. This data set is confidential but may be obtained by researchers through ACARA's Data Access Program at <a href="http://www.acara.edu.au/contact-us/acara-data-access">http://www.acara.edu.au/contact-us/acara-data-access</a>.

Researchers must submit a data request form, outlining the project for which the data will be used. Obtaining the individual-level data also requires passing an ethics clearance from your institution. Queries about ACARA's Data Access Program may be directed to <a href="mailto:datarequest@acara.edu.au">datarequest@acara.edu.au</a>. The authorised user of the data set and contact for this project is Sarah Cornell-Farrow, <a href="mailto:sarah.cornell-farrow@adelaide.edu.au">sarah.cornell-farrow@adelaide.edu.au</a>.

ACARA provided two files with the following names:

student\_deidentified\_2013.csv

student\_deidentified\_2014.csv


## Cleaning the Data Set

The above data contains raw NAPLAN scores for each student who sat it in 2013-14. In order to turn these raw scores into a dummy variable corresponding to a student performing 'At Standard' or Below Standard', we followed the cutoffs published by ACARA at <a href="http://nap.edu.au/results-and-reports/how-to-interpret/score-equivalence-tables">http://nap.edu.au/results-and-reports/how-to-interpret/score-equivalence-tables</a>. We use the cutoffs corresponding to the year in which the student sat NAPLAN (i.e., we used 2013 cutoffs for students sitting the test in 2013, etc.) 

In order to process the raw data into the variables used in our study, execute the 'clean_data.R' script with the above two files placed in the working directory. The code will output two R data files, 'NAPLAN\_data\_reg.Rda' and 'NAPLAN\_data\_clas.Rda'. The former has each student's raw score as the dependent variable to be used with regression models, the latter uses ACARA cutoffs to create an 'At Standard'/'Below Standard' dummy as the dependent variable, which is the data set used in this study.

## Estimating the Classifiers

Classifiers may be estimated by running the Jupyter Notebook 'main.ipynb'. This notebook was executed on a computer with 12 cores and a GPU with a total runtime of around 1 hour 15 minutes. 

Elastic net and random forest classifiers exploit parallel processing for bootstrap samples. The neural net is trained on the GPU.

## Environment

We executed the notebook in the following environment:

	- Jupyter notebook with R kernel
	- CUDA v9.0
	- cuDNN v7
	- python v3.6
	- tensorflow-gpu v1.12.0 
	- R v3.5.2 (libraries listed in main.ipynb)
	
Note that tensorflow-gpu does not run on python versions higher than 3.6. If CUDA is not available this may be run with tensorflow on the CPU, however this is not recommended.

If you are using a tensorflow with a GPU, be sure to install the Keras package for R using the GPU option. I.e.,

	install.packages('keras')
	library(keras)
	install_keras(tensorflow='gpu')




For any questions or clarifications, contact <a href="mailto:robert.garrard@csiro.au">robert.garrard@csiro.au</a>.



