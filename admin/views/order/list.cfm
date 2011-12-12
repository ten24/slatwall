<!---

    Slatwall - An e-commerce plugin for Mura CMS
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
<cfparam name="rc.$" type="any" />
<cfparam name="rc.orderSmartList" type="any" />
<cfparam name="rc.orderStatusOptions" type="array" />
<cfparam name="rc.isSearch" default=0 />
<cfparam name="rc.showAdvancedSearch" default=false />

<cfoutput>

<div class="svoadminorderlist">
	<form action="#buildURL('admin:order.list')#" method="post">
		<input type="hidden" name="isSearch" value="1" />
		<input name="Keyword" value="#rc.Keyword#" /> 
		<div id="advancedSearchOptions" <cfif !rc.showAdvancedSearch>style="display:none;"</cfif>>
			#$.Slatwall.rbKey("entity.order.orderOpenDateTime")#: 
			<input type="date" value="#rc.orderDateStart#" name="orderDateStart" class="datepicker" /> to <input type="date" value="#rc.orderDateEnd#" name="orderDateEnd" class="datepicker" /> 
			<cfif len(rc.orderDateStart) gt 0 or len(rc.orderDateEnd) gt 0>
				<a href="##" id="clearDates">#$.slatwall.rbKey('admin.search.cleardates')#</a><br>
			</cfif>
			<div id="statusSelections">
			#$.Slatwall.rbKey("entity.order.orderStatusType")#:
			<cfloop array="#rc.orderStatusOptions#" index="thisStatus" >
				<input type="checkbox" name="statusCode" id="#thisStatus['id']#" class="statusOption" value="#thisStatus['id']#"<cfif listFindNoCase(rc.statusCode,thisStatus['id'])> checked="checked"</cfif> /> <label for="#thisStatus['id']#">#thisStatus['name']#</label>
			</cfloop>
			<a href="##" id="selectAllStatuses">#$.slatwall.rbKey('define.selectall')#</a>
			</div>
		</div>
		<button type="submit">#rc.$.Slatwall.rbKey("admin.order.search")#</button>&nbsp;&nbsp;
		<a href="##" id="showAdvancedSearch"<cfif rc.showAdvancedSearch> style="display:none;"</cfif>>#$.slatwall.rbKey("admin.order.list.showAdvancedSearch")#</a>
	</form>
	
	<cfif rc.isSearch>
		<h4>#rc.orderSmartList.getRecordsCount()# #$.slatwall.rbKey("admin.order.list.searchresultsfound")#</h4>
	</cfif>
	
	<table id="OrderList" class="listing-grid stripe">
		<tr>
			<th>#rc.$.Slatwall.rbKey("entity.order.orderNumber")#</th>
			<th>#rc.$.Slatwall.rbKey("entity.order.orderOpenDateTime")#</th>
			<th class="varWidth">#rc.$.Slatwall.rbKey("entity.account.fullName")#</th>
			<th>#rc.$.Slatwall.rbKey("entity.order.orderStatusType")#</th>
			<th>#rc.$.Slatwall.rbKey("entity.order.total")#</th>
			<th>&nbsp</th>
		</tr>
		<cfloop array="#rc.orderSmartList.getPageRecords()#" index="local.order">
			<tr>
				<td>#Local.Order.getOrderNumber()#</td>
				<td>#DateFormat(Local.Order.getOrderOpenDateTime(), "medium")#</td>
				<td class="varWidth">
					#Local.Order.getAccount().getFullName()# <cfif local.order.getAccount().isGuestAccount()>(#$.slatwall.rbKey('admin.order.account.isguestaccount')#)</cfif>
				</td>
				<td>#Local.Order.getOrderStatusType().getType()#</td>
				<td>#local.order.getFormattedValue('total', 'currency')#</td>
				<td class="administration">
					<ul class="one">
					  <cf_SlatwallActionCaller action="admin:order.detail" querystring="orderID=#local.order.getOrderID()#" class="detail" type="list">
					</ul>     						
				</td>
			</tr>
		</cfloop>
	</table>
	<cf_SlatwallSmartListPager smartList="#rc.orderSmartList#">
	<cfif rc.isSearch>
		<cfset local.exportText = $.slatwall.rbKey("admin.order.list.exportSearchResults") />
	<cfelse>
		<cfset local.exportText = $.slatwall.rbKey("admin.order.list.exportDisplayedOrders") />
	</cfif>
	<form name="slatwallOrderExport" action="#buildURL(action='admin:order.exportorders')#" method="post">
		<input type="hidden" name="keyword" value="#rc.keyword#" />
		<input type="hidden" name="orderDateStart" value="#rc.orderDateStart#" />
		<input type="hidden" name="orderDateEnd" value="#rc.orderDateEnd#" />
		<input type="hidden" name="statusCode" value="#rc.statusCode#" />
		<input type="hidden" name="orderBy" value="#rc.orderBy#" />
		<cf_SlatwallActionCaller action="admin:order.exportorders" type="submit" class="button" text="#local.exportText#" />
	</form>
</div>
</cfoutput>
