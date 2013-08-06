<cfif thisTag.executionMode is "start">
	
	<cfparam name="attributes.edit" type="boolean" default="false" />					<!--- hint: When in edit mode this will create a Form Field, otherwise it will just display the value" --->

	<cfparam name="attributes.title" type="string" default="" />						<!--- hint: This can be used to override the displayName of a property" --->
	<cfparam name="attributes.hint" type="string" default="" />							<!--- hint: This is the hint value associated with whatever field we are displaying.  If specified, you will get a tooltip popup --->
	
	<cfparam name="attributes.value" type="string" default="" />						<!--- hint: This can be used to override the value of a property --->
	<cfparam name="attributes.valueOptions" type="array" default="#arrayNew(1)#" />		<!--- hint: This can be used to set a default value for the property IF it hasn't been defined  NOTE: right now this only works for select boxes--->
	<cfparam name="attributes.valueOptionsSmartList" type="any" default="" />			<!--- hint: This can either be either an entityName string, or an actual smartList --->
	<cfparam name="attributes.valueDefault" type="string" default="" />					<!--- hint: This can be used to set a default value for the property IF it hasn't been defined  NOTE: right now this only works for select boxes--->
	<cfparam name="attributes.valueLink" type="string" default="" />					<!--- hint: if specified, will wrap property value with an achor tag using the attribute as the href value --->
	<cfparam name="attributes.valueFormatType" type="string" default="" />				<!--- hint: This can be used to defined the format of this property wehn it is displayed --->
	
	<cfparam name="attributes.fieldName" type="string" default="" />					<!--- hint: This can be used to override the default field name" --->
	<cfparam name="attributes.fieldType" type="string" default="" />					<!--- hint: When in edit mode you can override the default type of form object to use" --->
	
	<cfparam name="attributes.titleClass" default="" />									<!--- hint: Adds class to whatever markup wraps the title element --->
	<cfparam name="attributes.valueClass" default="" />									<!--- hint: Adds class to whatever markup wraps the value element --->
	<cfparam name="attributes.fieldClass" default="" />									<!--- hint: Adds class to the actual field element --->
	<cfparam name="attributes.valueLinkClass" default="" />								<!--- hint: Adds class to whatever markup wraps the value link element --->
		
	<cfparam name="attributes.toggle" type="string" default="no" />						<!--- hint: This attribute indicates whether the field can be toggled to show/hide the value. Possible values are "no" (no toggling), "Show" (shows field by default but can be toggled), or "Hide" (hide field by default but can be toggled) --->
	<cfparam name="attributes.displayType" default="dl" />								<!--- hint: This attribute is used to specify if the information comes back as a definition list (dl) item or table row (table) or with no formatting or label (plain) --->
	
	<cfparam name="attributes.errors" type="array" default="#arrayNew(1)#" />			<!--- hint: This holds any errors for the current field if needed --->
		
	<cfparam name="attributes.modalCreateAction" type="string" default="" />			<!--- hint: This allows for a special admin action to be passed in where the saving of that action will automatically return the results to this field --->
		
	<cfparam name="attributes.multiselectPropertyIdentifier" type="string" default="" />
		
	<cfswitch expression="#attributes.displaytype#">
		<!--- DL Case --->
		<cfcase value="dl">
			<cfif attributes.edit>
				<cfoutput>
					<div class="control-group">
						<label for="#attributes.fieldName#" class="control-label">#attributes.title#<cfif len(attributes.hint)> <a href="##" tabindex="-1" data-toggle="tooltip" class="hint" data-title="#attributes.hint#"><i class="icon-question-sign"></i></a></cfif></label></dt>
						<div class="controls">
							<cf_HibachiFormField attributecollection="#attributes#" />
							<cf_HibachiErrorDisplay errors="#attributes.errors#" displayType="label" for="#attributes.fieldName#" />
						</div>
					</div>
				</cfoutput>
			<cfelse>
				<cfoutput>
					<dt class="title<cfif len(attributes.titleClass)> #attributes.titleClass#</cfif>">#attributes.title#<cfif len(attributes.hint)> <a href="##" tabindex="-1" data-toggle="tooltip" class="hint" data-title="#attributes.hint#"><i class="icon-question-sign"></i></a></cfif></dt>
					<cfif attributes.valueLink neq "">
						<dd class="value<cfif len(attributes.valueClass)> #attributes.valueClass#</cfif>"><a href="#attributes.valueLink#" class="#attributes.valueLinkClass#">#attributes.value#</a></dd>
					<cfelse>
						<dd class="value<cfif len(attributes.valueClass)> #attributes.valueClass#</cfif>">#attributes.value#</dd>
					</cfif>
				</cfoutput>
			</cfif>
		</cfcase>
		<!--- TABLE Display --->
		<cfcase value="table">
			<cfif attributes.edit>
				<cfoutput>
					<tr>
						<td class="title<cfif len(attributes.titleClass)> #attributes.titleClass#</cfif>"><label for="#attributes.fieldName#">#attributes.title#<cfif len(attributes.hint)> <a href="##" tabindex="-1" data-toggle="tooltip" class="hint" data-title="#attributes.hint#"><i class="icon-question-sign"></i></a></cfif></label></td>
						<td class="value<cfif len(attributes.valueClass)> #attributes.valueClass#</cfif>">
							<cf_HibachiFormField attributecollection="#attributes#" />
							<cf_HibachiErrorDisplay errors="#attributes.errors#" displayType="label" for="#attributes.fieldName#" />
						</td>
					</tr>
				</cfoutput>
			<cfelse>
				<cfoutput>
					<tr>
						<td class="title<cfif len(attributes.titleClass)> #attributes.titleClass#</cfif>">#attributes.title#<cfif len(attributes.hint)> <a href="##" tabindex="-1" rel="tooltip" class="hint" title="#attributes.hint#"><i class="icon-question-sign"></i></a></cfif></td>
						<cfif attributes.valueLink neq "">
							<td class="value<cfif len(attributes.valueClass)> #attributes.valueClass#</cfif>"><a href="#attributes.valueLink#" class="#attributes.valueLinkClass#">#attributes.value#</a></td>
						<cfelse>
							<td class="value<cfif len(attributes.valueClass)> #attributes.valueClass#</cfif>">#attributes.value#</td>
						</cfif>
					</tr>
				</cfoutput>
			</cfif>
		</cfcase>
		<!--- INLINE Display --->
		<cfcase value="span">
			<cfif attributes.edit>
				<cfoutput>
					<span class="title<cfif len(attributes.titleClass)> #attributes.titleClass#</cfif>"><label for="#attributes.fieldName#">#attributes.title#<cfif len(attributes.hint)> <a href="##" tabindex="-1" rel="tooltip" class="hint" title="#attributes.hint#"><i class="icon-question-sign"></i></a></cfif></label></span>
					<span class="value<cfif len(attributes.valueClass)> #attributes.valueClass#</cfif>">
						<cf_HibachiFormField attributecollection="#attributes#" />
						<cf_HibachiErrorDisplay errors="#attributes.errors#" displayType="label" for="#attributes.fieldName#" />
					</span>
				</cfoutput>
			<cfelse>
				<cfoutput>
					<span class="title<cfif len(attributes.titleClass)> #attributes.titleClass#</cfif>">#attributes.title#<cfif len(attributes.hint)> <a href="##" tabindex="-1" rel="tooltip" class="hint" title="#attributes.hint#"><i class="icon-question-sign"></i></a></cfif>: </span>
					<cfif attributes.valueLink neq "">
						<span class="value<cfif len(attributes.valueClass)> #attributes.valueClass#</cfif>"><a href="#attributes.valueLink#" class="#attributes.valueLinkClass#">#attributes.value#</a></span>
					<cfelse>
						<span class="value<cfif len(attributes.valueClass)> #attributes.valueClass#</cfif>">#attributes.value#</span>
					</cfif>
				</cfoutput>
			</cfif>
		</cfcase>
		<!--- Plain Display (value only) --->
		<cfcase value="plain">
			<cfif attributes.edit>
				<cfoutput>
					<cf_HibachiFormField attributecollection="#attributes#" />
					<cf_HibachiErrorDisplay errors="#attributes.errors#" displayType="label" for="#attributes.fieldName#" />
				</cfoutput>
			<cfelse>
				<cfoutput>
					<cfif attributes.valueLink neq "">
						<a href="#attributes.valueLink#" class="#attributes.valueLinkClass#">#attributes.value#</a>
					<cfelse>
						<cfif attributes.fieldType eq "listingMultiselect">
							<cf_HibachiListingDisplay smartList="#attributes.valueOptionsSmartList#" multiselectFieldName="#attributes.fieldName#" multiselectFieldClass="#attributes.fieldClass#" multiselectvalues="#attributes.value#" multiselectPropertyIdentifier="#attributes.multiselectPropertyIdentifier#" edit="false"></cf_HibachiListingDisplay>
						<cfelse>
							#attributes.value#
						</cfif>
					</cfif>
				</cfoutput>
			</cfif>
		</cfcase>
	</cfswitch>
</cfif>