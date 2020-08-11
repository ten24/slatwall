<cfscript>
    variables.framework.hibachi.errorDisplayFlag = BooleanFormat(getPageContext().getRequest().getServerPort() == '8906');
    variables.framework.hibachi.localUrlPattern= '^stoneandberg$';
</cfscript>

<!---
<cfset variables.framework.hibachi.readOnlyDataSource= 'stoneandberg_readonly' />
<cfset variables.framework.hibachi.availableClusters = [ 'web', 'admin', 'task', 'flexship', 'push' ] />
<cfset variables.framework.hibachi.cluster.taskUrlPattern= '^monat(staging)?task\.' />
<cfset variables.framework.hibachi.cluster.flexshipUrlPattern= '^monat(staging)?taskflexship\.' />
<cfset variables.framework.hibachi.cluster.pushUrlPattern= '^monat(staging)?taskpush\.' />
<cfset variables.framework.isECSInstance= true />
--->