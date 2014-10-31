<cfparam name="attributes.fluidDisplay" type="boolean" default="true" />

<cfif thisTag.executionMode is "start">
	<cfoutput>
		<cfif attributes.fluidDisplay>
			<div class="row">
		<cfelse>
			<div class="row">
		</cfif>
	</cfoutput>
<cfelse>
	<cfoutput>
		</div>
	</cfoutput>
</cfif>