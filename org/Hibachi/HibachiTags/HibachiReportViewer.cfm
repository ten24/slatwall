<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.report" type="any" />
	<cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#" />
	
	<cfoutput>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/js/Chart.bundle.min.js"></script>
		
		<div id="hibachi-report" data-reportname="#attributes.report.getClassName()#">
			<!--- Configure --->
			<div id="hibachi-report-configure-bar">
				#attributes.report.getReportConfigureBar()#
			</div>
			
			<!---this block deals with sales this week--->
			<cfset weekMinDateTime="#CreateDateTime(Year(now()),Month(DateAdd('m', -1, now())),Day(DateAdd('d', -7, now())),0,0,0)#" />
		    <cfset weekMaxDateTime="#CreateDateTime(Year(now()),Month(now()),Day(now()),23,59,59)#" />
			<cfset salesRevenueWeekCollectionList = attributes.hibachiScope.getService('orderService').getOrderCollectionList() />
			<cfset salesRevenueWeekCollectionList.setDisplayProperties('') />
			<cfset salesRevenueWeekCollectionList.addDisplayAggregate('calculatedTotal','SUM','totalOrders') />
			<cfif attributes.report.getReportSite() != "ALL">
				<cfif !len(attributes.report.getReportSite())>
					<cfset salesRevenueWeekCollectionList.addFilter('orderCreatedSite.siteID', 'NULL','IS')/>
				<cfelse>
					<cfset salesRevenueWeekCollectionList.addFilter('orderCreatedSite.siteID', attributes.report.getReportSite(),'=')/>
				</cfif>
			</cfif>
			<cfset salesRevenueWeekCollectionList.addFilter('createdDateTime', weekMinDateTime,'>=')/>
			<cfset salesRevenueWeekCollectionList.addFilter('createdDateTime', weekMaxDateTime,'<=')/>
			<cfset salesRevenueWeekCollectionList.addFilter('orderStatusType.systemCode','ostNotPlaced','!=') />
			<cfif salesRevenueWeekCollectionList.getRecords()[1]['totalOrders'] EQ " ">
			<cfset salesWeekRevenue="$0" />
			<cfelse>
			<cfset salesWeekRevenue = "#request.slatwallScope.formatValue(salesRevenueWeekCollectionList.getRecords()[1]['totalOrders'], 'currency')#" />
			</cfif>
			<!---this block deals with sales this week--->
			
			<!---this block deals with sales current day--->
			<cfset currentDayMinDateTime="#CreateDateTime(Year(now()),Month(now()),Day(now()),0,0,0)#" />
			<cfset currentDayMaxDateTime="#CreateDateTime(Year(now()),Month(now()),Day(now()),23,59,59)#" />
			<cfset salesRevenueDayCollectionList = attributes.hibachiScope.getService('orderService').getOrderCollectionList() />
			<cfset salesRevenueDayCollectionList.setDisplayProperties('') />
			<cfset salesRevenueDayCollectionList.addDisplayAggregate('calculatedTotal','SUM','dayTotalOrders') />
			<cfif attributes.report.getReportSite() != "ALL">
				<cfif !len(attributes.report.getReportSite())>
					<cfset salesRevenueDayCollectionList.addFilter('orderCreatedSite.siteID', 'NULL','IS')/>
				<cfelse>
					<cfset salesRevenueDayCollectionList.addFilter('orderCreatedSite.siteID', attributes.report.getReportSite(),'=')/>
				</cfif>
			</cfif>
			
			<cfset salesRevenueDayCollectionList.addFilter('createdDateTime', currentDayMinDateTime,'>=')/>
			<cfset salesRevenueDayCollectionList.addFilter('createdDateTime', currentDayMaxDateTime,'<=')/>
			<cfset salesRevenueDayCollectionList.addFilter('orderStatusType.systemCode','ostNotPlaced','!=') />
			<cfif salesRevenueDayCollectionList.getRecords()[1]['dayTotalOrders'] EQ " ">
			<cfset salesDayRevenue="$0" />
			<cfelse>
			<cfset salesDayRevenue = "#request.slatwallScope.formatValue(salesRevenueDayCollectionList.getRecords()[1]['dayTotalOrders'], 'currency')#" />
			</cfif>
			<!---this block deals with sales current day--->
			
			<!---this block deals with accounts --->
			<cfset accountCollectionList = attributes.hibachiScope.getService('accountService').getAccountCollectionList() />
			<cfset accountCollectionList.setDisplayProperties('') />
			<cfset accountCollectionList.addDisplayAggregate('accountID','COUNT','totalAccounts') />
			<cfset accountCollectionList.addFilter('accountCreatedSite.siteID', 'NULL','IS')/>
			<cfif attributes.report.getReportSite() != "ALL">
				<cfif !len(attributes.report.getReportSite())>
					<cfset accountCollectionList.addFilter('accountCreatedSite.siteID', 'NULL','IS')/>
				<cfelse>
					<cfset accountCollectionList.addFilter('accountCreatedSite.siteID', attributes.report.getReportSite(),'=')/>
				</cfif>
			</cfif>
			<cfset accountCollectionList.addFilter('createdDateTime', currentDayMinDateTime,'>=')/>
			<cfset accountCollectionList.addFilter('createdDateTime', currentDayMaxDateTime,'<=')/>
			<cfif accountCollectionList.getRecords()[1]['totalAccounts'] EQ " ">
			<cfset accounts="0" />
			<cfelse>
			<cfset accounts = "#accountCollectionList.getRecords()[1]['totalAccounts']#" />
			</cfif>
			<!---this block deals with accounts --->
			
			<!---this block deals with average order current day--->
			<cfset averageDayOrdersCollectionList = attributes.hibachiScope.getService('orderService').getOrderCollectionList() />
			<cfset averageDayOrdersCollectionList.setDisplayProperties('') />
			<cfset averageDayOrdersCollectionList.addDisplayAggregate('calculatedTotal','AVG','dayAvergeOrders') />
			<cfif attributes.report.getReportSite() != "ALL">
				<cfif !len(attributes.report.getReportSite())>
					<cfset averageDayOrdersCollectionList.addFilter('orderCreatedSite.siteID', 'NULL','IS')/>
				<cfelse>
					<cfset averageDayOrdersCollectionList.addFilter('orderCreatedSite.siteID', attributes.report.getReportSite(),'=')/>
				</cfif>
			</cfif>
			<cfset averageDayOrdersCollectionList.addFilter('createdDateTime', currentDayMinDateTime,'>=')/>
			<cfset averageDayOrdersCollectionList.addFilter('createdDateTime', currentDayMaxDateTime,'<=')/>
			<cfset averageDayOrdersCollectionList.addFilter('orderStatusType.systemCode','ostNotPlaced','!=') />
			<cfif averageDayOrdersCollectionList.getRecords()[1]['dayAvergeOrders'] EQ " ">
			<cfset averageSalesDayRevenue="$0" />
			<cfelse>
			<cfset averageSalesDayRevenue = "#request.slatwallScope.formatValue(averageDayOrdersCollectionList.getRecords()[1]['dayAvergeOrders'], 'currency')#" />
			</cfif>
			<!---this block deals with average order current day--->
		
		    <div class="Mcard-wrapper col-md-12" style="margin-bottom: 24px;">
		        <div class="col-md-3">
					<sw-stat-widget 
						title="Sales This Week" 
						metric="#salesWeekRevenue#"
						img-src="/assets/images/piggy-bank-1.png"
						img-alt="Piggy Bank"
						footer-class="Mcard-footer1"
					>
					</sw-stat-widget>
		        </div>
		
		         <div class="col-md-3">
		        	<sw-stat-widget 
						title="Orders Today" 
						metric="#salesDayRevenue#"
						img-src="/assets/images/shopping-bag-gray.png"
						img-alt="Shopping Bags"
						footer-class="Mcard-footer2"
					>
					</sw-stat-widget>
		        </div>
		
		        <div class="col-md-3">
		    		<sw-stat-widget 
						title="Average Orders Today" 
						metric="#averageSalesDayRevenue#"
						img-src="/assets/images/dollar-symbol-gray.png"
						img-alt="Dollar Symbol Badge"
						footer-class="Mcard-footer4"
					>
					</sw-stat-widget>
		        </div>
		        
		    	<div class="col-md-3">
		    		<sw-stat-widget 
						title="Accounts Today" 
						metric="#accounts#"
						img-src="/assets/images/user-2.png"
						img-alt="User Icon"
						footer-class="Mcard-footer3"
					>
					</sw-stat-widget>
		        </div>
			</div>
			
			<!--- Chart --->
			<div class="hibachi-report-chart-container">
				<h3 class="hibachi-report-chart-title">#attributes.report.getChartData().options.title.text#</h3>
				<div id="hibachi-report-chart-wrapper">
					<canvas id="hibachi-report-chart" width="1800" height="600"></canvas>
				</div>
			</div>

			<script type="text/javascript">
				jQuery(document).ready(function(){
					addLoadingDiv( 'hibachi-report' );
					updateReport();
				});
			</script>
		</div>
	</cfoutput>
</cfif>

