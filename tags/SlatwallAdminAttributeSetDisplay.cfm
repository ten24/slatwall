<!---

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.

    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms
    of your choice, provided that you follow these specific guidelines:

	- You also meet the terms and conditions of the license of each
	  independent module
	- You must not alter the default display of the Slatwall name or logo from
	  any part of the application
	- Your custom code must not alter or create any files inside Slatwall,
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets
	the above guidelines as a combined work under the terms of GPL for this program,
	provided that you include the source code of that other code when and as the
	GNU GPL requires distribution of source code.

    If you modify this program, you may extend this exception to your version
    of the program, but you are not obligated to do so.

Notes:

--->
<cfimport prefix="swa" taglib="../tags" />
<cfimport prefix="hb" taglib="../org/Hibachi/HibachiTags" />
<cfif thisTag.executionMode is "start">

	<cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#" />
	<cfparam name="attributes.attributeSet" type="any" />
	<cfparam name="attributes.edit" type="boolean" default=false />
	<cfparam name="attributes.fieldNamePrefix" type="string" default="" />
	<cfparam name="attributes.entity" type="any" default="" />

	<cfset thisTag.attributeSmartList = attributes.attributeSet.getAttributesSmartList() />
	<cfset thisTag.attributeSmartList.addFilter('activeFlag', 1) />
	<cfset thisTag.attributeSmartList.addOrder("sortOrder|ASC") />

	<cfloop array="#thisTag.attributeSmartList.getRecords()#" index="attribute">
		<cfset fdAttributes = structNew() />
		<cfset fdAttributes.title = attribute.getAttributeName()  />
		<cfset fdAttributes.hint = attribute.getAttributeHint() />
		<cfset fdAttributes.edit = attributes.edit />
		<cfset fdAttributes.fieldname = "#attributes.fieldNamePrefix##attribute.getAttributeCode()#" />
		<cfset fdAttributes.fieldType = attribute.getFormFieldType() />

		<!--- Setup fieldClass --->
		<cfset fdAttributes.fieldClass = "" />
		<cfif !isNull(attribute.getRequiredFlag()) && isBoolean(attribute.getRequiredFlag()) AND attribute.getRequiredFlag()>
			<cfset fdAttributes.fieldClass = listAppend(fdAttributes.fieldClass, "required", " ") />
		</cfif>

		<!--- Setup Value --->
		<cfset fdAttributes.value = "" />

		<cfif isObject(attributes.entity)>
			<cfset thisAttributeValueObject = attributes.entity.getAttributeValue(attribute.getAttributeCode(), true) />
			<cfif isObject(thisAttributeValueObject)>
				<cfif attributes.edit>
					<cfif thisAttributeValueObject.getClassName() eq 'AttributeValue'>
						<cfset fdAttributes.value = thisAttributeValueObject.getAttributeValue() />
					<cfelse>
						<cfset fdAttributes.value = thisAttributeValueObject.getPrimaryIDValue() />
					</cfif>
				<cfelseif structKeyExists(thisAttributeValueObject, 'getAttributeValueFormatted')>
					<cfset fdAttributes.value = thisAttributeValueObject.getAttributeValueFormatted() />
				<cfelse>
					<cfset fdAttributes.value = thisAttributeValueObject.getSimpleRepresentation() />
				</cfif>
				<cfif !len(fdAttributes.value) AND !isNull(attribute.getDefaultValue())>
					<cfset fdAttributes.value = attribute.getDefaultValue()  />
				</cfif>
			<cfelse>
				<cfset fdAttributes.value = thisAttributeValueObject />
			</cfif>
		<cfelseif !isNull(attribute.getDefaultValue())>
			<cfset fdAttributes.value = attribute.getDefaultValue() />
		</cfif>
		<cfif attribute.getAttributeInputType() EQ "date">
			<cfset fdAttributes.value = DateFormat(fdAttributes.value,"mmm dd, yyyy")>
		</cfif>
		<cfif attribute.getAttributeInputType() EQ "dateTime">
			<cfset fdAttributes.value = DateTimeFormat(fdAttributes.value,"mmm dd, yyyy hh:nn tt")>
		</cfif>
		<!---Setup Value Options --->
		<cfif attributes.edit>
			<cfset fdAttributes.valueOptions = attribute.getAttributeOptionsOptions() />
		</cfif>

		<cfif listFindNoCase('relatedObjectSelect,relatedObjectMultiselect', attribute.getAttributeInputType())>
			<cfset fdAttributes.valueOptionsCollectionList = attribute.getRelatedObjectCollectionConfig()/>

			<cfif attribute.getAttributeInputType() eq 'relatedObjectMultiselect'>
				<cfset fdAttributes.multiselectPropertyIdentifier = attributes.hibachiScope.getService('hibachiService').getPrimaryIDPropertyNameByEntityName( attribute.getRelatedObject() ) />
			</cfif>
		</cfif>
		
		<cfif not attributes.edit and attribute.getAttributeInputType() eq 'typeSelect' and len(fdAttributes.value)>
			<cfset typeObject="#attributes.hibachiScope.getService('TypeService').getType(fdAttributes.value)#" />
			<cfif !isNull(typeObject)>
				<cfset fdAttributes.valueLink = "?slatAction=entity.detailtype&typeID=#fdAttributes.value#" />
				<cfset fdAttributes.value= typeObject.getTypeName() />
				
			</cfif>
		</cfif>

		<!--- Setup file link --->
		<cfif not attributes.edit and attribute.getAttributeInputType() eq 'file' and len(fdAttributes.value)>
			<cfif attributes.entity.hasProperty(attribute.getAttributeCode()) AND structKeyExists(attributes.entity, 'get#attribute.getAttributeCode()#UploadDirectory')>
				<cfset fdAttributes.valueLink = "#attributes.hibachiScope.getURLFromPath(attributes.entity.invokeMethod('get#attribute.getAttributeCode()#UploadDirectory'))##fdAttributes.value#" />
			<cfelse>
				<cfset fdAttributes.valueLink = "#attributes.hibachiScope.getURLFromPath(attribute.getAttributeValueUploadDirectory())##fdAttributes.value#" />
			</cfif>
			<cfif structKeyExists(fdAttributes, 'valueLink') AND left(fdAttributes.valueLink, 5) EQ 's3://'>
 				<cfset fdAttributes.valueLink = "#attributes.hibachiScope.getSignedS3URL(fdAttributes.valueLink)#" />
			</cfif>


			
		<cfelseif not isNull(thisAttributeValueObject) AND isObject(thisAttributeValueObject) AND thisAttributeValueObject.getClassName() EQ 'AttributeValue'>
			<cfset removeLink = "?slatAction=admin:entity.deleteattributeValue&attributeValueid=#thisAttributeValueObject.getAttributeValueID()#&redirectAction=admin:entity.detail#attributes.attributeSet.getAttributeSetObject()#&#attributes.attributeSet.getAttributeSetObject()#ID=#thisAttributeValueObject.invokeMethod('get'&attributes.attributeSet.getAttributeSetObjectPrimaryIDPropertyName())#"/>
			<cfset fdAttributes.removeLink = removeLink/>
		<cfelseif isObject(attributes.entity) AND attribute.getAttributeInputType() eq 'file' AND (isNull(thisattributeValueObject) OR not isObject(thisAttributeValueObject)) >
			<cfset removeLink = "?slatAction=admin:entity.deleteCustomPropertyFile&#attributes.entity.getPrimaryIDPropertyName()#=#attributes.entity.getPrimaryIDValue()#&entityName=#attribute.getAttributeSet().getAttributeSetObject()#&attributeCode=#attribute.getAttributeCode()#&redirectAction=admin:entity.detail#attributes.attributeSet.getAttributeSetObject()#"/>
			<cfset fdAttributes.removeLink = removeLink/>
		</cfif>
			<hb:HibachiFieldDisplay attributeCollection="#fdAttributes#" />

	</cfloop>
</cfif>
