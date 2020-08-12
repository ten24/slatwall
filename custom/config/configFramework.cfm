<cfscript>
    variables.framework.hibachi.localUrlPattern= '^stoneandberg(?:\.local)?$';
    variables.framework.hibachi.developmentUrlPattern= '^stoneandberg.ten24dev.com$';
    variables.framework.hibachi.errorDisplayFlag = BooleanFormat( getEnvironment() == 'local');
</cfscript>

<!---
<cfset variables.framework.hibachi.readOnlyDataSource= 'stoneandberg_readonly' />
<cfset variables.framework.hibachi.availableClusters = [ 'web', 'admin', 'task', 'push' ] />
<cfset variables.framework.hibachi.cluster.taskUrlPattern= '^monat(staging)?task\.' />
<cfset variables.framework.hibachi.cluster.flexshipUrlPattern= '^monat(staging)?taskflexship\.' />
<cfset variables.framework.hibachi.cluster.pushUrlPattern= '^monat(staging)?taskpush\.' />
<cfset variables.framework.isECSInstance= true />
--->