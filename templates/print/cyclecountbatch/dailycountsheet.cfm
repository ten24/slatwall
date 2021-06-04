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
																			
	This is a print template designed to be used to customize the print job	
	that slatwall does.  If you would like to customize this template, it	
	should first be coppied into the /custom/templates/ directory in the	
	same folder path naming convention that it currently resides inside.	
																			
	All print templates have 2 objects that are passed in (seen below):		
																			
	print: This is the actually print entity that will have print settings	
	that will eventually be persisted to the database as a log of this		
	print job as long as the "Log Print" setting is set to true.			
																			
	printData: This is a structure used to set values that will get			
	populated into the print entity once this processing is complete.		
																			
	It will also be used as a final stringReplace() struct for any ${} keys	
	that have not already been relpaced.									
																			
	Lastly, the base object that is being used for this print should also	
	be injected into the template and paramed at the top.					
																			
--->
<cfparam name="print" type="any" />	
<cfparam name="printData" type="struct" default="#structNew()#" />
<cfparam name="cycleCountBatch" type="any" />

<cfset isNull(printData.countDay) ? printData['countDay'] = cycleCountBatch.getNextDayNumber() - cycleCountBatch.getPhysicalsCount() : '' />
<cfset cycleCountBatchItems = cycleCountBatch.getItemsToCountByDay(printData['countDay'],false) />

<cfoutput>
	<div id="container" style="width: 625px; font-family: arial; font-size: 12px;background:##fff;">
		<div id="top" style="width: 625px; margin: 0; padding: 0;">
			<h1 style="font-size: 24px; text-align: center;">Daily Cycle Count Sheet</h1>
		</div>

		<table id="styles" style="border-spacing: 0px; border-collapse: collapse; border: 0px; text-align: left; font-size: 18px; width:625px;">
			<thead>
				<tr>
					<th style="background: ##f9f9f9; border: 0px solid; padding: 10px 60px; width: 180px;">Counter</th>
					<th style="background: ##f9f9f9; border: 0px solid; padding: 10px 60px; width: 180px;">Location</th>
					<th style="background: ##f9f9f9; border: 0px solid; padding: 10px 60px; width: 180px;">Count Date</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td style="border-bottom: 1px solid ##d8d8d8; padding: 20px 60px;"> </td>
					<td style="border-bottom: 1px solid ##d8d8d8; padding: 20px 60px;">#cycleCountBatch.getLocation().getLocationName()# </td>
					<td style="border-bottom: 1px solid ##d8d8d8; padding: 20px 60px;"> </td>
				</tr>
			</tbody>
		</table>
		<hr style="margin: 20px 0px;">
		<table id="styles" style="border-spacing: 0px; border-collapse: collapse; border: 1px solid ##d8d8d8; text-align: left; font-size: 12px; width:625px;">
			<thead>
				<tr>
					<th style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 10px 20px;">Sku Code</th>
					<th style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 10px 20px;">Description</th>
					<th style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 10px 20px;">Shelf Number</th>
					<th style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 10px 20px;">Alt Shelf</th>
					<th style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 10px 20px;">Expected QOH</th>
					<th style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 10px 20px;">Actual QOH</th>
				</tr>
			</thead>
			<tbody>
				<cfloop array="#cycleCountBatchItems#" index="local.item">
					<cfset local.stock = getService('stockService').getStockBySkuIDAndLocationID(item.skuID,cycleCountBatch.getLocation().getLocationID()) />
					<tr>
						<td style="border: 1px solid ##d8d8d8; padding: 10px 20px;">#local.item.skuCode#</td>
						<td style="border: 1px solid ##d8d8d8; padding: 10px 20px;">
							#!isNull(local.item.skuName) ? local.item.skuName : local.stock.getSku().getProduct().getTitle()#
						</td>
						<td style="border: 1px solid ##d8d8d8; padding: 10px 20px;">#local.stock.getShelfNumber()#</td>
						<td style="border: 1px solid ##d8d8d8; padding: 10px 20px;">
							<cfset local.skuAltShelfList = '' />
                            <cfif !isNull(local.stock.getAltShelf2()) && len(trim(local.stock.getAltShelf2())) && local.stock.getAltShelf2() NEQ 0>
                                <cfset local.skuAltShelfList = listAppend(local.skuAltShelfList,local.stock.getAltShelf2(),'/') />
                            </cfif>
                            <cfif !isNull(local.stock.getAltShelf3()) && len(trim(local.stock.getAltShelf3())) && local.stock.getAltShelf3() NEQ 0>
                                <cfset local.skuAltShelfList = listAppend(local.skuAltShelfList,local.stock.getAltShelf3(),'/') />
                            </cfif>
                            <cfif !isNull(local.stock.getAltShelf4()) && len(trim(local.stock.getAltShelf4())) && local.stock.getAltShelf4() NEQ 0>
                                <cfset local.skuAltShelfList = listAppend(local.skuAltShelfList,local.stock.getAltShelf4(),'/') />
                            </cfif>
                            #local.skuAltShelfList#
						</td>
						<td style="border: 1px solid ##d8d8d8; padding: 10px 20px;">#local.stock.getQOH()#</td>
						<td style="border: 1px solid ##d8d8d8; padding: 10px 20px;"></td> 
					</tr>
				</cfloop>
			</tbody>
		</table>
	</div>
</cfoutput>
