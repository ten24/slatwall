<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.loyaltyAccruement" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>

	<cfset local.accrCurrencyList = getHibachiSCope().getService("LoyaltyService").getAccruementCurrencyCollectionList() />
	<cfset local.accrCurrencyList.setDisplayProperties("accruementCurrencyID") />
	<cfset local.accrCurrencyList.addDisplayProperty(displayProperty="currencyCode",columnConfig={isVisible=true}) />
	<cfset local.accrCurrencyList.addFilter("loyaltyAccruement.loyaltyAccruementID",rc.loyaltyAccruement.getLoyaltyAccruementID()) />

    <hb:HibachiListingDisplay 
        collectionList="#local.accrCurrencyList#" 
        edit="#rc.edit#" 
        displaytype="plainTitle"
        showSimpleListingControls="false"
		enableAveragesAndSums="false"
        hideUnfilteredResults="true"/>
		

	<hb:HibachiProcessCaller 
		action="admin:entity.preprocessloyaltyaccruement" 
		entity="#rc.loyaltyAccruement#" 
		processContext="addpromotioneligiblecurrency"
		querystring="fRedirectAction=admin:entity.detailLoyaltyAccruement"
		class="btn btn-default"
		icon="plus"
		modal="true" 
	/>		
		
</cfoutput>