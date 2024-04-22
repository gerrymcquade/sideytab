{smcl}
{it:Version 0.1.3} 


{title:sideytab}

{p 4 4 2}
{bf:sideytab:} A module for producing sideways esttab tables.


{title:Syntax}

{p 8 8 2} {bf:sideytab} {it:anything} [{it:if}] [using] {it:filename} [, {it:options}] [{it:table options}] [{it:esttab_options}]

{p 4 4 2}
where {it:anything} is the name of a stored estimate. See  {browse "help estimates":estimates} for information about storing estimation results. An alternative to the estimates store command is provided by  {browse "help eststo":eststo}. 
{it:filename}  must be a filetype supported by  {browse "help esttab":esttab}.

{p 4 4 2}
The main options are:

{col 5}{it:Options}{col 30}{it:Description}
{space 4}{hline 67}
{col 5}{ul:keep}({it:keeplist}){col 30}Specify which coefficients to keep
{col 5}{ul:stats}({it:scalarlist}){col 30}Specify which stored statistics to keep
{col 5}{ul:prefix}({it:string}){col 30}Prefix applied to each new estimate name
{col 5}{ul:nocons}tant{col 30}Do not save model constant to estimates
{col 5}{ul:tab}le{col 30}Produce new table output
{space 4}{hline 67}

{p 4 4 2}
If the {bf:table} option is specified the following options are relevant:

{col 5}{it:Table options}{col 23}{it:Description}
{space 4}{hline 74}
{col 5}{ul:r}eplace{col 23}Overwrite an existing file
{col 5}{ul:a}ppend{col 23}Append the output to an existing file
{col 5}{it:esttab_options}{col 23}Any other relevant options passed {it:asis} to {bf:esttab}
{space 4}{hline 74}


{title:Description}

{p 4 4 2}
This package is a simple wrapper for  {browse "help esttab":esttab}, originally created for personal use. It takes stored estimates, runs esttab to compile the {bf:r(coefs)} and {bf:r(stats)} matrices, collecting each coefficient and posting them to 
{bf:e()} such that each coefficient can be used as a column in an esttab table, similar to 
{browse "http://repec.org/bocode/e/estout/advanced.html#advanced907/":this example}. Each coefficient, as well as any specified statistics, are stored as estimates, which can be accessed by  {browse "help estimates dir":estimates dir}.

{p 4 4 2}
Additionally, if {bf:table} is specified it can produce and save the new table to disk. The table can be saved as any format supported by esttab.


{title:Installation}

{p 4 4 2}
This package is hosted on Github. You can install {bf:sideytab} directly from it{c 39}s  {browse "https://github.com/gerrymcquade/sideytab/":Github repository} by typing:

        net install sideytab, from("https://github.com/gerrymcquade/sideytab/")


{title:Main options}

{p 4 4 2}
{bf:{ul:keep}({it:keeplist})} Specifies which coefficients should be run through {bf:esttab} , therefore which coefficients are available in {bf:r(coefs)} to be collected and posted to 
{bf:e()} . {it:keeplist} is passed asis to {bf:esttab}, therefore it is specified the same as {it:droplist} in  {browse "help estout##drop":estout} . Each coefficient will be stored as an estimate which can be used in a later {bf:esttab} call. 

{p 4 4 2}
When coefficients are posted as a new estimate, they must adhere to the naming conventions of {it:namelist}. Therefore coefficients with a leading numeric or containing special characters will have these characters replaced by an underscore "_". 
This affects coefficients defined using factor notation, e.g. {bf:1.x} will be renamed as {bf:__x} . Alternatively, a prefix can be added to all estimate names, using the {bf:prefix} option (see below).

{p 4 4 2}
{bf:{ul:stats}({it:scalarlist})} Specifies one or more scalar statistics to be collected via {bf:r(stats)} and stored as estimates, with names corresponding to the name of each statistic. This includes any statistics which have been added via the 
{bf:estadd} command. Statistics are collected and stored as estimates given the name of the statistic. These can be tabulated as models using {bf:esttab} , etc.

{p 4 4 2}
Additionally, the {bf:r(stats)} matrix is added to the final stored estimate via {bf:estadd} , allowing them to be called within the {bf:cell()} option of {bf:estout} with the syntax {bf:S[{it:name}]} where {it:name} is the statistic name. 
Alternatively it can be referred to as {bf:S[{it:#}]} with the column index # of the matrix {bf:S} . See {bf:example 4} below for further details.

{p 4 4 2}
{bf:{ul:prefix}({it:string})} Specifies a prefix to be added to the new stored estimate names for each coefficient. It must not begin with a numeric or special character except "_". This is particularly useful for factor notation 
(e.g. {bf:1.foreign} ).

{p 4 4 2}
{bf:{ul:nocons}tant} If specified, suppresses the model constant, such that it will not be in {bf:r(coefs)} and is not stored as an estimate.

{p 4 4 2}
{bf:{ul:tab}le} Outputs the new table with flipped coefficients and models. If specified without {bf:[using]} then the table is simply printed in the Stata window. If combined with {bf:[using]} then the table is saved to disk using the 
{it:filename} specified. 
{it:filename} must be a filetype supported by {bf:esttab} (for details, see 
{browse "help esttab##format":esttab} ). For saving to disk, either {bf:replace} or {bf:append} must be specifed (see below). 


{title:Table options}

{p 4 4 2}
If option {bf:table} is specified, the following options apply:

{p 4 4 2}
{bf:{ul:r}eplace} Overwrites an existing file with the same name if it exists, and creates a new file otherwise.

{p 4 4 2}
{bf:{ul:a}ppend} Specifies that the output be appended to an existing file. It may be used even if the file does not yet exist.

{p 4 4 2}
{bf:[esttab_options]} All additional {bf:esttab/estout} syntax specified will be passed {it:asis} to the final {bf:esttab} call.     {break}


{title:Remarks}

{p 4 4 2}
This package is meant to be minimal, however if you have any features you think would be good to add (and preferably some advice on how to implement them as well!) then let me know! 
This package was designed for personal use, therefore it is possible errors exist in the code, please let me know if you spot any.


{title:Examples}

{p 4 4 2}
These examples show that sideytab can be used alone or in conjunction with {bf:esttab} to produce new flipped tables:


{p 4 4 2}
	{bf:1. Produce a flipped table with columns weight, mpg, N and r2}

        qui reg price weight
        estimates store model1

        qui reg price weight mpg turn
        estimates store model2

        sideytab model1 model2, keep(weight mpg) stats(N r2) noconstant table


{p 4 4 2}
	{bf:2. Save table to disk as .tex file} 

        sideytab model1 model2 using "example2.rtf", ///
        keep(weight mpg) stats(N r2) noconstant table replace


{p 4 4 2}
	{bf:3. Passing additional esttab options for the output table} 

        sideytab model1 model2 using "example3.rtf", ///
        keep(weight mpg) stats(N r2) noconstant table replace ///
        mtitle("Weight" "Price" "N" "R-sq") ///
        coeflabel(model1 "Baseline" model2 "Modified")


{p 4 4 2}
	{bf:4. Using the prefix() option} 

        sideytab model1 model2, ///
        keep(weight mpg) stats(N r2) noconstant prefix(a_) table

        estimates dir


{p 4 4 2}
	{bf:5. Suppress table output, tabulate new estimates post-command using esttab}

        sideytab model1 model2, keep(weight mpg) stats(N r2) noconstant

        estimates dir

        esttab weight mpg N r2, b(2) se mtitle("Weight" "Price" "N" "R-sq") ///
        coeflabel(model1 "Baseline" model2 "Modified") noobs


{p 4 4 2}
	{bf:6. Using estout cell() to display statistics}

        qui reg price weight
        estimates store model3

        qui reg mpg weight
        estimates store model4

        sideytab model3 model4, stats(N) noconstant

        esttab weight, cell("b(f(3)) S[N](f(0))" "se(par s f(3))") ///
        noobs collabel("Weight" "N") nomtitle nonumbers	


{p 4 4 2}
	{bf:7. Adding additional scalars to be tabulated}
	
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
	

{title:Author}

{p 4 4 2}
Gerald McQuade     {break}
Department of Economics, Lancaster University Management School      {break}
{browse "g.mcquade1@lancaster.ac.uk":g.mcquade1@lancaster.ac.uk}      {break}
{browse "https://gerrymcquade.github.io/":gerrymcquade.gitbhub.io}      {break}

{space 4}{hline}

{p 4 4 2}
This help file was dynamically produced by 
{browse "http://www.haghish.com/markdoc/":MarkDoc Literate Programming package} 


