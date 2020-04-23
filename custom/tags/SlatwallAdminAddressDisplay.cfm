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
<cfimport prefix="swa" taglib="../../tags" />
<cfimport prefix="hb" taglib="../../org/Hibachi/HibachiTags" />
<cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#" />
<cfparam name="attributes.address" type="any" />
<cfparam name="attributes.edit" type="boolean" default="true" />
<cfparam name="attributes.fieldNamePrefix" type="string" default="" />
<cfparam name="attributes.showCountry" type="boolean" default="true" />
<cfparam name="attributes.showPhoneNumber" type="boolean" default="true" />
<cfparam name="attributes.showEmailAddress" type="boolean" default="false" />
<cfparam name="attributes.showName" type="boolean" default="true" />
<cfparam name="attributes.showCompany" type="boolean" default="true" />
<cfparam name="attributes.showStreetAddress" type="boolean" default="true" />
<cfparam name="attributes.showStreet2Address" type="boolean" default="true" />
<cfparam name="attributes.showLocality" type="boolean" default="true" />
<cfparam name="attributes.showCity" type="boolean" default="true" />
<cfparam name="attributes.showState" type="boolean" default="true" />
<cfparam name="attributes.showPostalCode" type="boolean" default="true" />
<cfparam name="attributes.site" type="any" />

<cfif isNull(attributes.address.getCountryCode()) and attributes.edit>
	<cfif !isNull(attributes.site)>
		<cfset attributes.address.setCountryCode(attributes.hibachiScope.getService('SiteService').getCountryCodeBySite(attributes.site))>
	<cfelse>
		<cfset attributes.address.setCountryCode('US') />
	</cfif>
</cfif>

<cfset local.suggestionID = 'suggestion-'&createUUID() />

<cfif thisTag.executionMode is "start">
	<cfoutput>

		<div class="slatwall-address-container form-horizontal">
			<input type="hidden" name="#attributes.fieldNamePrefix#addressID" value="#attributes.address.getAddressID()#" />
			<cfif attributes.showCountry>
				<hb:HibachiPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#countryCode" property="countryCode" fieldType="select" fieldClass="slatwall-address-countryCode" />
				<cfif attributes.edit>
					<input type="hidden" name="#attributes.fieldNamePrefix#countryCode" value="#attributes.address.getCountryCode()#" />
				</cfif>
			</cfif>
			<cfif attributes.showName>
				<hb:HibachiPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#name" property="name" edit="#attributes.edit#" fieldClass="slatwall-address-name" />
			</cfif>
			<cfif attributes.showCompany>
				<hb:HibachiPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#company" property="company" edit="#attributes.edit#" fieldClass="slatwall-address-company"  />
			</cfif>
			<cfif attributes.showPhoneNumber>
				<hb:HibachiPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#phoneNumber" property="phoneNumber" edit="#attributes.edit#" fieldClass="slatwall-address-phoneNumber"  />
			</cfif>
			<cfif attributes.showEmailAddress>
				<hb:HibachiPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#emailAddress" property="emailAddress" edit="#attributes.edit#" fieldClass="slatwall-address-emailAddress"  />
			</cfif>
			<cfif attributes.showStreetAddress AND (isNull(attributes.address.getCountry()) OR ( NOT isNull(attributes.address.getCountry().getStreetAddressShowFlag()) AND attributes.address.getCountry().getStreetAddressShowFlag() ) )>
				<hb:HibachiPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#streetAddress" property="streetAddress" edit="#attributes.edit#" fieldClass="slatwall-address-streetAddress" />	
			</cfif>
			<cfif attributes.showStreet2Address AND (isNull(attributes.address.getCountry()) OR ( NOT isNull(attributes.address.getCountry().getStreet2AddressShowFlag()) AND attributes.address.getCountry().getStreet2AddressShowFlag() ) )>
				<hb:HibachiPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#street2Address" property="street2Address" edit="#attributes.edit#" fieldClass="slatwall-address-street2Address" />	
			</cfif>
			<cfif attributes.showLocality AND (isNull(attributes.address.getCountry()) OR  ( NOT isNull(attributes.address.getCountry().getLocalityShowFlag()) AND attributes.address.getCountry().getLocalityShowFlag()  ))>
				<hb:HibachiPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#locality" property="locality" edit="#attributes.edit#" fieldClass="slatwall-address-locality" />	
			</cfif>
			<cfif attributes.showCity AND (isNull(attributes.address.getCountry()) OR  ( NOT isNULL(attributes.address.getCountry().getCityShowFlag()) AND attributes.address.getCountry().getCityShowFlag()) ) >
				<hb:HibachiPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#city" property="city" edit="#attributes.edit#" fieldClass="slatwall-address-city" />	
			</cfif>
			<cfif attributes.showState AND (isNull(attributes.address.getCountry()) OR ( NOT isNull(attributes.address.getCountry().getStateCodeShowFlag()) AND attributes.address.getCountry().getStateCodeShowFlag() ))  >
				<cfif attributes.edit and arrayLen(attributes.address.getStateCodeOptions()) gt 1>
					<hb:HibachiPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#stateCode" property="stateCode" fieldType="select" edit="#attributes.edit#" fieldClass="slatwall-address-stateCode" />
				<cfelse>
					<hb:HibachiPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#stateCode" property="stateCode" fieldType="text" edit="#attributes.edit#" fieldClass="slatwall-address-stateCode" />
				</cfif>
			</cfif>
			<cfif attributes.showPostalCode AND (isNull(attributes.address.getCountry()) OR  ( NOT isNull(attributes.address.getCountry().getPostalCodeShowFlag()) AND attributes.address.getCountry().getPostalCodeShowFlag() )) >
				<hb:HibachiPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#postalCode" property="postalCode" edit="#attributes.edit#" fieldClass="slatwall-address-postalCode" />	
			</cfif>
			
			<cfif len(trim(attributes.address.getAddressID())) EQ 0>
				<div class="#local.suggestionID#-block well well-lg" style="display:none">
					<h4>#attributes.hibachiScope.rbKey("entity.address.suggestedAddress")#:</h4>
					
					<input type="hidden" name="#attributes.fieldNamePrefix#verifyAddress" value="true">
					<span class="#local.suggestionID#-address-new"></span><br>
					<span class="#local.suggestionID#-address-new-2"></span><br>
					<span class="#local.suggestionID#-address-new-3"></span><br>
					<a class="btn btn-success" id="#local.suggestionID#">#attributes.hibachiScope.rbKey("entity.address.useSuggestedAddress")#</a>
					<a class="btn btn-default pull-right" id="#local.suggestionID#-continue">#attributes.hibachiScope.rbKey("entity.address.continueSuggestedAddress")#</a>
				</div>
			</cfif>
		</div>

		<cfif len(trim(attributes.address.getAddressID())) EQ 0>
			<script type="text/javascript">
				$(document).ready(function(){
					
					
					var prefix          = '#local.suggestionID#';
					var preventDupsHash = '';
					var countryCode     = $("input[name='#attributes.fieldNamePrefix#countryCode']");
					var streetAddress   = $("input[name='#attributes.fieldNamePrefix#streetAddress']");
					var street2Address  = $("input[name='#attributes.fieldNamePrefix#street2Address']");
					var locality        = $("input[name='#attributes.fieldNamePrefix#locality']");
					var city            = $("input[name='#attributes.fieldNamePrefix#city']");
					var stateCode       = $("select[name='#attributes.fieldNamePrefix#stateCode']");
					var postalCode      = $("input[name='#attributes.fieldNamePrefix#postalCode']");
					var verify          = $("input[name='#attributes.fieldNamePrefix#verifyAddress");
					var suggestion      = {};
					var currentForm     = streetAddress.closest("form");
					var submitForm      = false;

					currentForm.submit(function(event) {
						if(!submitForm){
							event.preventDefault();
							var requestData = {
								'address.countryCode' : countryCode.val(),
								'address.streetAddress' : streetAddress.val(),
								'address.street2Address' : street2Address.val(),
								'address.city' : city.val(),
								'address.stateCode' : locality.val() ? locality.val() : stateCode.children("option:selected").val(),
								'address.postalCode' : postalCode.val()
							};
							if(!requestData['address.streetAddress']){
								submitForm = true;
								verify.val('false');
								currentForm.submit();
								return;
							}
							
							if(JSON.stringify(requestData) != preventDupsHash){
								preventDupsHash = JSON.stringify(requestData);
								$.ajax({
									type: 'POST',
									url: '?slatAction=api:main.verifyAddress',
									data: requestData,
									dataType: "json",
									context: document.body,
									success: function(r) {
										suggestion = r.suggestedAddress;
										
										if(suggestion === 'undefined' || (!r.success &&
											suggestion.streetAddress.toLowerCase() == requestData['address.streetAddress'] &&
											suggestion.city.toLowerCase() == requestData['address.city'] &&
											suggestion.stateCode.toLowerCase() == requestData['address.stateCode'] &&
											suggestion.postalCode.substring(0, 5) == requestData['address.postalCode'].substring(0, 5))
										){
											r.success = true;
										}
										
										if(!r.success){
											$('.'+prefix+'-address-new').text(suggestion.streetAddress);
											$('.'+prefix+'-address-new-2').text(suggestion.city+' - '+ suggestion.stateCode + ', ' +suggestion.countryCode);
											$('.'+prefix+'-address-new-3').text(suggestion.postalCode);
											$('.#local.suggestionID#-block').show();
										}else{
											submitForm = true;
											verify.val('true');
											currentForm.submit();
										}
									}
								});
							}
						}
					});
					
					$('###local.suggestionID#').on('click', function() {
					  if(suggestion.streetAddress.toLowerCase() != streetAddress.val().toLowerCase()){
					  	streetAddress.val(suggestion.streetAddress)
					  }
					  if(suggestion.city.toLowerCase() != city.val().toLowerCase()){
					  	city.val(suggestion.city)
					  }
					  if(suggestion.postalCode.toLowerCase() != postalCode.val().toLowerCase()){
					  	postalCode.val(suggestion.postalCode)
					  }
					  submitForm = true;
					  verify.val('true');
					  currentForm.submit();
					});
					
					$('###local.suggestionID#-continue').on('click', function() {
					  submitForm = true;
					  verify.val('false');
					  currentForm.submit();
					});
					
				});
			</script>
		</cfif>
	</cfoutput>
</cfif>
