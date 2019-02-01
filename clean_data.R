#!\usr\bin\Rscript
# Organizes raw NAPLAN data into workable format
#
# Files that must be in the working directory:
#   student_deidentified_2013.csv
#   student_deidentified_2014.csv
#
# Output files:
#   NAPLAN_data.csv
setwd("~/rob.garrard@csiro.it/Projects/Classification of High Risk Students/R Codes/2019.01.01")

data.2013 <- read.csv('student_deidentified_2013.csv')
data.2014 <- read.csv('student_deidentified_2014.csv')

# Dimensions of each data set.
print(dim(data.2013))
print(dim(data.2014))

# These data sets have the same columns. Merge them vertically.

data <- rbind(data.2013, data.2014)
rm(list=c('data.2013', 'data.2014'))

# Take a look at the total size of data and its column names.
dim(data)
colnames(data)

# Drop the unnecessary columns.
to.drop <- c(3, 4, 5, 17:27)
data <- data[, -to.drop]

# Rename columns
print(colnames(data))

new.names <- c('state', 'grade', 'private', 'age', 'female',
               'indigenous', 'LBOTE', 'mumschool', 'mumhighed',
               'mumoccup', 'dadschool', 'dadhighed', 'dadoccup',
               'readscore', 'writescore', 'spellscore', 'gramscore',
               'numscore', 'sameschool', 'prevreadscore', 'prevwritescore',
               'prevspellscore', 'prevgramscore', 'prevnumscore')
colnames(data) <- new.names

# Rearrange columns to have regressors on RHS
new.order <- c(14, 18, 15:17, 2:7, 1, 19, 8:13, 20, 24, 21:23)
data <- data[, new.order]

# Missing data coded as 9 in some variables, 0 in others. Replace with NAs.
data$LBOTE[data$LBOTE == 9] <- NA
data[, 14:19][data[, 14:19] == 9] <- NA
data[, 14:19][data[, 14:19] == 0] <- NA



# Set relevant variables to factors.
factors <- c(6, 7, 9:19)
for (i in factors){
  data[, i] <- factor(data[, i])
}

# Change the levels of some factors
levels(data$private) <- c(0, 1)
levels(data$female) <- c(0, 1)
levels(data$grade) <- c(3, 5, 7, 9)
levels(data$LBOTE) <- c(0, 1)

summary(data)
#############################
# Now we have clean data (but filled with NAs). This
# is ready for predictive regression. Let's save it.
save(data, file='NAPLAN_data_reg.Rda')

# In order to do predictive classification, we
# first need to classify each student's score
# as either "below standard" or "at standard".
#
# Let's create two new dummy variables representing
# these classes for the numeracy and reading scores
# as well as previous scores.
# For the time being, we're not doing grammer, 
# spelling, and writing.
to.drop <- c(3:5, 22:24)
data <- data[, -to.drop]

# Replace readscore and numscore by 0 or 1 depending on
# whether they reach the cutoff for their grade.
# Recall that the first 1,117,362 observations are 2013,
# with the remaining 1,121,629 from 2014. Since the cutoff
# scores for minimum standards are different depending on
# the year the test was sat, we need to add in a temporary
# year variable.
year <- rep(2013, dim(data)[1])
year[1117363:length(year)] <- 2014
year <- factor(year)
data <- cbind(data, year)

####################################
# What follows is a set of decision rules for
# determining whether or not a student is achieving
# minimum standards. The rule is a threshold for 
# the score achieved by a student on each section
# of NAPLAN. The threshold depends on the grade
# the student is in, and is updated each year,
# so the threshold is calculated using score,
# grade, and year the test was sat.

# Create readrisk and numrisk variables.
data <- data.frame(readrisk=0, numrisk=0, data)

data$readrisk[data$grade==3 & data$year==2013 & data$readscore<=322] <- 1
data$readrisk[data$grade==3 & data$year==2014 & data$readscore<=319] <- 1
data$readrisk[data$grade==5 & data$year==2013 & data$readscore<=419] <- 1
data$readrisk[data$grade==5 & data$year==2014 & data$readscore<=424] <- 1
data$readrisk[data$grade==7 & data$year==2013 & data$readscore<=477] <- 1
data$readrisk[data$grade==7 & data$year==2014 & data$readscore<=473] <- 1
data$readrisk[data$grade==9 & data$year==2013 & data$readscore<=528] <- 1
data$readrisk[data$grade==9 & data$year==2014 & data$readscore<=529] <- 1

data$numrisk[data$grade==3 & data$year==2013 & data$numscore<=314] <- 1
data$numrisk[data$grade==3 & data$year==2014 & data$numscore<=317] <- 1
data$numrisk[data$grade==5 & data$year==2013 & data$numscore<=422] <- 1
data$numrisk[data$grade==5 & data$year==2014 & data$numscore<=424] <- 1
data$numrisk[data$grade==7 & data$year==2013 & data$numscore<=477] <- 1
data$numrisk[data$grade==7 & data$year==2014 & data$numscore<=476] <- 1
data$numrisk[data$grade==9 & data$year==2013 & data$numscore<=526] <- 1
data$numrisk[data$grade==9 & data$year==2014 & data$numscore<=527] <- 1

# Drop readscore and numscore
data <- data[, -c(3, 4)]
data$readrisk <- factor(data$readrisk)
data$numrisk <- factor(data$numrisk)

levels(data$readrisk) <- c("At Standard", "Below Standard")
levels(data$numrisk) <- c("At Standard", "Below Standard")


##############################################
# Want to do exactly the same thing but for previous
# reading and numeracy score. The previous NAPLAN
# would have been sat in 2010 and 2011 respectively.

# For now, let's just use the same cutoffs.
# Create readrisk and numrisk variables.
data <- data.frame(data, prevreadrisk=0, prevnumrisk=0)


data$prevreadrisk[data$grade==3] <- NA
data$prevreadrisk[data$grade==5 & data$year==2013 & data$prevreadscore<=318] <- 1
data$prevreadrisk[data$grade==5 & data$year==2014 & data$prevreadscore<=319] <- 1
data$prevreadrisk[data$grade==7 & data$year==2013 & data$prevreadscore<=416] <- 1
data$prevreadrisk[data$grade==7 & data$year==2014 & data$prevreadscore<=420] <- 1
data$prevreadrisk[data$grade==9 & data$year==2013 & data$prevreadscore<=475] <- 1
data$prevreadrisk[data$grade==9 & data$year==2014 & data$prevreadscore<=473] <- 1

data$prevnumrisk[data$grade==3] <- NA
data$prevnumrisk[data$grade==5 & data$year==2013 & data$prevnumscore<=322] <- 1
data$prevnumrisk[data$grade==5 & data$year==2014 & data$prevnumscore<=312] <- 1
data$prevnumrisk[data$grade==7 & data$year==2013 & data$prevnumscore<=417] <- 1
data$prevnumrisk[data$grade==7 & data$year==2014 & data$prevnumscore<=421] <- 1
data$prevnumrisk[data$grade==9 & data$year==2013 & data$prevnumscore<=476] <- 1
data$prevnumrisk[data$grade==9 & data$year==2014 & data$prevnumscore<=476] <- 1

data <- data[, -c(17:19)]
data$prevnumrisk <- factor(data$prevnumrisk)
data$prevreadrisk <- factor(data$prevreadrisk)

levels(data$prevnumrisk) <- c("At Standard", "Below Standard")
levels(data$prevreadrisk) <- c("At Standard", "Below Standard")


# Save data for predictive classification.
save(data, file='NAPLAN_data_clas.Rda')

print("Done!")


