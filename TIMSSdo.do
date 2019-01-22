use TIMSS.dta, clear //
tab IDCNTRY
tab IDCNTRY E_SEX
tab IDCNTRY E_SEX, miss //para identificar el número de datos perdidos
tab IDCNTRY E_SEX if IDCNTRY==222, miss
tab E_SEX if IDCNTRY==392, miss
//Establecer la ponderaciones de las muestras(pesos totales)
svyset IDSCHOOL [pw=TOTWGT]
save TIMSS, replace
svy: tab E_SEX if IDCNTRY==392, miss
svy: tab E_BOOK if IDCNTRY==392, miss
svy: tab E_BOOK if IDCNTRY==222, miss
help pv

//Análisis de regresión
pv, pv(BSMMAT0*):svy: reg @pv E_SEX if IDCNTRY==392
pv, pv(BSMMAT0*):svy: reg @pv E_SEX if IDCNTRY==222

pv, pv(BSMMAT0*):svy: reg @pv E_SEX E_BOOK if IDCNTRY==392
pv, pv(BSMMAT0*):svy: reg @pv E_SEX E_BOOK if IDCNTRY==222

// Apartir de acá es el código correspondiente al análisis factorial
use TIMSS, clear
browse
svy: tab IDCNTRY E_AUTO1, miss row
tabstat E_AUTO*[aw=TOTWGT], by (IDCNTRY) stat(mean sd min max)

sort IDCNTRY
by IDCNTRY : correlate E_AUTO*[aw=TOTWGT]
by IDCNTRY : correlate E_GUSTO*[aw=TOTWGT]

// Análisis factorial exploratorio
factor E_AUTO* [aw= TOTWGT] if IDCNTRY==222, ml bl(.35)
factor E_AUTO* [aw= TOTWGT] if IDCNTRY==392, ml bl(.35)
factor E_GUSTO [aw= TOTWGT] if IDCNTRY==392, ml bl(.35)

// Análisis factorial confirmatorio
sem (E_AUTO* <- FACTOR) if IDCNTRY==222 [iweight= TOTWGT], stand latent(FACTOR)
estat ggof, stats(rmsea indices)

// Invarianza de medición en Eda
// Primer nivel de invarianza
sem (E_GUSTO*<-FACTOR)(E_GUSTO1<-FACTOR _cons@0)[iweight=SENWGT], group(IDCNTRY) latent(FACTOR) ginvariant(none) mean(FACTOR) variance(e.E_GUSTO1@0)
estat ggof
sem (E_GUSTO*<-FACTOR)(E_GUSTO1<-FACTOR _cons@0)[iweight=SENWGT], group(IDCNTRY) latent(FACTOR) ginvariant(mcoef) mean(FACTOR) variance(e.E_GUSTO1@0)

sem (E_GUSTO*<-FACTOR)(E_GUSTO1<-FACTOR _cons@0)[iweight=SENWGT], group(IDCNTRY) latent(FACTOR) ginvariant(mcoef mcons) mean(FACTOR) variance(e.E_GUSTO1@0)







