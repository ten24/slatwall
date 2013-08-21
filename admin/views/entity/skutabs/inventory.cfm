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
<cfparam name="rc.sku" type="any" />

<cfparam name="rc.product" type="any">

<cfset rc.locations = $.slatwall.getService("locationService").listLocation() />

<cfoutput>
	<table class="table table-striped table-bordered table-condensed">
		<tr>
			<th>Location</th>
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
		<tr class="sku">
			<td><strong>All Locations</strong></td>
			<td>#rc.sku.getQuantity('QOH')#</td>
			<td>#rc.sku.getQuantity('QOSH')#</td>
			<td>#rc.sku.getQuantity('QNDOO')#</td>
			<td>#rc.sku.getQuantity('QNDORVO')#</td>
			<td>#rc.sku.getQuantity('QNDOSA')#</td>
			<td>#rc.sku.getQuantity('QNRORO')#</td>
			<td>#rc.sku.getQuantity('QNROVO')#</td>
			<td>#rc.sku.getQuantity('QNROSA')#</td>
			<td>#rc.sku.getQuantity('QC')#</td>
			<td>#rc.sku.getQuantity('QE')#</td>
			<td>#rc.sku.getQuantity('QNC')#</td>
			<td>#rc.sku.getQuantity('QATS')#</td>
			<td>#rc.sku.getQuantity('QIATS')#</td>
		</tr>
		<cfif arrayLen(rc.locations) gt 1>
			<cfloop array="#rc.locations#" index="local.location">
				<tr class="stock">
					<td>#local.location.getLocationName()#</td>
					<td>#rc.sku.getQuantity('QOH', local.location.getLocationID())#</td>
					<td>#rc.sku.getQuantity('QOSH', local.location.getLocationID())#</td>
					<td>#rc.sku.getQuantity('QNDOO', local.location.getLocationID())#</td>
					<td>#rc.sku.getQuantity('QNDORVO', local.location.getLocationID())#</td>
					<td>#rc.sku.getQuantity('QNDOSA', local.location.getLocationID())#</td>
					<td>#rc.sku.getQuantity('QNRORO', local.location.getLocationID())#</td>
					<td>#rc.sku.getQuantity('QNROVO', local.location.getLocationID())#</td>
					<td>#rc.sku.getQuantity('QNROSA', local.location.getLocationID())#</td>
					<td>#rc.sku.getQuantity('QC', local.location.getLocationID())#</td>
					<td>#rc.sku.getQuantity('QE', local.location.getLocationID())#</td>
					<td>#rc.sku.getQuantity('QNC', local.location.getLocationID())#</td>
					<td>#rc.sku.getQuantity('QATS', local.location.getLocationID())#</td>
					<td>#rc.sku.getQuantity('QIATS', local.location.getLocationID())#</td>
				</tr>
			</cfloop>
		</cfif>
	</table>
</cfoutput>
