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
<cfif thisTag.executionMode is "start">

	<!--- Specifying these values will allow for the settings to be automatically pulled --->
	<cfparam name="attributes.valueObject" type="any" default="" />
	<cfparam name="attributes.valueObjectProperty" type="string" default="" />
	
	<!--- General Settings that end up getting applied to the value object --->
	<cfparam name="attributes.type" type="string" default="text" />
	<cfparam name="attributes.name" type="string" default="" />
	<cfparam name="attributes.class" type="string" default="" />
	<cfparam name="attributes.value" type="any" default="" />
	<cfparam name="attributes.valueOptions" type="array" default="#arrayNew(1)#" />		<!--- Used for select, checkbox group, multiselect --->
	<cfparam name="attributes.fieldAttributes" type="string" default="" />
	
	<!---
		attributes.type have the following options:
		
		checkbox			|	As a single checkbox this doesn't require any options, but it will create a hidden field for you so that the key gets submitted even when not checked.  The value of the checkbox will be 1
		checkboxgroup		|	Requires the valueOptions to be an array of simple value if name and value is same or array of structs with the format of {value="", name=""}
		file				|	No value can be passed in
		multiselect			|	Requires the valueOptions to be an array of simple value if name and value is same or array of structs with the format of {value="", name=""}
		password			|	No Value can be passed in
		radiogroup			|	Requires the valueOptions to be an array of simple value if name and value is same or array of structs with the format of {value="", name=""}
		select      		|	Requires the valueOptions to be an array of simple value if name and value is same or array of structs with the format of {value="", name=""}
		text				|	Simple Text Field
		textarea			|	Simple Textarea
		yesno				|	This is used by booleans and flags to create a radio group of Yes and No
	--->
	
	
	<cfsilent>
		<!--- If the value isn't explicitly defined, try to pull it out of the value object if one exists --->
		<cfif 	not len(attributes.value)
				and isObject(attributes.valueObject)
				and len(attributes.valueObjectProperty)
				and ( attributes.valueObject.hasProperty(attributes.valueObjectProperty) OR
						(
							attributes.valueObject.isPersistent()
								AND
							attributes.valueObject.hasAttributeCode( attributes.valueObjectProperty )
						) 
					)>
			<cfset thistag.thisValue = attributes.valueObject.invokeMethod("get#attributes.valueObjectProperty#") />
			<cfif not isNull(thistag.thisValue) && isSimpleValue(thistag.thisValue)>
				<cfset attributes.value = thistag.thisValue />
			</cfif>
		</cfif>
		
		<!--- If the field name isn't explicitly defined, but the valueObjectProperty is... then we can use that --->
		<cfif not len(attributes.name) and len(attributes.valueObjectProperty)>
			<cfset attributes.name = attributes.valueObjectProperty />
		</cfif>
	</cfsilent>
	
	<cfswitch expression="#attributes.type#">
		<cfcase value="checkbox">
			<cfoutput>
				<input type="hidden" name="#attributes.name#" value="" />
				<input type="checkbox" name="#attributes.name#" value="1" class="#attributes.class#" <cfif attributes.value EQ "1"> checked="checked"</cfif> #attributes.fieldAttributes# />
			</cfoutput>
		</cfcase>
		<cfcase value="checkboxgroup">
			<cfoutput>
				<input type="hidden" name="#attributes.name#" value="" />
				<cfloop array="#attributes.valueOptions#" index="option">
					<cfset thisOptionValue = isSimpleValue(option) ? option : structKeyExists(option, 'value') ? structFind(option, 'value') : '' />
					<cfset thisOptionName = isSimpleValue(option) ? option : structFind(option, 'name') />
					<input type="checkbox" name="#attributes.name#" value="#thisOptionValue#" class="#attributes.class#" <cfif listFindNoCase(attributes.value, thisOptionValue)> checked="checked"</cfif> #attributes.fieldAttributes# /> <span class="#attributes.class#">#thisOptionName#</span> <br />
				</cfloop>
			</cfoutput>
		</cfcase>
		<cfcase value="file">
			<cfoutput>
				<input type="file" name="#attributes.name#" class="#attributes.class#" #attributes.fieldAttributes# />
			</cfoutput>
		</cfcase>
		<cfcase value="multiselect">
			<cfoutput>
				<input name="#attributes.name#" type="hidden" value="" />
				<select name="#attributes.name#" class="#attributes.class#" multiple="multiple" #attributes.fieldAttributes#>
					<cfloop array="#attributes.valueOptions#" index="option">
						<cfset thisOptionValue = isSimpleValue(option) ? option : structKeyExists(option, 'value') ? structFind(option, 'value') : '' />
						<cfset thisOptionName = isSimpleValue(option) ? option : structFind(option, 'name') />
						<option value="#thisOptionValue#" <cfif listFindNoCase(attributes.value, thisOptionValue)> selected="selected"</cfif>>#thisOptionName#</option>
					</cfloop>
				</select>
			</cfoutput>
		</cfcase>
		<cfcase value="password">
			<cfoutput>
				<input type="password" name="#attributes.name#" class="#attributes.class#" autocomplete="off" #attributes.fieldAttributes# />
			</cfoutput>
		</cfcase>
		<cfcase value="radiogroup">
			<cfoutput>
				<!--- if attributes.value is not a valid option default to first one, Array find can't find empty value so we need to loop through --->
				<cfset valueExists = false />
				<cfloop array="#attributes.valueOptions#" index="option">
					<cfset thisOptionValue = isSimpleValue(option)?option:option['value'] />
					<cfif thisOptionValue EQ attributes.value>
						<cfset valueExists = true />
						<cfbreak />
					</cfif>
				</cfloop>
				<cfif !valueExists>
					<cfset attributes.value = attributes.valueOptions[1]['value'] />
				</cfif>
				<cfloop array="#attributes.valueOptions#" index="option">
						<cfset thisOptionValue = isSimpleValue(option) ? option : structKeyExists(option, 'value') ? structFind(option, 'value') : '' />
						<cfset thisOptionName = isSimpleValue(option) ? option : structFind(option, 'name') />
					<label class="radio"><input type="radio" name="#attributes.name#" value="#thisOptionValue#" class="#attributes.class#" <cfif attributes.value EQ thisOptionValue> checked="checked"</cfif> #attributes.fieldAttributes# /> #thisOptionName#</label>
				</cfloop>
			</cfoutput>
		</cfcase>
		<cfcase value="select">
			<cfoutput>
				<select name="#attributes.name#" class="#attributes.class#" #attributes.fieldAttributes#>
					<cfloop array="#attributes.valueOptions#" index="option">
						<cfset thisOptionValue = isSimpleValue(option) ? option : structKeyExists(option, 'value') ? structFind(option, 'value') : '' />
						<cfset thisOptionName = isSimpleValue(option) ? option : structFind(option, 'name') />
						<option value="#thisOptionValue#" <cfif attributes.value EQ thisOptionValue> selected="selected"</cfif>>#thisOptionName#</option>
					</cfloop>
				</select>
			</cfoutput>
		</cfcase>
		<cfcase value="text">
			<cfoutput>
				<input type="text" name="#attributes.name#" value="#htmlEditFormat(attributes.value)#" class="#attributes.class#" #attributes.fieldAttributes# />
			</cfoutput>
		</cfcase>
		<cfcase value="textarea">
			<cfoutput>
				<textarea name="#attributes.name#" class="#attributes.class#" #attributes.fieldAttributes#>#htmlEditFormat(attributes.value)#</textarea>
			</cfoutput>
		</cfcase>
		<cfcase value="yesno">
			<cfoutput>
				<label class="radio inline"><input type="radio" name="#attributes.name#" class="#attributes.class#" value="1" <cfif isBoolean(attributes.value) && attributes.value>checked="checked"</cfif> #attributes.fieldAttributes# />#yesNoFormat(1)#</label>
				<label class="radio inline"><input type="radio" name="#attributes.name#" class="#attributes.class#" value="0" <cfif (isboolean(attributes.value) && not attributes.value) || not isBoolean(attributes.value)>checked="checked"</cfif> #attributes.fieldAttributes# />#yesNoFormat(0)#</label>
			</cfoutput>
		</cfcase>
	</cfswitch>
</cfif>
