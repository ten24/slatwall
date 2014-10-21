<cfparam name="rc.orderItem" type="any" />
<cfparam name="rc.order" type="any" default="#rc.orderItem.getOrder()#" />
<cfparam name="rc.sku" type="any" default="#rc.orderItem.getSku()#" />
<cfparam name="rc.edit" default="false" />

<cfoutput>
	<cf_HibachiPropertyRow>
		
		<cf_HibachiPropertyList divclass="col-md-6">
			<div class="well">
				#rc.sku.getImage(width=100, height=100)#
			</div>
			<hr />
			<cf_HibachiPropertyDisplay object="#rc.orderItem#" property="price" edit="#rc.edit#" />
			<cf_HibachiPropertyDisplay object="#rc.orderItem#" property="quantity" edit="#rc.edit#" />
		</cf_HibachiPropertyList>
		
		<cf_HibachiPropertyList divclass="col-md-6">
			
			<!--- Totals --->
			<cf_HibachiPropertyTable>
				<cf_HibachiPropertyTableBreak header="Sku Details" />
				<cf_HibachiPropertyDisplay object="#rc.orderItem#" property="skuPrice" edit="false" displayType="table" title="#$.slatwall.rbKey('admin.entity.detailorderitem.skuPriceWhenOrdered')#" />
				<cf_HibachiPropertyDisplay object="#rc.orderItem.getSku()#" property="price" edit="false" displayType="table" title="#$.slatwall.rbKey('admin.entity.detailorderitem.currentSkuPrice')#" />
				<cfif rc.orderItem.getSku().getProduct().getBaseProductType() eq "subscription">
					<cf_HibachiPropertyDisplay object="#rc.orderItem.getSku()#" property="renewalPrice" edit="#rc.edit#" displayType="table" title="#$.slatwall.rbKey('admin.entity.detailorderitem.currentSkuRenewalPrice')#" />
				</cfif>
				<cf_HibachiPropertyDisplay object="#rc.sku#" property="skuCode" edit="false" displayType="table">
				<cfloop array="#rc.sku.getAlternateSkuCodes()#" index="asc">
					<cf_HibachiPropertyDisplay object="#asc#" title="#asc.getAlternateSkuCodeType().getType()#" property="alternateSkuCode" edit="false" displayType="table">	
				</cfloop>
				<cfloop array="#rc.sku.getOptions()#" index="option">
					<cf_HibachiPropertyDisplay object="#option#" title="#option.getOptionGroup().getOptionGroupName()#" property="optionName" edit="false" displayType="table">
				</cfloop>
				<cf_HibachiPropertyTableBreak header="Status" />
				<cf_HibachiPropertyDisplay object="#rc.orderItem#" property="orderItemStatusType" edit="false" displayType="table" />
				<cfif rc.orderItem.getOrderItemType().getSystemCode() eq "oitSale">
					<cf_HibachiPropertyDisplay object="#rc.orderItem#" property="quantityDelivered" edit="false" displayType="table" />
					<cf_HibachiPropertyDisplay object="#rc.orderItem#" property="quantityUndelivered" edit="false" displayType="table" />
				<cfelse>
					<cf_HibachiPropertyDisplay object="#rc.orderItem#" property="quantityReceived" edit="false" displayType="table" />
					<cf_HibachiPropertyDisplay object="#rc.orderItem#" property="quantityUnreceived" edit="false" displayType="table" />
				</cfif>
				<cf_HibachiPropertyTableBreak header="Price Totals" />
				<cf_HibachiPropertyDisplay object="#rc.orderItem#" property="extendedPrice" edit="false" displayType="table" />
				<cf_HibachiPropertyDisplay object="#rc.orderItem#" property="discountAmount" edit="false" displayType="table" />
				<cf_HibachiPropertyDisplay object="#rc.orderItem#" property="extendedPriceAfterDiscount" edit="false" displayType="table" />
				<cf_HibachiPropertyDisplay object="#rc.orderItem#" property="taxAmount" edit="false" displayType="table" />
				<cf_HibachiPropertyTableBreak />
				<cf_HibachiPropertyDisplay object="#rc.orderItem#" property="itemTotal" edit="false" displayType="table" titleClass="table-total" valueClass="table-total" />	
				
			</cf_HibachiPropertyTable>
			
		</cf_HibachiPropertyList>
	</cf_HibachiPropertyRow>
</cfoutput>