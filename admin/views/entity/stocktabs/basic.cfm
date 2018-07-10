<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.stock" type="any" />
<cfparam name="rc.sku" type="any" default="#rc.stock.getSku()#" />
<cfparam name="rc.location" type="any" default="#rc.stock.getLocation()#" />
<cfparam name="rc.edit" type="boolean" default="false" />
<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.sku#" property="activeFlag" >
			<hb:HibachiPropertyDisplay object="#rc.sku#" property="skuName">
			<hb:HibachiPropertyDisplay object="#rc.sku#" property="skuCode" >
			<hb:HibachiPropertyDisplay object="#rc.location#" property="locationName" >
			<hb:HibachiPropertyDisplay object="#rc.sku#" property="userDefinedPriceFlag" >
			<hb:HibachiPropertyDisplay object="#rc.sku#" property="price">
			<hb:HibachiPropertyDisplay object="#rc.sku#" property="listPrice" >
			<hb:HibachiPropertyDisplay object="#rc.stock#" property="averageCost" edit="#rc.edit#" >
			<hb:HibachiPropertyDisplay object="#rc.stock#" property="minQuantity" edit="#rc.edit#" >
			<hb:HibachiPropertyDisplay object="#rc.stock#" property="maxQuantity" edit="#rc.edit#" >
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>
