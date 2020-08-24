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
<cfoutput>
	
	<div class="row s-body-nav" style="margin-bottom: 30px;">
	    <nav class="navbar navbar-default" role="navigation">
	      	<div class="col-md-4 s-header-info">
				<h1 class="actionbar-title">#$.slatwall.rbKey('admin.report')#</h1>
			</div>

			<div class="col-md-8">

			</div>
		</nav>
	</div>

	<div class="row">
		<div class="col-md-12">
			
			<!--- SITES --->
		<!---NULL SITE--->
		<!--- DASHBOARD_WIDGETS --->
			<!---this block deals with sales this week--->
	<cfset weekMinDateTime="#CreateDateTime(Year(now()),Month(now()),Day(DateAdd('d', -7, now())),0,0,0)#" />
    <cfset weekMaxDateTime="#CreateDateTime(Year(now()),Month(now()),Day(now()),23,59,59)#" />
	<cfset salesRevenueWeekCollectionList = getHibachiScope().getService('orderService').getOrderCollectionList() />
	<cfset salesRevenueWeekCollectionList.setDisplayProperties('') />
	<cfset salesRevenueWeekCollectionList.addDisplayAggregate('calculatedTotal','SUM','totalOrders') />
	<cfset salesRevenueWeekCollectionList.addFilter('orderCreatedSite.siteID', 'NULL','IS')/>
	<cfset salesRevenueWeekCollectionList.addFilter('createdDateTime', weekMinDateTime,'>=')/>
	<cfset salesRevenueWeekCollectionList.addFilter('createdDateTime', weekMaxDateTime,'<=')/>
	<cfset salesRevenueWeekCollectionList.addFilter('orderStatusType.systemCode','ostNotPlaced','!=') />
	<cfif salesRevenueWeekCollectionList.getRecords()[1]['totalOrders'] EQ " ">
	<cfset salesWeekRevenue="$0" />
	<cfelse>
	<cfset salesWeekRevenue = "#$.slatwall.formatValue(salesRevenueWeekCollectionList.getRecords()[1]['totalOrders'], 'currency')#" />
	</cfif>
	
	<!---this block deals with sales this week--->
	
	<!---this block deals with sales current day--->
	<cfset currentDayMinDateTime="#CreateDateTime(Year(now()),Month(now()),Day(now()),0,0,0)#" />
	<cfset currentDayMaxDateTime="#CreateDateTime(Year(now()),Month(now()),Day(now()),23,59,59)#" />
	<cfset salesRevenueDayCollectionList = getHibachiScope().getService('orderService').getOrderCollectionList() />
	<cfset salesRevenueDayCollectionList.setDisplayProperties('') />
	<cfset salesRevenueDayCollectionList.addDisplayAggregate('calculatedTotal','SUM','dayTotalOrders') />
	<cfset salesRevenueDayCollectionList.addFilter('orderCreatedSite.siteID', 'NULL','IS')/>
	<cfset salesRevenueDayCollectionList.addFilter('createdDateTime', currentDayMinDateTime,'>=')/>
	<cfset salesRevenueDayCollectionList.addFilter('createdDateTime', currentDayMaxDateTime,'<=')/>
	<cfset salesRevenueDayCollectionList.addFilter('orderStatusType.systemCode','ostNotPlaced','!=') />
	<cfif salesRevenueDayCollectionList.getRecords()[1]['dayTotalOrders'] EQ " ">
	<cfset salesDayRevenue="$0" />
	<cfelse>
	<cfset salesDayRevenue = "#$.slatwall.formatValue(salesRevenueDayCollectionList.getRecords()[1]['dayTotalOrders'], 'currency')#" />
	</cfif>
	<!---this block deals with sales current day--->
	
	<!---this block deals with shopping cart session--->
	<cfset shoppingCartSessionCollectionList = getHibachiScope().getService('orderService').getOrderCollectionList() />
	<cfset shoppingCartSessionCollectionList.setDisplayProperties('') />
	<cfset shoppingCartSessionCollectionList.addDisplayAggregate('orderID','COUNT','totalCartSessions') />
	<cfset shoppingCartSessionCollectionList.addFilter('orderCreatedSite.siteID', 'NULL','IS')/>
	<cfset shoppingCartSessionCollectionList.addFilter('createdDateTime', currentDayMinDateTime,'>=')/>
	<cfset shoppingCartSessionCollectionList.addFilter('createdDateTime', currentDayMaxDateTime,'<=')/>
	<cfset shoppingCartSessionCollectionList.addFilter('orderStatusType.systemCode','ostNotPlaced','=') />
	<cfif shoppingCartSessionCollectionList.getRecords()[1]['totalCartSessions'] EQ " ">
	<cfset shoppingCartDay="0" />
	<cfelse>
	<cfset shoppingCartDay = "#shoppingCartSessionCollectionList.getRecords()[1]['totalCartSessions']#" />
	</cfif>
	<!---this block deals with shopping cart session--->
	
	
	<!---this block deals with average order current day--->
	<cfset averageDayOrdersCollectionList = getHibachiScope().getService('orderService').getOrderCollectionList() />
	<cfset averageDayOrdersCollectionList.setDisplayProperties('') />
	<cfset averageDayOrdersCollectionList.addDisplayAggregate('calculatedTotal','AVG','dayAvergeOrders') />
	<cfset averageDayOrdersCollectionList.addFilter('orderCreatedSite.siteID', 'NULL','IS')/>
	<cfset averageDayOrdersCollectionList.addFilter('createdDateTime', currentDayMinDateTime,'>=')/>
	<cfset averageDayOrdersCollectionList.addFilter('createdDateTime', currentDayMaxDateTime,'<=')/>
	<cfset averageDayOrdersCollectionList.addFilter('orderStatusType.systemCode','ostNotPlaced','!=') />
	<cfif averageDayOrdersCollectionList.getRecords()[1]['dayAvergeOrders'] EQ " ">
	<cfset averageSalesDayRevenue="$0" />
	<cfelse>
	<cfset averageSalesDayRevenue = "#$.slatwall.formatValue(averageDayOrdersCollectionList.getRecords()[1]['dayAvergeOrders'], 'currency')#" />
	</cfif>
	
	<!---this block deals with average order current day--->

    <div class="Mcard-wrapper col-md-12">
		                <div class="col-md-3">
		                    <div class="Mcard">
		                        <div class="Mcard-body ">
		                           <div><h1> #salesWeekRevenue# </h1></div>
		                           <div><img src="/assets/images/piggy-bank-1.png" alt="Piggy Bank"></div>
		                        </div>
		                        <div class="Mcard-footer Mcard-footer1">
		                            <div><p>Sales This Week </p></div> <div><img src="/assets/images/arrow.png" alt="arrow"></div>
		                        </div>
		                    </div>
		                </div>

 		                <div class="col-md-3">
		                    <div class="Mcard">
		                        <div class="Mcard-body ">
		                           <div><h1> #salesDayRevenue# </h1></div>
		                           <div><img src="/assets/images/shopping-bag-gray.png" alt="Shopping Bags"></div>
		                        </div>
		                        <div class="Mcard-footer Mcard-footer2">
		                            <div><p>Orders Today</p></div> <div><img src="/assets/images/arrow.png" alt="arrow"></div>
		                        </div>
		                    </div>
		                </div>

 		                <div class="col-md-3">
		                    <div class="Mcard">
		                        <div class="Mcard-body ">
		                           <div><h1> #shoppingCartDay# </h1></div>
		                           <div><img src="/assets/images/user-2.png" alt="User Icon"></div>
		                        </div>
		                        <div class="Mcard-footer Mcard-footer3">
		                            <div><p>Shopping Cart Today</p></div> <div><img src="/assets/images/arrow.png" alt="arrow"></div>
		                        </div>
		                    </div>
		                </div>
		                <div class="col-md-3">
		                    <div class="Mcard">
		                        <div class="Mcard-body ">
		                           <div><h1> #averageSalesDayRevenue# </h1></div>
		                           <div><img src="/assets/images/dollar-symbol-gray.png" alt="User Icon"></div>
		                        </div>
		                        <div class="Mcard-footer Mcard-footer4">
		                            <div><p>Average Orders Today</p></div> <div><img src="/assets/images/arrow.png" alt="arrow"></div>
		                        </div>
		                    </div>
		                </div>
		    		</div>
			
			
			<!--- DASHBOARD_WIDGETS --->
		<!---NULL SITE--->
		<!---Non-NULL SITE--->
		<cfset siteCollectionList = getHibachiScope().getService('siteService').getSiteCollectionList() />
	<cfset siteCollectionList.setDisplayProperties('siteID,siteName', { isVisible=true }) />
	<cfloop array="#siteCollectionList.getRecords()#" index="siteRecord" >
        
        <cfset siteName = siteRecord['siteName'] />
        <cfset siteID = siteRecord['siteID'] />
    	
    	
	<!--- DASHBOARD_WIDGETS --->
			<!---this block deals with sales this week--->
	<cfset weekMinDateTime="#CreateDateTime(Year(now()),Month(now()),Day(DateAdd('d', -7, now())),0,0,0)#" />
    <cfset weekMaxDateTime="#CreateDateTime(Year(now()),Month(now()),Day(now()),23,59,59)#" />
	<cfset salesRevenueWeekCollectionList = getHibachiScope().getService('orderService').getOrderCollectionList() />
	<cfset salesRevenueWeekCollectionList.setDisplayProperties('') />
	<cfset salesRevenueWeekCollectionList.addDisplayAggregate('calculatedTotal','SUM','totalOrders') />
	<cfset salesRevenueWeekCollectionList.addFilter('orderCreatedSite.siteID', siteID,'=')/>
	<cfset salesRevenueWeekCollectionList.addFilter('createdDateTime', weekMinDateTime,'>=')/>
	<cfset salesRevenueWeekCollectionList.addFilter('createdDateTime', weekMaxDateTime,'<=')/>
	<cfset salesRevenueWeekCollectionList.addFilter('orderStatusType.systemCode','ostNotPlaced','!=') />
	<cfif salesRevenueWeekCollectionList.getRecords()[1]['totalOrders'] EQ " ">
	<cfset salesWeekRevenue="$0" />
	<cfelse>
	<cfset salesWeekRevenue = "#$.slatwall.formatValue(salesRevenueWeekCollectionList.getRecords()[1]['totalOrders'], 'currency')#" />
	</cfif>
	
	<!---this block deals with sales this week--->
	
	<!---this block deals with sales current day--->
	<cfset currentDayMinDateTime="#CreateDateTime(Year(now()),Month(now()),Day(now()),0,0,0)#" />
	<cfset currentDayMaxDateTime="#CreateDateTime(Year(now()),Month(now()),Day(now()),23,59,59)#" />
	<cfset salesRevenueDayCollectionList = getHibachiScope().getService('orderService').getOrderCollectionList() />
	<cfset salesRevenueDayCollectionList.setDisplayProperties('') />
	<cfset salesRevenueDayCollectionList.addDisplayAggregate('calculatedTotal','SUM','dayTotalOrders') />
	<cfset salesRevenueDayCollectionList.addFilter('orderCreatedSite.siteID', siteID,'=')/>
	<cfset salesRevenueDayCollectionList.addFilter('createdDateTime', currentDayMinDateTime,'>=')/>
	<cfset salesRevenueDayCollectionList.addFilter('createdDateTime', currentDayMaxDateTime,'<=')/>
	<cfset salesRevenueDayCollectionList.addFilter('orderStatusType.systemCode','ostNotPlaced','!=') />
	<cfif salesRevenueDayCollectionList.getRecords()[1]['dayTotalOrders'] EQ " ">
	<cfset salesDayRevenue="$0" />
	<cfelse>
	<cfset salesDayRevenue = "#$.slatwall.formatValue(salesRevenueDayCollectionList.getRecords()[1]['dayTotalOrders'], 'currency')#" />
	</cfif>
	<!---this block deals with sales current day--->
	
	<!---this block deals with shopping cart session--->
	<cfset shoppingCartSessionCollectionList = getHibachiScope().getService('orderService').getOrderCollectionList() />
	<cfset shoppingCartSessionCollectionList.setDisplayProperties('') />
	<cfset shoppingCartSessionCollectionList.addDisplayAggregate('orderID','COUNT','totalCartSessions') />
	<cfset shoppingCartSessionCollectionList.addFilter('orderCreatedSite.siteID', siteID,'=')/>
	<cfset shoppingCartSessionCollectionList.addFilter('createdDateTime', currentDayMinDateTime,'>=')/>
	<cfset shoppingCartSessionCollectionList.addFilter('createdDateTime', currentDayMaxDateTime,'<=')/>
	<cfset shoppingCartSessionCollectionList.addFilter('orderStatusType.systemCode','ostNotPlaced','=') />
	<cfif shoppingCartSessionCollectionList.getRecords()[1]['totalCartSessions'] EQ " ">
	<cfset shoppingCartDay="0" />
	<cfelse>
	<cfset shoppingCartDay = "#shoppingCartSessionCollectionList.getRecords()[1]['totalCartSessions']#" />
	</cfif>
	<!---this block deals with shopping cart session--->
	
	
	<!---this block deals with average order current day--->
	<cfset averageDayOrdersCollectionList = getHibachiScope().getService('orderService').getOrderCollectionList() />
	<cfset averageDayOrdersCollectionList.setDisplayProperties('') />
	<cfset averageDayOrdersCollectionList.addDisplayAggregate('calculatedTotal','AVG','dayAvergeOrders') />
	<cfset averageDayOrdersCollectionList.addFilter('orderCreatedSite.siteID', siteID,'=')/>
	<cfset averageDayOrdersCollectionList.addFilter('createdDateTime', currentDayMinDateTime,'>=')/>
	<cfset averageDayOrdersCollectionList.addFilter('createdDateTime', currentDayMaxDateTime,'<=')/>
	<cfset averageDayOrdersCollectionList.addFilter('orderStatusType.systemCode','ostNotPlaced','!=') />
	<cfif averageDayOrdersCollectionList.getRecords()[1]['dayAvergeOrders'] EQ " ">
	<cfset averageSalesDayRevenue="$0" />
	<cfelse>
	<cfset averageSalesDayRevenue = "#$.slatwall.formatValue(averageDayOrdersCollectionList.getRecords()[1]['dayAvergeOrders'], 'currency')#" />
	</cfif>
	
	<!---this block deals with average order current day--->

    <div class="Mcard-wrapper col-md-12">
    	<div><h4> #siteName# </h4></div>
		                <div class="col-md-3">
		                    <div class="Mcard">
		                        <div class="Mcard-body ">
		                           <div><h1> #salesWeekRevenue# </h1></div>
		                           <div><img src="/assets/images/piggy-bank-1.png" alt="Piggy Bank"></div>
		                        </div>
		                        <div class="Mcard-footer Mcard-footer1">
		                            <div><p>Sales This Week </p></div> <div><img src="/assets/images/arrow.png" alt="arrow"></div>
		                        </div>
		                    </div>
		                </div>

 		                <div class="col-md-3">
		                    <div class="Mcard">
		                        <div class="Mcard-body ">
		                           <div><h1> #salesDayRevenue# </h1></div>
		                           <div><img src="/assets/images/shopping-bag-gray.png" alt="Shopping Bags"></div>
		                        </div>
		                        <div class="Mcard-footer Mcard-footer2">
		                            <div><p>Orders Today</p></div> <div><img src="/assets/images/arrow.png" alt="arrow"></div>
		                        </div>
		                    </div>
		                </div>

 		                <div class="col-md-3">
		                    <div class="Mcard">
		                        <div class="Mcard-body ">
		                           <div><h1> #shoppingCartDay# </h1></div>
		                           <div><img src="/assets/images/user-2.png" alt="User Icon"></div>
		                        </div>
		                        <div class="Mcard-footer Mcard-footer3">
		                            <div><p>Shopping Cart Today</p></div> <div><img src="/assets/images/arrow.png" alt="arrow"></div>
		                        </div>
		                    </div>
		                </div>
		                <div class="col-md-3">
		                    <div class="Mcard">
		                        <div class="Mcard-body ">
		                           <div><h1> #averageSalesDayRevenue# </h1></div>
		                           <div><img src="/assets/images/dollar-symbol-gray.png" alt="User Icon"></div>
		                        </div>
		                        <div class="Mcard-footer Mcard-footer4">
		                            <div><p>Average Orders Today</p></div> <div><img src="/assets/images/arrow.png" alt="arrow"></div>
		                        </div>
		                    </div>
		                </div>
		    		</div>
			
			
			<!--- DASHBOARD_WIDGETS --->
        
    </cfloop>
	
	<!--- SITES --->
		
		<!---Non-NULL SITE--->
	
			
	
	
			
			<hb:HibachiMessageDisplay />
			<hb:HibachiReportViewer report="#rc.report#" />
		</div>
		
	</div>
</cfoutput>
