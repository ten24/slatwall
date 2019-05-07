<!--- Dump out the internal struct and array used in the cfc --->
<hr>
<cfoutput>#scoperFileName#</cfoutput><br><br>

<cfdump var="#varscoper.getResultsStruct()#" label="Internal Processing Struct Used For Tracking Variables">

<br><br>
<cfdump var="#varscoper.getResultsArray()#" label="Array Of Unscoped Variables">
<cfflush>