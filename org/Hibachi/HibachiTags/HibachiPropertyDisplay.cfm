<cfif thisTag.executionMode is "start">
	<!--- Implicit --->
	<cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#" />	
		
	<!--- These are required Attributes --->
	<cfparam name="attributes.object" type="any" />											<!--- hint: This is a required attribute that defines the object that contains the property to display --->
	<cfparam name="attributes.property" type="string" /> 									<!--- hint: This is a required attribute as the property that you want to display" --->
	
	<!--- These are optional Attributes --->
	<cfparam name="attributes.edit" type="boolean" default="false" />						<!--- hint: When in edit mode this will create a Form Field, otherwise it will just display the value" --->
	
	<cfparam name="attributes.title" type="string" default="" />							<!--- hint: This can be used to override the displayName of a property" --->
	<cfparam name="attributes.hint" type="string" default="" />								<!--- hint: If specified, then this will produce a tooltip around the title --->
	
	<cfparam name="attributes.value" type="string" default="" />							<!--- hint: This can be used to override the value of a property --->
	<cfparam name="attributes.valueOptions" type="array" default="#arrayNew(1)#" />			<!--- hint: This can be used to set a default value for the property IF it hasn't been defined  NOTE: right now this only works for select boxes--->
	<cfparam name="attributes.valueOptionsSmartList" type="any" default="" />				<!--- hint: This can either be either an entityName string, or an actual smartList --->
	<cfparam name="attributes.valueDefault" type="string" default="" />						<!--- hint: This can be used to set a default value for the property IF it hasn't been defined  NOTE: right now this only works for select boxes--->
	<cfparam name="attributes.valueLink" type="string" default="" />						<!--- hint: if specified, will wrap property value with an achor tag using the attribute as the href value --->
	<cfparam name="attributes.valueFormatType" type="string" default="" />					<!--- hint: This can be used to defined the format of this property wehn it is displayed --->

	<cfparam name="attributes.fieldName" type="string" default="" />						<!--- hint: This can be used to override the default field name" --->
	<cfparam name="attributes.fieldType" type="string" default="" />						<!--- hint: When in edit mode you can override the default type of form object to use" --->
	
	<cfparam name="attributes.titleClass" default="" />										<!--- hint: Adds class to whatever markup wraps the title element --->
	<cfparam name="attributes.valueClass" default="" />										<!--- hint: Adds class to whatever markup wraps the value element --->
	<cfparam name="attributes.fieldClass" default="" />										<!--- hint: Adds class to the actual field element --->
	<cfparam name="attributes.valueLinkClass" default="" />									<!--- hint: Adds class to whatever markup wraps the value link element --->
	
	<cfparam name="attributes.toggle" type="string" default="no" />							<!--- hint: This attribute indicates whether the field can be toggled to show/hide the value. Possible values are "no" (no toggling), "Show" (shows field by default but can be toggled), or "Hide" (hide field by default but can be toggled) --->
	<cfparam name="attributes.displayType" default="dl" />									<!--- hint: This attribute is used to specify if the information comes back as a definition list (dl) item or table row (table) or with no formatting or label (plain) --->
	
	<cfparam name="attributes.errors" type="array" default="#arrayNew(1)#" />				<!--- hint: This holds any errors for the current field if needed --->
	<cfparam name="attributes.displayVisible" type="string" default="" />					<!--- hint: binds visibility of element to another form value (ie displayVisible="{inputname}:{inputvalue}") --->
	
	<cfparam name="attributes.modalCreateAction" type="string" default="" />				<!--- hint: This allows for a special admin action to be passed in where the saving of that action will automatically return the results to this field --->
	
	<cfparam name="attributes.autocompletePropertyIdentifiers" type="string" default="" />	<!--- hint: This describes the list of properties that we want to get from an entity --->
	<cfparam name="attributes.autocompleteNameProperty" type="string" default="" />			<!--- hint: This is the value property that will get assigned to the hidden field when selected --->
	<cfparam name="attributes.autocompleteValueProperty" type="string" default="" /> 		<!--- hint: This is the single name property that shows once an option is selected --->
	<cfparam name="attributes.autocompleteSelectedValueDetails" type="struct" default="#structNew()#" />
	
	<cfparam name="attributes.fieldAttributes" type="string" default="" />					<!--- hint: This is used to pass specific additional fieldAttributes when in edit mode --->
	
	<!---
		attributes.fieldType have the following options:
		
		checkbox			|	As a single checkbox this doesn't require any options, but it will create a hidden field for you so that the key gets submitted even when not checked.  The value of the checkbox will be 1
		checkboxgroup		|	Requires the valueOptions to be an array of simple value if name and value is same or array of structs with the format of {value="", name=""}
		date				|	This is still just a textbox, but it adds the jQuery date picker
		dateTime			|	This is still just a textbox, but it adds the jQuery date & time picker
		file				|	No value can be passed in
		multiselect			|	Requires the valueOptions to be an array of simple value if name and value is same or array of structs with the format of {value="", name=""}
		password			|	No Value can be passed in
		radiogroup			|	Requires the valueOptions to be an array of simple value if name and value is same or array of structs with the format of {value="", name=""}
		select      		|	Requires the valueOptions to be an array of simple value if name and value is same or array of structs with the format of {value="", name=""}
		text				|	Simple Text Field
		textarea			|	Simple Textarea
		time				|	This is still just a textbox, but it adds the jQuery time picker
		wysiwyg				|	Value needs to be a string
		yesno				|	This is used by booleans and flags to create a radio group of Yes and No
		textautocomplete	|	This fieldtype will query an entity to get specific values
		
	--->
	
	<!---
		attributes.displayType have the following options:
		dl
		table
		span
		plain
	--->
	
	<!--- First Make sure that we have the ability to actually display this property --->
	<cfif !attributes.object.isPersistent() || attributes.hibachiScope.authenticateEntityProperty('read', attributes.object.getClassName(), attributes.property)>
		
		<cfsilent>
			
			<!--- If this was originally set to edit... make sure that they have edit ability for this property --->

			<cfif attributes.edit and attributes.object.isPersistent() and not attributes.hibachiScope.authenticateEntityProperty('update', attributes.object.getClassName(), attributes.property)>
				<cfset attributes.edit = false />
			</cfif>
			
			<!--- Set Up whatever fieldtype this should be --->
			<cfif attributes.fieldType eq "">
				<cfset attributes.fieldType = attributes.object.getPropertyFieldType( attributes.property ) />
			</cfif>
			
			<!--- If this is in edit mode then get the pertinent field info --->
			<cfif attributes.edit or attributes.fieldType eq "listingMultiselect">
				<cfset attributes.fieldClass = listAppend(attributes.fieldClass, attributes.object.getPropertyValidationClass( attributes.property ), " ") />
				<cfif attributes.fieldName eq "">
					<cfset attributes.fieldName = attributes.object.getPropertyFieldName( attributes.property ) />
				</cfif>
				<cfif listFindNoCase("checkboxgroup,radiogroup,select,multiselect", attributes.fieldType) and not arrayLen(attributes.valueOptions)>
					<cfset attributes.valueOptions = attributes.object.invokeMethod( "get#attributes.property#Options" ) />
				<cfelseif listFindNoCase("listingMultiselect", attributes.fieldType)>
					<cfset propertyMD = attributes.object.getPropertyMetaData( attributes.property ) />
					<cfif structKeyExists(propertyMD, "cfc")>
						<cfset attributes.multiselectPropertyIdentifier = "#attributes.hibachiScope.getService('hibachiService').getPrimaryIDPropertyNameByEntityName( propertyMD.cfc )#" />
					</cfif>
					<cfset attributes.valueOptionsSmartList = attributes.object.invokeMethod( "get#attributes.property#OptionsSmartList" ) />
				</cfif>
			</cfif>
			
			<!--- Setup textautocomplete values if they wern't passed in --->
			<cfif attributes.fieldType eq "textautocomplete">
				<cfset attributes.fieldAttributes = listAppend(attributes.fieldAttributes, 'data-acpropertyidentifiers="#attributes.autocompletePropertyIdentifiers#"', ' ') />
				<cfset attributes.fieldAttributes = listAppend(attributes.fieldAttributes, 'data-entityName="#listLast(attributes.object.getPropertyMetaData(attributes.property).cfc,'.')#"', ' ') />
				<cfif not len(attributes.autocompleteValueProperty)>
					<cfset attributes.autocompleteValueProperty = listLast(attributes.fieldName, '.') />
				</cfif>
				<cfset attributes.fieldAttributes = listAppend(attributes.fieldAttributes, 'data-acvalueproperty="#attributes.autocompleteValueProperty#"', ' ') />
				<cfif not len(attributes.autocompleteNameProperty)>
					<cfset attributes.autocompleteNameProperty = "simpleRepresentation" />
				</cfif>
				<cfset attributes.fieldAttributes = listAppend(attributes.fieldAttributes, 'data-acnameproperty="#attributes.autocompleteNameProperty#"', ' ') />
			</cfif>
			
			<!--- Set Up The Value --->
			<cfif attributes.value eq "">
	
				<cfset attributes.value = attributes.object.getValueByPropertyIdentifier( attributes.property ) />
				
				<cfif isNull(attributes.value) || (isSimpleValue(attributes.value) && attributes.value eq "")>
					<cfset attributes.value = attributes.valueDefault />
				</cfif>
				
				<!--- If the value was an object, typically a MANY-TO-ONE, then we get either the identifierValue or for display a simpleRepresentation --->
				<cfif isObject(attributes.value) && attributes.object.isPersistent()>
					<cfif attributes.edit>
						<!--- If this is a textautocomplete then we need to setup all of the propertyIdentifiers --->
						<cfif attributes.fieldType eq "textautocomplete">
							<cfloop list="#attributes.autocompletePropertyIdentifiers#" index="pi">
								<cfset attributes.autocompleteSelectedValueDetails[ pi ] = attributes.value.getValueByPropertyIdentifier( pi ) />
							</cfloop>
							<cfif not structKeyExists(attributes.autocompleteSelectedValueDetails, attributes.autocompleteNameProperty)>
								<cfset attributes.autocompleteSelectedValueDetails[ attributes.autocompleteNameProperty ] = attributes.value.getValueByPropertyIdentifier( attributes.autocompleteNameProperty ) />
							</cfif>
						</cfif>
						<cfset attributes.value = attributes.value.getIdentifierValue() />  
					<cfelse>
						<cfset attributes.value = attributes.value.getSimpleRepresentation() />
					</cfif>
	
				<!--- If the value was an array, typically a MANY-TO-MANY, then we loop over the array and create either a list of simpleRepresetnation or a list of identifier values --->	
				<cfelseif isArray(attributes.value)>
					<cfset thisValueList = "" />
					<cfloop array="#attributes.value#" index="thisValue">
						<cfif isObject(thisValue) && thisValue.isPersistent()>
							<cfif attributes.edit or attributes.fieldType eq "listingMultiselect">
								<cfset thisValueList = listAppend(thisValueList, thisValue.getIdentifierValue()) />
							<cfelse>
								<cfset thisValueList = listAppend(thisValueList, " #thisValue.getSimpleRepresentation()#") />
							</cfif>
						</cfif>
					</cfloop>
					<cfset attributes.value = trim(thisValueList) />
				<cfelse>
					<cfif not attributes.edit or (attributes.edit and listFindNoCase("datetime,time,date", attributes.object.getPropertyFormatType( attributes.property )) and not isNull(attributes.object.invokeMethod( "get#attributes.property#" )))>
						<cfif isNumeric(attributes.value) and attributes.value lt 0>
							<cfset attributes.valueClass &= " negative" />
						</cfif>
						
						<cfset attributes.value = attributes.object.getFormattedValue(attributes.property) />
						
					</cfif>
				</cfif>
				
				<!--- Final check to make sure that the value is simple --->
				<cfif not isSimpleValue(attributes.value)>
					<cfif isSimpleValue(attributes.valueDefault)>
						<cfset attributes.value = attributes.valueDefault />
					<cfelse>
						<cfset attributes.value = "" />
					</cfif>
				</cfif>
			</cfif>
			
			<!--- Set up the property title --->
			<cfif attributes.title eq "">
				<cfset attributes.title = attributes.object.getPropertyTitle( attributes.property ) />
			</cfif>
			
			<cfif attributes.hint eq "">
				<cfset attributes.hint = attributes.object.getPropertyHint( attributes.property ) />
			</cfif>
				
			<!--- Add the error class to the form field if it didn't pass validation --->
			<cfif attributes.object.hasError(attributes.property)>
				<cfset attributes.fieldClass = attributes.fieldClass & " error" />
				
				<cfset attributes.errors = attributes.object.getError( attributes.property ) />
			</cfif>
			
			<!--- If the field type is file, then look for an hb_fileAccept value --->
			<cfif structKeyExists(attributes.object.getPropertyMetaData(attributes.property), "hb_fileAcceptExtension")>
				<cfset attributes.fieldAttributes = listAppend(attributes.fieldAttributes, 'accept="#attributes.object.getPropertyMetaData(attributes.property).hb_fileAcceptExtension#"', " ") />
			</cfif>
			
			<!--- Setup null value --->
			<cfif structKeyExists(attributes.object.getPropertyMetaData(attributes.property), "hb_nullRBKey")>
				 <cfset attributes.fieldAttributes = listAppend(attributes.fieldAttributes, 'placeholder="#attributes.hibachiScope.rbKey( attributes.object.getPropertyMetaData(attributes.property).hb_nullRBKey )#"', " ") />
			</cfif>
		</cfsilent>
		
		<cf_HibachiFieldDisplay attributecollection="#attributes#" />
	</cfif>

</cfif>

