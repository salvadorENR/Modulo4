/* first.do
   Do file for A/S Seminar "Stata Overview"
   Illustrates some basic commands */   

//--Load data
clear
use pop2					//or:  use pop2, clear

//--Browse data				//(br) Data Editor (Browse) window
browse						//In Variables panel, can reduce nb shown

//--turn off page-by-page display
set more off		(set more on)
							
//--Describe data
describe					//(de) Summary of dataset variables
codebook 					//Describe data contents
codebook, compact			//nb unique values
summarize					//(su) Mean, Max, Min, Std Dev
count						//(cou) nb Obs	
ds						//Var names						

//--Varlist syntax
summarize value
summarize pop value
summarize d*
summarize gender-country
summarize pop ,detail		//summarize [variable list], options

//--Subset with "if"   (like an SQL Select)
// select some variables and filter observations
list country year if year == 2002
list country year pop if year == 2002 & pop > 50000 
// exclude observations where pop data is missing
list country year pop if year == 2002 & pop > 50000 & pop != .
list country year pop if year == 2002 & pop > 50000 & pop ~= .
list country year pop if year == 2002 & pop > 50000 & ! missing(pop)

//--Subset with "in"
list in 3						//obs 3
list country year pop in 3	
list country year pop in 1/5		//obs 1-5
list country year pop in -10/l		//obs 10th from last to last

//--Delete unneeded cols, rows (cleaning)
codebook, compact					//see vars with only 1 unique value
drop dsex dstatus statutdelapopulation flags 
drop agegroups							

//--Create new variables
generate pop_thous = pop /1000

//boolean var
generate b_countrysize = 0
replace b_countrysize = 1 if pop >= 10000 & pop != .

//--Summarize by group 
count if b_countrysize == 1

//--The "prefixed" command is run for each subgroup of the "by variable"
by b_countrysize: summarize pop				//ERROR: "by" variables must be sorted
sort b_countrysize
by b_countrysize: summarize pop

bysort b_countrysize: summarize pop			//shorthand

//--Create classes 
recode age (0/14=1) (15/64=2) (65/100=3) , generate(agegroup)
tab agegroup		
drop agegroup
// modify groups, add labels
recode age (0/14=1 "Child") (15/20=2 "Teenager") (21/26=3 "Young Adult")  (27/64=4 "Adult") (65/80=5 "Senior") (81/100=6 "Old"), generate(agegroup)
bysort agegroup: summarize pop value
tab agegroup

//--Egnerate (egen) = extensions to "generate"
//  may sometimes want to combine with "by" to simplify creation of new vars
sort country year

browse country year agegroup gender pop 
//see total per year per country
table country year, contents (sum pop)

//want to save these figures as variable 
bysort country year: egen pop_tot = sum(pop)
browse country year agegroup gender pop pop_tot

//--Automatic transformation of string variable into numeric variable
describe gender						//in Variables panel, observe Type of gender variable 
encode gender, generate(gender_num) //observe Type of gender_num variable
							//' Male', 'Female' are now just labels
drop gender
rename gender_num gender
describe gender

//--Labels: dataset, variable 
describe
label data "Training dataset"
label variable pop_thous "Pop in thous"

/*------------Tabulate, Table, Tabstat -------------
		Statistics -
			Summaries, tables and tests
				Tables
					Tabulate
					Table
					Tabstat
					*/
/*--1) tabulate (tab)
		tabulate one-way
		tabulate two-way
		tabulate, summarize()
		*/

//one-way		
tab gender
tab year
tab agegroup

//two-way
tab agegroup gender			//rows & cols of table - def stat: freq
tab gender b_countrysize
tab pop year
tab year , summarize(pop)
tab agegroup gender, summarize(pop) //Mean + Std.Dev + Freq

//tabulate, summarize()
tabulate agegroup gender, summarize(pop) nostandard nofreq

//--2) table
table agegroup gender  		//default stat: nb obs (freq)
table agegroup gender,contents(mean pop mean value) 
							
//--3) tabstat
tabstat agegroup gender  	//don't specify rows & cols
tabstat age pop value , statistics(count mean sd p50 max min)