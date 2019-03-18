<cfparam name="attributes.edit" type="boolean" default="false"/>				<!---IE rc.edit value --->
<cfparam name="attributes.placeholderText" type="string" default="Search Accounts" />		<!--- entity.location --->
<cfif thisTag.executionMode is "start">
	<cfoutput>
			<sw-typeahead-input-field
				data-entity-name="Account"
				data-property-to-save="account.accountID"
				data-property-to-show="calculatedFullName"
				data-properties-to-load="accountID,calculatedFullName"
				data-show-add-button="false"
				data-show-view-button="false"
				data-placeholder-text="#attributes.placeholderText#"
				data-multiselect-mode="false"
				data-order-by-list="calculatedFullName|ASC" >
				
				<span sw-typeahead-search-line-item data-property-identifier="calculatedFullName" is-searchable="true"></span><br>
				
			</sw-typeahead-input-field>
	</cfoutput>
</cfif> 
