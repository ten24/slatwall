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


<cfset sites = $.slatwall.getService('siteService').getSiteSmartList() />
<cfset sites.addFilter('activeFlag', 1) />

<cfset rc.sitesArray = sites.getRecords() />

<cfoutput>
	<hb:HibachiEntityActionBar type="static"></hb:HibachiEntityActionBar>
	
	<hb:HibachiEntityDetailGroup>
		<hb:HibachiEntityDetailItem view="admin:entity/settingstabs/global" />
		<hb:HibachiEntityDetailItem view="admin:entity/settingstabs/globaladvanced" />
		<hb:HibachiEntityDetailItem view="admin:entity/settingstabs/attribute" />
		<hb:HibachiEntityDetailItem view="admin:entity/settingstabs/account" />
		<hb:HibachiEntityDetailItem view="admin:entity/settingstabs/address" />
		<hb:HibachiEntityDetailItem view="admin:entity/settingstabs/brand" />
		<hb:HibachiEntityDetailItem view="admin:entity/settingstabs/category" />
		<hb:HibachiEntityDetailItem view="admin:entity/settingstabs/content" />
		<hb:HibachiEntityDetailItem view="admin:entity/settingstabs/email" />
		<hb:HibachiEntityDetailItem view="admin:entity/settingstabs/fulfillmentmethod" />
		<hb:HibachiEntityDetailItem view="admin:entity/settingstabs/image" />
		<hb:HibachiEntityDetailItem view="admin:entity/settingstabs/location" />
		<hb:HibachiEntityDetailItem view="admin:entity/settingstabs/locationConfiguration" />
		<hb:HibachiEntityDetailItem view="admin:entity/settingstabs/order" />
		<hb:HibachiEntityDetailItem view="admin:entity/settingstabs/paymentmethod" />
		<hb:HibachiEntityDetailItem view="admin:entity/settingstabs/physical" />
		<hb:HibachiEntityDetailItem view="admin:entity/settingstabs/producttype" />
		<hb:HibachiEntityDetailItem view="admin:entity/settingstabs/product" />
		<hb:HibachiEntityDetailItem view="admin:entity/settingstabs/site" />
		<hb:HibachiEntityDetailItem view="admin:entity/settingstabs/shippingmethod" />
		<hb:HibachiEntityDetailItem view="admin:entity/settingstabs/shippingmethodrate" />
		<hb:HibachiEntityDetailItem view="admin:entity/settingstabs/sku" />
		<hb:HibachiEntityDetailItem view="admin:entity/settingstabs/subscriptionusage" />
		<hb:HibachiEntityDetailItem view="admin:entity/settingstabs/task" />
	</hb:HibachiEntityDetailGroup>
</cfoutput>

