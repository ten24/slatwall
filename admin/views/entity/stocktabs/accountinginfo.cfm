<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.sku" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<!--- get all actively used currencies--->
	<cfset activeCurrencies=listToArray(getHibachiScope().getService('currencyService').getAllActiveCurrencyIDList())>
	
	
	<sw-tab-group id="#getHibachiScope().createHibachiUUID()#">
		<cfloop array="#activeCurrencies#" index="currencyCode" >
			<sw-tab-content id="#getHibachiScope().createHibachiUUID()#" name="#currencyCode#">
				<!---<hb:HibachiPropertyDisplay object="#rc.stock#" property="calculatedAverageCost" edit="false"/>
			<hb:HibachiPropertyDisplay object="#rc.stock#" property="calculatedAverageLandedCost" edit="false" />
			<hb:HibachiPropertyDisplay object="#rc.sku#" property="currentMargin" edit="false">
			<hb:HibachiPropertyDisplay object="#rc.sku#" property="currentLandedMargin" edit="false">
			<hb:HibachiPropertyDisplay object="#rc.sku#" property="currentAssetValue" edit="false">
			<hb:HibachiPropertyDisplay object="#rc.sku#" property="averagePriceSold" edit="false">--->
				<hb:HibachiPropertyDisplay object="#rc.sku#" property="currentMargin" value="#rc.sku.getCurrentMargin(currencyCode)#" edit="false">
				<hb:HibachiPropertyDisplay object="#rc.sku#" property="currentLandedMargin" value="#rc.sku.getCurrentLandedMargin(currencyCode)#" edit="false">
				<hb:HibachiPropertyDisplay object="#rc.sku#" property="currentAssetValue" value="#rc.sku.getCurrentAssetValue(currencyCode)#" edit="false">
				<hb:HibachiPropertyDisplay object="#rc.sku#" property="averagePriceSold" value="#rc.sku.getAveragePriceSold(currencyCode)#" edit="false">
			</sw-tab-content>
		</cfloop>
	</sw-tab-group>
			

</cfoutput>
