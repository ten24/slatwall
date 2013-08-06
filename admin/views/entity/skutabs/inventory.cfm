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
	<!--- NOTE: I had to add divs to the table headers so the bootstrap tooltips would work properly - [GG] --->
	<!---<table class="table table-striped table-bordered table-condensed">
		<tr>
			<th>Location</th>
			<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qoh.full')#">#$.slatwall.rbKey('define.qoh')#</div></th>
			<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qosh.full')#">#$.slatwall.rbKey('define.qosh')#</div></th>
			<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qndoo.full')#">#$.slatwall.rbKey('define.qndoo')#</div></th>
			<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qndorvo.full')#">#$.slatwall.rbKey('define.qndorvo')#</div></th>
			<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qndosa.full')#">#$.slatwall.rbKey('define.qndosa')#</div></th>
			<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qnroro.full')#">#$.slatwall.rbKey('define.qnroro')#</div></th>
			<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qnrovo.full')#">#$.slatwall.rbKey('define.qnrovo')#</div></th>
			<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qnrosa.full')#">#$.slatwall.rbKey('define.qnrosa')#</div></th>
			<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qc.full')#">#$.slatwall.rbKey('define.qc')#</div></th>
			<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qe.full')#">#$.slatwall.rbKey('define.qe')#</div></th>
			<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qnc.full')#">#$.slatwall.rbKey('define.qnc')#</div></th>
			<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qats.full')#">#$.slatwall.rbKey('define.qats')#</div></th>
			<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qiats.full')#">#$.slatwall.rbKey('define.qiats')#</div></th>
		</tr>
		<tr class="sku">
			<td><a href="##" class="table-action-expand depth0" data-depth="0"><i class="icon-plus"></i></a><strong>All Locations</strong></td>
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
			<cfloop array="#rc.locations#" index="loc">
				<cfset locationID = loc.getLocationID()/>
				<tr class="stock">
					<td>#loc.getLocationName()#</td>
					<td>#rc.sku.getQuantity('QOH', locationID)#</td>
					<td>#rc.sku.getQuantity('QOSH', locationID)#</td>
					<td>#rc.sku.getQuantity('QNDOO', locationID)#</td>
					<td>#rc.sku.getQuantity('QNDORVO', locationID)#</td>
					<td>#rc.sku.getQuantity('QNDOSA', locationID)#</td>
					<td>#rc.sku.getQuantity('QNRORO', locationID)#</td>
					<td>#rc.sku.getQuantity('QNROVO', locationID)#</td>
					<td>#rc.sku.getQuantity('QNROSA', locationID)#</td>
					<td>#rc.sku.getQuantity('QC', locationID)#</td>
					<td>#rc.sku.getQuantity('QE', locationID)#</td>
					<td>#rc.sku.getQuantity('QNC', locationID)#</td>
					<td>#rc.sku.getQuantity('QATS', locationID)#</td>
					<td>#rc.sku.getQuantity('QIATS', locationID)#</td>
				</tr>
			</cfloop>
		</cfif>
	</table>--->
	
	
	
	<div class="container" style="width: 100%;">
		<div class="row-fluid">
			
			
			
			<div class="accordion" id="accordiontotal">
					<div class="accordion-group">
						<div class="accordion-heading">
							<a class="accordion-toggle" href="##inventorytotal" data-toggle="collapse" data-parent="##accordiontotal">All Locations</a>
						</div>
						<div class="accordion-body collapse in" id="inventorytotal">
							<div class="accordion-inner">
			
								<table class="table table-striped table-bordered table-condensed">
									<tr>
										<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qoh.full')#">#$.slatwall.rbKey('define.qoh')#</div></th>
										<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qosh.full')#">#$.slatwall.rbKey('define.qosh')#</div></th>
										<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qndoo.full')#">#$.slatwall.rbKey('define.qndoo')#</div></th>
										<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qndorvo.full')#">#$.slatwall.rbKey('define.qndorvo')#</div></th>
										<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qndosa.full')#">#$.slatwall.rbKey('define.qndosa')#</div></th>
										<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qnroro.full')#">#$.slatwall.rbKey('define.qnroro')#</div></th>
										<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qnrovo.full')#">#$.slatwall.rbKey('define.qnrovo')#</div></th>
										<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qnrosa.full')#">#$.slatwall.rbKey('define.qnrosa')#</div></th>
										<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qc.full')#">#$.slatwall.rbKey('define.qc')#</div></th>
										<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qe.full')#">#$.slatwall.rbKey('define.qe')#</div></th>
										<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qnc.full')#">#$.slatwall.rbKey('define.qnc')#</div></th>
										<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qats.full')#">#$.slatwall.rbKey('define.qats')#</div></th>
										<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qiats.full')#">#$.slatwall.rbKey('define.qiats')#</div></th>
									</tr>
									<tr class="sku">
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
								</table>
			
			
			
			
			
			
			
			
			
			<cfif arrayLen(rc.locations) gt 1>
			<cfloop array="#rc.locations#" index="loc">
				<cfset locationID = loc.getLocationID()/>
			
				<div class="accordion" id="accordion#locationID#">
					<div class="accordion-group">
						<div class="accordion-heading">
							<a class="accordion-toggle" href="###locationid#" data-toggle="collapse" data-parent="##accordion#locationID#">#loc.getLocationName()#</a>
						</div>
						<div class="accordion-body collapse" id="#locationid#">
							<div class="accordion-inner">
							
								<table class="table table-striped table-bordered table-condensed">
									<tr>
										<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qoh.full')#">#$.slatwall.rbKey('define.qoh')#</div></th>
										<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qosh.full')#">#$.slatwall.rbKey('define.qosh')#</div></th>
										<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qndoo.full')#">#$.slatwall.rbKey('define.qndoo')#</div></th>
										<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qndorvo.full')#">#$.slatwall.rbKey('define.qndorvo')#</div></th>
										<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qndosa.full')#">#$.slatwall.rbKey('define.qndosa')#</div></th>
										<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qnroro.full')#">#$.slatwall.rbKey('define.qnroro')#</div></th>
										<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qnrovo.full')#">#$.slatwall.rbKey('define.qnrovo')#</div></th>
										<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qnrosa.full')#">#$.slatwall.rbKey('define.qnrosa')#</div></th>
										<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qc.full')#">#$.slatwall.rbKey('define.qc')#</div></th>
										<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qe.full')#">#$.slatwall.rbKey('define.qe')#</div></th>
										<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qnc.full')#">#$.slatwall.rbKey('define.qnc')#</div></th>
										<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qats.full')#">#$.slatwall.rbKey('define.qats')#</div></th>
										<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qiats.full')#">#$.slatwall.rbKey('define.qiats')#</div></th>
									</tr>
									<tr>
										<td>#rc.sku.getQuantity('QOH', locationID)#</td>
										<td>#rc.sku.getQuantity('QOSH', locationID)#</td>
										<td>#rc.sku.getQuantity('QNDOO', locationID)#</td>
										<td>#rc.sku.getQuantity('QNDORVO', locationID)#</td>
										<td>#rc.sku.getQuantity('QNDOSA', locationID)#</td>
										<td>#rc.sku.getQuantity('QNRORO', locationID)#</td>
										<td>#rc.sku.getQuantity('QNROVO', locationID)#</td>
										<td>#rc.sku.getQuantity('QNROSA', locationID)#</td>
										<td>#rc.sku.getQuantity('QC', locationID)#</td>
										<td>#rc.sku.getQuantity('QE', locationID)#</td>
										<td>#rc.sku.getQuantity('QNC', locationID)#</td>
										<td>#rc.sku.getQuantity('QATS', locationID)#</td>
										<td>#rc.sku.getQuantity('QIATS', locationID)#</td>
									</tr>
								</table>
							
							</div>
						</div>
					</div>
				</div>
			
			</cfloop>
			</cfif>
			
			
				</div>
						</div>
					</div>
				</div>
			
			
			
			
			
			
			
		</div>
	</div>
	
	
	
	
	
	
	
	<!---<table >
		<tr>
			<th>Location</th>
			<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qoh.full')#">#$.slatwall.rbKey('define.qoh')#</div></th>
			<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qosh.full')#">#$.slatwall.rbKey('define.qosh')#</div></th>
			<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qndoo.full')#">#$.slatwall.rbKey('define.qndoo')#</div></th>
			<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qndorvo.full')#">#$.slatwall.rbKey('define.qndorvo')#</div></th>
			<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qndosa.full')#">#$.slatwall.rbKey('define.qndosa')#</div></th>
			<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qnroro.full')#">#$.slatwall.rbKey('define.qnroro')#</div></th>
			<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qnrovo.full')#">#$.slatwall.rbKey('define.qnrovo')#</div></th>
			<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qnrosa.full')#">#$.slatwall.rbKey('define.qnrosa')#</div></th>
			<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qc.full')#">#$.slatwall.rbKey('define.qc')#</div></th>
			<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qe.full')#">#$.slatwall.rbKey('define.qe')#</div></th>
			<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qnc.full')#">#$.slatwall.rbKey('define.qnc')#</div></th>
			<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qats.full')#">#$.slatwall.rbKey('define.qats')#</div></th>
			<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qiats.full')#">#$.slatwall.rbKey('define.qiats')#</div></th>
		</tr>
		<tr class="sku">
			<td><a href="##" class="table-action-expand depth0" data-depth="0"><i class="icon-plus"></i></a><strong>All Locations</strong></td>
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
				<tr>
					<div class="accordion" id="accordion2">
			<cfloop array="#rc.locations#" index="loc">
				<cfset locationID = loc.getLocationID()/>
					<div class="accordion-group">
					    <div class="accordion-heading">
							<a class="accordion-toggle" data-toggle="collapse" data-parent="##accordion2" href="###locationID#">
					      		#loc.getLocationName()#
							</a>
						</div>
						<div id="#locationID#" class="accordion-body collapse in">
							<div class="accordion-inner">
								whatever
								<!---<table class="table table-striped table-bordered table-condensed">
									<tr>
										<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qoh.full')#">#$.slatwall.rbKey('define.qoh')#</div></th>
										<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qosh.full')#">#$.slatwall.rbKey('define.qosh')#</div></th>
										<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qndoo.full')#">#$.slatwall.rbKey('define.qndoo')#</div></th>
										<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qndorvo.full')#">#$.slatwall.rbKey('define.qndorvo')#</div></th>
										<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qndosa.full')#">#$.slatwall.rbKey('define.qndosa')#</div></th>
										<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qnroro.full')#">#$.slatwall.rbKey('define.qnroro')#</div></th>
										<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qnrovo.full')#">#$.slatwall.rbKey('define.qnrovo')#</div></th>
										<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qnrosa.full')#">#$.slatwall.rbKey('define.qnrosa')#</div></th>
										<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qc.full')#">#$.slatwall.rbKey('define.qc')#</div></th>
										<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qe.full')#">#$.slatwall.rbKey('define.qe')#</div></th>
										<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qnc.full')#">#$.slatwall.rbKey('define.qnc')#</div></th>
										<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qats.full')#">#$.slatwall.rbKey('define.qats')#</div></th>
										<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qiats.full')#">#$.slatwall.rbKey('define.qiats')#</div></th>
									</tr>
									<tr class="stock">
										<td>#rc.sku.getQuantity('QOH', locationID)#</td>
										<td>#rc.sku.getQuantity('QOSH', locationID)#</td>
										<td>#rc.sku.getQuantity('QNDOO', locationID)#</td>
										<td>#rc.sku.getQuantity('QNDORVO', locationID)#</td>
										<td>#rc.sku.getQuantity('QNDOSA', locationID)#</td>
										<td>#rc.sku.getQuantity('QNRORO', locationID)#</td>
										<td>#rc.sku.getQuantity('QNROVO', locationID)#</td>
										<td>#rc.sku.getQuantity('QNROSA', locationID)#</td>
										<td>#rc.sku.getQuantity('QC', locationID)#</td>
										<td>#rc.sku.getQuantity('QE', locationID)#</td>
										<td>#rc.sku.getQuantity('QNC', locationID)#</td>
										<td>#rc.sku.getQuantity('QATS', locationID)#</td>
										<td>#rc.sku.getQuantity('QIATS', locationID)#</td>
									</tr>
								</table>--->
							</div> <!-- /accordion-inner -->
						</div> <!-- accordion-body -->
						
						
					</div><!--accordion-group -->
					
			</cfloop>
			</div><!-- accordion2 -->
		</tr>
			
			
		</cfif>
	</table>
	
	--->
	
	
	
	
	
		
	
	
	
<!---	<ul style="list-style:none;">
		<li>
			<span class="collapsible"><i  class="icon-plus"></i> All Locations</span>
			<table class="table table-striped table-bordered table-condensed">
				<tr>
					<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qoh.full')#">#$.slatwall.rbKey('define.qoh')#</div></th>
					<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qosh.full')#">#$.slatwall.rbKey('define.qosh')#</div></th>
					<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qndoo.full')#">#$.slatwall.rbKey('define.qndoo')#</div></th>
					<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qndorvo.full')#">#$.slatwall.rbKey('define.qndorvo')#</div></th>
					<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qndosa.full')#">#$.slatwall.rbKey('define.qndosa')#</div></th>
					<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qnroro.full')#">#$.slatwall.rbKey('define.qnroro')#</div></th>
					<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qnrovo.full')#">#$.slatwall.rbKey('define.qnrovo')#</div></th>
					<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qnrosa.full')#">#$.slatwall.rbKey('define.qnrosa')#</div></th>
					<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qc.full')#">#$.slatwall.rbKey('define.qc')#</div></th>
					<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qe.full')#">#$.slatwall.rbKey('define.qe')#</div></th>
					<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qnc.full')#">#$.slatwall.rbKey('define.qnc')#</div></th>
					<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qats.full')#">#$.slatwall.rbKey('define.qats')#</div></th>
					<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qiats.full')#">#$.slatwall.rbKey('define.qiats')#</div></th>
				</tr>
				<tr class="sku">
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
			</table>
			
			<ul style="list-style:none;">
				
				<cfif arrayLen(rc.locations) gt 1>
					<cfloop array="#rc.locations#" index="loc">
						<cfset locationID = loc.getLocationID()/>
						<li>
							<span class="collapsible"><i  class="icon-plus"></i> #loc.getLocationName()#</span>
								<ul style="list-style:none;">
									<li><span class="collapsible">
										<table class="table table-striped table-bordered table-condensed">
											<tr>
												<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qoh.full')#">#$.slatwall.rbKey('define.qoh')#</div></th>
												<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qosh.full')#">#$.slatwall.rbKey('define.qosh')#</div></th>
												<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qndoo.full')#">#$.slatwall.rbKey('define.qndoo')#</div></th>
												<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qndorvo.full')#">#$.slatwall.rbKey('define.qndorvo')#</div></th>
												<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qndosa.full')#">#$.slatwall.rbKey('define.qndosa')#</div></th>
												<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qnroro.full')#">#$.slatwall.rbKey('define.qnroro')#</div></th>
												<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qnrovo.full')#">#$.slatwall.rbKey('define.qnrovo')#</div></th>
												<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qnrosa.full')#">#$.slatwall.rbKey('define.qnrosa')#</div></th>
												<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qc.full')#">#$.slatwall.rbKey('define.qc')#</div></th>
												<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qe.full')#">#$.slatwall.rbKey('define.qe')#</div></th>
												<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qnc.full')#">#$.slatwall.rbKey('define.qnc')#</div></th>
												<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qats.full')#">#$.slatwall.rbKey('define.qats')#</div></th>
												<th style="white-space:normal; vertical-align: text-bottom;"><div class="show-tooltip" data-toggle="tooltip" data-placement="top" title="#$.slatwall.rbKey('define.qiats.full')#">#$.slatwall.rbKey('define.qiats')#</div></th>
											</tr>
											<tr class="sku">
												<td>#rc.sku.getQuantity('QOH', locationID)#</td>
												<td>#rc.sku.getQuantity('QOSH', locationID)#</td>
												<td>#rc.sku.getQuantity('QNDOO', locationID)#</td>
												<td>#rc.sku.getQuantity('QNDORVO', locationID)#</td>
												<td>#rc.sku.getQuantity('QNDOSA', locationID)#</td>
												<td>#rc.sku.getQuantity('QNRORO', locationID)#</td>
												<td>#rc.sku.getQuantity('QNROVO', locationID)#</td>
												<td>#rc.sku.getQuantity('QNROSA', locationID)#</td>
												<td>#rc.sku.getQuantity('QC', locationID)#</td>
												<td>#rc.sku.getQuantity('QE', locationID)#</td>
												<td>#rc.sku.getQuantity('QNC', locationID)#</td>
												<td>#rc.sku.getQuantity('QATS', locationID)#</td>
												<td>#rc.sku.getQuantity('QIATS', locationID)#</td>
											</tr>
										</table>
									</span></li>
								</ul>
						</span></li>
					</cfloop>
				</cfif>
			</ul>
		</li>
	</ul>--->
	
	
	

	
	
	
</cfoutput>
