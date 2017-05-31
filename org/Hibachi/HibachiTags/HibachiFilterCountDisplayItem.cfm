<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfif thisTag.executionMode is "start">
	<!--- Core Attributes --->
	<cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#" />
	<cfparam name="attributes.entityName" default=""/>
	<cfparam name="attributes.propertyIdentifier" default=""/>
	<cfparam name="attributes.collectionList" type="any" default=""/>
	<cfparam name="attributes.filterType" default="f"/>
	<cfparam name="attributes.title" default=""/>
	<cfparam name="attributes.optionData" default="#arrayNew(1)#"/>
	<cfparam name="attributes.optionName" default=""/>
	<cfparam name="attributes.optionValue" default=""/>
	
	<cfif !isNull(attributes.collectionList) && isObject(attributes.collectionList)>
		<cfset attributes.entityName = attributes.collectionList.getCollectionObject()/>
	<cfelse>
		<cfset attributes.collectionList = attributes.hibachiScope.getService('HibachiService').getCollectionList(attributes.entityName)/>
	</cfif>
	
	<!--- refine list to ID,Name, and count --->
	<cfset attributes.optionValue = attributes.hibachiScope.getService('hibachiService').getPrimaryIDPropertyNameByEntityName(attributes.entityName)/>
	<cfset attributes.optionName = attributes.hibachiScope.getService('hibachiService').getSimpleRepresentationPropertyNameByEntityName(attributes.entityName)/>
	
	<cfset attributes.collectionList.applyData(url)/>
	
	<cfif !arrayLen(attributes.optionData)>
		<cfset attributes.collectionList.setDisplayProperties('#attributes.optionName#,#attributes.optionValue#')/>
		<cfset attributes.collectionList.addDisplayAggregate(attributes.propertyIdentifier, 'COUNT', 'itemCount')/>
		<cfset attributes.collectionList.addOrderBy(attributes.optionName)/>
		<cfset attributes.optionData = attributes.collectionList.getRecords()/>
	</cfif>
	
	
	<cfif !len(attributes.title)>
		<cfset attributes.title =attributes.hibachiScope.rbKey('entity.#attributes.entityName#_plural')/>
	</cfif>
	
	<cfassociate basetag="cf_HibachiFilterCountDisplay" datacollection="filterCountGroups">
</cfif>