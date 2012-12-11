<!---

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) 2011 ten24, LLC

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
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

--->

<cfparam name="rc.orderItem" type="any" />
<cfparam name="rc.order" type="any" />

<cfoutput>
	<cf_SlatwallDetailForm object="#rc.orderItem#" edit="true" saveaction="admin:order.addOrderItem">
		
		<input type="hidden" name="orderID" value="#rc.order.getOrderID()#" />
		
		<cf_SlatwallDetailHeader fluidDisplay="false">
			<cf_SlatwallPropertyList divClass="span6">
				<div style="height:300px;">
				<cf_SlatwallPropertyDisplay object="#rc.orderItem#" fieldname="skuID" property="sku" fieldtype="textautocomplete" autocompletePropertyIdentifiers="adminIcon,product.productName,product.productType.productTypeName,skuCode,price" edit="true">
				<cf_SlatwallPropertyDisplay object="#rc.orderItem#" fieldname="quantity" property="quantity" edit="true" value="1">
				</div>
			</cf_SlatwallPropertyList>
			<cf_SlatwallPropertyList divClass="span6">
				<cfset local.orderFulfillmentSmartList = rc.order.getOrderFulfillmentsSmartList() />
				<cfset local.existingFulfillmentSelected = false />
				<div class="control-group">
					<label for="fulfillmentMethodID" class="control-label">#$.slatwall.rbKey('entity.orderFulfillment')#</label>
					<div class="controls">
						<select name="orderFulfillment.orderFulfillmentID" class="valid">
							<cfloop array="#local.orderFulfillmentSmartList.getRecords()#" index="orderFulfillment">
								<cfif not local.existingFulfillmentSelected>
									<cfset local.existingFulfillmentSelected = true />
									<option value="#orderFulfillment.getOrderFulfillmentID()#" selected="selected">#orderFulfillment.getFulfillmentMethod().getFulfillmentMethodName()# | <cfif not isNull(orderFulfillment.getAddress())>#orderFulfillment.getAddress().getSimpleRepresentation()#</cfif></option>
								<cfelse>
									<option value="#orderFulfillment.getOrderFulfillmentID()#">#orderFulfillment.getFulfillmentMethod().getFulfillmentMethodName()# | <cfif not isNull(orderFulfillment.getAddress())>#orderFulfillment.getAddress().getSimpleRepresentation()#</cfif></option>
								</cfif>
							</cfloop>
							<option value="">#$.slatwall.rbKey('define.new')#</option>
						</select>
					</div>
				</div>
				<div <cfif local.existingFulfillmentSelected>style="display:none;"</cfif> id="newFulfillmentMethod">
					<cfset local.fulfillmentMethodSmartList = $.slatwall.getService("fulfillmentService").getFulfillmentMethodSmartList() />
					<cfset local.fulfillmentMethodSmartList.addFilter('activeFlag', 1) />
					<cfset local.fulfillmentMethodSmartList.addOrder('sortOrder|ASC') />
					<div class="control-group">
						<label for="fulfillmentMethodID" class="control-label">#$.slatwall.rbKey('entity.fulfillmentMethod')#</label>
						<div class="controls">
							<select name="orderFulfillment.orderFulfillmentID" class="valid">
								<cfloop array="#local.fulfillmentMethodSmartList.getRecords()#" index="fulfillmentMethod">
									<option value="#fulfillmentMethod.getFulfillmentMethodID()#">
										#fulfillmentMethod.getFulfillmentMethodName()#
									</option>
								</cfloop>
							</select>
						</div>
					</div>
					<cf_SlatwallAddressDisplay address="#$.slatwall.getService('addressService').newAddress()#" edit="true" />
				</div>
			</cf_SlatwallPropertyList>	
		</cf_SlatwallDetailHeader>
		
	</cf_SlatwallDetailForm>
</cfoutput>