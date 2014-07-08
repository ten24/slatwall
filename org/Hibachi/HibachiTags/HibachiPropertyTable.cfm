<cfif thisTag.executionMode is "start">
	
	<!--- This param is used to create unique ID's for browser tests --->
	<cfparam name="request.propertyTableCount" default="0" />
	<cfset request.propertyTableCount++ />
	
	<cfoutput>
		<table class="table table-striped table-bordered table-condensed" id="hibachiPropertyTable#request.propertyTableCount#">
			<tbody>
	</cfoutput>
	
<cfelse>
	<cfoutput>
			</tbody>
		</table>
	</cfoutput>
</cfif>