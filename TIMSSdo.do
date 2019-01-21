use TIMSS.dta, clear //
tab IDCNTRY
tab IDCNTRY E_SEX
tab IDCNTRY E_SEX, miss //para identificar el número de datos perdidos
tab IDCNTRY E_SEX if IDCNTRY==222, miss
tab E_SEX if IDCNTRY==392, miss
svyset IDSCHOOL [pw=TOTWGT]
save TIMSS, replace
svy: tab E_SEX if IDCNTRY==392, miss
svy: tab E_BOOK if IDCNTRY==392, miss
svy: tab E_BOOK if IDCNTRY==222, miss
pv, pv(BSMMAT0*):svy: reg @pv E_BOOK if IDCNTRY==392
pv, pv(BSMMAT0*):svy: reg @pv E_BOOK if IDCNTRY==222
help pv
pv, pv(BSMMAT0*):svy: reg @pv E_SEX if IDCNTRY==392
pv, pv(BSMMAT0*):svy: reg @pv E_SEX if IDCNTRY==222

pv, pv(BSMMAT0*):svy: reg @pv E_SEX E_BOOK if IDCNTRY==392
pv, pv(BSMMAT0*):svy: reg @pv E_SEX E_BOOK if IDCNTRY==222
