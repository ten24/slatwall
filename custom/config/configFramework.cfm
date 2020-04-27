<cfset variables.framework.hibachi.errorDisplayFlag = true />
<cfset variables.framework.hibachi.localUrlPattern= '^monat$' />
<cfset variables.framework.hibachi.readOnlyDataSource= 'monat_readonly' />
<cfset variables.framework.hibachi.availableClusters = [ 'web', 'admin', 'task', 'flexship', 'push' ] />
<cfset variables.framework.hibachi.cluster.taskUrlPattern= '^monattask\.' />
<cfset variables.framework.hibachi.cluster.flexshipUrlPattern= '^monatstagingtaskflexship\.' />
<cfset variables.framework.hibachi.cluster.pushUrlPattern= '^monatstagingtaskpush\.' />
<cfset variables.framework.isECSInstance= true' />
