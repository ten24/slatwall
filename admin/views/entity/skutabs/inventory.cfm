<!---

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) 2011 ten24, LLC

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
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

--->
<cfparam name="rc.sku" type="any" />

<cfparam name="rc.product" type="any">

<cfset rc.locations = $.slatwall.getService("locationService").listLocation() />

<cfoutput>
	<table class="table table-striped table-bordered table-condensed">
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