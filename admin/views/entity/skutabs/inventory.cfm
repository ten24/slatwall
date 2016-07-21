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
<cfparam name="rc.sku" type="any" />
<cfparam name="rc.product" type="any">

<cfoutput>
	<table id="inventory-table" class="table table-bordered table-hover">
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
			<td><a href="##" class="update-inventory-plus depth0" data-depth="0" data-locationid="" data-locationidpath="path" data-skuid="#rc.sku.getskuID()#"><i class="glyphicon glyphicon-plus"></i></a> <strong>All Locations</strong></td>
			<td>#rc.sku.getQuantity('QOH')#</td>
			<td>#rc.sku.getQuantity('QOSH')#</td>
			<td><a href="#$.slatwall.buildURL(action='entity.listorderitem', querystring='F:sku.skuid=#rc.sku.getskuID()#&F:order.orderStatusType.systemCode=ostNew,ostOnHold,ostProcessing&F:orderItemType.systemCode=oitSale')#">#rc.sku.getQuantity('QNDOO')#</a></td>
			<td>#rc.sku.getQuantity('QNDORVO')#</td>
			<td>#rc.sku.getQuantity('QNDOSA')#</td>
			<td><a href="#$.slatwall.buildURL(action='entity.listorderitem', querystring='F:sku.skuid=#rc.sku.getskuID()#&F:order.orderStatusType.systemCode=ostNew,ostOnHold,ostProcessing&F:orderItemType.systemCode=oitReturn')#">#rc.sku.getQuantity('QNRORO')#</a></td>
			<td><a href="#$.slatwall.buildURL(action='entity.listvendororderitem', querystring='F:stock.sku.skuid=#rc.sku.getskuID()#&F:vendorOrder.vendorOrderStatusType.systemCode=vostNew,vostPartiallyReceived&F:vendorOrderItemType.systemCode=voitPurchase')#">#rc.sku.getQuantity('QNROVO')#</a></td>
			<td><a href="#$.slatwall.buildURL(action='entity.liststockadjustmentitem', querystring='F:stockadjustment.stockadjustmentstatustype.systemCode=sastNew&F:toStock.sku.skuID=#rc.sku.getskuID()#')#">#rc.sku.getQuantity('QNROSA')#</a></td>
			<td>#rc.sku.getQuantity('QC')#</td>
			<td>#rc.sku.getQuantity('QE')#</td>
			<td>#rc.sku.getQuantity('QNC')#</td>
			<td>#rc.sku.getQuantity('QATS')#</td>
			<td>#rc.sku.getQuantity('QIATS')#</td>
		</tr>
	</table>


</cfoutput>
