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


<cfparam name="rc.orderFulfillment" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<hb:HibachiEntityProcessForm entity="#rc.orderFulfillment#" edit="#rc.edit#" sRedirectAction="admin:entity.detailorderfulfillment">
		
		<hb:HibachiEntityActionBar type="preprocess" object="#rc.orderFulfillment#">
		</hb:HibachiEntityActionBar>
		
		<hb:HibachiPropertyRow>
			<hb:HibachiPropertyList>
				
				<!--- Fulfillment Method --->
				<hb:HibachiPropertyDisplay object="#rc.processObject#" property="fulfillmentMethodID" edit="#rc.edit#">

				<cfset loadFulfillmentMethodType = rc.processObject.getFulfillmentMethodIDOptions()[1]['fulfillmentMethodType'] />
				<cfloop array="#rc.processObject.getFulfillmentMethodIDOptions()#" index="option">
					<cfif option['value'] eq rc.processObject.getFulfillmentMethodID()>
						<cfset loadFulfillmentMethodType = option['fulfillmentMethodType'] />
					</cfif>
				</cfloop>

				<!--- Email Fulfillment Details --->
				<hb:HibachiDisplayToggle selector="select[name='fulfillmentMethodID']" valueAttribute="fulfillmentmethodtype" showValues="email" loadVisable="#loadFulfillmentMethodType eq 'email'#">
					<!--- Email Address --->
					<!--- Setup the primary address as the default account address --->
					<cfset defaultEmail = "" />

					<cfif !isNull(rc.orderFulfillment.getOrder().getAccount())>
						<cfif isNull(rc.processObject.getAccountEmailAddressID()) && !rc.orderFulfillment.getOrder().getAccount().getPrimaryEmailAddress().isNew()>
							<cfset defaultEmail = rc.orderFulfillment.getOrder().getAccount().getPrimaryEmailAddress().getAccountEmailAddressID() />
						<cfelseif !isNull(rc.processObject.getAccountEmailAddressID())>
							<cfset defaultEmail = rc.processObject.getAccountEmailAddressID() />
						</cfif>
					</cfif>
					<!--- Account Address --->
					<hb:HibachiPropertyDisplay object="#rc.processObject#" property="accountEmailAddressID" edit="#rc.edit#" value="#defaultEmail#" />
					<hb:HibachiDisplayToggle selector="select[name='accountEmailAddressID']" showValues="" loadVisable="#!len(defaultEmail)#">
						<hb:HibachiPropertyDisplay object="#rc.processObject#" property="emailAddress" edit="#rc.edit#" />
						<!--- Save New Email Address --->
						<hb:HibachiPropertyDisplay object="#rc.processObject#" property="saveAccountEmailAddressFlag" edit="#rc.edit#" />
					</hb:HibachiDisplayToggle>
				</hb:HibachiDisplayToggle>

				<!--- Attribute values for location typeahead used by shipping and pickup fulfillment methods --->
				<cfset topLevelLocationID = "" />
				<cfset selectedLocationID = "" />

				<!--- Apply additional location filtering to typeahead if non-leaf order defaultStockLocation exists --->
				<cfif not isNull(rc.processObject.getOrderFulfillment().getOrder().getDefaultStockLocation())>
					<cfset topLevelLocationID = rc.processObject.getOrderFulfillment().getOrder().getDefaultStockLocation().getLocationID() />
					
					<!--- use defaultStockLocation as default if it is the only option --->
					<cfif not rc.orderFulfillment.getOrder().getDefaultStockLocation().hasChildren()>
						<cfset selectedLocationID = topLevelLocationID />
					</cfif>
				</cfif>

				<!--- Pickup Fulfillment Details --->
				<hb:HibachiDisplayToggle selector="select[name='fulfillmentMethodID']" valueAttribute="fulfillmentmethodtype" showValues="pickup" loadVisable="#loadFulfillmentMethodType eq 'pickup'#">

					<!--- Select default location if pickupLocationID provided --->
					<cfif not isNull(rc.processObject.getPickupLocationID())>
						<cfset selectedLocationID = rc.processObject.getPickupLocationID() />
					</cfif>

					<swa:SlatwallLocationTypeahead selectedLocationID="#selectedLocationID#" locationPropertyName="pickupLocationID"  locationLabelText="#rc.$.slatwall.rbKey('entity.orderFulfillment.pickupLocation')#" edit="#rc.edit#" showActiveLocationsFlag="true" ignoreParentLocationsFlag="true" topLevelLocationID="#topLevelLocationID#" ></swa:SlatwallLocationTypeahead>
					
				</hb:HibachiDisplayToggle>

				<!--- Shipping Fulfillment Details --->
				<hb:HibachiDisplayToggle selector="select[name='fulfillmentMethodID']" valueAttribute="fulfillmentmethodtype" showValues="shipping" loadVisable="#loadFulfillmentMethodType eq 'shipping'#">
					
					<!--- Display fulfillment location typeahead if non-leaf order defaultStockLocation exists --->
					<cfif not isNull(rc.orderFulfillment.getOrder().getDefaultStockLocation()) and not rc.orderFulfillment.getOrder().getDefaultStockLocation().hasChildren()>

						<!--- Implicitly set locationID to that of defaultStockLocation --->
						<input type="hidden" name="locationID" value="#selectedLocationID#">

					<cfelse>
						<!--- Select default fulfillment location based on locationID --->
						<cfif not isNull(rc.processObject.getPickupLocationID())>
							<cfset selectedLocationID = rc.processObject.getPickupLocationID() />
						</cfif>

						<!--- Display typeahead if options exist --->
						<swa:SlatwallLocationTypeahead selectedLocationID="#selectedLocationID#" locationPropertyName="locationID"  locationLabelText="#rc.$.slatwall.rbKey('processObject.Order_AddOrderItem.locationID')#" edit="#rc.edit#" showActiveLocationsFlag="true" ignoreParentLocationsFlag="true" topLevelLocationID="#topLevelLocationID#" ></swa:SlatwallLocationTypeahead>
						<!---
						<hb:HibachiPropertyDisplay object="#rc.processObject#" property="locationID" edit="#rc.edit#" title="#$.slatwall.rbKey('processObject.Order_AddOrderItem.locationID')#" />  
						--->
					</cfif>

					<!--- Setup the primary address as the default account address --->
					<cfset defaultValue = "" />

					<cfif !isNull(rc.orderFulfillment.getOrder().getAccount())>
					<cfif isNull(rc.processObject.getShippingAccountAddressID()) && !rc.orderFulfillment.getOrder().getAccount().getPrimaryAddress().isNew()>
						<cfset defaultValue = rc.orderFulfillment.getOrder().getAccount().getPrimaryAddress().getAccountAddressID() />
					<cfelseif !isNull(rc.processObject.getShippingAccountAddressID())>
						<cfset defaultValue = rc.processObject.getShippingAccountAddressID() />
					</cfif>

					<!--- Account Address --->
					<hb:HibachiPropertyDisplay object="#rc.processObject#" property="shippingAccountAddressID" edit="#rc.edit#" value="#defaultValue#" />
				</cfif>

					<!--- New Address --->
					<hb:HibachiDisplayToggle selector="select[name='shippingAccountAddressID']" showValues="" loadVisable="#!len(defaultValue)#">

						<!--- Address Display --->
						<swa:SlatwallAdminAddressDisplay address="#rc.processObject.getShippingAddress()#" fieldNamePrefix="shippingAddress." />

					<cfif !isNull(rc.orderFulfillment.getOrder().getAccount())>
						<!--- Save New Address --->
						<hb:HibachiPropertyDisplay object="#rc.processObject#" property="saveShippingAccountAddressFlag" edit="#rc.edit#" />

						<!--- Save New Address Name --->
						<hb:HibachiDisplayToggle selector="input[name='saveShippingAccountAddressFlag']" loadVisable="#rc.processObject.getSaveShippingAccountAddressFlag()#">
							<hb:HibachiPropertyDisplay object="#rc.processObject#" property="saveShippingAccountAddressName" edit="#rc.edit#" />
						</hb:HibachiDisplayToggle>
					</cfif>

					</hb:HibachiDisplayToggle>

				</hb:HibachiDisplayToggle>
				
			</hb:HibachiPropertyList>
			
		</hb:HibachiPropertyRow>
		
	</hb:HibachiEntityProcessForm>
</cfoutput>
