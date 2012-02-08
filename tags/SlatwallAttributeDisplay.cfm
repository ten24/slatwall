<!---

    Slatwall - An e-commerce plugin for Mura CMS
    Copyright (C) 2011 ten24, LLC

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
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

--->
<!--- hint: This is a required attribute that defines the object that contains the property to display --->
<cfparam name="attributes.attribute" type="any" />
<cfparam name="attributes.attributeValue" type="any" />
<cfparam name="attributes.edit" type="boolean" default="false" />

<cfset local = structNew() />

<cfif thisTag.executionMode is "start">
	<cfif attributes.attribute.getactiveFlag()>
		<cfoutput>
			<dt><label for="attribute.#attributes.attribute.getAttributeID()#">#attributes.attribute.getAttributeName()#<cfif attributes.attribute.getRequiredFlag() EQ 1> *</cfif></label></dt>
			<dd>
				<cfswitch expression="#attributes.attribute.getAttributeType().getSystemCode()#">
					<cfcase value="atSelect">
						<select name="attribute.#attributes.attribute.getAttributeID()#" id="attribute.#attributes.attribute.getAttributeID()#">
							<option value="#attributes.attribute.getDefaultValue()#">Select an option</option>
							<cfloop array="#attributes.attribute.getAttributeOptions()#" index="attributeOption" >
								<option value="#attributeOption.getAttributeOptionValue()#" <cfif attributes.attributeValue EQ attributeOption.getAttributeOptionValue()> Selected</cfif>>#attributeOption.getAttributeOptionLabel()#</option>
							</cfloop>
						</select>
					</cfcase>
					<cfcase value="atTextBox">
						<input type="text" name="attribute.#attributes.attribute.getAttributeID()#" id="attribute.#attributes.attribute.getAttributeID()#" value="#attributes.attributeValue#" />
					</cfcase>
					<cfcase value="atTextArea">
						<textarea name="attribute.#attributes.attribute.getAttributeID()#.#attributes.attributeValueID#" id="attribute.#attributes.attribute.getAttributeID()#.#attributes.attributeValueID#">#attributes.attributeValue#</textarea>
					</cfcase>
					<cfcase value="atRichTextEditor">
						<textarea name="attribute.#attributes.attribute.getAttributeID()#.#attributes.attributeValueID#" id="attribute.#attributes.attribute.getAttributeID()#.#attributes.attributeValueID#">#attributes.attributeValue#</textarea>
						<script type="text/javascript" language="Javascript">
							var loadEditorCount = 0;
							 
						</script>
					</cfcase>
					<cfcase value="atCheckBox">
						<input type="hidden" name="attribute.#attributes.attribute.getAttributeID()#.#attributes.attributeValueID#" id="attribute.#attributes.attribute.getAttributeID()#.#attributes.attributeValueID#" value="" />
						<cfloop array="#attributes.attribute.getAttributeOptions()#" index="local.option" >
							<input type="checkbox" name="attribute.#attributes.attribute.getAttributeID()#.#attributes.attributeValueID#" value="#local.option.getAttributeOptionValue()#" <cfif attributes.attributeValue EQ local.option.getAttributeOptionValue()> checked</cfif>>#local.option.getAttributeOptionLabel()#</option>
						</cfloop>					
					</cfcase>
					<cfcase value="atRadioGroup">
						<input type="hidden" name="attribute.#attributes.attribute.getAttributeID()#.#attributes.attributeValueID#" id="attribute.#attributes.attribute.getAttributeID()#.#attributes.attributeValueID#" value="" />
						<cfloop array="#attributes.attribute.getAttributeOptions()#" index="local.option" >
							<input type="radio" name="attribute.#attributes.attribute.getAttributeID()#.#attributes.attributeValueID#" value="#local.option.getAttributeOptionValue()#" <cfif attributes.attributeValue EQ local.option.getAttributeOptionValue()> checked</cfif>>#local.option.getAttributeOptionLabel()#</option>
						</cfloop>					
					</cfcase>
					<cfdefaultcase></cfdefaultcase>
				</cfswitch>
			</dd>
		</cfoutput>
	</cfif>
</cfif>