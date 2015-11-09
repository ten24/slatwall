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
			<cfif rc.product.getBaseProductType() EQ "subscription">
				<hb:HibachiPropertyDisplay object="#rc.sku#" property="renewalPrice" edit="#rc.edit#">
				<cfif !isNull(rc.product.getRenewalSku())>
					<hb:HibachiPropertyDisplay object="#rc.product.getRenewalSku()#" fieldname="renewalSku.skuCode" property="skuCode" edit="#rc.edit#" title="#$.slatwall.getRBKey('define.renewalSku')#" valuelink="#$.slatwall.buildURL(action='admin:entity.detailsku',querystring='skuID=#rc.product.getRenewalSku().getSkuID()#')#"/>
					<input type="hidden" name="renewalSku.skuID" value="#rc.product.getRenewalSku().getSkuID()#" />  
				</cfif>
			</cfif>
			<hb:HibachiPropertyDisplay object="#rc.sku#" property="listPrice" edit="#rc.edit#">
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>
