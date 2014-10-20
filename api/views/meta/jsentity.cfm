<cfparam name="rc.entity" />

<cfsavecontent variable="local.jsOutput">
<cfoutput>
jsEntities[ '#rc.entity.getClassName()#' ] = function() {
	
	this.metaData = #serializeJSON(rc.entity.getPropertiesStruct())#;
	this.data = {};
	this.modifiedData = {};
	
	<!--- Loop over properties --->
	<cfloop array="#rc.entity.getProperties()#" index="local.property">
		
		<!--- Make sure that this property is a persistent one --->
		<cfif !structKeyExists(local.property, "persistent") && ( !structKeyExists(local.property,"fieldtype") || listFindNoCase("column,id", local.property.fieldtype) )>
			
			<!--- Find the default value for this property --->
			<cfset local.defaultValue = rc.entity.invokeMethod('get#local.property.name#') />

			<cfif isNull(local.defaultValue)>
				this.data.#local.property.name# = null;
			<cfelseif structKeyExists(local.property, "ormType") and listFindNoCase('boolean,int,integer,float,big_int', local.property.ormType)>
				this.data.#local.property.name# = #rc.entity.invokeMethod('get#local.property.name#')#;
			<cfelse>
				this.data.#local.property.name# = '#rc.entity.invokeMethod('get#local.property.name#')#';
			</cfif>
		</cfif>
		
	</cfloop>
	
};
jsEntities[ '#rc.entity.getClassName()#' ].prototype = {
	
	'init':function( data ) {
		for(var key in this) {
			// Set the values to the values in the data passed in, or API promisses 
		}
	}
	,'getMetaData':function( propertyName ) {
		if(propertyName === undefined) {
			return this.metaData
		}
		return this.metaData[ propertyName ];
	}
	
	<cfloop array="#rc.entity.getProperties()#" index="local.property">
		<cfif !structKeyExists(local.property, "persistent")>
			,'get#local.property.name#':function() {
				return this.#local.property.name#;
			}
			<cfif structKeyExists(local.property, "fieldtype")>
				<cfif listFindNoCase('many-to-one', local.property.fieldtype)>
				,'get#local.property.name#OptionsCollection':function() {
					// This should get pulled down 
					var c = {};
					return angular('slatwallservice').getCollection(c);
				}
				<cfelseif listFindNoCase('one-to-many,many-to-many', local.property.fieldtype)>
				,'get#local.property.name#Collection':function() {
					var c = {};
					return angular('slatwallservice').getCollection(c);
				}
				</cfif>
			</cfif>
		</cfif>
	</cfloop>
}	
</cfoutput>	
</cfsavecontent>

<cfoutput>#local.jsOutput#</cfoutput>