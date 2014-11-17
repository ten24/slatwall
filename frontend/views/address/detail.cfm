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
<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfparam name="address" type="any" />
<cfparam name="edit" type="boolean" default="true" />
<cfparam name="fieldNamePrefix" type="string" default="" />
<cfparam name="showName" type="boolean" default="true" />
<cfparam name="showCompany" type="boolean" default="true" />
<cfparam name="showStreetAddress" type="boolean" default="true" />
<cfparam name="showStreet2Address" type="boolean" default="true" />
<cfparam name="showLocality" type="boolean" default="true" />
<cfparam name="showCity" type="boolean" default="true" />
<cfparam name="showState" type="boolean" default="true" />
<cfparam name="showPostalCode" type="boolean" default="true" />
<cfparam name="showCountry" type="boolean" default="true" />

<cfoutput>
	<div class="addressDisplay">
		<cfif edit>
			<dl>
				<cfif showCountry>
					<swa:SlatwallPropertyDisplay object="#address#" fieldName="#fieldNamePrefix#countryCode" property="countryCode" fieldType="select" edit="true" />
				</cfif>
				<cfif showName>
					<swa:SlatwallPropertyDisplay object="#address#" fieldName="#fieldNamePrefix#name" property="name" edit="true" />
				</cfif>
				<cfif showCompany>
					<swa:SlatwallPropertyDisplay object="#address#" fieldName="#fieldNamePrefix#company" property="company" edit="true" />
				</cfif>
				<cfif address.getCountry().getStreetAddressShowFlag() and showStreetAddress>
					<swa:SlatwallPropertyDisplay object="#address#" fieldName="#fieldNamePrefix#streetAddress" property="streetAddress" edit="true" />
				</cfif>
				<cfif address.getCountry().getStreet2AddressShowFlag() and showStreet2Address>
					<swa:SlatwallPropertyDisplay object="#address#" fieldName="#fieldNamePrefix#street2Address" property="street2Address" edit="true" />
				</cfif>
				<cfif address.getCountry().getCityShowFlag() and showCity>
					<swa:SlatwallPropertyDisplay object="#address#" fieldName="#fieldNamePrefix#city" property="city" edit="true" />
				</cfif>
				<cfif address.getCountry().getStateCodeShowFlag() and showState>
					<cfif arrayLen(address.getStateCodeOptions()) gt 1>
						<swa:SlatwallPropertyDisplay object="#address#" fieldName="#fieldNamePrefix#stateCode" property="stateCode" fieldType="select" edit="true" />
					<cfelse>
						<swa:SlatwallPropertyDisplay object="#address#" fieldName="#fieldNamePrefix#stateCode" property="stateCode" fieldType="text" edit="true" />
					</cfif>
				</cfif>
				<cfif address.getCountry().getPostalCodeShowFlag() and showPostalCode>
					<swa:SlatwallPropertyDisplay object="#address#" fieldName="#fieldNamePrefix#postalCode" property="postalCode" edit="#edit#" />
				</cfif>
				<input type="hidden" name="#fieldNamePrefix#addressID" value="#address.getAddressID()#" />
			</dl>
			
			<script type="text/javascript">
				jQuery(document).ready(function(){
					jQuery('select[name="#fieldNamePrefix#countryCode"]').change(function() {
						jQuery.ajax({
							type: 'get',
							url: '/plugins/Slatwall/api/index.cfm/country/' + jQuery('select[name="#fieldNamePrefix#countryCode"]').val() + '/',
							data: {
								apiKey: '#$.slatwall.getAPIKey("country", "get")#'
							},
							dataType: "json",
							context: document.body,
							success: function(r) {
								console.log(r);
							}
						});
					});
				});
			</script>
		<cfelse>
			<cfif len(address.getName())><strong>#address.getName()#</strong><br /></cfif>
			<cfif len(address.getCompany())>#address.getCompany()#<br /></cfif>
			<cfif len(address.getStreetAddress())>#address.getStreetAddress()#<br /></cfif>
			<cfif len(address.getStreet2Address())>#address.getStreet2Address()#<br /></cfif>
			<cfif len(address.getCity())>#address.getCity()#, </cfif>
			<cfif len(address.getStateCode())>#address.getStateCode()# </cfif>
			<cfif len(address.getPostalCode())>#address.getPostalCode()#</cfif><br />
			<cfif len(address.getCountryCode())>#address.getCountryCode()#</cfif>
		</cfif>
	</div>
</cfoutput>
