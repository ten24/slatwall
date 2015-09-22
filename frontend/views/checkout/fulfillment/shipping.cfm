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
<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />
<cfparam name="params.orderFulfillment" type="any" />
<cfparam name="params.orderFulfillmentIndex" type="string" />
<cfparam name="params.edit" type="boolean" />

<cfset local.address = $.slatwall.getService("addressService").newAddress() />

<!--- If a Shipping Address for this fulfillment is specified, then use it --->
<cfif not isNull(params.orderFulfillment.getShippingAddress())>
	<cfset local.selectedAccountAddressID = "" />
	<!--- override the new local.address with whatever the shipping address is --->
	<cfset local.address = params.orderFulfillment.getShippingAddress() />
<!--- If an Account Shipping Address for this fulfillment is specified, then use it --->
<cfelseif not isNull(params.orderFulfillment.getAccountAddress())>
	<cfset local.selectedAccountAddressID = params.orderFulfillment.getAccountAddress().getAccountAddressID() />
	<!--- If we are not in edit mode then override the local.address with the account address --->
	<cfif not params.edit>
		<cfset local.address = params.orderFulfillment.getAccountAddress().getAddress() />
	</cfif>
<!--- If the fulfillment has nothing, But this account has addresses the set the current as an account address --->
<cfelseif arrayLen($.slatwall.account().getAccountAddresses())>
	<cfset local.selectedAccountAddressID = $.slatwall.account().getAccountAddresses()[1].getAccountAddressID() />
<!--- Defualt case for new customers with nothing setup --->
<cfelse>
	<cfset local.selectedAccountAddressID = "" />
</cfif>

<cfoutput>
	<div class="svocheckoutfulfillmentshipping">
		<div class="shippingAddress">
			<h5>Shipping Address</h5>
			
			<!--- If In Edit Mode, show the different Shipping Address Form Fields --->
			<cfif params.edit>
				
				<!--- Check For Account Address Options, Loop over and create the various form fields for each --->
				<cfif arrayLen($.slatwall.account().getAccountAddresses())>
					<dl>
						<dt><label for="orderFulfillments[#params.orderFulfillmentIndex#].addressIndex">Select an Address</label></dt>
						<dd>
							<select name="orderFulfillments[#params.orderFulfillmentIndex#].addressIndex">
								<option value="0">New Address</option>
								<cfloop from="1" to="#arrayLen($.slatwall.account().getAccountAddresses())#" index="local.addressIndex">
									<cfset local.accountAddress = $.slatwall.account().getAccountAddresses()[local.addressIndex] />
									<option value="#local.addressIndex#" <cfif local.selectedAccountAddressID EQ local.accountAddress.getAccountAddressID()>Selected</cfif>>#local.accountAddress.getAccountAddressName()#</option>
								</cfloop>
							</select>
						</dd>
					</dl>
					<cfloop from="1" to="#arrayLen($.slatwall.account().getAccountAddresses())#" index="local.addressIndex">
						<cfset local.accountAddress = request.slatwallScope.account().getAccountAddresses()[local.addressIndex] />
						<div id="shippingAddress_#local.addressIndex#" class="addressBlock" style="display:none;">
							<!--- Uncomment if you want to be able to rename address nicknames during checkout --->
							<!---
							<dl>
								<dt><label for="orderFulfillments[#params.orderFulfillmentIndex#].accountAddresses[#local.addressIndex#].accountAddressName">Address Nickname</label></dt>
								<dd><input type="text" name="orderFulfillments[#params.orderFulfillmentIndex#].accountAddresses[#local.addressIndex#].accountAddressName" value="#local.accountAddress.getAccountAddressName()#" /></dd>	
							</dl>
							--->
							<swa:SlatwallAddressDisplay address="#local.accountAddress.getAddress()#" fieldNamePrefix="orderFulfillments[#params.orderFulfillmentIndex#].accountAddresses[#local.addressIndex#].address." edit="true">
							<input type="hidden" name="orderFulfillments[#params.orderFulfillmentIndex#].accountAddresses[#local.addressIndex#].accountAddressID" value="#local.accountAddress.getAccountAddressID()#" />
						</div>
					</cfloop>
				</cfif>
				
				<!--- New Address Form --->
				<div id="shippingAddress_0" class="addressBlock" style="display:none;">
					<swa:SlatwallAddressDisplay address="#local.address#" fieldNamePrefix="orderFulfillments[#params.orderFulfillmentIndex#].shippingAddress." edit="#params.edit#">
					
					<!--- Save New Address Option (Only if not a guest account) --->
					<cfif not $.slatwall.account().isGuestAccount()>
						<dl>
							<dt><label for="orderFulfillments[#params.orderFulfillmentIndex#].saveAccountAddress">Save This Address</label></dt>
							<dd>
								<input type="hidden" name="orderFulfillments[#params.orderFulfillmentIndex#].saveAccountAddress" value="" />
								<input type="checkbox" name="orderFulfillments[#params.orderFulfillmentIndex#].saveAccountAddress" value="1" />
							</dd>
						</dl>
						<dl style="display:none;" class="accountAddressName">
							<dt><label for="orderFulfillments[#params.orderFulfillmentIndex#].saveAccountAddressName">Address Nickname</label></dt>
							<dd>
								<input type="text" name="orderFulfillments[#params.orderFulfillmentIndex#].saveAccountAddressName" value="" />
							</dd>
						</dl>
					</cfif>
				</div>
				
				<input type="hidden" name="orderFulfillments[#params.orderFulfillmentIndex#].orderFulfillmentID" value="#params.orderFulfillment.getOrderFulfillmentID()#" />

			<!--- If NOT In Edit Mode, just display the address --->
			<cfelse>
				<swa:SlatwallAddressDisplay address="#local.address#" edit="false">
			</cfif>
		</div>
		
		<cfif arrayLen(params.orderFulfillment.getShippingMethodOptions())>
			<div class="shippingMethod">
				<h5>Shipping Method</h5>
				<swa:SlatwallShippingMethodDisplay orderFulfillmentIndex="#params.orderFulfillmentIndex#" orderFulfillmentShipping="#params.orderFulfillment#" edit="#local.edit#">
			</div>
		</cfif>
	</div>
	
	<script type="text/javascript">
		jQuery(document).ready(function(){
			
			jQuery('select[name="orderFulfillments[#params.orderFulfillmentIndex#].addressIndex"]').change(function(){
				var selectedAddressIndex = jQuery('select[name="orderFulfillments[#params.orderFulfillmentIndex#].addressIndex"]').val();
				displayShippingAddress(selectedAddressIndex);
			});
			
			jQuery('input[name="orderFulfillments[#params.orderFulfillmentIndex#].saveAccountAddress"]').change(function(){
				if(jQuery(this).attr('checked') == 'checked'){
					jQuery('.accountAddressName').show();
					if(!jQuery('.accountAddressName input').val().length) {
						var name = jQuery('input[name="orderFulfillments[#params.orderFulfillmentIndex#].shippingAddress.name"]').val();
						jQuery('.accountAddressName input').val(name + ' - Home');
					}
				} else {
					jQuery('.accountAddressName').hide();
				}
			});
			
			var currentAddressIndex = jQuery('select[name="orderFulfillments[#params.orderFulfillmentIndex#].addressIndex"]').val();
			
			if(currentAddressIndex == undefined) {
				displayShippingAddress( 0 );
			} else {
				displayShippingAddress( currentAddressIndex );
			}
			
		});
		
		function displayShippingAddress( addressIndex ) {
			jQuery('.addressBlock').hide();
			jQuery('##shippingAddress_' + addressIndex).show();
		}
	</script>
</cfoutput>
