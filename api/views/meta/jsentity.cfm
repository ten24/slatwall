<cfparam name="rc.entity" />

<cfsavecontent variable="local.jsOutput">
<cfoutput>
jsEntities[ '#rc.entity.getClassName()#' ] = function() {
	<cfloop array="#rc.entity.getProperties()#" index="local.property">
	<cfif !structKeyExists(local.property, "persistent") && ( !structKeyExists(local.property,"fieldtype") || listFindNoCase("column,id", local.property.fieldtype) )>
	this.#local.property.name# = '#rc.entity.invokeMethod('get#local.property.name#')#';
	</cfif>
	</cfloop>
};
jsEntities[ '#rc.entity.getClassName()#' ].prototype = {
	<cfset first=true />
	<cfloop array="#rc.entity.getProperties()#" index="local.property">
	<cfif !structKeyExists(local.property, "persistent")>
	<cfif !first>,</cfif>'get#local.property.name#':function() {
		return this.#local.property.name#;
	}
	<cfset first=false />
	</cfif>
	</cfloop>
}	
</cfoutput>	
</cfsavecontent>

<cfoutput>#local.jsOutput#</cfoutput>