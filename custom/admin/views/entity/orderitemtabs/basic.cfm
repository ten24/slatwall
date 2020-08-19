<cfimport prefix="swa" taglib="../../../../../tags" />
<cfimport prefix="hb" taglib="../../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.orderItem" type="any" />
<cfparam name="rc.order" type="any" default="#rc.orderItem.getOrder()#" />
<cfparam name="rc.sku" type="any" default="#rc.orderItem.getSku()#" />
<cfparam name="rc.edit" default="false" />

<cfoutput>
	<cfset local.OrderItemJSON = rc.orderItem.getEncodedJsonRepresentation()>
	
	<hb:HibachiPropertyRow>
		
		<hb:HibachiPropertyList divclass="col-md-6">
			<div class="s-image-wrapper">
				#rc.sku.getImage(width=200, height=200)#
			</div>
			<hr />
			<cfif !isnull(rc.orderItem.getAppliedPriceGroup())>
				<hb:HibachiPropertyDisplay object="#rc.orderItem#" property="appliedPriceGroup" edit="false" />	
			</cfif>
		
			
			<hb:HibachiPropertyDisplay object="#rc.orderItem#" property="price" edit="#rc.edit#" />
			<hb:HibachiPropertyDisplay object="#rc.orderItem#" property="quantity" edit="#rc.edit#" />
			<hb:HibachiPropertyDisplay object="#rc.orderItem#" property="currencyCode" edit="false" />
			
			<hr />
			<div class="table-responsive">
				<sw-simple-property-display object="#OrderItemJSON#" property="calculatedExtendedPersonalVolume" title="Personal Volume (Extended)" edit="false" display-type="table" refresh-event="refreshOrder#rc.order.getOrderID()#"></sw-simple-property-display>
				<sw-simple-property-display object="#OrderItemJSON#" property="calculatedExtendedCommissionableVolume" title="Commissionable Volume (Extended)" edit="false" display-type="table" refresh-event="refreshOrder#rc.order.getOrderID()#"></sw-simple-property-display>
				<sw-simple-property-display object="#OrderItemJSON#" property="calculatedExtendedProductPackVolume" title="Product Pack Volume (Extended)" edit="false" display-type="table" refresh-event="refreshOrder#rc.order.getOrderID()#"></sw-simple-property-display>
				<sw-simple-property-display object="#OrderItemJSON#" property="calculatedExtendedRetailValueVolume" title="Retail Value Volume (Extended)" edit="false" display-type="table" refresh-event="refreshOrder#rc.order.getOrderID()#"></sw-simple-property-display>
				<sw-simple-property-display object="#OrderItemJSON#" property="calculatedExtendedRetailCommission" title="Retail Commission (Extended)" edit="false" display-type="table" refresh-event="refreshOrder#rc.order.getOrderID()#"></sw-simple-property-display>
				<sw-simple-property-display object="#OrderItemJSON#" property="calculatedExtendedTaxableAmount" title="Taxable Amount (Extended)" currency-flag="true"  edit="false" display-type="table" refresh-event="refreshOrder#rc.order.getOrderID()#"></sw-simple-property-display>
			</div>
		</hb:HibachiPropertyList>
		
		<hb:HibachiPropertyList divclass="col-md-6">
			
			<!--- Totals --->
			<hb:HibachiPropertyTable>
				<hb:HibachiPropertyTableBreak header="Order Details" />
				<hb:HibachiPropertyDisplay object="#rc.orderItem.getOrder()#" property="orderNumber" edit="false" displayType="table" />
				<hb:HibachiPropertyTableBreak header="Product Details" />
				<hb:HibachiPropertyDisplay object="#rc.orderItem.getSku().getProduct()#" property="productName" valuelink="?slatAction=admin:entity.detailproduct&productID=#rc.orderItem.getSku().getProduct().getProductID()#" edit="false" displayType="table" />
				<hb:HibachiPropertyDisplay object="#rc.sku#" property="skuCode" valuelink="?slatAction=admin:entity.detailsku&skuID=#rc.orderItem.getSku().getSkuID()#" edit="false" displayType="table">
				<cfloop array="#rc.sku.getAlternateSkuCodes()#" index="asc">
					<hb:HibachiPropertyDisplay object="#asc#" title="#asc.getAlternateSkuCodeType().getTypeName()#" property="alternateSkuCode" edit="false" displayType="table">	
				</cfloop>
				<cfloop array="#rc.sku.getOptions()#" index="option">
					<hb:HibachiPropertyDisplay object="#option#" title="#option.getOptionGroup().getOptionGroupName()#" property="optionName" edit="false" displayType="table">
				</cfloop>
				<cfif rc.orderItem.getSku().getProduct().getBaseProductType() eq "subscription">
					<hb:HibachiPropertyDisplay object="#rc.orderItem.getSku()#" property="renewalPrice" edit="#rc.edit#" displayType="table" />
				</cfif>
				<hb:HibachiPropertyDisplay object="#rc.orderItem#" property="skuPrice" title="Sku Price (Snapshot)" edit="false" displayType="table" />
				<hb:HibachiPropertyDisplay object="#rc.orderItem.getSku()#" property="price"  title="Sku Price (Current)" edit="false" displayType="table" />
				<hb:HibachiPropertyTableBreak header="Status" />
				<hb:HibachiPropertyDisplay object="#rc.orderItem#" property="orderItemStatusType" edit="false" displayType="table" />
				<cfif rc.orderItem.getOrderItemType().getSystemCode() eq "oitSale">
					<hb:HibachiPropertyDisplay object="#rc.orderItem#" property="quantityDelivered" edit="false" displayType="table" />
					<hb:HibachiPropertyDisplay object="#rc.orderItem#" property="quantityUndelivered" edit="false" displayType="table" />
				<cfelse>
					<hb:HibachiPropertyDisplay object="#rc.orderItem#" property="quantityReceived" edit="false" displayType="table" />
					<hb:HibachiPropertyDisplay object="#rc.orderItem#" property="quantityUnreceived" edit="false" displayType="table" />
				</cfif>
				<hb:HibachiPropertyDisplay object="#rc.orderItem#" property="estimatedFulfillmentDateTime" edit="false" displayType="table" />
				<hb:HibachiPropertyTableBreak header="Price Totals" />
				<hb:HibachiPropertyDisplay object="#rc.orderItem#" property="extendedPrice" edit="false" displayType="table" />
				<hb:HibachiPropertyDisplay object="#rc.orderItem#" property="discountAmount" edit="false" displayType="table" />
				<hb:HibachiPropertyDisplay object="#rc.orderItem#" property="extendedPriceAfterDiscount" edit="false" displayType="table" />
				<cfif rc.orderItem.getVATAmount()>
					<hb:HibachiPropertyDisplay object="#rc.orderItem#" property="vatAmount" edit="false" displayType="table" />
				<cfelse>
					<hb:HibachiPropertyDisplay object="#rc.orderItem#" property="taxAmount" edit="false" displayType="table" />
				</cfif>
				<hb:HibachiPropertyTableBreak />
				<hb:HibachiPropertyDisplay object="#rc.orderItem#" property="itemTotal" edit="false" displayType="table" titleClass="table-total" valueClass="table-total" />	
				
				
			</hb:HibachiPropertyTable>
			
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>