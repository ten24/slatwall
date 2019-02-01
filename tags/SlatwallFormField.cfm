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
	<cfparam name="attributes.fieldType" type="string" />
	<cfparam name="attributes.fieldName" type="string" />
	<cfparam name="attributes.fieldClass" type="string" default="" />
	<cfparam name="attributes.value" type="any" default="" />
	<cfparam name="attributes.valueOptions" type="array" default="#arrayNew(1)#" />
	<cfparam name="attributes.valueOptionsSmartList" type="any" default="" />
	<cfparam name="attributes.fieldAttributes" type="string" default="" />
	<cfparam name="attributes.modalCreateAction" type="string" default="" />			<!--- hint: This allows for a special admin action to be passed in where the saving of that action will automatically return the results to this field --->

	<cfparam name="attributes.autocompletePropertyIdentifiers" type="string" default="" />
	<cfparam name="attributes.autocompleteNameProperty" type="string" default="" />
	<cfparam name="attributes.autocompleteValueProperty" type="string" default="" />
	<cfparam name="attributes.autocompleteSelectedValueDetails" type="struct" default="#structNew()#" />
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
		hidden				|	This is used mostly for processing
	--->

	<cfsilent>
		<cfloop collection="#attributes#" item="key">
			<cfif left(key,5) eq "data-">
				<cfset attributes.fieldAttributes = listAppend(attributes.fieldAttributes, "#key#=#attributes[key]#", " ") />
			</cfif>
		</cfloop>
	</cfsilent>
	<cfswitch expression="#attributes.fieldType#">
		<cfcase value="hidden">
			<cfoutput>
				<input type="hidden" name="#attributes.fieldName#" value="#attributes.value#" />
			</cfoutput>
		</cfcase>
		<cfcase value="checkbox">
			<cfoutput>
				<input type="hidden" name="#attributes.fieldName#" value="" />
				<input type="checkbox" name="#attributes.fieldName#" value="1" class="#attributes.fieldClass#" <cfif attributes.value EQ "1"> checked="checked"</cfif> #attributes.fieldAttributes# />
			</cfoutput>
		</cfcase>
		<cfcase value="checkboxgroup">
			<cfoutput>
				<input type="hidden" name="#attributes.fieldName#" value="" />
				<cfloop array="#attributes.valueOptions#" index="option">
					<cfset thisOptionValue = isSimpleValue(option) ? option : structKeyExists(option, 'value') ? structFind(option, 'value') : '' />
					<cfset thisOptionName = isSimpleValue(option) ? option : structFind(option, 'name') />
					<input type="checkbox" name="#attributes.fieldName#" value="#thisOptionValue#" class="#attributes.fieldClass#" <cfif listFindNoCase(attributes.value, thisOptionValue)> checked="checked"</cfif> #attributes.fieldAttributes# /> <span class="#attributes.fieldClass#">#thisOptionName#</span> <br />
				</cfloop>
			</cfoutput>
		</cfcase>
		<cfcase value="date">
			<cfoutput>
				<input type="text" name="#attributes.fieldName#" value="#attributes.value#" class="#attributes.fieldClass# datepicker" #attributes.fieldAttributes# />
			</cfoutput>
		</cfcase>
		<cfcase value="dateTime">
			<cfoutput>
				<input type="text" name="#attributes.fieldName#" value="#attributes.value#" class="#attributes.fieldClass# datetimepicker" #attributes.fieldAttributes# />
			</cfoutput>
		</cfcase>
		<cfcase value="file">
			<cfoutput>
				<input type="file" name="#attributes.fieldName#" class="#attributes.fieldClass#" #attributes.fieldAttributes# />
			</cfoutput>
		</cfcase>
		<cfcase value="listingMultiselect">
			<hb:HibachiListingDisplay smartList="#attributes.valueOptionsSmartList#" multiselectFieldName="#attributes.fieldName#" multiselectFieldClass="#attributes.fieldClass#" multiselectvalues="#attributes.value#" edit="true"></hb:HibachiListingDisplay>
		</cfcase>
		<cfcase value="multiselect">
			<cfoutput>
				<input name="#attributes.fieldName#" type="hidden" value="" />
				<select name="#attributes.fieldName#" class="#attributes.fieldClass# multiselect" multiple="multiple" #attributes.fieldAttributes#>
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
				<input type="password" name="#attributes.fieldName#" class="#attributes.fieldClass#" autocomplete="off" #attributes.fieldAttributes# />
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
					<input type="radio" name="#attributes.fieldName#" value="#thisOptionValue#" class="#attributes.fieldClass#" <cfif attributes.value EQ thisOptionValue> checked="checked"</cfif> #attributes.fieldAttributes# /><span class="#attributes.fieldClass#">#thisOptionName#</span>
				</cfloop>
			</cfoutput>
		</cfcase>
		<cfcase value="select">
			<cfoutput>
				<select name="#attributes.fieldName#" class="#attributes.fieldClass#" #attributes.fieldAttributes#>
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
				<input type="text" name="#attributes.fieldName#" value="#attributes.value#" class="#attributes.fieldClass#" #attributes.fieldAttributes# />
			</cfoutput>
		</cfcase>
		<cfcase value="textautocomplete">
			<cfoutput>
				<cfset suggestionsID = createUUID() />
				<div class="autoselect-container">
					<input type="hidden" name="#attributes.fieldName#" value="#attributes.value#" />
					<input type="text" name="#attributes.fieldName#-autocompletesearch" class="textautocomplete #attributes.fieldClass# form-control" data-acfieldname="#attributes.fieldName#" data-sugessionsid="#suggestionsID#" #attributes.fieldAttributes# <cfif len(attributes.value)>disabled="disabled"</cfif> />
					<div class="autocomplete-selected" <cfif not len(attributes.value)>style="display:none;"</cfif>><a href="##" class="textautocompleteremove"><i class="icon-remove"></i></a> <span class="value" id="selected-#suggestionsID#"><cfif len(attributes.value)>#attributes.autocompleteSelectedValueDetails[ attributes.autocompleteNameProperty ]#</cfif></span></div>
					<div class="autocomplete-options" style="display:none;overflow:scroll;">
						<ul class="#listLast(lcase(attributes.fieldName),".")#" id="#suggestionsID#">
							<cfif len(attributes.value)>
								<li>
									<a href="##" class="textautocompleteadd" data-acvalue="#attributes.value#" data-acname="#attributes.autocompleteSelectedValueDetails[ attributes.autocompleteNameProperty ]#">
									<cfset local.counter = 0 />
									<cfloop list="#attributes.autocompletePropertyIdentifiers#" index="pi">
										<cfset local.counter++ />
										<cfif local.counter lte 2 and pi neq "adminIcon">
											<span class="#listLast(pi,".")# first">
										<cfelse>
											<span class="#listLast(pi,".")#">
										</cfif>
										#attributes.autocompleteSelectedValueDetails[ pi ]#</span>
									</cfloop>
									</a>
								</li>
							</cfif>
						</ul>
					</div>
					<cfif len(attributes.modalCreateAction)>
						<hb:HibachiActionCaller action="#attributes.modalCreateAction#" modal="true" icon="plus" type="link" class="btn btn-default modal-fieldupdate-textautocomplete" icononly="true">
					</cfif>
				</div>
			</cfoutput>
		</cfcase>
		<cfcase value="textarea">
			<cfoutput>
				<textarea name="#attributes.fieldName#" class="#attributes.fieldClass#" #attributes.fieldAttributes#>#attributes.value#</textarea>
			</cfoutput>
		</cfcase>
		<cfcase value="time">
			<cfoutput>
				<input type="text" name="#attributes.fieldName#" value="#attributes.value#" class="#attributes.fieldClass# timepicker" #attributes.fieldAttributes# />
			</cfoutput>
		</cfcase>
		<cfcase value="wysiwyg">
			<cfoutput>
				<textarea name="#attributes.fieldName#" class="#attributes.fieldClass# wysiwyg" #attributes.fieldAttributes#>#attributes.value#</textarea>
			</cfoutput>
		</cfcase>
		<cfcase value="yesno">
			<cfoutput>
				<label class="radio inline"><input type="radio" name="#attributes.fieldName#" class="#attributes.fieldClass# yes" value="1" <cfif isBoolean(attributes.value) && attributes.value>checked="checked"</cfif> #attributes.fieldAttributes# />#yesNoFormat(1)#</label>
				<label class="radio inline"><input type="radio" name="#attributes.fieldName#" class="#attributes.fieldClass# yes" value="0" <cfif (isboolean(attributes.value) && not attributes.value) || not isBoolean(attributes.value)>checked="checked"</cfif> #attributes.fieldAttributes# />#yesNoFormat(0)#</label>
			</cfoutput>
		</cfcase>
	</cfswitch>

</cfif>
