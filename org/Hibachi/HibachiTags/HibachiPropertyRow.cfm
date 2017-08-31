<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfparam name="attributes.fluidDisplay" type="boolean" default="true" />
<cfparam name="attributes.divAttributes" type="string" default="" />


<cfif thisTag.executionMode is "start">
	<cfoutput>
		<cfif attributes.fluidDisplay>
			<div class="row" #attributes.divAttributes#>
		<cfelse>
			<div class="row" #attributes.divAttributes#>
		</cfif>
	</cfoutput>
<cfelse>
	<cfoutput>
		</div>
	</cfoutput>
</cfif>