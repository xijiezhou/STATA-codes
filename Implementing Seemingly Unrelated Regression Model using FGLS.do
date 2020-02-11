clear

cd "/Users/zhouxijie/STATA/data"

use ChristensenGreene1976.dta

keep if _n<=123 /* only use observations 1-123 */

describe

* Set the term related to lnY equal to 0

gen lnC = log(cost)
gen lnY = log(q)
gen lnP_L = log(pl)
gen lnP_K = log(pk)
gen lnP_F = log(pf)

gen lnY2 = (lnY)^2/2
gen lnP_LL = (lnP_L)^2/2
gen lnP_KK = (lnP_K)^2/2
gen lnP_FF = (lnP_F)^2/2

gen lnP_LK = lnP_L*lnP_K/2
gen lnP_LF = lnP_L*lnP_F/2
gen lnP_KF = lnP_K*lnP_F/2

gen lnYL = lnY*lnP_L
gen lnYK = lnY*lnP_K
gen lnYF = lnY*lnP_F

**calculate normalized input prices
gen lnPK_PF=lnP_K-lnP_F
gen lnPL_PF=lnP_L-lnP_F

*******************Define Constraints**********************
***Model specification
*(1)
constraint define 1 [lnC]lnP_L + [lnC]lnP_K + [lnC]lnP_F = 1
*(2)
constraint define 2 [lnC]lnYL + [lnC]lnYK + [lnC]lnYF = 0
*(3)
constraint define 3 [lnC]lnP_LL + [lnC]lnP_LK + [lnC]lnP_LF = 0
constraint define 4 [lnC]lnP_LK + [lnC]lnP_KK + [lnC]lnP_KF = 0
constraint define 5 [lnC]lnP_LF + [lnC]lnP_KF + [lnC]lnP_FF = 0

*(6) and cost function
**capital
constraint define  6 [sk]_cons=[lnC]lnP_K
constraint define  7 [sk]lnPK_PF=[lnC]lnP_KK
constraint define  8 [sk]lnPL_PF=[lnC]lnP_LK
constraint define  9 [sk]lnY=[lnC]lnYK

**labor
constraint define  10 [sl]_cons=[lnC]lnP_L
constraint define  11 [sl]lnPL_PF=[lnC]lnP_LL
constraint define  12 [sl]lnY=[lnC]lnYL

**cross equation
constraint define 13 [sk]lnPL_PF=[sl]lnPK_PF

**impose the restriction from homotheticity, or straightly delete the parameter???
constraint define 14 [sl]lnY = 0
constraint define 15 [sk]lnY = 0

********************Model A********************************
*compare with B!
sureg (lnC lnY lnY2 lnP_L lnP_K lnP_F lnP_LL lnP_KK lnP_FF lnP_LK lnP_LF lnP_KF lnYL lnYK lnYF) (sl lnY lnPL_PF lnPK_PF) (sk lnY lnPL_PF lnPK_PF), isure constraints(1-13)
matrix list e(Sigma)
display log(det(e(Sigma)))


***calculate returns to scale using Model A estimates
gen RTS_A=(1-(_b[lnY] + _b[lnY2]*lnY+_b[lnYK]*lnP_K+_b[lnYL]*lnP_L+_b[lnYF]*lnP_F))
xtile cats_A=q, nq(5)
tabstat q, by (cats_A) stat (mean p50)
tabstat RTS_A, by (cats_A) stat (mean p50)

********************Model B********************************
sureg (lnC lnY lnY2 lnP_L lnP_K lnP_F lnP_LL lnP_KK lnP_FF lnP_LK lnP_LF lnP_KF lnYL lnYK lnYF) (sl lnY lnPL_PF lnPK_PF) (sk lnY lnPL_PF lnPK_PF), isure constraints(1-15)
matrix list e(Sigma)
display log(det(e(Sigma)))

***calculate returns to scale using Model B estimates
gen RTS_B=(1-(_b[lnY] + _b[lnY2]*lnY+_b[lnYK]*lnP_K+_b[lnYL]*lnP_L+_b[lnYF]*lnP_F))
xtile cats_B=q, nq(5)
tabstat q, by (cats_B) stat (mean p50)
tabstat RTS_B, by (cats_B) stat (mean p50)
