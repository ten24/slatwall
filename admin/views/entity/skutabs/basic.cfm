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
			<cfif rc.product.getBaseProductType() EQ "event">
				<hb:HibachiPropertyDisplay object="#rc.sku#" property="publishedFlag" edit="#rc.edit#">
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
			<cfif rc.product.getBaseProductType() EQ "subscription">
				<cfif isNull(rc.sku.getRenewalSku())>
					<hb:HibachiPropertyDisplay object="#rc.sku#" property="renewalPrice" edit="#rc.edit#">
				</cfif>
				<cfif !isNull(rc.sku.getRenewalSku()) && !rc.edit>
					<hb:HibachiPropertyDisplay object="#rc.sku.getRenewalSku()#" fieldname="renewalSku.skuCode" property="skuCode" edit="#rc.edit#" title="#$.slatwall.getRBKey('define.renewalSku')#" valuelink="#$.slatwall.buildURL(action='admin:entity.detailsku',querystring='skuID=#rc.sku.getRenewalSku().getSkuID()#')#"/>
				<cfelseif !isNull(rc.sku.getRenewalSku()) && rc.edit>
					<swa:SlatwallErrorDisplay object="#rc.sku#" errorName="renewalSku" />
					<hb:HibachiListingDisplay smartList="#rc.sku.getProduct().getSubscriptionSkuSmartList()#"
											  selectValue="#rc.sku.getRenewalSku().getSkuID()#"
											  selectFieldName="renewalSku.skuID"
											  title="#$.slatwall.rbKey('define.renewalSku')#"
											  edit="#rc.edit#">
						<hb:HibachiListingColumn propertyIdentifier="skuCode" />
						<hb:HibachiListingColumn propertyIdentifier="skuName" />
						<hb:HibachiListingColumn propertyIdentifier="skuDescription" />
						<hb:HibachiListingColumn propertyIdentifier="subscriptionTerm.subscriptionTermName" />
						<hb:HibachiListingColumn propertyIdentifier="price" />
					</hb:HibachiListingDisplay>
				</cfif>
			</cfif>
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>
