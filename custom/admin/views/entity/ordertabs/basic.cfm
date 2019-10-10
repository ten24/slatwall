<cfimport prefix="swa" taglib="../../../../../tags" />
<cfimport prefix="hb" taglib="../../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.order" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<cfset local.OrderJSON = rc.order.getEncodedJsonRepresentation()>
	
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList divclass="col-md-6">
			
			<!--- Account --->
			
			<cfif rc.edit>
				<hb:HibachiPropertyDisplay object="#rc.order#" property="account" fieldtype="textautocomplete" autocompletePropertyIdentifiers="adminIcon,fullName,company,emailAddress,phoneNumber,address.simpleRepresentation" edit="true">
				
				<cfloop index="local.priceGroup" array="#rc.order.getAccount().getPriceGroups()#">
					<hb:HibachiPropertyDisplay object="#local.priceGroup#" property="priceGroupName">
				</cfloop>
					
			<cfelseif !isNull(rc.order.getAccount()) && rc.order.getAccount().getOrganizationFlag()>
 				<hb:HibachiPropertyDisplay object="#rc.order.getAccount()#" property="company">	
			<cfelseif !isNull(rc.order.getAccount())>
				<hb:HibachiPropertyDisplay object="#rc.order.getAccount()#" property="fullName" valuelink="?slatAction=admin:entity.detailaccount&accountID=#rc.order.getAccount().getAccountID()#" title="#$.slatwall.rbKey('entity.account')#">
				<hb:HibachiPropertyDisplay object="#rc.order.getAccount()#" property="emailAddress" valuelink="mailto:#rc.order.getAccount().getEmailAddress()#">
				<hb:HibachiPropertyDisplay object="#rc.order.getAccount()#" property="phoneNumber">
				
				<cfloop index="local.priceGroup" array="#rc.order.getAccount().getPriceGroups()#">
					<hb:HibachiPropertyDisplay object="#local.priceGroup#" property="priceGroupName">
				</cfloop>
				
			</cfif>
			
			<!--- Adds account type from the order. --->
			<cfif !isNull(rc.order.getAccountType())>
				<cfset local.accountType = $.slatwall.getService("TypeService").getTypeByTypeCode(rc.order.getAccountType())>
				<cfif !isNull(accountType)>
					<hb:HibachiPropertyDisplay object="#rc.order#" property="accountType" value="#accountType.getTypeName()#">
				</cfif>
			</cfif>
			
			<!--- Origin --->
			<hb:HibachiPropertyDisplay object="#rc.order#" property="orderCreatedSite" edit="false">
			
			<hb:HibachiPropertyDisplay object="#rc.order#" property="orderOrigin" edit="#rc.edit#">

			<!--- Order Type --->
			<hb:HibachiPropertyDisplay object="#rc.order#" property="orderType" edit="false">
				
			<!--- Quote Flag --->
			<hb:HibachiPropertyDisplay object="#rc.order#" property="quoteFlag" edit="#rc.edit#">
			
			<!--- Quote Price Expiration --->
			<cfif rc.order.getQuoteFlag()>
				<hb:HibachiPropertyDisplay object="#rc.order#" property="quotePriceExpiration" edit="false">	
			</cfif>
			<!--- Short Refenece, Quote Number --->
			<cfif rc.order.getShortReferenceID(false) neq "">
				<hb:HibachiFieldDisplay title="#$.slatwall.rbkey('entity.order.quoteNumber')#" value="#rc.order.getShortReferenceID(false)#" edit="false" displayType="dl">
			</cfif>

			<!--- Default Stock Location --->
			<swa:SlatwallLocationTypeahead property="#rc.order.getDefaultStockLocation()#" locationPropertyName="defaultStockLocation.locationID"  locationLabelText="#rc.$.slatwall.rbKey('entity.order.defaultStockLocation')#" edit="#rc.edit#" showActiveLocationsFlag="true" ></swa:SlatwallLocationTypeahead>

			<!--- Order IP Address --->
			<cfif !isNull(rc.order.getOrderOpenIPAddress())>
				<hb:HibachiPropertyDisplay object="#rc.order#" property="orderOpenIPAddress" edit="false">
			</cfif>

			<!--- Referenced Order --->
			<cfif !isNull(rc.order.getReferencedOrder())>
				<hb:HibachiPropertyDisplay object="#rc.order#" property="referencedOrder" valuelink="?slatAction=admin:entity.detailorder&orderID=#rc.order.getReferencedOrder().getOrderID()#">
				<hb:HibachiPropertyDisplay object="#rc.order#" property="referencedOrderType">
			</cfif>

			<!--- Assigned Account --->
			<cfif rc.edit>
				<hb:HibachiPropertyDisplay object="#rc.order#" property="assignedAccount" fieldtype="textautocomplete" autocompletePropertyIdentifiers="adminIcon,fullName,company,emailAddress,phoneNumber,address.simpleRepresentation" edit="true">
			<cfelseif !isNull(rc.order.getAssignedAccount())>
				<hb:HibachiPropertyDisplay object="#rc.order.getAssignedAccount()#" property="fullName" valuelink="?slatAction=admin:entity.detailaccount&accountID=#rc.order.getAssignedAccount().getAccountID()#" title="#$.slatwall.rbKey('entity.order.assignedAccount')#">
			</cfif>
			
		</hb:HibachiPropertyList>
		<hb:HibachiPropertyList divclass="col-md-6">

			<!--- Totals --->
			<hb:HibachiPropertyTable>
				<hb:HibachiPropertyTableBreak header="#$.slatwall.rbKey('admin.entity.detailorder.overview')#" />
				<hb:HibachiPropertyDisplay object="#rc.order#" property="orderStatusType" edit="false" displayType="table">
				<hb:HibachiPropertyDisplay object="#rc.order#" property="currencyCode" edit="false" displayType="table">
				<cfif !isNull(rc.order.getOrderOpenDateTime())>
					<hb:HibachiPropertyDisplay object="#rc.order#" property="orderOpenDateTime" edit="false" displayType="table">
				</cfif>
				<cfif !isNull(rc.order.getOrderCloseDateTime())>
					<hb:HibachiPropertyDisplay object="#rc.order#" property="orderCloseDateTime" edit="false" displayType="table">
				</cfif>
				<hb:HibachiPropertyTableBreak header="Totals" />
			</hb:HibachiPropertyTable>
		
			<div class="table-responsive">
				<sw-simple-property-display object="#OrderJSON#" property="calculatedPersonalVolumeTotal" title="Personal Volume Total" edit="false" display-type="table" refresh-event="refreshOrder#rc.order.getOrderID()#"></sw-simple-property-display>
				<sw-simple-property-display object="#OrderJSON#" property="calculatedCommissionableVolumeTotal" title="Commissionable Volume Total" edit="false" display-type="table" refresh-event="refreshOrder#rc.order.getOrderID()#"></sw-simple-property-display>
				<sw-simple-property-display object="#OrderJSON#" property="calculatedSubTotal" title="Subtotal" currency-flag="true" edit="false" display-type="table" refresh-event="refreshOrder#rc.order.getOrderID()#"></sw-simple-property-display>
				<sw-simple-property-display object="#OrderJSON#" property="calculatedTaxTotal" title="Tax Total" currency-flag="true"  edit="false" display-type="table" refresh-event="refreshOrder#rc.order.getOrderID()#"></sw-simple-property-display>
				<sw-simple-property-display object="#OrderJSON#" property="calculatedFulfillmentTotal" currency-flag="true"  title="Fulfillment Total" edit="false" display-type="table" refresh-event="refreshOrder#rc.order.getOrderID()#"></sw-simple-property-display>
				<sw-simple-property-display object="#OrderJSON#" property="calculatedDiscountTotal" currency-flag="true"  title="Discount Total" edit="false" display-type="table" refresh-event="refreshOrder#rc.order.getOrderID()#"></sw-simple-property-display>
				<sw-simple-property-display object="#OrderJSON#" property="calculatedTotal" default="#rc.order.getTotal()#" currency-flag="true" title="Total" edit="false" display-type="table" refresh-event="refreshOrder#rc.order.getOrderID()#"></sw-simple-property-display>
			</div>
				
			<div class="table-responsive">
				<sw-simple-property-display object="#OrderJSON#" property="calculatedPaymentAmountDue" default="#rc.order.getPaymentAmountDue()#" currency-flag="true" title="Payment Amount Due" edit="false" display-type="table" display-width="'200'" refresh-event="refreshOrder#rc.order.getOrderID()#"></sw-simple-property-display>
			</div>
			
		</hb:HibachiPropertyList>

	</hb:HibachiPropertyRow>
</cfoutput>
