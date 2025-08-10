// Data manipulation and analsysis

// Imported "raw dataset" from Lathiff_Manuscript_One_data file 


// Generate the logarithms of the variables 

generate lnages=ln(ages)
generate lnao_cap=ln(ao_cap)
generate lnrp=ln(rp)
generate lnasrd=ln(asrd)
generate lnascgs=ln(ascgs)


// Multiple imputation method used to impute missing values in the data

mi set mlong

mi register imputed lnasrd
mi impute regress lnasrd lnages lnascgs lnao_cap lnrp, add(20) force

mi register imputed lnao_cap
mi impute regress lnao_cap lnages lnascgs lnasrd lnrp, add(20) force

mi register imputed lnascgs
mi impute regress lnascgs lnages lnao_cap lnasrd lnrp, add(20) force

mi register imputed lnages
mi impute regress lnages lnascgs lnao_cap lnasrd lnrp, add(20) force

mi register imputed lnrp
mi impute regress lnrp lnages lnascgs lnao_cap lnasrd, add(20) force

clear

// Fill in missing data in excel

// Import "Data for analysis" dataset from Lathiff_Manuscript_One_data


// Panel data setting

encode rtb, gen( rtb1 )
xtset rtb1 year


// To test for the use of static or dynamic model

gen lag_lnages= lnages[_n-1]

xtreg lnages lnao_cap lnrp lnasrd lnascgs lag_lnages


// Post estimation Techniques/Diagnostic tests


// Test for cross-sectional dependence by using Pesaran 2004 cross-sectional dependence, and Frees tests

xtreg lnages lnao_cap lnrp lnasrd lnascgs

xtcsd, pesaran
xtcsd, frees

// Tests for unit root/stationarity of the variables: First generation 

// Pesearan unit root tests (IPS)


xtunitroot ips lnages
xtunitroot ips d.lnages
xtunitroot ips lnages,t
xtunitroot ips d.lnages,t
xtunitroot ips lnasrd
xtunitroot ips d.lnasrd
xtunitroot ips lnasrd,t
xtunitroot ips d.lnasrd,t
xtunitroot ips lnascgs
xtunitroot ips d.lnascgs
xtunitroot ips lnascgs,t
xtunitroot ips d.lnascgs,t
xtunitroot ips lnao_cap
xtunitroot ips d.lnao_cap
xtunitroot ips lnao_cap,t
xtunitroot ips d.lnao_cap,t
xtunitroot ips lnrp
xtunitroot ips d.lnrp
xtunitroot ips lnrp,t
xtunitroot ips d.lnrp,t

// Cointegration test

xtcointtest pedroni lnages lnao_cap lnrp lnasrd lnascgs
xtcointtest kao lnages lnao_cap lnrp lnasrd lnascgs


// test for slope heterogeneity

xthst d.lnages L.d.lnages lnao_cap lnrp lnasrd lnascgs

// Regression: Fully modified ordinary least squares 

xtcointreg lnages lnao_cap lnrp lnasrd lnascgs, est(fmols)

// Robustness check: Canonical cointegration regression

xtcointreg lnages lnao_cap lnrp lnasrd lnascgs , est(ccr)


