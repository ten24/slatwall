<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.divClass" type="string" default="col-md-12" />
	<cfparam name="request.context.edit" type="boolean" default="false" />
	<cfparam name="attributes.edit" type="boolean" default="#request.context.edit#" />

	<cfoutput>
		<div class="#attributes.divClass#">
			<cfif attributes.edit>
				<fieldset class="dl-horizontal" style="max-width: 650px;">
			<cfelse>
				<dl class="dl-horizontal s-property-info">
			</cfif>
	</cfoutput>
<cfelse>
	<cfoutput>
			<cfif attributes.edit>
				</fieldset>
			<cfelse>
				</dl>
			</cfif>
		</div>
	</cfoutput>
</cfif>
