<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfif thisTag.executionMode is "start">
	<!--- Core Attributes --->
	<cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#" />
	<!--- object collection list will be based on if you want an implied list --->
	<cfparam name="attributes.entityName" default=""/>
	<!--- what property are we counting --->
	<cfparam name="attributes.propertyIdentifier" default=""/>
	<!--- if you want to explicity pass in a collectionList --->
	<cfparam name="attributes.collectionList" type="any" default=""/>
	<!--- filter type related to the buildurl filtertype look at collection API under applydata function --->
	<cfparam name="attributes.filterType" default="f"/>
	<!--- defaults to entity name rbkey plural but you can override it --->
	<cfparam name="attributes.title" default="#attributes.hibachiScope.rbKey('entity.#attributes.entityName#_plural')#"/>
	<!--- 	the result of the collection list getRecords method; you can override this if you want to pass in hard coded data
			example: price range [{minPrice=0,maxPrice=24.95},{minPrice=0,maxPrice=24.95}]
	 --->
	<cfparam name="attributes.optionData" default="#arrayNew(1)#"/>
	<!--- option name defaults to simple representation of the entity but you can override for special cases like price range --->
	<cfparam name="attributes.optionNameKey" default="#attributes.hibachiScope.getService('hibachiService').getSimpleRepresentationPropertyNameByEntityName(attributes.entityName)#"/>
	<!--- option name defaults to simple representation of the entity but you can override for special cases like price range --->
	<cfparam name="attributes.optionValueKey" default="#attributes.hibachiScope.getService('hibachiService').getPrimaryIDPropertyNameByEntityName(attributes.entityName)#"/>
	<!--- build url propIdentifier used to define the relative path for the build url example defaultSku.price=--->
	<cfparam name="attributes.buildUrlPropertyIdentifier" default="#attributes.optionNameKey#"/>
	
	<cfif !isNull(attributes.collectionList) && isObject(attributes.collectionList)>
		<cfset attributes.entityName = attributes.collectionList.getCollectionObject()/>
	<cfelse>
		<cfset attributes.collectionList = attributes.hibachiScope.getService('HibachiService').getCollectionList(attributes.entityName)/>
	</cfif>
	
	<cfif !arrayLen(attributes.optionData)>
		
		<cfset attributes.collectionList.setDisplayProperties('#attributes.optionNameKey#,#attributes.optionValueKey#')/>
		<cfset attributes.collectionList.addDisplayAggregate(attributes.propertyIdentifier, 'COUNT', 'itemCount')/>
		<cfset attributes.collectionList.addOrderBy(attributes.optionNameKey)/>
		<cfset attributes.collectionList.applyData(url)/>
		<cfset attributes.optionData = attributes.collectionList.getRecords()/>
		
	</cfif>
	
	
	<cfassociate basetag="cf_HibachiFilterCountDisplay" datacollection="filterCountGroups">
</cfif>