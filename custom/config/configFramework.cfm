<cfset variables.framework.hibachi.errorDisplayFlag = true />
<cfset variables.framework.hibachi.localUrlPattern= '^monat$' />
<cfset variables.framework.hibachi.readOnlyDataSource= 'monat_readonly' />
<cfset variables.framework.hibachi.availableClusters = [ 'web', 'admin', 'task', 'flexship', 'push' ] />
<cfset variables.framework.hibachi.cluster.taskUrlPattern= '^monat(staging)?task\.' />
<cfset variables.framework.hibachi.cluster.flexshipUrlPattern= '^monat(staging)?taskflexship\.' />
<cfset variables.framework.hibachi.cluster.pushUrlPattern= '^monat(staging)?taskpush\.' />
<cfset variables.framework.isECSInstance= true />
