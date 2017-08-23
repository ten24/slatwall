<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />

<cffunction name="getHTML">
	<cfargument name="title"/>
	<cfargument name="optionData"/>
	<cfargument name="template"/>
	<cfsavecontent variable="htmlContent" >
		<cfinclude template="#arguments.template#" >
	</cfsavecontent>
	<cfreturn htmlContent>
</cffunction>

<cfif thisTag.executionMode is "start">
	<!--- Core Attributes --->
	<cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#" />
	<!--- object collection list will be based on if you want an implied list --->
	<cfparam name="attributes.entityName" default=""/>
	<!--- what property are we counting --->
	<cfparam name="attributes.propertyIdentifier" default=""/>
	<!--- what property will we use to apply existing filters --->
	<cfparam name="attributes.inversePropertyIdentifier" default=""/>
	<!--- if you want to explicity pass in a collectionList --->
	<cfparam name="attributes.collectionList" type="any" default=""/>
	<!--- filter type related to the buildurl filtertype look at collection API under applydata function --->
	<cfparam name="attributes.filterType" default="f"/>
	<!--- defaults to entity name rbkey plural but you can override it --->
	<cfparam name="attributes.title" default="#attributes.hibachiScope.rbKey('entity.#attributes.entityName#_plural')#"/>
	<!--- template override --->
	<cfparam name="attributes.template" default="./tagtemplates/hibachifiltercountdisplayitem.cfm"/>
	
	<cfparam name="attributes.rangeData" default=""/>
	<cfparam name="attributes.discriminatorProperty" default=""/>
	
	
	
	<!--- do we have a collection list or should we make one? --->
	<cfif !isNull(attributes.collectionList) && isObject(attributes.collectionList)>
		<cfset attributes.entityName = attributes.collectionList.getCollectionObject()/>
		<cfset copyOfCollectionList = attributes.hibachiScope.getService('HibachiService').invokeMethod('get#attributes.entityName#CollectionList')/>
		<cfset copyOfCollectionList.setCollectionConfigStruct(duplicate(attributes.collectionList.getCollectionConfigStruct()))/>
	<cfelse>
		<cfset attributes.collectionList = attributes.hibachiScope.getService('HibachiService').getCollectionList(attributes.entityName)/>
		<cfset copyOfCollectionList = attributes.collectionList/>
	</cfif>
	
	
	<cfset lastEntityName = attributes.hibachiScope.getService('HibachiService').getLastEntityNameInPropertyIdentifier(
		attributes.entityName,
		attributes.propertyIdentifier
	)/>
	<!---derive the filter type here --->
	<cfset filterIdentifier = ""/>
	<cfif attributes.hibachiScope.getService('HibachiService').getPropertyIsObjectByEntityNameAndPropertyIdentifier(attributes.entityName,attributes.propertyIdentifier)>
		<cfset propertyMetaData = attributes.hibachiScope.getService('HibachiService').getPropertiesStructByEntityName(
			lastEntityName
		)[listLast(attributes.propertyIdentifier, ".")]/>
		<cfset attributes.title = attributes.hibachiScope.rbKey('entity.#propertyMetaData.cfc#_plural')/>
		<cfset primaryIDName = attributes.hibachiScope.getService('hibachiService').getPrimaryIDPropertyNameByEntityName(propertyMetaData.cfc)/>
		
		<cfset filterIdentifier = attributes.propertyIdentifier & '.' & primaryIDName/>
	<cfelse>
		<cfset propertyMetaData = attributes.hibachiScope.getService('HibachiService').getPropertiesStructByEntityName(
			lastEntityName
		)[listLast(attributes.propertyIdentifier, ".")]/>
		<cfset attributes.title = attributes.hibachiScope.rbKey('entity.#lastEntityName#.#propertyMetaData.name#')/>
		<cfset filterIdentifier = attributes.propertyIdentifier/>
	</cfif>
	
	<cfset filterType = 'f'/>
	
	<!--- get the option data here --->
	<cfif isArray(attributes.rangeData)>
		<cfset attributes.optionData = attributes.hibachiScope.getService('HibachiService').getOptionsByEntityNameAndPropertyIdentifierAndRangeData(copyOfCollectionList,attributes.entityName,attributes.propertyIdentifier,attributes.rangeData)/>
		<cfset filterType = 'r'/>
	<cfelseif len(attributes.discriminatorProperty)>
		<cfset attributes.optionData = attributes.hibachiScope.getService('HibachiService').getOptionsByEntityNameAndPropertyIdentifierAndDiscriminatorProperty(copyOfCollectionList,attributes.entityName,attributes.propertyIdentifier,attributes.discriminatorProperty,attributes.inversePropertyIdentifier)/>
	<cfelse>
		<cfset optionCollectionList = attributes.hibachiScope.getService('HibachiService').getOptionsCollectionListByEntityNameAndPropertyIdentifier(copyOfCollectionList,attributes.entityName,attributes.propertyIdentifier,attributes.inversePropertyIdentifier)/>
		<cfset optionCollectionList.applyData(data=url,excludeslist=attributes.propertyIdentifier)/>
		
		<cfset attributes.optionData = optionCollectionList.getRecords()/>
	</cfif>
	
	<!--- create the html now that we have all the data we need --->
	<cfset attributes.htmlContent = ""/>
	<cfif isArray(attributes.optionData)>
		<cfset attributes.htmlContent = getHTML(attributes.title,attributes.optionData,attributes.template)/>
	<cfelseif isStruct(attributes.optionData)>
		<cfloop collection="#attributes.optionData#" item="discriminatorName">
			<cfset attributes.htmlContent &=getHTML(discriminatorName,attributes.optionData[discriminatorName],attributes.template)/>
		</cfloop>
	</cfif>
	
	<cfassociate basetag="cf_HibachiFilterCountDisplay" datacollection="filterCountGroups">
	
</cfif>

