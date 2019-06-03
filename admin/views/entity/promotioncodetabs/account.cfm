<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />


<cfparam name="rc.promotionCode" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>

    <cfset rc.accountCollectionList = rc.promotionCode.getAccountsCollectionList() />
    <cfset accountsSelectedIDList = rc.accountCollectionList.getPrimaryIDList() />
        
    <cfif rc.edit>
        <cfset rc.accountCollectionList = $.slatwall.getService('accountService').getAccountCollectionList() />
    </cfif>
    
    <cfset rc.accountCollectionList.setDisplayProperties(
		'firstName,lastName,company,primaryEmailAddress.emailAddress',
		{
			isVisible=true,
			isSearchable=true,
			isDeletable=true
		}
	)/>
	<cfset rc.accountCollectionList.addDisplayProperty(displayProperty='accountID',columnConfig={
		isVisible=false,
		isSearchable=false,
		isDeletable=false
	})/>
	<hb:HibachiListingDisplay 
		collectionList="#rc.accountCollectionList#"
		multiselectFieldName="accounts"
		multiselectValues="#accountsSelectedIDList#"
	>
	</hb:HibachiListingDisplay>
</cfoutput>