<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" /> 
<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.fieldType" type="string" />
	<cfparam name="attributes.fieldName" type="string" />
	<cfparam name="attributes.fieldClass" type="string" default="" />
	<cfparam name="attributes.value" type="any" default="" />
	<cfparam name="attributes.valueOptions" type="array" default="#arrayNew(1)#" />
	<cfparam name="attributes.valueOptionsSmartList" type="any" default="" />
	<cfparam name="attributes.valueOptionsCollectionList" type="any" default="" />
	<cfparam name="attributes.fieldAttributes" type="string" default="" />
	<cfparam name="attributes.modalCreateAction" type="string" default="" />			<!--- hint: This allows for a special admin action to be passed in where the saving of that action will automatically return the results to this field --->

	<cfparam name="attributes.autocompletePropertyIdentifiers" type="string" default="" />
	<cfparam name="attributes.autocompleteNameProperty" type="string" default="" />
	<cfparam name="attributes.autocompleteValueProperty" type="string" default="" />
	<cfparam name="attributes.autocompleteSelectedValueDetails" type="struct" default="#structNew()#" />
	<cfparam name="attributes.autocompleteDataEntity" type="string" default="" />
	<cfparam name="attributes.showActiveFlag" type="boolean" default="false" />
	<cfparam name="attributes.maxrecords" type="string" default="25" />
	<cfparam name="attributes.removeLink" type="string" default=""/>

	<cfparam name="attributes.multiselectPropertyIdentifier" type="string" default="" />
	<cfparam name="attributes.showEmptySelectBox" type="boolean" default="#false#" />
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
		typeahead			|	This is used for working with the angular typeahead functionality
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
				
				<div class="s-checkbox">
					<input type="checkbox" id="#attributes.fieldName#" name="#attributes.fieldName#" value="1" class="#attributes.fieldClass# form-control" <cfif attributes.value EQ "1"> checked="checked"</cfif> #attributes.fieldAttributes# />
					<label for="#attributes.fieldName#"></label>
				</div>
				
			</cfoutput>
		</cfcase>
		<cfcase value="checkboxgroup">
			<cfoutput>
				<input type="hidden" name="#attributes.fieldName#" value="" />
				<cfloop array="#attributes.valueOptions#" index="option">
					<cfset thisOptionValue = isSimpleValue(option) ? option : structKeyExists(option, 'value') ? structFind(option, 'value') : '' />
					<cfset thisOptionName = isSimpleValue(option) ? option : structFind(option, 'name') />
					
					<div class="s-checkbox">
						<input type="checkbox" id="#thisOptionValue#" name="#attributes.fieldName#" value="#thisOptionValue#" class="#attributes.fieldClass# form-control" <cfif listFindNoCase(attributes.value, thisOptionValue)> checked="checked"</cfif> #attributes.fieldAttributes# /> 
						<label for="#thisOptionValue#"> #thisOptionName#</label>
					</div>
					
				</cfloop>
			</cfoutput>
		</cfcase>
		<cfcase value="date">
			<cfoutput>
				<input type="text" name="#attributes.fieldName#" value="#attributes.value#" class="#attributes.fieldClass# datepicker form-control" #attributes.fieldAttributes# />
			</cfoutput>
		</cfcase>
		<cfcase value="dateTime">
			<cfoutput>
				<input type="text" name="#attributes.fieldName#" value="#attributes.value#" class="#attributes.fieldClass# datetimepicker form-control" #attributes.fieldAttributes# />
			</cfoutput>
		</cfcase>
		<cfcase value="file">
			<cfoutput>
				
				<div class="s-file-upload">
					<ul class="list-unstyled list-inline">
						<li><input type="file" name="#attributes.fieldName#" #attributes.fieldAttributes#></li>
						<cfif attributes.value neq ''>
							<li><a href="#attributes.removeLink#" class="btn btn-xs btn-primary s-remove-btn s-remove">Remove <span>"#attributes.value#"</span></a></li>
						</cfif>
					</ul>
				</div>
				
			</cfoutput>
		</cfcase>
		<cfcase value="listingMultiselect">
			<cfif structKeyExists(attributes,'valueOptionsSmartList') && (isObject(attributes.valueOptionsSmartList) || len(attributes.valueOptionsSmartlist)) >
				
				<hb:HibachiListingDisplay smartList="#attributes.valueOptionsSmartList#" multiselectFieldName="#attributes.fieldName#" multiselectValues="#attributes.value#" multiselectPropertyIdentifier="#attributes.multiselectPropertyIdentifier#" title="#attributes.title#" edit="true"></hb:HibachiListingDisplay>
			<cfelseif structKeyExists(attributes,'valueOptionsCollectionList') >
				<cfoutput>
					<cfset scopeVariableID = 'valueOptionsCollectionList#rereplace(createUUID(),'-','','all')#'/>
					<span ng-init="#scopeVariableID#=$root.hibachiScope.$injector.get('collectionConfigService').newCollectionConfig().loadJson(#rereplace(attributes.valueOptionsCollectionList,'"',"'",'all')#)"></span>
					<sw-listing-display
						ng-if="#scopeVariableID#.collectionConfigString"
					    data-collection-config="#scopeVariableID#"
					    data-has-search="true"
					    data-has-action-bar="true"
					    data-show-filters="true"
					    show-simple-listing-controls="false"
					    edit="true"
						data-multiselect-field-name="#attributes.fieldName#"
						data-multiselectable="true"
						data-multi-slot="true"
						data-multiselect-values="#attributes.value#"
					>
					</sw-listing-display>
				</cfoutput>
			</cfif>
		</cfcase>
		<cfcase value="listingSelect">
			<cfif structKeyExists(attributes,'valueOptionsSmartList') && (isObject(attributes.valueOptionsSmartList) || len(attributes.valueOptionsSmartlist)) >
				<hb:HibachiListingDisplay smartList="#attributes.valueOptionsSmartList#" selectFieldName="#attributes.fieldName#" selectvalue="#attributes.value#" edit="true"></hb:HibachiListingDisplay>
			<cfelseif structKeyExists(attributes,'valueOptionsCollectionList') >
				<cfoutput>
					<cfset scopeVariableID = 'valueOptionsCollectionList#rereplace(createUUID(),'-','','all')#'/>
					<span ng-init="#scopeVariableID#=$root.hibachiScope.$injector.get('collectionConfigService').newCollectionConfig().loadJson(#rereplace(attributes.valueOptionsCollectionList,'"',"'",'all')#)"></span>
					<sw-listing-display
						ng-if="#scopeVariableID#.collectionConfigString"
					    data-collection-config="#scopeVariableID#"
					    data-has-search="true"
					    data-has-action-bar="true"
					    data-show-filters="true"
					    show-simple-listing-controls="false"
					    edit="true"
						data-multiselect-field-name="#attributes.fieldName#"
						data-multiselectable="true"
						data-multiselect-values="#attributes.value#"
						data-multi-slot="true"
						data-is-radio="true"
					>
					</sw-listing-display>
				</cfoutput>
			</cfif>
		</cfcase>
		<cfcase value="multiselect">
			<cfoutput>
				<input name="#attributes.fieldName#" type="hidden" value="" />
				<select name="#attributes.fieldName#" class="#attributes.fieldClass# multiselect" multiple="multiple" #attributes.fieldAttributes#>
					<cfloop array="#attributes.valueOptions#" index="option">
						<cfset thisOptionName = "" />
						<cfset thisOptionValue = "" />
						<cfset thisOptionData = "" />
						<cfif isSimpleValue(option)>
							<cfset thisOptionName = option />
							<cfset thisOptionValue = option />
						<cfelse>
							<cfloop collection="#option#" item="key">
								<cfif key eq "name">
									<cfset thisOptionName = option[ key ] />
								<cfelseif key eq "value">
									<cfset thisOptionValue = option[ key ] />
								<cfelseif not isNull(key) and structKeyExists(option, key) and not isNull(option[key])>
									<cfset thisOptionData = listAppend(thisOptionData, 'data-#replace(lcase(key), '_', '-', 'all')#="#option[key]#"', ' ') />
								</cfif>
							</cfloop>
						</cfif>
						<cfset thisOptionValue = isSimpleValue(option) ? option : structKeyExists(option, 'value') ? structFind(option, 'value') : '' />
						<cfset thisOptionName = isSimpleValue(option) ? option : structFind(option, 'name') />
						<option value="#thisOptionValue#" <cfif listFindNoCase(attributes.value, thisOptionValue)> selected="selected"</cfif>>#thisOptionName#</option>
					</cfloop>
				</select>
			</cfoutput>
		</cfcase>
		<cfcase value="password">
			<cfoutput>
				<input type="password" name="#attributes.fieldName#" class="form-control #attributes.fieldClass#" autocomplete="off" #attributes.fieldAttributes# />
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
				<cfif !valueExists and arrayLen(attributes.valueOptions)>
					<cfset attributes.value = attributes.valueOptions[1]['value'] />
				</cfif>
				<cfloop array="#attributes.valueOptions#" index="option">
					<cfset thisOptionValue = isSimpleValue(option) ? option : structKeyExists(option, 'value') ? structFind(option, 'value') : '' />
					<cfset thisOptionName = isSimpleValue(option) ? option : structFind(option, 'name') />
					<div class="radio">
						<input type="radio" id="#thisOptionValue#" name="#attributes.fieldName#" value="#thisOptionValue#" class="#attributes.fieldClass#" <cfif attributes.value EQ thisOptionValue> checked="checked"</cfif> #attributes.fieldAttributes# />
						<label for="#thisOptionValue#">
							#thisOptionName#
						</label>
					</div>	
				</cfloop>
			</cfoutput>
		</cfcase>
		<cfcase value="select">
			<cfoutput>
				<cfif arrayLen(attributes.valueOptions) || attributes.showEmptySelectBox >
					<select name="#attributes.fieldName#" class="form-control #attributes.fieldClass# j-custom-select" #attributes.fieldAttributes#>
						<cfloop array="#attributes.valueOptions#" index="option">
							<cfset thisOptionName = "" />
							<cfset thisOptionValue = "" />
							<cfset thisOptionData = "" />
							<cfif isSimpleValue(option)>
								<cfset thisOptionName = option />
								<cfset thisOptionValue = option />
							<cfelse>
								<cfloop collection="#option#" item="key">
									<cfif structkeyExists(option,key)>
										<cfif key eq "name">
											<cfset thisOptionName = option[ key ] />
										<cfelseif key eq "value">
											<cfset thisOptionValue = option[ key ] />
										<cfelseif not isNull(key) and structKeyExists(option, key) and not isNull(option[key])>
											<cfset thisOptionData = listAppend(thisOptionData, '#replace(lcase(key), '_', '-', 'all')#="#request.context.fw.getHibachiScope().hibachiHtmlEditFormat(option[key])#"', ' ') />
										</cfif>
									</cfif>
								</cfloop>
							</cfif>
							<cfset thisOptionValue = request.context.fw.getHibachiScope().hibachiHtmlEditFormat(thisOptionValue)>
							<cfset thisOptionName = request.context.fw.getHibachiScope().hibachiHtmlEditFormat(thisOptionName)>
							<cfset thisOptionData = thisOptionData>

							<option value="#thisOptionValue#" #thisOptionData#<cfif attributes.value EQ thisOptionValue> selected="selected"</cfif>>#thisOptionName#</option>
						</cfloop>
					</select>
				</cfif>
			</cfoutput>
		</cfcase>
		<cfcase value="text">
			<cfoutput>
				<input type="text" name="#attributes.fieldName#" value="#attributes.value#" class="form-control #attributes.fieldClass#" #attributes.fieldAttributes# />
			</cfoutput>
		</cfcase>
		<cfcase value="textautocomplete">
			<cfoutput>
				<cfset suggestionsID = reReplace(attributes.fieldName, '[^0-9A-Za-z]','','all') & "-suggestions" />
				<div class="autoselect-container">
					<input type="hidden" name="#attributes.fieldName#" value="#attributes.value#" />
					<input type="text" name="#reReplace(attributes.fieldName, '[^0-9A-Za-z]','','all')#-autocompletesearch" autocomplete="off" class="textautocomplete #attributes.fieldClass# form-control" data-acfieldname="#attributes.fieldName#" data-sugessionsid="#suggestionsID#" #attributes.fieldAttributes# <cfif len(attributes.value)>disabled="disabled"</cfif> />
					<div class="autocomplete-selected" <cfif not len(attributes.value)>style="display:none;"</cfif>><a href="##" class="textautocompleteremove"><i class="glyphicon glyphicon-remove"></i></a> <span class="value" id="selected-#suggestionsID#"><cfif len(attributes.value)>#attributes.autocompleteSelectedValueDetails[ attributes.autocompleteNameProperty ]#</cfif></span></div>
					<div class="autocomplete-options" style="display:none;">
						<ul class="#listLast(lcase(attributes.fieldName),".")#" id="#suggestionsID#">
							<cfif len(attributes.value)>
								<li>
									<a href="##" class="textautocompleteadd" data-acvalue="#attributes.value#" data-acname="#attributes.autocompleteSelectedValueDetails[ attributes.autocompleteNameProperty ]#">
									<cfset thisTag.counter = 0 />
									<cfloop list="#attributes.autocompletePropertyIdentifiers#" index="pi">
										<cfset thisTag.counter++ />
										<cfif thisTag.counter lte 2 and pi neq "adminIcon">
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
						<hb:HibachiActionCaller action="#attributes.modalCreateAction#" modal="true" icon="plus" type="link" class="btn modal-fieldupdate-textautocomplete" icononly="true">
					</cfif>
				</div>
			</cfoutput>
		</cfcase>
		<cfcase value="typeahead">
			<cfoutput>
				<div ng-cloak class="form-group #attributes.fieldClass#" #attributes.fieldAttributes#>
					<!--- Generic Configured brand --->
					<sw-typeahead-input-field
							data-entity-name="#attributes.autocompleteDataEntity#"
					        data-property-to-save="#attributes.autocompleteValueProperty#"
					        data-property-to-show="#attributes.autocompleteNameProperty#"
					        data-properties-to-load="#attributes.autocompletePropertyIdentifiers#"
					        data-show-add-button="true"
					        data-show-view-button="true"
					        data-placeholder-rb-key=""
					        data-placeholder-text="Search #attributes.autocompleteDataEntity#"
					        data-multiselect-mode="false"
					        data-filter-flag="true"
					        data-field-name="#attributes.fieldName#"
					        data-initial-entity-id="#attributes.value#"
					        data-max-records="#attributes.maxrecords#"
					        data-order-by-list="#attributes.autocompleteNameProperty#|ASC">

					    <sw-collection-config
					            data-entity-name="#attributes.autocompleteDataEntity#"
					            data-collection-config-property="typeaheadCollectionConfig"
					            data-parent-directive-controller-as-name="swTypeaheadInputField"
					            data-all-records="true">
					    	
					    	<!--- Columns --->
 							<sw-collection-columns>
 								<sw-collection-column data-property-identifier="#attributes.autocompleteNameProperty#" is-searchable="true"></sw-collection-column>
 								<sw-collection-column data-property-identifier="#attributes.autocompleteValueProperty#" is-searchable="false"></sw-collection-column>
 							</sw-collection-columns>
 							
 							<!--- Order By --->
 					    	<sw-collection-order-bys>
 					        	<sw-collection-order-by data-order-by="#attributes.autocompleteNameProperty#|ASC"></sw-collection-order-by>
 					    	</sw-collection-order-bys>

					    	<!--- Filters --->
					    	<cfif attributes.showActiveFlag EQ true>
						    	<sw-collection-filters>
		                            <sw-collection-filter data-property-identifier="activeFlag" data-comparison-operator="=" data-comparison-value="1"></sw-collection-filter>
		                        </sw-collection-filters>
					    	</cfif>
					    </sw-collection-config>

						<span sw-typeahead-search-line-item data-property-identifier="#attributes.autocompleteNameProperty#" dropdownOpen="false" is-searchable="true"></span><br>

					</sw-typeahead-input-field>
				</div>
			</cfoutput>
		</cfcase>
		<cfcase value="textarea">
			<cfoutput>
				<textarea name="#attributes.fieldName#" class="#attributes.fieldClass# form-control" #attributes.fieldAttributes#>#attributes.value#</textarea>
			</cfoutput>
		</cfcase>
		<cfcase value="time">
			<cfoutput>
				<input type="text" name="#attributes.fieldName#" value="#attributes.value#" class="#attributes.fieldClass# timepicker form-control" #attributes.fieldAttributes# />
			</cfoutput>
		</cfcase>
		<cfcase value="wysiwyg">
			<!--- need to always have application key in ckfinder --->
			<cfset attributes.fieldAttributes = listAppend(attributes.fieldAttributes,'applicationkey="#request.context.fw.getHibachiScope().getApplicationValue('applicationKey')#"',' ' )/>
			
			<cfset request.isWysiwygPage = true />
			<cfoutput>
				<textarea name="#attributes.fieldName#" class="#attributes.fieldClass# wysiwyg form-control" #attributes.fieldAttributes#>#attributes.value#</textarea>
			</cfoutput>
		</cfcase>
		<cfcase value="yesno">
			<cfoutput>
				<div class="radio">
					<input type="radio" name="#attributes.fieldName#" id="#attributes.fieldName#Yes" class="#attributes.fieldClass# yes" value="1" <cfif isBoolean(attributes.value) && attributes.value>checked="checked"</cfif> #attributes.fieldAttributes# />
					<label for="#attributes.fieldName#Yes">
						#yesNoFormat(1)#
					</label>
				</div>
				<div class="radio">
					<input type="radio" name="#attributes.fieldName#" id="#attributes.fieldName#No" class="#attributes.fieldClass# yes" value="0" <cfif (isboolean(attributes.value) && not attributes.value) || not isBoolean(attributes.value)>checked="checked"</cfif> #attributes.fieldAttributes# />
					<label for="#attributes.fieldName#No">
						#yesNoFormat(0)#
					</label>
				</div>
			</cfoutput>
		</cfcase>
	</cfswitch>

</cfif>
