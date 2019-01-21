use TIMSS.dta, clear //
tab IDCNTRY
tab IDCNTRY E_SEX
tab IDCNTRY E_SEX, miss //para identificar el número de datos perdidos
tab IDCNTRY E_SEX if IDCNTRY==222, miss
tab E_SEX if IDCNTRY==392, miss

