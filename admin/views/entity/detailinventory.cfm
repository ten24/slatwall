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


<cfparam name="rc.product" type="any">
<cfparam name="rc.locations" type="array">

<cfoutput>
	<div class="svoinventorydetailproduct">
		<table class="listing-grid stripe">
			<tr>
				<th colspan="3">Product Name / Sku / Location</th>
				<th style="white-space:normal; vertical-align: text-bottom;">#$.slatwall.rbKey('define.qoh.full')#</th>
				<th style="white-space:normal; vertical-align: text-bottom;">#$.slatwall.rbKey('define.qosh.full')#</th>
				<th style="white-space:normal; vertical-align: text-bottom;">#$.slatwall.rbKey('define.qndoo.full')#</th>
				<th style="white-space:normal; vertical-align: text-bottom;">#$.slatwall.rbKey('define.qndorvo.full')#</th>
				<th style="white-space:normal; vertical-align: text-bottom;">#$.slatwall.rbKey('define.qndosa.full')#</th>
				<th style="white-space:normal; vertical-align: text-bottom;">#$.slatwall.rbKey('define.qnroro.full')#</th>
				<th style="white-space:normal; vertical-align: text-bottom;">#$.slatwall.rbKey('define.qnrovo.full')#</th>
				<th style="white-space:normal; vertical-align: text-bottom;">#$.slatwall.rbKey('define.qnrosa.full')#</th>
				<th style="white-space:normal; vertical-align: text-bottom;">#$.slatwall.rbKey('define.qc.full')#</th>
				<th style="white-space:normal; vertical-align: text-bottom;">#$.slatwall.rbKey('define.qe.full')#</th>
				<th style="white-space:normal; vertical-align: text-bottom;">#$.slatwall.rbKey('define.qnc.full')#</th>
				<th style="white-space:normal; vertical-align: text-bottom;">#$.slatwall.rbKey('define.qats.full')#</th>
				<th style="white-space:normal; vertical-align: text-bottom;">#$.slatwall.rbKey('define.qiats.full')#</th>
			</tr>
			<cfloop array="#rc.product.getSkus()#" index="local.sku">
				<tr class="sku">
					<td style="text-align:left;">#local.sku.getSkuCode()#</td>
					<cfif arrayLen(rc.locations) gt 1>
						<td style="text-align:left;">#local.sku.displayOptions()#</td>
						<td>All Locations</td>
					<cfelse>
						<td style="text-align:left;" colspan="2">#local.sku.displayOptions()#</td>
					</cfif>
					<td>#local.sku.getQuantity('QOH')#</td>
					<td>#local.sku.getQuantity('QOSH')#</td>
					<td>#local.sku.getQuantity('QNDOO')#</td>
					<td>#local.sku.getQuantity('QNDORVO')#</td>
					<td>#local.sku.getQuantity('QNDOSA')#</td>
					<td>#local.sku.getQuantity('QNRORO')#</td>
					<td>#local.sku.getQuantity('QNROVO')#</td>
					<td>#local.sku.getQuantity('QNROSA')#</td>
					<td>#local.sku.getQuantity('QC')#</td>
					<td>#local.sku.getQuantity('QE')#</td>
					<td>#local.sku.getQuantity('QNC')#</td>
					<td>#local.sku.getQuantity('QATS')#</td>
					<td>#local.sku.getQuantity('QIATS')#</td>
				</tr>
				<cfif arrayLen(rc.locations) gt 1>
					<cfloop array="#rc.locations#" index="local.location">
						<tr class="stock">
							<td class="varWidth" colspan="2">&nbsp;</td>
							<td>#local.location.getLocationName()#</td>
							<td>#local.sku.getQuantity('QOH', local.location.getLocationID())#</td>
							<td>#local.sku.getQuantity('QOSH', local.location.getLocationID())#</td>
							<td>#local.sku.getQuantity('QNDOO', local.location.getLocationID())#</td>
							<td>#local.sku.getQuantity('QNDORVO', local.location.getLocationID())#</td>
							<td>#local.sku.getQuantity('QNDOSA', local.location.getLocationID())#</td>
							<td>#local.sku.getQuantity('QNRORO', local.location.getLocationID())#</td>
							<td>#local.sku.getQuantity('QNROVO', local.location.getLocationID())#</td>
							<td>#local.sku.getQuantity('QNROSA', local.location.getLocationID())#</td>
							<td>#local.sku.getQuantity('QC', local.location.getLocationID())#</td>
							<td>#local.sku.getQuantity('QE', local.location.getLocationID())#</td>
							<td>#local.sku.getQuantity('QNC', local.location.getLocationID())#</td>
							<td>#local.sku.getQuantity('QATS', local.location.getLocationID())#</td>
							<td>#local.sku.getQuantity('QIATS', local.location.getLocationID())#</td>
						</tr>
					</cfloop>
				</cfif>
			</cfloop>
			<tr class="product">
				<td colspan="3">TOTAL</td>
				<td>#rc.product.getQuantity('QOH')#</td>
				<td>#rc.product.getQuantity('QOSH')#</td>
				<td>#rc.product.getQuantity('QNDOO')#</td>
				<td>#rc.product.getQuantity('QNDORVO')#</td>
				<td>#rc.product.getQuantity('QNDOSA')#</td>
				<td>#rc.product.getQuantity('QNRORO')#</td>
				<td>#rc.product.getQuantity('QNROVO')#</td>
				<td>#rc.product.getQuantity('QNROSA')#</td>
				<td>#rc.product.getQuantity('QC')#</td>
				<td>#rc.product.getQuantity('QE')#</td>
				<td>#rc.product.getQuantity('QNC')#</td>
				<td>#rc.product.getQuantity('QATS')#</td>
				<td>#rc.product.getQuantity('QIATS')#</td>
			</tr>
		</table>
	</div>
</cfoutput>

















