# ReadMe for run_analysis.R

The script performs the following tasks in order:

* The zip containing the data for the project is downloaded from 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
and the required data extracted from the zip

* Subject ids are added to the training dataset.  This join is simply a row merge
of the two input files

* Activity ids are added to the training dataset.  Again, this join is a simple
row merge

* The previous two steps are repeated for the test dataset.

* The training and test datasets contain the same variables so the test set
is appended to the training set.

* Next we need to add descriptive variable names to the data.  The original
variable names contain duplicates so as a first step we prepend a row number to the
list of names to create unique values.  These slightly ammended values are then applied
to the combined data.

* The Activity ids, currently numeric, are replaced with the descriptive labels
that they represent.  This is done by merging on the labels and then dropping the
original id field

* The columns we are intersted in are then extracted from the data

* Duplicated column names have now been dropped so we remove our prepended id
from the names

* To create the tidy data set we first transpose the data using the subject and
activity identifiers as the id and everthing else as the measure

* We add a mean column for each subject/activity/variable combination

* Finally, the tidy data is written out

Additonal explanation can be found in comments within the script itself.

CodeBook.md describes the variables contained in the final, transformed dataset 