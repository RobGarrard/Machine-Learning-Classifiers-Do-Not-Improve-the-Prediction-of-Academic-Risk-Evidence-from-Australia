**SET WORKING DIRECTORY**
clear
cd "\\uofa\users$\users8\a1610328\SARAH\StudentData"
**the working directory should be the folder where the ACARA csv data is saved**

**IMPORT DATA**
import delimited student_deidentified_2013.csv, case(preserve)
gen year=0
tempfile student2013
save `student2013'
clear
import delimited student_deidentified_2014.csv, case(preserve)
gen year=1
append using `student2013'
label data "student-level NAPLAN data"

**RENAMING AND LABELLING VARIABLES**
label variable year "=1 if 2014 dataset"
rename RANDOM_SCHOOL_ID school
label variable school "random schoolid"
rename RANDOM_STUDENT_ID student
label variable student "random studentid"
rename AGE age
label variable age "age at time of test to 1 decimal place"
rename INDIGENOUS_STATUS indig
label variable indig "=1 if aboriginal or torres strait islander origin"
rename MOTHER_SCHOOL_EDUCATION mumschool
label variable mumschool "1=year9 2=year10 3=year11 4=year12 (or equivalent)"
replace mumschool=. if mumschool==0
rename MOTHER_NON_SCHOOL_EDUCATION mumhighed
label variable mumhighed "5=certificate I to IV or trade 6=advanced diploma or diploma 7=bachelor 8=none"
replace mumhighed=. if mumhighed==0
rename MOTHER_OCCUP_GROUP mumoccup
label variable mumoccup "1=senior management 2=other business manager 3=trade clerk sales and service 4=machine operator 8=not in paid work"
replace mumoccup=. if mumoccup==9
rename FATHER_SCHOOL_EDUCATION dadschool
label variable dadschool "1=year9 2=year10 3=year11 4=year12 (or equivalent)"
replace dadschool=. if dadschool==0
rename FATHER_NON_SCHOOL_EDUCATION dadhighed
label variable dadhighed "5=certificate I to IV or trade 6=advanced diploma or diploma 7=bachelor 8=none"
replace dadhighed=. if dadhighed==0
rename FATHER_OCCUP_GROUP dadoccup
label variable dadoccup "1=senior management 2=other business manager 3=trade clerk sales and service 4=machine operator 8=not in paid work"
replace dadoccup=. if dadoccup==9
rename TEST_PARTICIPATION_CA part_calc
label variable part_calc "p=present a=absent e=exempt w=withdrawn s=sanctioned abandonment"
rename TEST_PARTICIPATION_NC part_n
label variable part_n "p=present a=absent e=exempt w=withdrawn s=sanctioned abandonment"
rename TEST_PARTICIPATION_R part_r
label variable part_r "p=present a=absent e=exempt w=withdrawn s=sanctioned abandonment"
rename TEST_PARTICIPATION_LC part_l
label variable part_l "p=present a=absent e=exempt w=withdrawn s=sanctioned abandonment"
rename TEST_PARTICIPATION_W part_w
label variable part_w "p=present a=absent e=exempt w=withdrawn s=sanctioned abandonment"
rename NUMERACY_ITEMS_CA numitemscalc
label variable numitemscalc "numeracy items calculator allowed"
rename NUMERACY_ITEMS_NC numitems
label variable numitems "numeracy items non-calculator"
rename READING_ITEMS readitems
label variable readitems "reading items"
rename LC_SPELLING_ITEMS spellitems
label variable spellitems "language conventions spelling items"
rename LC_G_P_ITEMS gitems
label variable gitems "language conventions grammar and punctuation items"
rename WRITING_ITEMS writems
label variable writems "writing items"
rename WLE_R readscore
label variable readscore "current reading score"
rename WLE_W writescore
label variable writescore "current writing score"
rename WLE_S spellscore
label variable spellscore "current spelling score"
rename WLE_G gramscore
label variable gramscore "current grammar and punctuation score"
rename WLE_N mathscore
label variable mathscore "current numeracy score"
rename SAME_SCHOOL_FLAG sameschool
label variable sameschool "same school flag"
rename prev_WLE_R readprev
label variable readprev "previous reading score"
rename prev_WLE_W writeprev
label variable writeprev "previous writing score"
rename prev_WLE_S spellprev
label variable spellprev "previous spelling score"
rename prev_WLE_G gramprev
label variable gramprev "previous grammar and punctuation score"
rename prev_WLE_N mathprev
label variable mathprev "previous numeracy score"

**GENDER DUMMY**
gen girl = 0
replace girl = 1 if SEX==2
label variable girl "=1 if girl"
drop SEX

**SECTOR DUMMIES**
gen pub = 0
replace pub = 1 if SECTOR=="G"
gen priv = 0
replace priv = 1 if SECTOR=="N"
label variable pub "=1 if government school"
label variable priv "=1 if non-government school"
drop SECTOR

**LOCATION DUMMIES**
gen met = 0
replace met = 1 if GEOLOCATION==1
label variable met "=1 if metropolitan location"
gen provincial = 0
replace provincial = 1 if GEOLOCATION==2
label variable provincial "=1 if provincial location"
gen remote = 0
replace remote = 1 if GEOLOCATION==3
label variable remote "=1 if remote or very remote location"
drop GEOLOCATION

**LBOTE DUMMY**
gen lbote = 0
replace lbote = 1 if LBOTE_STATUS=="Y"
replace lbote=. if LBOTE_STATUS=="9"
label variable lbote "=1 if language background other than english"
drop LBOTE_STATUS

**STATE DUMMIES**
gen SA = 0
replace SA = 1 if TAA=="SA"
label variable SA "=1 if South Australia"
gen NSW = 0
replace NSW = 1 if TAA=="NSW"
label variable NSW "=1 if New South Wales"
gen TAS = 0
replace TAS = 1 if TAA=="TAS"
label variable TAS "=1 if Tasmania"
gen VIC = 0
replace VIC = 1 if TAA=="VIC"
label variable VIC "=1 if Victoria"
gen QLD = 0
replace QLD = 1 if TAA=="QLD"
label variable QLD "=1 if Queensland"
gen WA = 0
replace WA = 1 if TAA=="WA"
label variable WA "=1 if Western Australia"
gen ACT = 0
replace ACT = 1 if TAA=="ACT"
label variable ACT "=1 if Australian Capital Territory"
gen NT = 0
replace NT = 1 if TAA=="NT"
label variable NT "=1 if Northern Territory"
drop TAA

**GRADE VARIABLE**
gen grade = 3
replace grade = 5 if YEAR_LEVEL=="Y5"
replace grade = 7 if YEAR_LEVEL=="Y7"
replace grade = 9 if YEAR_LEVEL=="Y9"
drop YEAR_LEVEL
label variable grade "grade of student in current year"

**SIMPLIFY IDS**
egen schoolid=group(school)
label variable schoolid "random school id"
drop school
replace schoolid=. if schoolid==1
egen studentid=group(schoolid year grade student)
label variable studentid "random student id"
drop student

**GENERATE COHORT VARIABLES**
egen cohort = group(schoolid year grade)
label variable cohort "cohort id for students in the same school, grade and year"
egen nstudent=count(studentid), by(cohort)
label variable nstudent "number of students in cohort"
egen meanreadscore=mean(readscore), by(cohort)
label variable meanreadscore "average cohort reading score"
egen meanmathscore=mean(mathscore), by(cohort)
label variable meanmathscore "average cohort numeracy score"

**CREATE BANDS**
gen mathband=6
label variable mathband "math band student situated in"
replace mathband=5 if mathscore<475 & grade==3 & year==1
replace mathband=4 if mathscore<417 & grade==3 & year==1
replace mathband=3 if mathscore<369 & grade==3 & year==1
replace mathband=2 if mathscore<317 & grade==3 & year==1
replace mathband=1 if mathscore<252 & grade==3 & year==1
replace mathband=8 if grade==5 & year==1
replace mathband=7 if mathscore<572 & grade==5 & year==1
replace mathband=6 if mathscore<529 & grade==5 & year==1
replace mathband=5 if mathscore<471 & grade==5 & year==1
replace mathband=4 if mathscore<424 & grade==5 & year==1
replace mathband=7 if mathscore<371 & grade==5 & year==1
replace mathband=9 if grade==7 & year==1
replace mathband=8 if mathscore<632 & grade==7 & year==1
replace mathband=7 if mathscore<580 & grade==7 & year==1
replace mathband=6 if mathscore<529 & grade==7 & year==1
replace mathband=5 if mathscore<476 & grade==7 & year==1
replace mathband=4 if mathscore<424 & grade==7 & year==1
replace mathband=10 if grade==9 & year==2014
replace mathband=9 if mathscore<682 & grade==9 & year==1
replace mathband=8 if mathscore<631 & grade==9 & year==1
replace mathband=7 if mathscore<578 & grade==9 & year==1
replace mathband=6 if mathscore<527 & grade==9 & year==1
replace mathband=5 if mathscore<473 & grade==9 & year==1
replace mathband=5 if mathscore<475 & grade==3 & year==0
replace mathband=4 if mathscore<417 & grade==3 & year==0
replace mathband=3 if mathscore<366 & grade==3 & year==0
replace mathband=2 if mathscore<314 & grade==3 & year==0
replace mathband=1 if mathscore<264 & grade==3 & year==0
replace mathband=8 if grade==5 & year==0
replace mathband=7 if mathscore<571 & grade==5 & year==0
replace mathband=6 if mathscore<529 & grade==5 & year==0
replace mathband=5 if mathscore<475 & grade==5 & year==0
replace mathband=4 if mathscore<422 & grade==5 & year==0
replace mathband=7 if mathscore<371 & grade==5 & year==0
replace mathband=9 if grade==7 & year==0
replace mathband=8 if mathscore<631 & grade==7 & year==0
replace mathband=7 if mathscore<578 & grade==7 & year==0
replace mathband=6 if mathscore<526 & grade==7 & year==0
replace mathband=5 if mathscore<477 & grade==7 & year==0
replace mathband=4 if mathscore<423 & grade==7 & year==0
replace mathband=10 if grade==9 & year==0
replace mathband=9 if mathscore<683 & grade==9 & year==0
replace mathband=8 if mathscore<632 & grade==9 & year==0
replace mathband=7 if mathscore<580 & grade==9 & year==0
replace mathband=6 if mathscore<526 & grade==9 & year==0
replace mathband=5 if mathscore<477 & grade==9 & year==0

gen readband=6
label variable readband "read band student situated in"
replace readband=5 if readscore<467 & grade==3 & year==1
replace readband=4 if readscore<420 & grade==3 & year==1
replace readband=3 if readscore<365 & grade==3 & year==1
replace readband=2 if readscore<319 & grade==3 & year==1
replace readband=1 if readscore<269 & grade==3 & year==1
replace readband=8 if grade==5 & year==1
replace readband=7 if readscore<577 & grade==5 & year==1
replace readband=6 if readscore<528 & grade==5 & year==1
replace readband=5 if readscore<475 & grade==5 & year==1
replace readband=4 if readscore<424 & grade==5 & year==1
replace readband=7 if readscore<369 & grade==5 & year==1
replace readband=9 if grade==7 & year==1
replace readband=8 if readscore<631 & grade==7 & year==1
replace readband=7 if readscore<579 & grade==7 & year==1
replace readband=6 if readscore<526 & grade==7 & year==1
replace readband=5 if readscore<473 & grade==7 & year==1
replace readband=4 if readscore<421 & grade==7 & year==1
replace readband=10 if grade==9 & year==1
replace readband=9 if readscore<684 & grade==9 & year==1
replace readband=8 if readscore<627 & grade==9 & year==1
replace readband=7 if readscore<576 & grade==9 & year==1
replace readband=6 if readscore<529 & grade==9 & year==1
replace readband=5 if readscore<478 & grade==9 & year==1
replace readband=5 if readscore<469 & grade==3 & year==0
replace readband=4 if readscore<424 & grade==3 & year==0
replace readband=3 if readscore<369 & grade==3 & year==0
replace readband=2 if readscore<322 & grade==3 & year==0
replace readband=1 if readscore<266 & grade==3 & year==0
replace readband=8 if grade==5 & year==0
replace readband=7 if readscore<574 & grade==5 & year==0
replace readband=6 if readscore<523 & grade==5 & year==0
replace readband=5 if readscore<471 & grade==5 & year==0
replace readband=4 if readscore<419 & grade==5 & year==0
replace readband=7 if readscore<368 & grade==5 & year==0
replace readband=9 if grade==7 & year==0
replace readband=8 if readscore<627 & grade==7 & year==0
replace readband=7 if readscore<575 & grade==7 & year==0
replace readband=6 if readscore<523 & grade==7 & year==0
replace readband=5 if readscore<477 & grade==7 & year==0
replace readband=4 if readscore<419 & grade==7 & year==0
replace readband=10 if grade==9 & year==0
replace readband=9 if readscore<686 & grade==9 & year==0
replace readband=8 if readscore<630 & grade==9 & year==0
replace readband=7 if readscore<580 & grade==9 & year==0
replace readband=6 if readscore<528 & grade==9 & year==0
replace readband=5 if readscore<478 & grade==9 & year==0

gen readrisk=0
label variable readrisk "0 if above standard, 1 if below standard"
replace readrisk=1 if grade==3 & readband==1
replace readrisk=1 if grade==5 & readband==3
replace readrisk=1 if grade==7 & readband==4
replace readrisk=1 if grade==9 & readband==5

gen mathrisk=0
label variable mathrisk "0 if above standard, 1 if below standard"
replace mathrisk=1 if grade==3 & mathband==1
replace mathrisk=1 if grade==5 & mathband==3
replace mathrisk=1 if grade==7 & mathband==4
replace mathrisk=1 if grade==9 & mathband==5

**DROP VARIABLES**
drop part_calc part_n part_r part_l part_w *\ 
\* numitemscalc numitems readitems spellitems gitems writems *\
\* writescore spellscore gramscore testdate mathband readband

**SAVE DATASET**
save NAPLAN_data, replace
