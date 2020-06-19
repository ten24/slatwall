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
<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />


<cfparam name="rc.attribute" type="any" />
<cfparam name="rc.edit" type="boolean" />


<cfoutput>
	<cfif rc.attribute.getAttributeInputType() eq "text">
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.attribute#" property="validationMessage" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.attribute#" property="validationRegex" edit="#rc.edit#">	
		</hb:HibachiPropertyList>
	<cfelseif rc.attribute.getAttributeInputType() eq "password">
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.attribute#" property="decryptValueInAdminFlag" edit="#rc.edit#">
		</hb:HibachiPropertyList>
	<cfelseif listFindNoCase( "checkboxGroup,multiselect,radioGroup,select",rc.attribute.getAttributeInputType() )>
		<cfif !isNull(rc.attribute.getAttributeOptionSource())>
			<cfset attributeOptionSmartList = rc.attribute.getAttributeOptionSource().getAttributeOptionsSmartList()>
		<cfelse>
			<cfset attributeOptionSmartlist = rc.attribute.getAttributeOptionsSmartList()>
		</cfif>
		<hb:HibachiListingDisplay smartList="#attributeOptionSmartList#"
								   recordEditAction="admin:entity.editattributeoption" 
								   recordEditQueryString="redirectAction=admin:entity.detailAttribute&attributeID=#rc.attribute.getAttributeID()#"
								   recordDeleteAction="admin:entity.deleteattributeoption"
								   recordDeleteQueryString="attributeID=#rc.attribute.getAttributeID()#&redirectAction=admin:entity.detailAttribute"
								   sortProperty="sortOrder"
								   sortContextIDColumn="attributeID"
								   sortContextIDValue="#rc.attribute.getAttributeID()#">
			<hb:HibachiListingColumn propertyIdentifier="attributeOptionValue" /> 
			<hb:HibachiListingColumn tdclass="primary" propertyIdentifier="attributeOptionLabel" /> 
		</hb:HibachiListingDisplay>
		<cfif isNull(rc.attribute.getAttributeOptionSource())>
			<hb:HibachiActionCaller action="admin:entity.createattributeoption" class="btn btn-default" icon="plus" queryString="redirectAction=admin:entity.detailAttribute&attributeid=#rc.attribute.getAttributeID()#" />
		<cfelse>
			<hb:HibachiActionCaller action="admin:entity.editattribute" text="#$.slatwall.rbkey('entity.attribute.attributeOptionSource')#" class="btn btn-default" icon="arrow-left" queryString="redirectAction=admin:entity.detailAttribute&attributeid=#rc.attribute.getAttributeOptionSource().getAttributeID()#" />
		</cfif>
	</cfif>
	
</cfoutput>
