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


<cfparam name="rc.order" type="any" />
<cfparam name="rc.processObject" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>

	<hb:HibachiEntityProcessForm entity="#rc.order#" edit="#rc.edit#" sRedirectAction="admin:entity.editorder" disableProcess="#not listFindNoCase(rc.processObject.getSku().setting('skuEligibleCurrencies'), rc.order.getCurrencyCode())#">

		<hb:HibachiEntityActionBar type="preprocess" backAction="admin:entity.editorder" backQueryString="orderID=#rc.order.getOrderID()#" object="#rc.order#">
		</hb:HibachiEntityActionBar>
			<span <cfif rc.processObject.getSku().isGiftCardSku()>ng-controller="preprocessorderitem_addorderitemgiftrecipient as giftRecipientControl" id="ngController"</cfif>>
				<cfif listFindNoCase(rc.processObject.getSku().setting('skuEligibleCurrencies'), rc.order.getCurrencyCode())>
					<hb:HibachiPropertyRow>
						<hb:HibachiPropertyList>
							<!--- Add the SkuID & orderItemTypeSystemCode --->
							<cfif not isNull(rc.processObject.getStockID())>
								<input type="hidden" name="stockID" value="#rc.processObject.getStockID()#" />
							</cfif>
							<cfif not isNull(rc.processObject.getSkuID())>
								<input type="hidden" name="skuID" value="#rc.processObject.getSkuID()#" />
							</cfif>
							<input type="hidden" name="orderItemTypeSystemCode" value="#rc.processObject.getOrderItemTypeSystemCode()#" />
							<h5>#$.slatwall.rbKey('admin.entity.preprocessorder_addorderitem.itemDetails')#</h5>
							<!--- Sku Properties --->
							<hb:HibachiPropertyDisplay object="#rc.processObject.getSku()#" property="skuCode" edit="false">
							<hb:HibachiPropertyDisplay object="#rc.processObject.getSku().getProduct()#" property="productName" edit="false">
							<hb:HibachiPropertyDisplay object="#rc.processObject.getSku()#" property="skuDefinition" edit="false">

							<!--- Order Item Details --->
							<cfif rc.processObject.getSku().isGiftCardSku() && rc.processObject.getSku().getGiftCardRecipientRequiredFlag() >
								<div ng-form="giftRecipientControl.quantityForm">
									<div class="alert alert-error" ng-show="giftRecipientControl.quantityForm.$invalid"
										 sw-rbkey="'admin.processorder_addorderitem.quantity.invalid'"></div>
									<div class="form-group ">
										<label for="quantity" class="control-label col-sm-4" style="text-align:left;">Quantity</label>
										<div class="col-sm-8">
											<input type="text" name="quantity" ng-bind="giftRecipientControl.quantity" readonly class="hide">
											<input type="number" class="form-control" ng-value="#rc.processObject.getQuantity()#" ng-model="giftRecipientControl.quantity" sw-numbers-only min-number="giftRecipientControl.getAssignedCount()" max-number="1000">
										</div>
									</div>
								</div>
							<cfelseif rc.processObject.getSku().isGiftCardSku() && !rc.processObject.getSku().getGiftCardAutoGenerateCodeFlag() >
								<hb:HibachiPropertyDisplay object="#rc.processObject#" property="quantity" edit="#rc.edit#">
							<cfelse>
								<hb:HibachiPropertyDisplay object="#rc.processObject#" property="quantity" edit="#rc.edit#">
							</cfif>
							<input type="hidden" name="oldQuantity" value="#rc.processObject.getQuantity()#">
							<hb:HibachiPropertyDisplay object="#rc.processObject#" property="price" edit="#rc.edit#">

							<!--- Manual Gift Card Code Entry --->
							<cfif rc.processObject.getSku().isGiftCardSku() && !rc.processObject.getSku().getGiftCardRecipientRequiredFlag() && !rc.processObject.getSku().getGiftCardAutoGenerateCodeFlag()>
								<script type="text/javascript">
									(function($) {
										var selectorQuantity = "form##adminentityprocessorder_addorderitem input[name=quantity]";
										var selectorGiftCardCodes = "##gift-card-code-fields";
										$(selectorQuantity).ready(function() {
											var giftCardCodeTitle = '#$.slatwall.rbKey('entity.GiftCard.giftCardCode')#';

											// init
											updateGiftCardInputFields();
	
											// setup change handler
											$(selectorQuantity).change(function() {
												updateGiftCardInputFields();
											});
	
											function updateGiftCardInputFields() {
												var quantity = $(selectorQuantity).val();
												if (quantity < 1) {
													$(selectorQuantity).val(1);
													quantity = 1;
												} else if (quantity > #rc.processObject.getSku().setting('skuOrderMaximumQuantity')#) {
													$(selectorQuantity).val(#rc.processObject.getSku().setting('skuOrderMaximumQuantity')#);
													quantity = #rc.processObject.getSku().setting('skuOrderMaximumQuantity')#;
												}

												var existingInputs = $(selectorGiftCardCodes).children();
	
												if (quantity > existingInputs.length) {
													for (var i = existingInputs.length; i < existingInputs.length + (quantity - existingInputs.length); i++) {
														addGiftCardCodeInputField(i+1);
													}
												} else if (quantity < existingInputs.length) {
													for (var i = existingInputs.length - 1; i > quantity - 1; i--) {
														removeGiftCardCodeInputField(i+1);
													}
												}
											}
	
											function addGiftCardCodeInputField(fieldIndex) {
												var fieldNamePrefix = 'recipients[' + fieldIndex + ']';
												var inputFieldTemplate = '<div class="form-group s-required">';
												inputFieldTemplate += '<label for="a" class="control-label col-sm-4">';
												inputFieldTemplate += '<span class="s-title">' + fieldIndex + '. ' + giftCardCodeTitle + '</span>';
												inputFieldTemplate += '</label>';
												inputFieldTemplate += '<div class="col-sm-8">';
												inputFieldTemplate += '<input type="hidden" name="' + fieldNamePrefix + '.quantity" value="1" class="form-control" />';
												inputFieldTemplate += '<input type="text" name="' + fieldNamePrefix + '.manualGiftCardCode" value="" class="form-control" />';
												inputFieldTemplate += '</div>';
												inputFieldTemplate += '</div>';
	
												$(selectorGiftCardCodes).append(inputFieldTemplate);
											}
	
											function removeGiftCardCodeInputField(fieldIndex) {
												$(selectorGiftCardCodes).children().last().remove();
											}
										});
									})(jQuery);
								</script>
								<div id="gift-card-code-fields"></div>
							</cfif>

							<!--- Add form fields to add registrant accounts --->
							<cfif rc.processObject.getSku().getProduct().getBaseProductType() EQ "event">
								<cfset currentRegistrantCount = rc.processObject.getSku().getService("EventRegistrationService").getUnavailableSeatCountBySku(rc.processObject.getSku()) />
								<cfloop from="1" to="#rc.processObject.getQuantity()#" index="i" >
									<fieldset>
										<legend>Registrant #i#</legend>
										<cfif rc.processObject.getSku().getEventCapacity() LT (currentRegistrantCount + i) >
											<input type="hidden" id="registrants[#i#].toWaitlistFlag" name="registrants[#i#].toWaitlistFlag" value="1" />
											<p class="alert-error">#$.slatwall.rbKey('entity.OrderItem.toWaitlist')#</p>
										<cfelse>
											<input type="hidden" id="registrants[#i#].toWaitlistFlag" name="registrants[#i#].toWaitlistFlag" value="0" />
										</cfif>
										<hb:HibachiFieldDisplay fieldname="registrants[#i#].newAccountFlag" title="New Account" fieldType="yesno" edit="#rc.edit#" value="1">
										<!--- New Account --->
										<hb:HibachiDisplayToggle selector="input[name='registrants[#i#].newAccountFlag']" loadVisable="yes">
											<hb:HibachiFieldDisplay fieldname="registrants[#i#].firstName"  title="#$.slatwall.rbKey('entity.account.firstName')#" fieldType="text" edit="#rc.edit#">
											<hb:HibachiFieldDisplay fieldname="registrants[#i#].lastName" title="#$.slatwall.rbKey('entity.account.lastName')#" fieldType="text" edit="#rc.edit#">
											<hb:HibachiFieldDisplay fieldname="registrants[#i#].emailAddress" title="#$.slatwall.rbKey('entity.account.emailAddress')#" fieldType="text" edit="#rc.edit#">
											<hb:HibachiFieldDisplay fieldname="registrants[#i#].phoneNumber" title="#$.slatwall.rbKey('entity.account.phoneNumber')#" fieldType="text" edit="#rc.edit#">
										</hb:HibachiDisplayToggle>
										<!--- Existing Account --->
										<hb:HibachiDisplayToggle selector="input[name='registrants[#i#].newAccountFlag']" showValues="0" >
											<cfset fieldAttributes = 'data-acpropertyidentifiers="adminIcon,fullName,company,emailAddress,phoneNumber,address.simpleRepresentation" data-entityname="Account" data-acvalueproperty="AccountID" data-acnameproperty="simpleRepresentation"' />
											<hb:HibachiFieldDisplay fieldAttributes="#fieldAttributes#" fieldName="registrants[#i#].accountID" fieldType="textautocomplete" edit="#rc.edit#" title="#$.slatwall.rbKey('entity.account')#"/>
										</hb:HibachiDisplayToggle>
									</fieldset>
									<br>
								</cfloop>
							</cfif>

							<!--- Order Item Custom Attributes --->
							<cfloop array="#rc.processObject.getAssignedOrderItemAttributeSets()#" index="attributeSet">
								<hr />
								<h5>#attributeSet.getAttributeSetName()#</h5>
								<swa:SlatwallAdminAttributeSetDisplay attributeSet="#attributeSet#" edit="#rc.edit#" />
							</cfloop>

							<!--- Order Fulfillment --->
							<cfif rc.processObject.getOrderItemTypeSystemCode() eq "oitSale">
								<hr />
								<h5>#$.slatwall.rbKey('admin.entity.preprocessorder_addorderitem.fulfillmentDetails')#</h5>
								<hb:HibachiPropertyDisplay object="#rc.processObject#" property="orderFulfillmentID" edit="#rc.edit#">

								<!--- New Order Fulfillment --->
								<hb:HibachiDisplayToggle selector="select[name='orderFulfillmentID']" showValues="new" loadVisable="#(!isNull(rc.processObject.getOrderFulfillmentID()) && rc.processObject.getOrderFulfillmentID() eq 'new')#">

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
										<cfif !rc.processObject.getSku().isGiftCardSku()>
										<!--- Email Address --->
											<hb:HibachiPropertyDisplay object="#rc.processObject#" property="emailAddress" edit="#rc.edit#" />
										</cfif>
									</hb:HibachiDisplayToggle>

									<!--- Attribute values for location typeahead used by shipping and pickup fulfillment methods --->
									<cfset topLevelLocationID = "" />
									<cfset selectedLocationID = "" />

									<!--- Apply additional location filtering to typeahead if non-leaf order defaultStockLocation exists --->
									<cfif not isNull(rc.processObject.getOrder().getDefaultStockLocation())>
										<cfset topLevelLocationID = rc.processObject.getOrder().getDefaultStockLocation().getLocationID() />
										
										<!--- use defaultStockLocation as default if it is the only option --->
										<cfif not rc.order.getDefaultStockLocation().hasChildren()>
											<cfset selectedLocationID = topLevelLocationID />
										</cfif>
									</cfif>

									<!--- Pickup Fulfillment Details --->
									<hb:HibachiDisplayToggle selector="select[name='fulfillmentMethodID']" valueAttribute="fulfillmentmethodtype" showValues="pickup" loadVisable="#loadFulfillmentMethodType eq 'pickup'#">

										<!--- Select default location if pickupLocationID provided --->
										<cfif not isNull(rc.processObject.getPickupLocationID())>
											<cfset selectedLocationID = rc.processObject.getPickupLocationID() />
										</cfif>

										<swa:SlatwallLocationTypeahead selectedLocationID="#selectedLocationID#" locationPropertyName="pickupLocationID"  locationLabelText="#rc.$.slatwall.rbKey('entity.orderFulfillment.pickupLocation')#" edit="#rc.edit#" showActiveLocationsFlag="true" topLevelLocationID="#topLevelLocationID#" ></swa:SlatwallLocationTypeahead>
										
									</hb:HibachiDisplayToggle>

									<!--- Shipping Fulfillment Details --->
									<hb:HibachiDisplayToggle selector="select[name='fulfillmentMethodID']" valueAttribute="fulfillmentmethodtype" showValues="shipping" loadVisable="#loadFulfillmentMethodType eq 'shipping'#">
										
										<!--- Display fulfillment location typeahead if non-leaf order defaultStockLocation exists --->
										<cfif not isNull(rc.order.getDefaultStockLocation()) and not rc.order.getDefaultStockLocation().hasChildren()>

											<!--- Implicitly set locationID to that of defaultStockLocation --->
											<input type="hidden" name="locationID" value="#selectedLocationID#">

										<cfelse>
											<!--- Select default fulfillment location based on locationID --->
											<cfif not isNull(rc.processObject.getLocationID())>
												<cfset selectedLocationID = rc.processObject.getLocationID() />
											</cfif>

											<!--- Display typeahead if options exist --->
											<swa:SlatwallLocationTypeahead selectedLocationID="#selectedLocationID#" locationPropertyName="locationID"  locationLabelText="#rc.$.slatwall.rbKey('processObject.Order_AddOrderItem.locationID')#" edit="#rc.edit#" showActiveLocationsFlag="true" topLevelLocationID="#topLevelLocationID#" ></swa:SlatwallLocationTypeahead>
											<!---
											<hb:HibachiPropertyDisplay object="#rc.processObject#" property="locationID" edit="#rc.edit#" title="#$.slatwall.rbKey('processObject.Order_AddOrderItem.locationID')#" />  
											--->
										</cfif>

										<!--- Setup the primary address as the default account address --->
										<cfset defaultValue = "" />

										<cfif !isNull(rc.order.getAccount())>
										<cfif isNull(rc.processObject.getShippingAccountAddressID()) && !rc.order.getAccount().getPrimaryAddress().isNew()>
											<cfset defaultValue = rc.order.getAccount().getPrimaryAddress().getAccountAddressID() />
										<cfelseif !isNull(rc.processObject.getShippingAccountAddressID())>
											<cfset defaultValue = rc.processObject.getShippingAccountAddressID() />
										</cfif>
										<cfset fieldAttributes = "ng-model=""shippingAccountAddressID"" ng-init=""shippingAccountAddressID = '#defaultValue#'""" />
										<!--- Account Address --->
										<hb:HibachiPropertyDisplay object="#rc.processObject#" property="shippingAccountAddressID" edit="#rc.edit#" value="#defaultValue#" fieldAttributes="#fieldAttributes#"  />
											
										</cfif>
										<!---Existing Addresses--->
										<cfloop array="#rc.processObject.getShippingAccountAddresses()#" index="accountAddress">
											<span ng-if="shippingAccountAddressID == '#accountAddress.getAccountAddressID()#'">
												<!--- Address Display --->
												<swa:SlatwallAdminAddressDisplay address="#accountAddress.getAddress()#" fieldNamePrefix="shippingAddress." />
											</span>
										</cfloop>
										<span ng-if="shippingAccountAddressID == ''">

										<!--- New Address --->
										<hb:HibachiDisplayToggle selector="select[name='shippingAccountAddressID']" showValues="" loadVisable="#!len(defaultValue)#">

											<!--- Address Display --->
											<swa:SlatwallAdminAddressDisplay address="#rc.processObject.getShippingAddress()#" fieldNamePrefix="shippingAddress." />

										<cfif !isNull(rc.order.getAccount())>
											<!--- Save New Address --->
											<hb:HibachiPropertyDisplay object="#rc.processObject#" property="saveShippingAccountAddressFlag" edit="#rc.edit#" />

											<!--- Save New Address Name --->
											<hb:HibachiDisplayToggle selector="input[name='saveShippingAccountAddressFlag']" loadVisable="#rc.processObject.getSaveShippingAccountAddressFlag()#">
												<hb:HibachiPropertyDisplay object="#rc.processObject#" property="saveShippingAccountAddressName" edit="#rc.edit#" />
											</hb:HibachiDisplayToggle>
										</cfif>

										</hb:HibachiDisplayToggle>
										
									</hb:HibachiDisplayToggle>
									<cfif $.slatwall.setting('globalAllowThirdPartyShippingAccount')>
										<hb:HibachiPropertyDisplay object="#rc.processObject#" property="thirdPartyShippingAccountIdentifier" edit="#rc.edit#">
									</cfif>
								</hb:HibachiDisplayToggle>
							<cfelse>
								<!--- Order Return --->
								<hr />
								<h5>#$.slatwall.rbKey('admin.entity.preprocessorder_addorderitem.returnDetails')#</h5>
								<hb:HibachiPropertyDisplay object="#rc.processObject#" property="orderReturnID" edit="#rc.edit#">

								<!--- New Order Return --->
								<hb:HibachiDisplayToggle selector="select[name='orderReturnID']" showValues="new" loadVisable="#(!isNull(rc.processObject.getOrderReturnID()) && rc.processObject.getOrderReturnID() eq 'new')#">

									<!--- Return Location --->
									<hb:HibachiPropertyDisplay object="#rc.processObject#" property="returnLocationID" edit="#rc.edit#">

									<!--- Fulfillment Refund Amount --->
									<hb:HibachiPropertyDisplay object="#rc.processObject#" property="fulfillmentRefundAmount" edit="#rc.edit#">

								</hb:HibachiDisplayToggle>
							</cfif>
						</hb:HibachiPropertyList>

					</hb:HibachiPropertyRow>

					<cfif rc.processObject.getSku().isGiftCardSku() && rc.processObject.getSku().getGiftCardRecipientRequiredFlag()>
						<div sw-add-order-item-gift-recipient quantity="giftRecipientControl.quantity" order-item-gift-recipients="giftRecipientControl.orderItemGiftRecipients"></div>
					</cfif>
			</span>
		<cfelse>
			<p class="text-error">#$.slatwall.rbKey('admin.entity.preprocessorder_addorderitem.wrongCurrency_info')#</p>
		</cfif>

	</hb:HibachiEntityProcessForm>

</cfoutput>