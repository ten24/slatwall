<!---

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC
	
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
	
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
	
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
	
    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your 
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms 
    of your choice, provided that you follow these specific guidelines: 

	- You also meet the terms and conditions of the license of each 
	  independent module 
	- You must not alter the default display of the Slatwall name or logo from  
	  any part of the application 
	- Your custom code must not alter or create any files inside Slatwall, 
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets 
	the above guidelines as a combined work under the terms of GPL for this program, 
	provided that you include the source code of that other code when and as the 
	GNU GPL requires distribution of source code.
    
    If you modify this program, you may extend this exception to your version 
    of the program, but you are not obligated to do so.

Notes:

--->
<cfparam name="attributes.fieldName" type="string" default="accountID" />
<cfparam name="attributes.edit" type="boolean" default="false"/>
<cfparam name="attributes.placeholderText" type="string" default="Search Accounts" />
<cfparam name="attributes.required" type="boolean" default="false"/>
<cfparam name="attributes.typeaheadID" type="string" default=""/>
<cfparam name="attributes.propertiesToSearch" type="string" default="firstName,lastName,company"/>
<cfparam name="attributes.propertiesToLoad" type="string" default="accountID,calculatedFullName,firstName,lastName,company,calculatedAdminIcon,accountCreatedSite.siteID"/>

<cfif thisTag.executionMode is "start">
	<cfoutput>
		<sw-typeahead-input-field
				data-typeahead-data-key="#attributes.typeaheadID#"
				data-entity-name="Account"
				data-field-name="#attributes.fieldName#"
				data-property-to-save="accountID"
				data-property-to-show="calculatedFullName"
				data-properties-to-search="#attributes.propertiesToSearch#"
				data-properties-to-load="#attributes.propertiesToLoad#"
				data-show-add-button="false"
				data-show-view-button="false"
				data-placeholder-text="#attributes.placeholderText#"
				data-multiselect-mode="false"
				data-validate-required="#attributes.required#"
				data-order-by-list="firstName|ASC" >
					<div class="row">
						<span class="adminIcon col-xs-2 col-sm-1 " sw-typeahead-search-line-item bind-html="true" data-property-identifier="calculatedAdminIcon" data-right-content-property-identifier="company"></span>
						<div class="col-xs-10 col-sm-offset-1">
							<p class="fullName first" sw-typeahead-search-line-item data-property-identifier="calculatedFullName"></p>
							<p class="company" sw-typeahead-search-line-item data-property-identifier="company"></p>
						</div>
					</div>
			</sw-typeahead-input-field>
	</cfoutput>
</cfif> 
