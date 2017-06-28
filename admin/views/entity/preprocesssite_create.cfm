<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />


<cfparam name="rc.site" type="any" />
<cfparam name="rc.processObject" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<hb:HibachiEntityProcessForm entity="#rc.site#" edit="#rc.edit#">
		
		<hb:HibachiEntityActionBar type="preprocess" object="#rc.site#">
		</hb:HibachiEntityActionBar>
		
		<hb:HibachiPropertyRow>
			<hb:HibachiPropertyList>
				<!--- General Details --->
				<hb:HibachiPropertyDisplay object="#rc.processObject#" property="app" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.processObject#" property="useAppTemplatesFlag" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.site#" property="siteName" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.site#" property="siteCode" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.site#" property="subdomainName" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.site#" property="domainNames" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.site#" property="allowAdminAccessFlag" edit="#rc.edit#">
				
				<sw-typeahead-input-field data-field-name="organizationID"
										  data-entity-name="Organization"
										  data-property-to-save="organizationID"
										  data-property-to-show="organizationName"> 
				
					<sw-collection-config
							data-entity-name="Organization"
							data-collection-config-property="typeaheadCollectionConfig"
							data-parent-directive-controller-as-name="swTypeaheadInputField"
							data-all-records="false"
							data-has-filters="false">
						<sw-collection-columns>
							<sw-collection-column data-property-identifier="organizationName" 
												data-is-searchable="true"></sw-collection-column>
							<sw-collection-column data-property-identifier="organizationID"></sw-collection-column>
						</sw-collection-columns>
					</sw-collection-config>
	
					<span sw-typeahead-search-line-item data-property-identifier="organizationName"></span> 	

				</sw-typeahead-input-field>
		
			</hb:HibachiPropertyList>
		</hb:HibachiPropertyRow>
		
	</hb:HibachiEntityProcessForm>
</cfoutput>
