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


<cfparam name="rc.cyclecountgroup" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<hb:HibachiEntityDetailForm object="#rc.cyclecountgroup#" edit="#rc.edit#">
		<hb:HibachiEntityActionBar type="detail" object="#rc.cyclecountgroup#" edit="#rc.edit#">
		</hb:HibachiEntityActionBar>

		<hb:HibachiEntityDetailGroup object="#rc.cyclecountgroup#">
			<hb:HibachiEntityDetailItem view="admin:entity/cyclecountgrouptabs/basic" open="true" text="#$.slatwall.rbKey('admin.define.basic')#" showOnCreateFlag=true />
			<hb:HibachiEntityDetailItem object="#rc.cyclecountgroup#" property="locations" edit="#rc.edit#">
			<hb:HibachiEntityDetailItem view="admin:entity/cyclecountgrouptabs/locationcollections" text="#$.slatwall.rbKey('entity.CycleCountGroup.locationCollection')#" />
			<hb:HibachiEntityDetailItem view="admin:entity/cyclecountgrouptabs/skucollections" text="#$.slatwall.rbKey('entity.CycleCountGroup.skuCollection')#" />
			<!--- Comments --->
			<swa:SlatwallAdminTabComments object="#rc.cyclecountgroup#" />
		</hb:HibachiEntityDetailGroup>
		
	</hb:HibachiEntityDetailForm>
</cfoutput>



<hr>

<br>rc.cyclecountgroup
<!--- <cfdump var="#rc.cyclecountgroup#" top="1" expand="false"> --->
<!--- <cfdump var="#rc.cyclecountgroup.getCycleCountGroupsSkusCollection()#" top="1" expand="false"> --->
<!--- <cfdump var="#rc.cyclecountgroup.getCycleCountGroupsSkusCollection()#" top="1" expand="false"> --->

<!--- <cfabort> --->

<cfdump var="#arrayLen(rc.cyclecountgroup.getCycleCountGroupsSkusCollection().getPageRecords())# of #arrayLen(rc.cyclecountgroup.getCycleCountGroupsSkusCollection().getRecords())#" top="10">
<cfdump var="#rc.cyclecountgroup.getCycleCountGroupsSkusCollection().getPageRecords(formatRecords=false)#" top="10">
<!--- <cfscript>
	for(skuDetails in rc.cyclecountgroup.getCycleCountGroupsSkusCollection().getPageRecords(formatRecords=false)) {
		writeDump(var=skuDetails);
		sku = rc.$.slatwall.getEntity('Sku', skuDetails['skuID']);
		for(stock in sku.getStocks()) {
			if(stock.hasInventory()) {
				writeDump(var=stock,top=1);
				newcCycleCountBatchItem = rc.$.slatwall.newEntity('cycleCountBatchItem');
				newcCycleCountBatchItem.setStock(stock);
				writeDump(var=newcCycleCountBatchItem,top=1);
			}
		}
		abort;
	}

</cfscript> --->

<!--- <cfdump var="#arrayLen(rc.cyclecountgroup.getCycleCountGroupsSkusCollection().getRecords())#" top="10">
<cfdump var="#rc.cyclecountgroup.getCycleCountGroupsSkusCollection().getRecords(formatRecords=false)#" top="10"> --->


<!--- 
	<cfset cycleCountGroupSmartList = rc.$.Slatwall.getService('physicalService').getCycleCountGroupSmartList()>
	<cfdump var="#arrayLen(cycleCountGroupSmartList.getRecords())#" top="1">
	<cfdump var="#cycleCountGroupSmartList#" top="1" expand="false">
	<cfloop array="#cycleCountGroupSmartList.getRecords()#" index="CycleCountGroup">
		<cfdump var="#arrayLen(cyclecountgroup.getLocations())#" top="1">
		<cfdump var="#cyclecountgroup.getLocations()#" top="1">

		<cfset skuSmartList = rc.$.Slatwall.getService("SkuService").getSkuSmartList()>
		<cfdump var="#arrayLen(skuSmartList.getRecords())#" top="1">
		<cfdump var="#skuSmartList#" top="1">
		<cfdump var="#skuSmartList.getRecords()[1]#" top="1">

		<cfset stockSmartList = rc.$.Slatwall.getService("StockService").getStockSmartList()>
		<cfset stockSmartList.addFilter('location.locationID','402821e55c415e4b015c65bb038a0098')>
		<cfdump var="#arrayLen(stockSmartList.getRecords())#" top="1">
		<cfdump var="#stockSmartList#" top="1">
		<cfdump var="#stockSmartList.getRecords()[1]#" top="1">

	</cfloop> --->


	<!--- <br><cfdump var="#location.getLocationIDPath()#" top="1" expand="false"> --->
	<!--- <cfset sSL = rc.$.Slatwall.getService('stockService').getStockSmartList()>
	<cfset sSL.addFilter('calculatedQATS', '0')>
	<cfdump var="#arrayLen(sSL.getRecords())#" top="1"> --->
	<!--- <cfdump var="#sSL.getRecords()[1]#" top="1">
	<cfdump var="#sSL.getRecords()[1].getSku()#" top="1" expand="false"> 
	<cfdump var="#arrayLen(sSL.getRecords()[1].getSku().getStocks())#" top="1">
	<cfdump var="#arrayLen(sSL.getRecords()[1].getLocation().getStocks())#" top="1">
	<cfdump var="#sSL.getRecords()[1].getLocation()#" top="1"> --->
	<!--- <cfdump var="#arrayLen(sSL.getRecords()[1].getLocation().getSkus())#" top="1"> --->

	<!--- <cfloop array="#sSL.getRecords()#" index="stock">
		<cfset deleteStock = rc.$.Slatwall.getService('stockService').deleteStock(stock)>
	</cfloop>
	<cfset ORMFlush()> --->



	<!--- <cfabort>


	<cfloop array="#rc.cyclecountgroup.getLocations()#" index="location">
		<br><cfdump var="#location.getLocationIDPath()#" top="1" expand="false">
		<cfset sSL = rc.$.Slatwall.getService('stockService').getStockSmartList()>
		<!--- <cfset sSL.addRange('calculatedQATS', '1^')> --->
		<cfset sSL.addLikeFilter('location.locationIDPath', '#location.getLocationIDPath()#%')>
		<cfdump var="#arrayLen(sSL.getRecords())#" top="1">
		<cfdump var="#sSL#" top="1">
		<cfloop array="#sSL.getRecords()#" index="stock">
			<cfdump var="#stock.getLocation().getLocationName()#" top="1">
			<cfdump var="#stock#" top="1">
		</cfloop>
	</cfloop> --->


	<!--- <cfdump var="#rc.$.slatwallScope.getService('stockService')#" top="1"> --->



	<!--- 
	<br>arrayLen(rc.cyclecountgroup.getLocations())
	<cfdump var="#arrayLen(rc.cyclecountgroup.getLocations())#" top="1">
	<br>rc.cyclecountgroup.getLocations()
	<cfloop array="#rc.cyclecountgroup.getLocations()#" index="location">
		<br><cfdump var="#location.getLocationName()#" top="1" expand="false">
		<cfdump var="#location#" top="1" expand="false">
		<br>arrayLen(location.getStocks())
		<cfdump var="#arrayLen(location.getStocks())#" top="1">
		<cfloop array="#location.getStocks()#" index="stock">
			<br><cfdump var="#stock.getLocation().getLocationName()#" top="1" expand="false">
			<br><cfdump var="#stock.getSku().getSkuCode()#" top="1" expand="false">
			<cfdump var="#stock#" top="1" >
		</cfloop>
	</cfloop>







 --->