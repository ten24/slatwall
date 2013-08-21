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
<cfparam name="rc.edit" default="false" />
<cfparam name="rc.attributeSet" type="any" />

<cfoutput>
	
<cf_HibachiEntityDetailForm object="#rc.attributeSet#" edit="#rc.edit#">
	<cf_HibachiEntityActionBar type="detail" object="#rc.attributeSet#" edit="#rc.edit#">
		<cf_HibachiActionCaller action="admin:entity.createattribute" queryString="attributesetid=#rc.attributeset.getAttributeSetID()#" type="list" modal=true />
	</cf_HibachiEntityActionBar>
	
	<cf_HibachiPropertyRow>
		<cf_HibachiPropertyList divclass="span6">
			<cf_HibachiPropertyDisplay object="#rc.attributeSet#" property="attributeSetType" edit="#rc.attributeSet.isNew()#">
			<cf_HibachiPropertyDisplay object="#rc.attributeSet#" property="activeFlag" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.attributeSet#" property="attributeSetName" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.attributeSet#" property="attributeSetCode" edit="#rc.edit#">
			<cfif rc.attributeSet.isNew()>
				<cf_HibachiDisplayToggle selector="select[name='attributeSetType.typeID']" showValues="444df292eea355ddad72f5614726bc75,444df293fcc530434949d63e408cac2b,444df328fa718364a389a4495f386a27,5accbf52063a5b4e2a73f19f4151cc40" loadVisable="#rc.attributeSet.getNewFlag() or listFindNoCase('444df292eea355ddad72f5614726bc75,444df293fcc530434949d63e408cac2b,444df328fa718364a389a4495f386a27,5accbf52063a5b4e2a73f19f4151cc40', rc.attributeSet.getAttributeSetType().getTypeID())#">
					<cf_HibachiPropertyDisplay object="#rc.attributeSet#" property="globalFlag" edit="#rc.edit#">
				</cf_HibachiDisplayToggle>
			</cfif>
		</cf_HibachiPropertyList>
		
		<cfif !rc.attributeSet.isNew()>
			<cf_HibachiPropertyList divclass="span6">
				<cfset local.canEditGlobal = listFind( "astProduct,astOrderItem", rc.attributeSet.getAttributeSetType().getSystemCode() ) && rc.edit />
				<cf_HibachiPropertyDisplay object="#rc.attributeSet#" property="globalFlag" edit="#local.canEditGlobal#">
				<cfif listFind( "astOrderItem", rc.attributeSet.getAttributeSetType().getSystemCode() )>
					<cf_HibachiPropertyDisplay object="#rc.attributeSet#" property="requiredFlag" edit="#rc.edit#">
					<cf_HibachiPropertyDisplay object="#rc.attributeSet#" property="accountSaveFlag" edit="#rc.edit#">
					<cf_HibachiPropertyDisplay object="#rc.attributeSet#" property="additionalCharge" edit="#rc.edit#">
				</cfif>
			</cf_HibachiPropertyList>
		</cfif>
	</cf_HibachiPropertyRow>
	
	<cf_HibachiTabGroup object="#rc.attributeSet#">
		<cf_HibachiTab view="admin:entity/attributesettabs/attributes" />
		<cf_HibachiTab view="admin:entity/attributesettabs/description" />
		<cfif not rc.attributeSet.getGlobalFlag()>
			<cfif listFindNoCase("astProductType,astProduct,astSku,astOrderItem", rc.attributeSet.getAttributeSetType().getSystemCode()) and not rc.attributeSet.getGlobalFlag()>
				<cf_HibachiTab property="producttypes" />
			</cfif>
			<cfif listFindNoCase("astProduct,astSku,astOrderItem", rc.attributeSet.getAttributeSetType().getSystemCode()) and not rc.attributeSet.getGlobalFlag()>
				<cf_HibachiTab property="products" />
				<cf_HibachiTab property="brands" />
			</cfif>
			<cfif listFindNoCase("astSku,astOrderItem", rc.attributeSet.getAttributeSetType().getSystemCode()) and not rc.attributeSet.getGlobalFlag()>
				<cf_HibachiTab property="skus" />
			</cfif>
		</cfif>
	</cf_HibachiTabGroup>
	
</cf_HibachiEntityDetailForm>

</cfoutput>

