<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.account" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfset rc.orderTemplateCollectionList = rc.account.getOrderTemplatesCollectionList() />
<cfset rc.orderTemplateCollectionList.setDisplayProperties('orderTemplateName,account.calculatedFullName,account.primaryEmailAddress.emailAddress',{isVisible=true,isSearchable=true,isDeletable=true}) />
<cfset rc.orderTemplateCollectionList.addDisplayProperties('createdDateTime',{isVisible=true,isSearchable=false,isDeletable=true}) />
<cfset rc.orderTemplateCollectionList.addDisplayProperties('calculatedTotal',{isVisible=true,isSearchable=false,isDeletable=true}) />
<cfset rc.orderTemplateCollectionList.addDisplayProperties('scheduleOrderNextPlaceDateTime',{isVisible=true,isSearchable=false,isDeletable=true}) />
<cfset rc.orderTemplateCollectionList.addDisplayProperty(displayProperty="orderTemplateID",title="#getHibachiScope().rbkey('entity.orderTemplate.orderTemplateID')#",columnConfig={isVisible=false,isSearchable=false,isDeletable=true} ) />
<cfset rc.orderTemplateCollectionList.addDisplayProperty(displayProperty="orderTemplateStatusType.typeName",title="#getHibachiScope().rbkey('entity.orderTemplate.orderTemplateStatusType')#",columnConfig={isVisible=true,isSearchable=false,isDeletable=true} ) />
<cfset rc.orderTemplateCollectionList.addDisplayProperty(displayProperty="currencyCode",columnConfig={isVisible=false,isSearchable=false,isDeletable=true} ) />
<!--- ottSchedule, using ID to improve performance --->
<cfset rc.orderTemplateCollectionList.addFilter('orderTemplateType.typeID', '2c948084697d51bd01697d5725650006') />
<cfset rc.orderTemplateCollectionList.setOrderBy('createdDateTime|asc')/>

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiListingDisplay
				recordDetailAction="admin:entity.detailordertemplate"
				collectionList="#rc.account.getOrderTemplatesCollectionList()#"
				usingPersonalCollection="false"
			>
			</hb:HibachiListingDisplay>
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
	<hb:HibachiProcessCaller action="admin:entity.preprocessordertemplate" 
							 entity="OrderTemplate" 
							 processContext="create" 
							 queryString="accountID=#rc.account.getAccountID()#"
							 class="btn btn-primary" 
							 icon="plus icon-white" 
							 modal="true" />
</cfoutput>	

