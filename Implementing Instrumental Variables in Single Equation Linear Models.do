
clear

cd "/Users/zhouxijie/STATA/data"

use card.dta

describe

sum educ lwage

*data manulation
gen miss_feduc=1 if fatheduc==.
replace miss_feduc=0 if miss_feduc==.
gen miss_meduc=1 if motheduc==.
replace miss_meduc=0 if miss_meduc==.
replace fatheduc=0 if fatheduc==.
replace motheduc=0 if motheduc==. 

* Question a
reg lwage educ exper expersq black south smsa reg661-reg668 smsa66, r

* Question b
reg educ exper expersq black south smsa reg661-reg668 smsa66 nearc4, r

* Question c
ivreg lwage exper expersq black south smsa reg661-reg668 smsa66 (educ=nearc4), r

* Question d
ivreg lwage exper expersq black south smsa reg661-reg668 smsa66 (educ=nearc2 nearc4), r

reg educ exper expersq black south smsa reg661-reg668 smsa66 nearc2 nearc4, r

* Question e
reg iq nearc4, r

* Question f
reg iq nearc4 smsa66 reg661 reg662 reg669, r

