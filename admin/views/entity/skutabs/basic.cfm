<cfparam name="rc.sku" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.sku#" edit="#rc.edit#">
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList>
				<cf_HibachiPropertyDisplay object="#rc.sku#" property="activeFlag" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.sku#" property="skuName" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.sku#" property="skuCode" edit="#rc.edit#">
				<cfif rc.product.getBaseProductType() EQ "event">
					<cf_HibachiPropertyDisplay object="#rc.sku#" property="publishedFlag" edit="#rc.edit#">
					<cf_HibachiPropertyDisplay object="#rc.sku#" property="eventStartDateTime" edit="false">
					<cf_HibachiPropertyDisplay object="#rc.sku#" property="eventEndDateTime" edit="false">
					<cf_HibachiPropertyDisplay object="#rc.sku#" property="startReservationDateTime" edit="false">
					<cf_HibachiPropertyDisplay object="#rc.sku#" property="endReservationDateTime" edit="false">
					<cf_HibachiPropertyDisplay object="#rc.sku#" property="purchaseStartDateTime" edit="#rc.edit#">
					<cf_HibachiPropertyDisplay object="#rc.sku#" property="purchaseEndDateTime" edit="#rc.edit#">
					<cf_HibachiPropertyDisplay object="#rc.sku#" property="eventCapacity" edit="false">
					<cf_HibachiPropertyDisplay object="#rc.sku#" property="attendedquantity" edit="#rc.edit#">
				</cfif>
				<cf_HibachiPropertyDisplay object="#rc.sku#" property="userDefinedPriceFlag" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.sku#" property="price" edit="#rc.edit#">
				<cfif rc.product.getBaseProductType() EQ "subscription">
					<cf_HibachiPropertyDisplay object="#rc.sku#" property="renewalPrice" edit="#rc.edit#">
				</cfif>
				<cf_HibachiPropertyDisplay object="#rc.sku#" property="listPrice" edit="#rc.edit#">
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>
	</cf_HibachiEntityDetailForm>
</cfoutput>
