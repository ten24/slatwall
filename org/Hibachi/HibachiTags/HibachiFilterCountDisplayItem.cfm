<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" /> 

<cffunction name="getHTML">
	<cfargument name="title"/>
	<cfargument name="optionData"/>
	<cfargument name="template"/>
	<cfargument name="formatter"/>
	
	<cfsavecontent variable="htmlContent" >
		<cfinclude template="#arguments.template#" >
	</cfsavecontent>
	<cfreturn htmlContent>
</cffunction>

<cfif thisTag.executionMode is "start">
	<!--- Core Attributes --->
	<cfset THISTAG.Parent = GetBaseTagData( "cf_HibachiFilterCountDisplay" ) />
	<cfparam name="attributes.hibachiScope" type="any" default="#THISTAG.Parent.attributes.hibachiScope#"/>
	<cfif structKeyExists(THISTAG.Parent.attributes,'collectionlist') && isObject(THISTAG.Parent.attributes.collectionlist)>
		<cfset attributes.collectionList = THISTAG.Parent.attributes.collectionList/> 
	</cfif>
	<cfif structKeyExists(THISTAG.Parent.attributes,'template') && len(THISTAG.Parent.attributes.template)>
		<cfset attributes.template = THISTAG.Parent.attributes.template/>
		
	</cfif>
			

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
	<!---comparison operator realted to build url --->
	<cfparam name="attributes.comparisonOperator" default=""/>
	<!--- defaults to entity name rbkey plural but you can override it --->
	<cfparam name="attributes.title" default=""/>
	<!--- can be custom function or a string referencing a function in the hibachiUtilityService example: snakeCaseToTitleCase --->
	<cfparam name="attributes.formatter" default=""/>
	<!--- template override --->
	<cfparam name="attributes.template" default="./tagtemplates/hibachifiltercountdisplayitem.cfm"/>
	
	<cfparam name="attributes.rangeData" default=""/>
	<cfparam name="attributes.showApplyRange" default="true"/>
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
	<cfif attributes.hibachiScope.getService('HibachiService').getHasPropertyByEntityNameAndPropertyIdentifier(attributes.entityName,attributes.propertyIdentifier)>
		<cfif attributes.hibachiScope.getService('HibachiService').getPropertyIsObjectByEntityNameAndPropertyIdentifier(attributes.entityName,attributes.propertyIdentifier)>
			<cfset propertyMetaData = attributes.hibachiScope.getService('HibachiService').getPropertiesStructByEntityName(
				lastEntityName
			)[listLast(attributes.propertyIdentifier, ".")]/>
			<cfif !len(attributes.title)>
				<cfset attributes.title = attributes.hibachiScope.rbKey('entity.#propertyMetaData.cfc#_plural')/>
			</cfif>
			<cfset primaryIDName = attributes.hibachiScope.getService('hibachiService').getPrimaryIDPropertyNameByEntityName(propertyMetaData.cfc)/>
			
			<cfset filterIdentifier = attributes.propertyIdentifier & '.' & primaryIDName/>
		<cfelse>
		
			<cfset propertyMetaData = attributes.hibachiScope.getService('HibachiService').getPropertiesStructByEntityName(
				lastEntityName
			)[listLast(attributes.propertyIdentifier, ".")]/>
			<cfif !len(attributes.title)>
				<cfset attributes.title = attributes.hibachiScope.rbKey('entity.#lastEntityName#.#propertyMetaData.name#')/>
			</cfif>
			<cfset filterIdentifier = attributes.propertyIdentifier/>
		</cfif>
	
	
		<cfset attributes.filterType = 'f'/>
		
		<!--- get the option data here --->
		<cfif isArray(attributes.rangeData)>
			<cfset attributes.optionData = attributes.hibachiScope.getService('HibachiService').getOptionsByEntityNameAndPropertyIdentifierAndRangeData(copyOfCollectionList,attributes.entityName,attributes.propertyIdentifier,attributes.rangeData)/>
			<cfset attributes.filterType = 'r'/>
		<cfelseif len(attributes.discriminatorProperty)>
			<cfset attributes.optionData = attributes.hibachiScope.getService('HibachiService').getOptionsByEntityNameAndPropertyIdentifierAndDiscriminatorProperty(copyOfCollectionList,attributes.entityName,attributes.propertyIdentifier,attributes.discriminatorProperty,attributes.inversePropertyIdentifier)/>
		<cfelse>
			<cfset selectedOptions = attributes.hibachiScope.getService('hibachiService').getSelectedOptionsByApplyData(attributes.entityName,attributes.propertyIdentifier)/>
			<cfset optionCollectionList = attributes.hibachiScope.getService('HibachiService').getOptionsCollectionListByEntityNameAndPropertyIdentifier(copyOfCollectionList,attributes.entityName,attributes.propertyIdentifier,attributes.inversePropertyIdentifier)/>
			<cfset attributes.optionData = optionCollectionList.getRecords()/>
			
			<!--- if attributes exist then we need to replace the name with the attributeOption --->
			<cfif attributes.hibachiScope.getService('HibachiService').getHasAttributeByEntityNameAndPropertyIdentifier(attributes.entityName,attributes.propertyIdentifier)>
				<cfset attributeCollectionList = attributes.hibachiScope.getService('HibachiService').getAttributeCollectionList()/>
				<cfset attributeCollectionList.addFilter('attributeCode',listLast(attributes.propertyIdentifier,'.'))/>
				<cfset attributeCollectionList.setDisplayProperties('attributeInputType')/>
				<cfset attributeRecord = attributeCollectionList.getRecords()/>
				<cfif attributeRecord[1]['attributeInputType'] eq 'Select'>
					<cfloop array="#attributes.optionData#" index="option">
						<cfset optionLabelCollectionList = attributes.hibachiScope.getService('HibachiService').getAttributeOptionCollectionList()/>
						<cfset optionLabelCollectionList.addFilter('attribute.attributeCode',listLast(attributes.propertyIdentifier,'.'))/>
						<cfset optionLabelCollectionList.addFilter('attributeOptionValue',option['name'])/>
						
						<cfset optionLabelRecords = optionLabelCollectionList.getRecords()/>
						<cfif arrayLen(optionLabelRecords)>
							<cfset optionName = optionLabelRecords[1]['attributeOptionLabel']/>
							<cfset option['name'] = optionName/>
						</cfif>
					</cfloop>
				<cfelseif attributeRecord[1]['attributeInputType'] eq 'Multiselect'>
					<cfset newOptionData = []/>
					<cfset newOptionStruct = {}/>
					<cfset attributes.comparisonOperator = 'like'/>
					<cfloop array="#attributes.optionData#" index="option">
						
						<cfloop list="#option['value']#" index="listItem">
							<cfif len(trim(listItem))>
								<cfif structKeyExists(newOptionStruct,listItem)>
									<cfset newOptionStruct[listItem]['count'] += option['count']/>
								<cfelse>
									<cfset optionLabelCollectionList = attributes.hibachiScope.getService('HibachiService').getAttributeOptionCollectionList()/>
									<cfset optionLabelCollectionList.addFilter('attribute.attributeCode',listLast(attributes.propertyIdentifier,'.'))/>
									<cfset optionLabelCollectionList.addFilter('attributeOptionValue',listItem)/>
									
									<cfset optionLabelRecords = optionLabelCollectionList.getRecords()/>
									<cfif arrayLen(optionLabelRecords)>
										<cfset optionName = optionLabelRecords[1]['attributeOptionLabel']/>
										<cfset newOptionStruct[listItem] = {
											name=optionName,
											value=listItem,
											count=option['count']
										}/>
									</cfif>
									<!--- array append structure by reference to prevent dupes --->
									<cfset arrayAppend(newOptionData,newOptionStruct[listItem])/>
								</cfif>
							</cfif>
						</cfloop> 
					</cfloop>
					<cfset attributes.optionData = newOptionData/>	
				</cfif>
			</cfif>
			<cfset attributes.optionData = attributes.hibachiScope.getService('HibachiUtilityService').arrayOfStructsSort(attributes.optionData,'name','Asc')/>
			<cfloop array="#selectedOptions#" index="selectedOption">
				<cfset found = false/>
				<cfloop array="#attributes.optionData#" index="option">
					<cfif selectedOption.value eq option.value>
						<cfset found = true/>
					</cfif>
				</cfloop> 
				<cfif !found>
					<cfset selectedOption.count = 0/>
					
					<cfset arrayAppend(attributes.optionData,selectedOption)/>
				</cfif>
			</cfloop>
		</cfif>
		<cfif !len(attributes.comparisonOperator)>
			<cfset attributes.comparisonOperator = 'in'/>
		</cfif>
		
		<cfset attributes.baseBuildUrl = "#attributes.filterType#:#filterIdentifier#"/>
		<cfset attributes.baseBuildUrl &= ":#attributes.comparisonOperator#"/>
		<cfset attributes.baseBuildUrl &= '='/>
		
		<!--- create the html now that we have all the data we need --->
		<cfset attributes.htmlContent = ""/>
		<cfif isArray(attributes.optionData)>
			<cfset attributes.htmlContent = getHTML(attributes.title,attributes.optionData,attributes.template,attributes.formatter)/>
		<cfelseif isStruct(attributes.optionData)>
			<cfloop collection="#attributes.optionData#" item="discriminatorName">
				 
				<cfset attributes.htmlContent &=getHTML(discriminatorName,attributes.optionData[discriminatorName],attributes.template,attributes.formatter)/>
			</cfloop>
		</cfif>
		
		
		<cfassociate basetag="cf_HibachiFilterCountDisplay" datacollection="filterCountGroups">
	</cfif>
</cfif>

