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
<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />


<cfparam name="rc.edit" default="false" />
<cfparam name="rc.attributeSet" type="any" />

<cfoutput>
	
<hb:HibachiEntityDetailForm object="#rc.attributeSet#" edit="#rc.edit#">
	<hb:HibachiEntityActionBar type="detail" object="#rc.attributeSet#" edit="#rc.edit#">
		<hb:HibachiActionCaller action="admin:entity.createattribute" queryString="attributesetid=#rc.attributeset.getAttributeSetID()#" type="list" modal=true />
	</hb:HibachiEntityActionBar>
	
	<hb:HibachiEntityDetailGroup object="#rc.attributeSet#">
		<hb:HibachiEntityDetailItem view="admin:entity/attributesettabs/basic" open="true" text="#$.slatwall.rbKey('admin.define.basic')#" showOnCreateFlag=true />
		<hb:HibachiEntityDetailItem view="admin:entity/attributesettabs/attributes" count="#rc.attributeSet.getAttributesCount()#"/>
		<hb:HibachiEntityDetailItem view="admin:entity/attributesettabs/description" />
		<cfif not rc.attributeSet.getGlobalFlag()>
			<cfif listFindNoCase("OrderItem,ProductType,Product,Sku", rc.attributeSet.getAttributeSetObject()) and not rc.attributeSet.getGlobalFlag()>
				<hb:HibachiEntityDetailItem property="producttypes" />
			</cfif>
			<cfif listFindNoCase("OrderItem,Product,Sku", rc.attributeSet.getAttributeSetObject()) and not rc.attributeSet.getGlobalFlag()>
				<hb:HibachiEntityDetailItem property="products" />
				<hb:HibachiEntityDetailItem property="brands" />
			</cfif>
			<cfif listFindNoCase("OrderItem,Sku", rc.attributeSet.getAttributeSetObject()) and not rc.attributeSet.getGlobalFlag()>
				<hb:HibachiEntityDetailItem property="skus" />
			</cfif>
			<cfif listFindNoCase("Type", rc.attributeSet.getAttributeSetObject()) and not rc.attributeSet.getGlobalFlag()>
				<hb:HibachiEntityDetailItem property="types" />
			</cfif>
			<cfif listFindNoCase("Content", rc.attributeSet.getAttributeSetObject()) and not rc.attributeSet.getGlobalFlag()>
				<hb:HibachiEntityDetailItem property="contents" />
			</cfif>
		</cfif>
	</hb:HibachiEntityDetailGroup>
	
</hb:HibachiEntityDetailForm>

</cfoutput>

