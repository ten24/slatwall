<cfscript>
    variables.framework.hibachi.localUrlPattern= '^stoneandberg(?:\.local)?$';
    variables.framework.hibachi.developmentUrlPattern= '^stoneandberg(?:-admin)?\.slatwall(commerce-dev)?\.io$';
    variables.framework.hibachi.errorDisplayFlag = BooleanFormat( getEnvironment() == 'local');
	variables.framework.hibachi.skipCreateRBKeysForAttributeCustomProperties = false;
</cfscript>
<cfset variables.framework.preflightOptions=true />