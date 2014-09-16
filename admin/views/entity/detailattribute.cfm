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
<cfparam name="rc.attribute" type="any">
<cfparam name="rc.attributeSet" type="any" default="#rc.attribute.getAttributeSet()#">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.attribute#" edit="#rc.edit#"
								saveActionQueryString="attributeSetID=#rc.attributeSet.getAttributeSetID()#">
									
		<cf_HibachiEntityActionBar type="detail" object="#rc.attribute#" edit="#rc.edit#"
								   backAction="admin:entity.detailAttributeSet"
								   backQueryString="attributeSetID=#rc.attributeSet.getAttributeSetID()#"
								   cancelAction="admin:entity.detailAttributeSet"
								   cancelQueryString="attributeSetID=#rc.attributeSet.getAttributeSetID()#" 
								   deleteQueryString="attributeSetID=#rc.attributeSet.getAttributeSetID()#&redirectAction=admin:entity.detailAttributeSet" />
		
		<cfif rc.edit>
			
			<!--- Hidden field to attach this to the attributeSet --->
			<input type="hidden" name="attributeSet.attributeSetID" value="#rc.attributeSet.getAttributeSetID()#" />
		</cfif>

		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList>
				<cf_HibachiPropertyDisplay object="#rc.attribute#" property="activeFlag" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.attribute#" property="requiredFlag" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.attribute#" property="attributeName" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.attribute#" property="attributeCode" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.attribute#" property="attributeHint" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.attribute#" property="defaultValue" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.attribute#" property="attributeType" valueDefault="text" edit="#rc.edit and rc.attribute.isNew()#">
				<cf_HibachiDisplayToggle selector="select[name='attributeType']" showValues="relatedObjectSelect,relatedObjectMultiselect" loadVisable="#(!isNull(rc.attribute.getAttributeType()) && listFindNoCase('relatedObjectSelect,releatedObjectMultiselect', rc.attribute.getAttributeType()))#">
					<cf_HibachiPropertyDisplay object="#rc.attribute#" property="relatedObject" edit="#rc.edit and rc.attribute.isNew()#">
				</cf_HibachiDisplayToggle>
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>

		<cf_HibachiTabGroup object="#rc.attribute#">
			<cfif not rc.attribute.isNew() and listFindNoCase( "text,password,checkboxGroup,multiselect,radioGroup,select",rc.attribute.getAttributeType() )>
				<cf_HibachiTab view="admin:entity/attributetabs/attributeoptions" />
			</cfif>
			<cf_HibachiTab view="admin:entity/attributetabs/description" />
		</cf_HibachiTabGroup>

	</cf_HibachiEntityDetailForm>
</cfoutput>
