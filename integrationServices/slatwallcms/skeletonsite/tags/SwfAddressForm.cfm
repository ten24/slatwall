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
<cfimport prefix="sw" taglib="." />

<cfparam name="attributes.selectedAccountAddress" type="string" />
<cfparam name="attributes.method" type="string" />
<cfparam name="attributes.visible" type="string" />
<cfparam name="attributes.formID" type="string" default="#createUUID()#" />
<cfparam name="attributes.additionalParameters" type="string" default="{}" />

<cfoutput>
    <cfif thisTag.executionMode is "start">
        <span ng-init="additionalParameters = #attributes.additionalParameters#"></span>
        
        <div class="alert alert-success" ng-show="slatwall.requests['#attributes.method#'].successfulActions.length">Shipping Address saved.</div>
        <div class="alert alert-danger" ng-show="slatwall.requests['#attributes.method#'].failureActions.length">Error saving shipping address. See below for errors.</div>
        <form 
        	ng-model="#attributes.selectedAccountAddress#" 
        	data-method="#attributes.method#"
        	ng-show="#attributes.visible#"
        	id="#attributes.formID#"
        	swf-address-form
        >
        	<input id="#attributes.formID#_addressAccountID" type="hidden" name="accountAddressID"  class="form-control"
        		ng-model="#attributes.selectedAccountAddress#.accountAddressID" 
        	>
            <h5>Create/Edit Shipping Address</h5>
        	<!---TODO:drive by success and failure actions being populated--->
            <div class="row">
        		<div class="form-group col-md-6">
        			<label for="#attributes.formID#_firstname" class="form-label">First Name</label>
        			<input id="#attributes.formID#_firstname" type="text" name="firstName" placeholder="First Name" class="form-control"
        				ng-model="#attributes.selectedAccountAddress#.address.firstName" swvalidationrequired="true"
        			>
                    <sw:SwfErrorDisplay formController="swfAddressForm" propertyIdentifier="firstName"/>
        		</div>
        		<div class="form-group col-md-6">
        			<label for="#attributes.formID#_lastname" class="form-label">Last Name</label>
        			<input id="#attributes.formID#_lastname" type="text" name="lastName" placeholder="Last Name" class="form-control"
        				ng-model="#attributes.selectedAccountAddress#.address.lastName" swvalidationrequired="true"
        			>
                    <sw:SwfErrorDisplay formController="swfAddressForm" propertyIdentifier="lastName"/>
                </div>
        		<div class="form-group col-md-6">
        			<label for="#attributes.formID#_street" class="form-label">{{swfAddressForm.addressOptions.streetAddressLabel || 'Street'}}</label>
        			<input id="#attributes.formID#_street" type="text" name="streetAddress" placeholder="Street Address" class="form-control"
        				ng-model="#attributes.selectedAccountAddress#.address.streetAddress" swvalidationrequired="true"
        			>
                    <sw:SwfErrorDisplay formController="swfAddressForm" propertyIdentifier="streetAddress"/>
                </div>
                <div class="form-group col-md-6">
        			<label for="#attributes.formID#_street2" class="form-label">{{swfAddressForm.addressOptions.street2AddressLabel || 'Street Address 2'}}</label>
        			<input id="#attributes.formID#_street2" type="text" name="street2Address" placeholder="Street Address" class="form-control"
        				ng-model="#attributes.selectedAccountAddress#.address.street2Address" 
        			>
        			<sw:SwfErrorDisplay formController="swfAddressForm" propertyIdentifier="street2Address"/>
                </div>
        		<div class="form-group col-md-3">
        			<label for="#attributes.formID#_city" class="form-label">{{swfAddressForm.addressOptions.cityLabel || 'City'}}</label>
        			<input id="#attributes.formID#_city" type="text" name="city" placeholder="City" class="form-control"
        				ng-model="#attributes.selectedAccountAddress#.address.city" swvalidationrequired="true"
        			>
                    <sw:SwfErrorDisplay formController="swfAddressForm" propertyIdentifier="city"/>
                </div>
        		<div class="form-group col-md-3">
        			<label for="#attributes.formID#_zip" class="form-label">{{swfAddressForm.addressOptions.postalCodeLabel || 'Zip Code'}}</label>
        			<input id="#attributes.formID#_zip" type="text" name="postalCode" placeholder="Zip code" class="form-control"
        				ng-model="#attributes.selectedAccountAddress#.address.postalCode" swvalidationrequired="true"
        			>
                    <sw:SwfErrorDisplay formController="swfAddressForm" propertyIdentifier="postalCode"/>
                </div>
        		<div class="form-group col-md-3" ng-if="!swfAddressForm.addressOptions || swfAddressForm.addressOptions.stateCodeShowFlag" ng-cloak>
        			<label for="#attributes.formID#_state" class="form-label">{{swfAddressForm.addressOptions.stateCodeLabel || 'State'}}</label>
        			<select id="#attributes.formID#_stateSelect" type="text" name="stateCode" placeholder="State" class="form-control"
        				ng-model="#attributes.selectedAccountAddress#.address.stateCode" swvalidationrequired="true" ng-if="slatwall.states.stateCodeOptions.length"
        			>
        				<option value="">State list...</option>
                        <option ng-repeat="state in slatwall.states.stateCodeOptions track by state.value" ng-value="state.value" ng-bind="state.name"
                        	ng-selected="state.value==#attributes.selectedAccountAddress#.address.stateCode"
                        ></option>
                    </select>
                    <input id="#attributes.formID#_stateInput" type="text" name="stateCode" placeholder="State" class="form-control"
        				ng-model="#attributes.selectedAccountAddress#.address.stateCode" swvalidationrequired="true" ng-if="!slatwall.states.stateCodeOptions.length">
                    <sw:SwfErrorDisplay formController="swfAddressForm" propertyIdentifier="stateCode"/>
                </div>
                <div class="form-group col-md-3" ng-if="swfAddressForm.addressOptions && swfAddressForm.addressOptions.localityShowFlag">
        			<label for="#attributes.formID#_locality" class="form-label">{{swfAddressForm.addressOptions.localityLabel || 'Locality'}}</label>
        			<input id="#attributes.formID#_locality" type="text" name="locality" placeholder="Zip code" class="form-control"
        				ng-model="#attributes.selectedAccountAddress#.address.locality" swvalidationrequired="true"
        			>
                    <sw:SwfErrorDisplay formController="swfAddressForm" propertyIdentifier="postalCode"/>
                </div>
        		<div class="form-group col-md-3">
        			<label for="#attributes.formID#_country" class="form-label">Country</label>
        			<select id="#attributes.formID#_country" type="text" name="countryCode" placeholder="Country" class="form-control"
        				ng-model="#attributes.selectedAccountAddress#.address.countryCode" swvalidationrequired="true"
        			>
                        <option value="">Country list...</option>
                        <option ng-repeat="country in slatwall.countries.countryCodeOptions track by country.value" ng-value="country.value" ng-bind="country.name"
                        	ng-selected="country.value==#attributes.selectedAccountAddress#.address.countryCode"
                        ></option>
                    </select>
                    <sw:SwfErrorDisplay formController="swfAddressForm" propertyIdentifier="countryCode"/>
                </div>
        		<div class="form-group col-md-6">
        			<label for="#attributes.formID#_phone-number" class="form-label">Phone Number</label>
        			<input id="#attributes.formID#_phone-number" type="tel" name="phoneNumber" placeholder="Phone number" class="form-control"
        				ng-model="#attributes.selectedAccountAddress#.address.phoneNumber" swvalidationrequired="true"
        			>
                    <sw:SwfErrorDisplay formController="swfAddressForm" propertyIdentifier="phoneNumber"/>
        		</div>
                <div class="form-group col-md-6">
        			<label for="#attributes.formID#_email" class="form-label">Email Address</label>
        			<input id="#attributes.formID#_email" name="emailAddress" placeholder="Email Address" class="form-control"
        				ng-model="#attributes.selectedAccountAddress#.address.emailAddress" swvalidationrequired="true" swvalidationdatatype="email"
        			>
                    <sw:SwfErrorDisplay formController="swfAddressForm" propertyIdentifier="emailAddress"/>
                </div>
                <div class="form-group col-md-6">
        			<label for="#attributes.formID#_company" class="form-label">Company</label>
        			<input id="#attributes.formID#_company" type="text" name="company" placeholder="Company" class="form-control"
        				ng-model="#attributes.selectedAccountAddress#.address.company"
        			>
        			<sw:SwfErrorDisplay formController="swfAddressForm" propertyIdentifier="company"/>
        		</div>
                <div class="form-group col-md-6">
        			<label for="#attributes.formID#_addressNickname" class="form-label">Address Nickname</label>
        			<input id="#attributes.formID#_addressNickname" type="text" name="accountAddressName" placeholder="Address Nickname" class="form-control"
        				ng-model="#attributes.selectedAccountAddress#.accountAddressName"
        			>
        			<sw:SwfErrorDisplay formController="swfAddressForm" propertyIdentifier="accountAddressName"/>
        		</div>
        	</div>
        	
        	<!-- Additional Parameters -->
        	<span ng-repeat="(key,value) in additionalParameters">
                <input type="hidden" name="{{key}}" ng-model="additionalParameters[key]">
            </span>
        	<!---TODO:implement options--->
            <!---<div class="row">
                <div class="form-group col-md-6">
                    <div class="form-group custom-control custom-checkbox">
                        <input type="checkbox" class="custom-control-input" id="address_save">
                        <label class="custom-control-label" for="address_save">Save to address book?</label>
                    </div>
                    <div class="form-group custom-control custom-checkbox">
                        <input type="checkbox" class="custom-control-input" id="address_default">
                        <label class="custom-control-label" for="address_default">Set as default address?</label>
                    </div>
                    <div class="form-group custom-control custom-checkbox">
                        <input type="checkbox" class="custom-control-input" id="address_billing_shipping">
                        <label class="custom-control-label" for="address_billing_shipping">Billing same as Shipping?</label>
                    </div>
                </div>
            </div>--->
        
            <div class="form-group">
                <!-- Save Address button -->
                <button ng-click="swfAddressForm.submitAddressForm()" 
                	ng-class="{disabled:swfAddressForm.loading}" 
                	class="btn btn-primary btn-block"
                >{{(slatwall.getRequestByAction('#attributes.method#').loading ? '' : 'Save Address')}}
                	<i ng-show="swfAddressForm.loading" class='fa fa-refresh fa-spin fa-fw'></i>
                </button>
                <!-- Close button to close create/edit shipping address & display  -->
                <button ng-show="#attributes.selectedAccountAddress#.accountAddressID.trim().length" 
                	class="btn btn-danger btn-sm mt-2"
                	ng-click="slatwall.deleteAccountAddress(#attributes.selectedAccountAddress#.accountAddressID)"
                	ng-disabled="slatwall.getRequestByAction('deleteAccountAddress').loading"
                >
                	{{slatwall.getRequestByAction('deleteAccountAddress').loading ? '':'Delete Address'}}
                    <i ng-show="slatwall.getRequestByAction('deleteAccountAddress').loading" class="fa fa-refresh fa-spin fa-fw my-1 float-right"></i>
                </button>
            </div>
            <!-- Create Shipping Address Button - only show when other addresses exist -->
            
        </form>
    </cfif>
</cfoutput>