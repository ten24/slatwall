<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.sku" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.sku#" property="activeFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.sku#" property="skuName" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.sku#" property="skuCode" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.sku#" property="publishedFlag" edit="#rc.edit#">
			<cfif rc.product.getBaseProductType() EQ "event">
				<hb:HibachiPropertyDisplay object="#rc.sku#" property="eventStartDateTime" edit="false">
				<hb:HibachiPropertyDisplay object="#rc.sku#" property="eventEndDateTime" edit="false">
				<hb:HibachiPropertyDisplay object="#rc.sku#" property="startReservationDateTime" edit="false">
				<hb:HibachiPropertyDisplay object="#rc.sku#" property="endReservationDateTime" edit="false">
				<hb:HibachiPropertyDisplay object="#rc.sku#" property="purchaseStartDateTime" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.sku#" property="purchaseEndDateTime" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.sku#" property="eventCapacity" edit="false">
				<hb:HibachiPropertyDisplay object="#rc.sku#" property="attendedquantity" edit="#rc.edit#">
			</cfif>
			<hb:HibachiPropertyDisplay object="#rc.sku#" property="userDefinedPriceFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.sku#" property="price" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.sku#" property="listPrice" edit="#rc.edit#">

			<cfif rc.product.getBaseProductType() EQ 'gift-card'>
				<hb:HibachiPropertyDisplay object="#rc.sku#" property="giftCardExpirationTerm" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.sku#" property="redemptionAmountType" edit="#rc.edit#" fieldAttributes="ng-model='redemptionAmountType' ng-init='redemptionAmountType=""#rc.sku.getRedemptionAmountType()#""'">
				<cfif !rc.edit>
					<hb:HibachiPropertyDisplay object="#rc.sku#" property="formattedRedemptionAmount">
				<cfelse>
					<div ng-hide="redemptionAmountType == 'sameAsPrice' || redemptionAmountType == ''">
						<hb:HibachiPropertyDisplay object="#rc.sku#" property="redemptionAmount" edit="#rc.edit#">
					</div>
				</cfif>
			</cfif>
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>
