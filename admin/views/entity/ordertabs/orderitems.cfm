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

<cfparam name="rc.order" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<!--- Order Items Detail--->
	<sw-order-items
		data-order-id="#rc.order.getOrderID()#"
		data-base-url="#getHibachiScope().getBaseImageURL()#/product/default/"	
	>
	</sw-order-items>
	
	<!--- If in edit and order is of correct status then we can add sale order items --->
	<cfif rc.edit and listFindNoCase("ostNotPlaced,ostNew,ostProcessing,ostOnHold", rc.order.getOrderStatusType().getSystemCode())>
		<!--- Tabs for Adding Sale Order Items Sku and Stock --->
		<hb:HibachiTabGroup tabLocation="top">
		<hb:HibachiTab tabid="soiaddsku" view="admin:entity/ordertabs/addsku" text="#$.slatwall.rbKey('define.add')# #$.slatwall.rbKey('entity.sku')#" />
		<hb:HibachiTab tabid="soiaddstock" view="admin:entity/ordertabs/addstock" text="#$.slatwall.rbKey('define.add')# #$.slatwall.rbKey('entity.stock')#" />
		<!--- Tabs for Adding Return Order Items Sku and Stock --->
		<hb:HibachiTab tabid="soiaddreturnsku" view="admin:entity/ordertabs/addreturnsku" text="#$.slatwall.rbKey('define.add')# Return #$.slatwall.rbKey('entity.sku')#" />
		<hb:HibachiTab tabid="soiaddreturnstock" view="admin:entity/ordertabs/addreturnstock" text="#$.slatwall.rbKey('define.add')# Return #$.slatwall.rbKey('entity.stock')#" />
		</hb:HibachiTabGroup>
</cfif>
</cfoutput>
