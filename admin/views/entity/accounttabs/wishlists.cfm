<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.account" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfset rc.account.getOrderTemplatesCollectionList().addFilter('orderTemplateType.systemCode','ottWishList','IN') />
<cfset rc.account.getOrderTemplatesCollectionList().setDisplayProperties() />
<cfset rc.account.getOrderTemplatesCollectionList().addDisplayProperty(displayProperty="orderTemplateID",title="#getHibachiScope().rbkey('entity.orderTemplate.orderTemplateID')#",columnConfig={isVisible=false,isSearchable=false,isDeletable=false} ) />
<cfset rc.account.getOrderTemplatesCollectionList().addDisplayProperty(displayProperty='orderTemplateName', title="Wish List Name", columnConfig={isVisible=true, isSearchable=true, isDeletable=true})/>
<cfset rc.account.getOrderTemplatesCollectionList().addDisplayProperty(displayProperty='account.calculatedFullName', columnConfig={isVisible=true, isSearchable=true, isDeletable=true})/>
<cfset rc.account.getOrderTemplatesCollectionList().addDisplayProperty(displayProperty='account.primaryEmailAddress.emailAddress', columnConfig={isVisible=true, isSearchable=true, isDeletable=true})/>
<cfset rc.account.getOrderTemplatesCollectionList().addDisplayProperty(displayProperty='createdDateTime', columnConfig={isVisible=true, isSearchable=true, isDeletable=true})/>

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiListingDisplay
				recordDetailAction="admin:entity.detailwishlist"
				collectionList="#rc.account.getOrderTemplatesCollectionList()#"
				usingPersonalCollection="false"
			>
			</hb:HibachiListingDisplay>
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
	<hb:HibachiActionCaller 
		action="admin:entity.preprocessordertemplate" 
		entity="OrderTemplate" 
		processcontext="createwishlist" 
		class="btn btn-default" 
		icon="plus" 
		querystring="sRedirectAction=admin:entity.detailaccount&accountID=#rc.account.getAccountID()#&processcontext=createwishlist&newAccountFlag=false" 
		modal=true 
	/>
	
</cfoutput>