<cfscript>
    variables.framework.hibachi.localUrlPattern= '^stoneandberg(?:\.local)?$';
    variables.framework.hibachi.developmentUrlPattern= '^stoneandberg(?:-admin)?\.ten24dev\.com$';
    variables.framework.hibachi.errorDisplayFlag = BooleanFormat( getEnvironment() == 'local');
</cfscript>