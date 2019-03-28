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
<!--- This import allows for the custom tags required by this page to work --->
<cfimport prefix="sw" taglib="./" />

<!---[DEVELOPER NOTES]															
																				
	If you would like to customize any of the public tags used by this			
	template, the recommended method is to uncomment the below import,			
	copy the tag you'd like to customize into the directory defined by			
	this import, and then reference with swc:tagname instead of sw:tagname.		
	Technically you can define the prefix as whatever you would like and use	
	whatever directory you would like but we recommend using this for			
	the sake of convention.														
																				
	<cfimport prefix="swc" taglib="/Slatwall/custom/public/tags" />				
																				
--->

<cfparam name="attributes.address" type="any" />
<cfparam name="attributes.ID" type="string" default="#createUUID()#" />
<cfparam name="attributes.fieldNamePrefix" type="string" default="" />
<cfparam name="attributes.fieldList" type="string" default="countryCode,name,company,streetAddress,street2Address,locality,city,stateCode,postalCode" />
<cfparam name="attributes.fieldClass" type="string" default="" />

<cfif isNull(attributes.address.getCountryCode())>
	<cfset attributes.address.setCountryCode('US') />
</cfif>

<cfif thisTag.executionMode is "start">
	<cfoutput>
		<!--- We place all of thse values into a 'sw-address' div so that the jQuery below updates the address fields based on --->
		<div id="#attributes.ID#" class="sw-address">
			
			<!--- We need to add a hidden address field so that the data can be populated, or updated --->
			<input type="hidden" name="#attributes.fieldNamePrefix#addressID" value="#attributes.address.getAddressID()#" />
			
			<cfloop list="#attributes.fieldList#" index="thisField">
				<!--- Country (important the data-sw-address allows for this to be modified by jQuery below)--->
				<cfif thisField eq "countryCode">
					<div class="control-group" data-sw-address="countryCode">
						<label class="control-label" for="rating">#request.slatwallScope.rbKey('entity.address.countryCode')#</label>
						<div class="controls">
							
							<sw:FormField type="select" name="#attributes.fieldNamePrefix#countryCode" valueObject="#attributes.address#" valueObjectProperty="countryCode" valueOptions="#attributes.address.getCountryCodeOptions()#" class="#attributes.fieldClass#" />
							<sw:ErrorDisplay object="#attributes.address#" errorName="countryCode" />
							
						</div>
					</div>
				</cfif>
				
				<!--- Name (important the data-sw-address allows for this to be modified by jQuery below)--->
				<cfif thisField eq "name">
					<div class="control-group" data-sw-property="name">
						<label class="control-label" for="rating" data-sw-label="true">#request.slatwallScope.rbKey('entity.address.name')#</label>
						<div class="controls" data-sw-field="true">
							
							<sw:FormField type="text" name="#attributes.fieldNamePrefix#name" valueObject="#attributes.address#" valueObjectProperty="name" class="#attributes.fieldClass#" />
							<sw:ErrorDisplay object="#attributes.address#" errorName="name" />
							
						</div>
					</div>
				</cfif>
				
				<!--- Company (important the data-sw-address allows for this to be modified by jQuery below)--->
				<cfif thisField eq "company">
					<div class="control-group" data-sw-property="company">
						<label class="control-label" for="rating" data-sw-label="true">#request.slatwallScope.rbKey('entity.address.company')#</label>
						<div class="controls" data-sw-field="true">
							
							<sw:FormField type="text" name="#attributes.fieldNamePrefix#company" valueObject="#attributes.address#" valueObjectProperty="company" class="#attributes.fieldClass#" />
							<sw:ErrorDisplay object="#attributes.address#" errorName="company" />
							
						</div>
					</div>
				</cfif>
				
				<!--- Street Address (important the data-sw-address allows for this to be modified by jQuery below)--->
				<cfif thisField eq "streetAddress">
					<div class="control-group#request.slatwallScope.getService('hibachiUtilityService').hibachiTernary(attributes.address.getCountry().getStreetAddressShowFlag(), '', ' hide')#" data-sw-property="streetAddress">
						<label class="control-label" for="rating" data-sw-label="true">#request.slatwallScope.rbKey('entity.address.streetAddress')#</label>
						<div class="controls" data-sw-field="true">
							
							<sw:FormField type="text" name="#attributes.fieldNamePrefix#streetAddress" valueObject="#attributes.address#" valueObjectProperty="streetAddress" class="#attributes.fieldClass#" />
							<sw:ErrorDisplay object="#attributes.address#" errorName="streetAddress" />
							
						</div>
					</div>
				</cfif>
				
				<!--- Street 2 Address (important the data-sw-address allows for this to be modified by jQuery below)--->
				<cfif thisField eq "street2Address">
					<div class="control-group#request.slatwallScope.getService('hibachiUtilityService').hibachiTernary(attributes.address.getCountry().getStreet2AddressShowFlag(), '', ' hide')#" data-sw-property="street2Address">
						<label class="control-label" for="rating" data-sw-label="true">#request.slatwallScope.rbKey('entity.address.street2Address')#</label>
						<div class="controls" data-sw-field="true">
							
							<sw:FormField type="text" name="#attributes.fieldNamePrefix#street2Address" valueObject="#attributes.address#" valueObjectProperty="street2Address" class="#attributes.fieldClass#" />
							<sw:ErrorDisplay object="#attributes.address#" errorName="street2Address" />
							
						</div>
					</div>
				</cfif>
				
				<!--- Locality --->
				<cfif thisField eq "locality">
					<div class="control-group#request.slatwallScope.getService('hibachiUtilityService').hibachiTernary(attributes.address.getCountry().getLocalityShowFlag(), '', ' hide')#" data-sw-property="locality">
						<label class="control-label" for="rating" data-sw-label="true">#request.slatwallScope.rbKey('entity.address.locality')#</label>
						<div class="controls" data-sw-field="true">
							
							<sw:FormField type="text" name="#attributes.fieldNamePrefix#locality" valueObject="#attributes.address#" valueObjectProperty="locality" class="#attributes.fieldClass#" />
							<sw:ErrorDisplay object="#attributes.address#" errorName="locality" />
							
						</div>
					</div>
				</cfif>
				
				<!--- City --->
				<cfif thisField eq "city">
					<div class="control-group#request.slatwallScope.getService('hibachiUtilityService').hibachiTernary(attributes.address.getCountry().getCityShowFlag(), '', ' hide')#" data-sw-property="city">
						<label class="control-label" for="rating" data-sw-label="true">#request.slatwallScope.rbKey('entity.address.city')#</label>
						<div class="controls" data-sw-field="true">
							
							<sw:FormField type="text" name="#attributes.fieldNamePrefix#city" valueObject="#attributes.address#" valueObjectProperty="city" class="#attributes.fieldClass#" />
							<sw:ErrorDisplay object="#attributes.address#" errorName="city" />
							
						</div>
					</div>
				</cfif>
				
				<!--- State Code --->
				<cfif thisField eq "stateCode">
					<div class="control-group#request.slatwallScope.getService('hibachiUtilityService').hibachiTernary(attributes.address.getCountry().getStateCodeShowFlag(), '', ' hide')#" data-sw-property="stateCode">
						<label class="control-label" for="rating" data-sw-label="true">#request.slatwallScope.rbKey('entity.address.stateCode')#</label>
						<div class="controls" data-sw-field="true">
							
							<cfif arrayLen(attributes.address.getStateCodeOptions())>
								<sw:FormField type="select" name="#attributes.fieldNamePrefix#stateCode" valueObject="#attributes.address#" valueObjectProperty="stateCode" valueOptions="#attributes.address.getCountry().getStateCodeOptions()#" class="#attributes.fieldClass#" />
							<cfelse>
								<sw:FormField type="text" name="#attributes.fieldNamePrefix#stateCode" valueObject="#attributes.address#" valueObjectProperty="stateCode" class="#attributes.fieldClass#" />
							</cfif>
							<sw:ErrorDisplay object="#attributes.address#" errorName="stateCode" />
							
						</div>
					</div>
				</cfif>
				
				<!--- Postal Code --->
				<cfif thisField eq "postalCode">
					<div class="control-group#request.slatwallScope.getService('hibachiUtilityService').hibachiTernary(attributes.address.getCountry().getPostalCodeShowFlag(), '', ' hide')#" data-sw-property="postalCode">
						<label class="control-label" for="rating" data-sw-label="true">#request.slatwallScope.rbKey('entity.address.postalCode')#</label>
						<div class="controls" data-sw-field="true">
							
							<sw:FormField type="text" name="#attributes.fieldNamePrefix#postalCode" valueObject="#attributes.address#" valueObjectProperty="postalCode" class="#attributes.fieldClass#" />
							<sw:ErrorDisplay object="#attributes.address#" errorName="postalCode" />
							
						</div>
					</div>
				</cfif>
				
			</cfloop>
			
			<script type="text/javascript">
				(function($){
					
					$(document).ready(function(e){
						
						$('body').on('change', 'select[name="#attributes.fieldNamePrefix#countryCode"]', function(){
							
							var that = this;
							var fieldList = '#attributes.fieldList#';
							
							var data = {
								'slatAction': 'public:ajax.country',
								'countryCode': $(this).val()
							};
							
							jQuery.ajax({
								type: 'get',
								url: '#request.slatwallScope.getApplicationValue("baseURL")#/',
								data: data,
								dataType: "json",
								context: document.body,
								headers: { 'X-Hibachi-AJAX': true },
								error: function( err ) {
									alert('There was an error processing request: ' + err);
								},
								success: function(r) {
									
									// Show & Hide necessary elements
									$.each(['streetAddress','street2Address','locality','city','stateCode','postalCode'], function(i, v){
										if(r.country[ v + 'ShowFlag' ] && $(that).closest('.sw-address').find('[data-sw-property="' + v + '"]').hasClass('hide')) {
											$(that).closest('.sw-address').find('[data-sw-property="' + v + '"]').removeClass('hide');
										} else if (!r.country[ v + 'ShowFlag' ] && !$(that).closest('.sw-address').find('[data-sw-property="' + v + '"]').hasClass('hide')) {
											$(that).closest('.sw-address').find('[data-sw-property="' + v + '"]').addClass('hide');
										}
									});
									
									// State Options Exists, and the select already exists
									if(r.country.stateCodeOptions.length) {
										
										// Possible turn from text input to select
										if($(that).closest('.sw-address').find('[data-sw-property="stateCode"] input').length && !$(that).closest('.sw-address').find('[data-sw-property="stateCode"] select').length) {
											var dname = $(that).closest('.sw-address').find('[data-sw-property="stateCode"] input').attr('name');
											var dclass = $(that).closest('.sw-address').find('[data-sw-property="stateCode"] input').attr('class');
											var newSelect = '<select name="' + dname + '" class="' + dclass + '"></select>';
											$(that).closest('.sw-address').find('[data-sw-property="stateCode"] input').replaceWith( newSelect );
										}
										
										// Clear out the options
										$(that).closest('.sw-address').find('[data-sw-property="stateCode"] select').html('');
										
										// Loop over the options and add then to the select
										$.each(r.country.stateCodeOptions, function(i, v){
											$(that).closest('.sw-address').find('[data-sw-property="stateCode"] select').append('<option value="' + v['value'] + '">' + v['name'] + '</option>');	
										});
										
									// If we need to convert the select box into a text input
									} else if(!$(that).closest('.sw-address').find('[data-sw-property="stateCode"] input').length && $(that).closest('.sw-address').find('[data-sw-property="stateCode"] select').length) {
										 
										var dname = $(that).closest('.sw-address').find('[data-sw-property="stateCode"] select').attr('name');
										var dclass = $(that).closest('.sw-address').find('[data-sw-property="stateCode"] select').attr('class');
										var newInput = '<input type="text" name="' + dname + '" class="' + dclass + '" />';
										$(that).closest('.sw-address').find('[data-sw-property="stateCode"] select').replaceWith(newInput);
										
									}
									
								}
							});
							
						});
							
					});
					
				})( jQuery );
			</script>
		</div>
	</cfoutput>
</cfif>
