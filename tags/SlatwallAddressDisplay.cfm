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
<cfimport prefix="swa" taglib="../tags" />
<cfimport prefix="hb" taglib="../org/Hibachi/HibachiTags" />
<cfparam name="attributes.address" type="any" />
<cfparam name="attributes.edit" type="boolean" default="true" />
<cfparam name="attributes.fieldNamePrefix" type="string" default="" />
<cfparam name="attributes.showName" type="boolean" default="true" />
<cfparam name="attributes.requireName" type="boolean" default="false" />
<cfparam name="attributes.showCompany" type="boolean" default="true" />
<cfparam name="attributes.requireCompany" type="boolean" default="false" />
<cfparam name="attributes.showStreetAddress" type="boolean" default="true" />
<cfparam name="attributes.requireStreetAddress" type="boolean" default="false" />
<cfparam name="attributes.showStreet2Address" type="boolean" default="true" />
<cfparam name="attributes.requireStreet2Address" type="boolean" default="false" />
<cfparam name="attributes.showLocality" type="boolean" default="true" />
<cfparam name="attributes.requireLocality" type="boolean" default="false" />
<cfparam name="attributes.showCity" type="boolean" default="true" />
<cfparam name="attributes.requireCity" type="boolean" default="false" />
<cfparam name="attributes.showState" type="boolean" default="true" />
<cfparam name="attributes.requireState" type="boolean" default="false" />
<cfparam name="attributes.showPostalCode" type="boolean" default="true" />
<cfparam name="attributes.requirePostalCode" type="boolean" default="false" />
<cfparam name="attributes.showCountry" type="boolean" default="true" />
<cfparam name="attributes.requireCountry" type="boolean" default="false" />

<cfset thisAddressID = createUUID() />

<cfif isNull(attributes.address.getCountryCode()) and attributes.edit>
	<cfset attributes.address.setCountryCode('US') />
</cfif>

<cfif thisTag.executionMode is "start">
	<cfoutput>
		<div id="#thisAddressID#" class="addressDisplay">
			<cfif attributes.edit>
				
				<cfif attributes.showCountry>
					<swa:SlatwallPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#countryCode" property="countryCode" fieldType="select" edit="true" />
				</cfif>
				<cfif attributes.showName>
					<swa:SlatwallPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#name" property="name" edit="true" />
				</cfif>
				<cfif attributes.showCompany>
					<swa:SlatwallPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#company" property="company" edit="true" />
				</cfif>
				<cfif (isNull(attributes.address.getCountry()) || attributes.address.getCountry().getStreetAddressShowFlag()) and attributes.showStreetAddress>
					<swa:SlatwallPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#streetAddress" property="streetAddress" edit="true" />
				</cfif>
				<cfif (isNull(attributes.address.getCountry()) || attributes.address.getCountry().getStreet2AddressShowFlag()) and attributes.showStreet2Address>
					<swa:SlatwallPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#street2Address" property="street2Address" edit="true" />
				</cfif>
				<cfif (isNull(attributes.address.getCountry()) || attributes.address.getCountry().getLocalityShowFlag()) and attributes.showLocality>
					<swa:SlatwallPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#street2Address" property="street2Address" edit="true" />
				</cfif>
				<cfif (isNull(attributes.address.getCountry()) || attributes.address.getCountry().getCityShowFlag()) and attributes.showCity>
					<swa:SlatwallPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#city" property="city" edit="true" />
				</cfif>
				<cfif (isNull(attributes.address.getCountry()) || attributes.address.getCountry().getStateCodeShowFlag()) and attributes.showState>
					<cfif attributes.edit and arrayLen(attributes.address.getStateCodeOptions()) gt 1>
						<swa:SlatwallPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#stateCode" property="stateCode" fieldType="select" edit="true" />
					<cfelse>
						<swa:SlatwallPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#stateCode" property="stateCode" fieldType="text" edit="true" />
					</cfif>
				</cfif>
				<cfif (isNull(attributes.address.getCountry()) || attributes.address.getCountry().getPostalCodeShowFlag()) and attributes.showPostalCode>
					<swa:SlatwallPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#postalCode" property="postalCode" edit="#attributes.edit#" />
				</cfif>
				<input type="hidden" name="#attributes.fieldNamePrefix#addressID" value="#attributes.address.getAddressID()#" />
				
				<script type="text/javascript">
					jQuery(document).ready(function(){
						jQuery('select[name="#attributes.fieldNamePrefix#countryCode"]').change(function() {
							
							var addressData = {
								addressID : jQuery('input[name="#attributes.fieldNamePrefix#addressID"]').val(),
								fieldNamePrefix : '#attributes.fieldNamePrefix#',
								showName : '#attributes.showName#',
								showCompany : '#attributes.showCompany#',
								showStreetAddress : '#attributes.showStreetAddress#',
								showStreet2Address : '#attributes.showStreet2Address#',
								showLocality : '#attributes.showLocality#',
								showCity : '#attributes.showCity#',
								showState : '#attributes.showState#',
								showPostalCode : '#attributes.showPostalCode#',
								showCountry : '#attributes.showCountry#',
								countryCode : jQuery('select[name="#attributes.fieldNamePrefix#countryCode"]').val(),
								name : jQuery('input[name="#attributes.fieldNamePrefix#name"]').val(),
								company : jQuery('input[name="#attributes.fieldNamePrefix#company"]').val(),
								streetAddress : jQuery('input[name="#attributes.fieldNamePrefix#streetAddress"]').val(),
								street2Address : jQuery('input[name="#attributes.fieldNamePrefix#street2Address"]').val(),
								city : jQuery('input[name="#attributes.fieldNamePrefix#city"]').val(),
								postalCode : jQuery('input[name="#attributes.fieldNamePrefix#postalCode"]').val()
							};
							
							if( jQuery('input[name="#attributes.fieldNamePrefix#stateCode"]').val() != undefined ) {
								addressData["stateCode"] = jQuery('input[name="#attributes.fieldNamePrefix#stateCode"]').val();
							}
							
							jQuery.ajax({
								type: 'get',
								url: '#request.slatwallScope.getBaseURL()#/frontend/api/index.cfm/display/addressDisplay/',
								data: addressData,
								dataType: "json",
								context: document.body,
								success: function(r) {
									jQuery('###thisAddressID#').replaceWith(r);
								}
							});
							
						});
					});
				</script>
			<cfelse>
				<cfif len(attributes.address.getName())><strong>#attributes.address.getName()#</strong><br /></cfif>
				<cfif len(attributes.address.getCompany())>#attributes.address.getCompany()#<br /></cfif>
				<cfif len(attributes.address.getStreetAddress())>#attributes.address.getStreetAddress()#<br /></cfif>
				<cfif len(attributes.address.getStreet2Address())>#attributes.address.getStreet2Address()#<br /></cfif>
				<cfif len(attributes.address.getLocality())>#attributes.address.getLocality()#, </cfif>
				<cfif len(attributes.address.getCity())>#attributes.address.getCity()#, </cfif>
				<cfif len(attributes.address.getStateCode())>#attributes.address.getStateCode()# </cfif>
				<cfif len(attributes.address.getPostalCode())>#attributes.address.getPostalCode()#</cfif><br />
				<cfif len(attributes.address.getCountryCode())>#attributes.address.getCountryCode()#</cfif>
			</cfif>
		</div>
	</cfoutput>
</cfif>
