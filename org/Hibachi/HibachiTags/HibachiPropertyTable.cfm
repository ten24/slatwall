<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfif thisTag.executionMode is "start">
	
	<!--- This param is used to create unique ID's for browser tests --->
	<cfparam name="request.propertyTableCount" default="0" />
	<cfset request.propertyTableCount++ />
	
	<cfoutput>
		<div class="table-responsive">
			<table class="table table-condensed" id="hibachiPropertyTable#request.propertyTableCount#">
				<tbody>
	</cfoutput>
	
<cfelse>
	<cfoutput>
				</tbody>
			</table>
		</div>
	</cfoutput>
</cfif>