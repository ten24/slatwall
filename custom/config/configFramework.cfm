<cfscript>
    variables.framework.hibachi.localUrlPattern= '^stoneandberg(?:\.local)?$';
    variables.framework.hibachi.developmentUrlPattern= '^stoneandberg(?:-admin)?\.ten24dev\.com$';
    variables.framework.hibachi.errorDisplayFlag = BooleanFormat( getEnvironment() == 'local');
</cfscript>
<cfset variables.framework.preflightOptions=true />
<cfset variables.framework.optionsAccessControl.headers='Accept,Authorization,Content-Type,auth-token' />

