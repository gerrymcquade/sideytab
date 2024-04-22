/***
_Version 0.1.3_ 

sideytab
--------

__sideytab:__ A module for producing sideways esttab tables.

Syntax
------ 

> __sideytab__ _anything_ [_if_] [using] _filename_ [, _options_] [_table options_] [_esttab_options_]

where _anything_ is the name of a stored estimate. See [estimates](help estimates) for information about storing estimation results. An alternative to the estimates store command is provided by [eststo](help eststo). 
_filename_  must be a filetype supported by [esttab](help esttab).

The main options are:

| _Options_               |  _Description_                           |
|:------------------------|:-----------------------------------------|
| **keep**(_keeplist_)    | Specify which coefficients to keep       |
| **stats**(_scalarlist_) | Specify which stored statistics to keep  |
| **prefix**(_string_)    | Prefix applied to each new estimate name |
| **nocons**tant          | Do not save model constant to estimates  |
| **tab**le               | Produce new table output                 |


If the __table__ option is specified the following options are relevant:

| _Table options_  | _Description_                                          |
|:-----------------|:-------------------------------------------------------|
| **r**eplace      | Overwrite an existing file                             |
| **a**ppend       | Append the output to an existing file                  |
| _esttab_options_ | Any other relevant options passed _asis_ to __esttab__ |


Description
-----------

This package is a simple wrapper for [esttab](help esttab), originally created for personal use. It takes stored estimates, runs esttab to compile the __r(coefs)__ and __r(stats)__ matrices, collecting each coefficient and posting them to 
__e()__ such that each coefficient can be used as a column in an esttab table, similar to 
[this example](http://repec.org/bocode/e/estout/advanced.html#advanced907/). Each coefficient, as well as any specified statistics, are stored as estimates, which can be accessed by [estimates dir](help estimates dir).

Additionally, if __table__ is specified it can produce and save the new table to disk. The table can be saved as any format supported by esttab.

Installation
------------

This package is hosted on Github. You can install __sideytab__ directly from it's [Github repository](https://github.com/gerrymcquade/sideytab/) by typing:

        net install sideytab, from("https://github.com/gerrymcquade/sideytab/")

Main options
------------

__**keep**(_keeplist_)__ Specifies which coefficients should be run through __esttab__ , therefore which coefficients are available in __r(coefs)__ to be collected and posted to 
__e()__ . _keeplist_ is passed asis to __esttab__, therefore it is specified the same as _droplist_ in [estout](help estout##drop) . Each coefficient will be stored as an estimate which can be used in a later __esttab__ call. 

When coefficients are posted as a new estimate, they must adhere to the naming conventions of _namelist_. Therefore coefficients with a leading numeric or containing special characters will have these characters replaced by an underscore "_". 
This affects coefficients defined using factor notation, e.g. __1.x__ will be renamed as ____x__ . Alternatively, a prefix can be added to all estimate names, using the __prefix__ option (see below).

__**stats**(_scalarlist_)__ Specifies one or more scalar statistics to be collected via __r(stats)__ and stored as estimates, with names corresponding to the name of each statistic. This includes any statistics which have been added via the 
__estadd__ command. Statistics are collected and stored as estimates given the name of the statistic. These can be tabulated as models using __esttab__ , etc.

Additionally, the __r(stats)__ matrix is added to the final stored estimate via __estadd__ , allowing them to be called within the __cell()__ option of __estout__ with the syntax __S[_name_]__ where _name_ is the statistic name. 
Alternatively it can be referred to as __S[_#_]__ with the column index # of the matrix __S__ . See __example 4__ below for further details.

__**prefix**(_string_)__ Specifies a prefix to be added to the new stored estimate names for each coefficient. It must not begin with a numeric or special character except "_". This is particularly useful for factor notation 
(e.g. __1.foreign__ ).

__**nocons**tant__ If specified, suppresses the model constant, such that it will not be in __r(coefs)__ and is not stored as an estimate.

__**tab**le__ Outputs the new table with flipped coefficients and models. If specified without __[using]__ then the table is simply printed in the Stata window. If combined with __[using]__ then the table is saved to disk using the 
_filename_ specified. 
_filename_ must be a filetype supported by __esttab__ (for details, see 
[esttab](help esttab##format) ). For saving to disk, either __replace__ or __append__ must be specifed (see below). 

Table options
-------------

If option __table__ is specified, the following options apply:

__**r**eplace__ Overwrites an existing file with the same name if it exists, and creates a new file otherwise.

__**a**ppend__ Specifies that the output be appended to an existing file. It may be used even if the file does not yet exist.

__[esttab_options]__ All additional __esttab/estout__ syntax specified will be passed _asis_ to the final __esttab__ call.   

Remarks
-------

This package is meant to be minimal, however if you have any features you think would be good to add (and preferably some advice on how to implement them as well!) then let me know! 
This package was designed for personal use, therefore it is possible errors exist in the code, please let me know if you spot any.

Examples
--------

These examples show that sideytab can be used alone or in conjunction with __esttab__ to produce new flipped tables:


	__1. Produce a flipped table with columns weight, mpg, N and r2__

        qui reg price weight
        estimates store model1

        qui reg price weight mpg turn
        estimates store model2

        sideytab model1 model2, keep(weight mpg) stats(N r2) noconstant table

    
	__2. Save table to disk as .tex file__ 

        sideytab model1 model2 using "example2.rtf", ///
        keep(weight mpg) stats(N r2) noconstant table replace


	__3. Passing additional esttab options for the output table__ 

        sideytab model1 model2 using "example3.rtf", ///
        keep(weight mpg) stats(N r2) noconstant table replace ///
        mtitle("Weight" "Price" "N" "R-sq") ///
        coeflabel(model1 "Baseline" model2 "Modified")

    
	__4. Using the prefix() option__ 

        sideytab model1 model2, ///
        keep(weight mpg) stats(N r2) noconstant prefix(a_) table

        estimates dir


	__5. Suppress table output, tabulate new estimates post-command using esttab__

        sideytab model1 model2, keep(weight mpg) stats(N r2) noconstant

        estimates dir

        esttab weight mpg N r2, b(2) se mtitle("Weight" "Price" "N" "R-sq") ///
        coeflabel(model1 "Baseline" model2 "Modified") noobs


	__6. Using estout cell() to display statistics__

        qui reg price weight
        estimates store model3

        qui reg mpg weight
        estimates store model4

        sideytab model3 model4, stats(N) noconstant

        esttab weight, cell("b(f(3)) S[N](f(0))" "se(par s f(3))") ///
        noobs collabel("Weight" "N") nomtitle nonumbers	


	__7. Adding additional scalars to be tabulated__
	
        eststo model5: qui reg price foreign turn
        qui summarize price if foreign == 0
        estadd scalar cm = r(mean) : model5 //control mean
        estadd scalar csd = r(sd) : model5 //control S.D.

        eststo model6: qui reg weight foreign turn
        qui summarize weight if foreign == 0
        estadd scalar cm = r(mean) : model6 
        estadd scalar csd = r(sd) : model6

        //basic output
        sideytab model5 model6, keep(foreign) stats(cm csd N) nocons table

        estimates dir

        //additional scalars and locals can be added to the new stored estimate "foreign"
        estadd local controls "Yes" : foreign

        //can modify layout via additional __esttab__ call
        esttab foreign using "example7.rtf", replace ///
        cells("b(fmt(3)) S[cm](fmt(2)) S[N](fmt(0))" "se(fmt(3) star par) S[csd](fmt(2) par)") ///
        noobs nomtitle nonumbers ///
        starlevel(* 0.10 ** 0.05 *** 0.01) staraux ///
        collabel("Foreign" "Control Mean" "N") ///
        coeflabel(model5 "Price" model6 "Weight") ///
        sca("controls Inc. Controls")	
	
Author
------

Gerald McQuade   
Department of Economics, Lancaster University Management School    
[g.mcquade1@lancaster.ac.uk](g.mcquade1@lancaster.ac.uk)    
[gerrymcquade.gitbhub.io](https://gerrymcquade.github.io/)    

- - -

This help file was dynamically produced by 
[MarkDoc Literate Programming package](http://www.haghish.com/markdoc/) 
***/

// A program to produce esttab tables with dependent variables as rows 
prog def sideytab

syntax anything [if] [using], ///
	[ ///
		Replace /// use with "using" to replace an existing file
		Append /// use with "using" to append to an existing file
		TABle /// suppress output of table (still stores estimates)
		KEEP(passthru) /// which vars from prexisting estimates to keep in new table
		STATS(passthru) /// which stats prexisting estimates to keep in new table
		PREFIX(name) /// prefix to attach to all stored estimates
		NOCONStant * /// suppress constant in new table
	] //the "*" means all other options for esttab
	
	//display info
	di ""
	di as text "Version 0.1.3 | By Gerald McQuade | gerrymcquade@gitbhub.io | g.mcquade1@lancaster.ac.uk"
	di ""
	
	//PARSE REPLACE OR APPEND IF USING SPECIFIED
	if "`using'" != "" {
		if ("`replace'" != "" & "`append'" == "") { //only replace specified
			loc outopt `replace'
		}
		else if ("`replace'" == "" & "`append'" != "") { //only append
			loc outopt `append'
		}
		else if ("`replace'" != "" & "`append'" != "") { //both = error
			di as error "Cannot specify both -replace-  and -append- with -using-! Please only specify one option"
			exit 198
		}
		else {
			di as error "Must specify either -replace- or -append- with -using-"
			exit 198
		}
	}
	else if ("`using'" == "" & ("`replace'" != "" | "`append'" != "")) {
		di as error "need to specify -using filename- when using option -replace- or -append-"
		exit 198
	}
	
//set columns list to empty	
loc cols
	
// 1st esttab to collect r(coefs) matrix
qui esttab `anything', cells(b se) `keep' `stats' nostar `noconstant'
	
	//prepare coefficients
	mat C = r(coefs)
	//mat list C
	
	//prepare stats
	if "`stats'" != "" { //check if stats option is provided before save matrix
		mat S = r(stats)
		//mat list S
	}
	
	eststo clear // must clear the previous esttab
	
	//--- COEFFICIENTS ---//
	loc rn: rownames C //collects the coefs that will become columns
	//strip first numbers away so fits namelist conventions
	if "`prefix'" == "" {
		loc rnames
		foreach n of local rn {
			loc r =ustrregexra("`n'", "^[0-9]+", "_")
			loc rnames `rnames' `r'
		}	
	}
	else { //if prefix is specified then below itwill save each estimate with the prefix
		loc rnames `rn'
		di as text "Estimates will be stored with prefix: `prefix' "
	}
	//replace any incorrect special characters as part of factor notation
	loc rnames: subinstr loc rnames "." "_", all //get rid of .
	loc rnames: subinstr loc rnames "#" "_", all //get rid of #
	
	//indicate if there was any changes to estimate names
	if "`rnames'" != "`rn'" {
		di as text "NOTE: coefficient names beginning with numbers, or containing special characters (e.g. factor variables) are invalid as stored estimate names; therefore each special character is replaced with an underscore _. To avoid this consider specifying a non numeric prefix using the prefix() option."
	}
		di ""
		di as text "stored estimate names are: `rnames'"
		di ""
	loc models : coleq C //collect different model names in C that become rows
		//di as red " coleq C: `models' "
	loc models : list uniq models //ensures list is unique model names
		//di as red " list uniq: `models' "
	
	loc i = 0 //coefficients counter
	//loop over coefficients
	foreach names of local rnames {
		loc ++i
		
		loc j = 0 //models counter
		cap mat drop b //clear matrices for coefs and SEs
		cap mat drop se
				
		foreach model of local models { //`model' is placeholder for nested loop
			loc ++j //increment second counter
			mat tmp = C[`i', 2*`j'-1] //subsets matrix to be coef `i'
			//2*`j'-1 correct column for coefficient in each model
			if tmp[1,1]<. { //check tmp isn't empty and run until it is
				mat colnames tmp = `model' //apply colnames from model local
				mat b = nullmat(b), tmp //add coef to coef matrix
				mat tmp[1,1] = C[`i', 2*`j'] //subset matrix to be se `i'  
				matrix se = nullmat(se), tmp //add se to se matrix
			}
		}
		
		ereturn post b //post coeff matrix to estimates
		qui estadd mat se //add standard errors to coeffs est
		
		//store new final estimate for tabulation
		eststo `prefix'`names'
		loc cols `cols' `prefix'`names'
	}
	
	//add stats defined by STATS(passthru) option as columns at end of table
	if "`stats'" != "" {
		//add the matrix S to the estimates so can be added as separate cell
		mat colnames S = `models'
		qui estadd mat S
		
		//offer option to include it as a coefficient (e.g. separate column)
		loc snames: rownames S //matrix defined above if have stats option
		loc i = 0
		foreach names of local snames {
			loc ++i
			loc j = 0
			cap mat drop b
			foreach model of local models {
				loc ++j
				mat tmp = S[`i', `j']
				mat colnames tmp = `model'
				mat b = nullmat(b), tmp
			}
			ereturn post b
			eststo `names'
			loc cols `cols' `names'
		} 
	}
	
	di ""
	di as text "Estimates for each column stored in order:"
	di "`cols'"
	di "To access type: estimates dir"

********************************************************************************	
	
	//--- parse using option ---//
	if "`table'" != "" { //if notable is specified, produce table
		esttab `using', `outopt' se mtitle noobs nonum compress ///
		starl(* 0.10 ** 0.05 *** 0.01) staraux ///
		`noconstant' `options'
	} 
	else {
		di "Option -table- not specified, table output suppressed."  
	}
end

//  [, _stats_subopts_] _stats_subopts_ are specified as in [estout](help estout##stats), however the only relevant option for final output is __fmt()__ .