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
<cfparam name="inventoryAnalysis" type="any" />

<cfoutput>
	<div id="container" style="width: 100%; font-family: arial; font-size: 12px;background:##fff;">
		
		<div id="top" style="width: 100%; margin: 0; padding: 0;">
			<h1 style="font-size: 20px;">Inventory Analysis Report</h1>
		</div>			
	
		<br style="clear:both;" />
		
		<div id="orderItems" style="margin-top: 15px; float: left; clear: both; width: 100%;">
			<table id="styles" style="border-spacing: 0px; border-collapse: collapse; border: 1px solid ##d8d8d8; text-align: left; font-size: 12px; ">
				<thead>
					<tr>
						<th style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 0px 5px;">Product Type</th>
						<th style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 0px 5px;">Sku Code</th>
						<th style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 0px 5px;">Description</th>
						<th style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 0px 5px;">Definition</th>
						<th style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 0px 5px;">Net Sales Last 12 Months</th>
						<th style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 0px 5px;">Committed <br>QC</th>
						<th style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 0px 5px;">Expected <br>QE</th>
						<th style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 0px 5px;">On Hand <br>QOH</th>
						<th style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 0px 5px;">Estimated Months Remaining</th>
						<th style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 0px 5px;">Total On Hand <br>QOH+QC</th>
						<th style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 0px 5px;">Estimated Days Out</th>
					</tr>
				</thead>

				<tbody>

					<cfloop query="#inventoryAnalysis.getReportData(inventoryAnalysis.getSkuCollection().getRecords()).query#">
						<tr>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">#ProductType#</td>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">#SkuCode#</td>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">#Description#</td>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">#Definition#</td>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">#NetSalesLast12Months#</td>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">#CommittedQC#</td>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">#ExpectedQE#</td>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">#OnHandQOH#</td>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">
								<cfif EstimatedMonthsRemaining neq 0>
									#numberFormat(EstimatedMonthsRemaining,'9.99')#	
								<cfelse>
									-
								</cfif>
							</td>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">#TotalOnHandQOHplusQC#</td>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">#EstimatedDaysOut#</td>
						</tr>
					</cfloop>
				</tbody>
			</table>
		</div>
	</div>
</cfoutput>
<cfabort>
