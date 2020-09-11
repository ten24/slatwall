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
			<cfset local.weekMinDateTime = CreateDateTime(Year(now()),Month(DateAdd('m', -1, now())),Day(DateAdd('d', -7, now())),0,0,0) />
		    <cfset local.weekMaxDateTime = CreateDateTime(Year(now()),Month(now()),Day(now()),23,59,59) />
			<cfset local.salesRevenueWeekCollectionList = attributes.hibachiScope.getService('orderService').getOrderCollectionList() />
			<cfset local.salesRevenueWeekCollectionList.setDisplayProperties('') />
			<cfset local.salesRevenueWeekCollectionList.addDisplayAggregate('calculatedTotal','SUM','totalOrders') />
			<cfif attributes.report.getReportSite() != "ALL">
				<cfif !len(attributes.report.getReportSite())>
					<cfset local.salesRevenueWeekCollectionList.addFilter('orderCreatedSite.siteID', 'NULL','IS')/>
				<cfelse>
					<cfset local.salesRevenueWeekCollectionList.addFilter('orderCreatedSite.siteID', attributes.report.getReportSite(),'=')/>
				</cfif>
			</cfif>
			<cfset local.salesRevenueWeekCollectionList.addFilter('createdDateTime', local.weekMinDateTime,'>=')/>
			<cfset local.salesRevenueWeekCollectionList.addFilter('createdDateTime', local.weekMaxDateTime,'<=')/>
			<cfset local.salesRevenueWeekCollectionList.addFilter('orderStatusType.systemCode','ostNotPlaced','!=') />
			<cfif local.salesRevenueWeekCollectionList.getRecords()[1]['totalOrders'] EQ " ">
			<cfset local.salesWeekRevenue="$0" />
			<cfelse>
			<cfset local.salesWeekRevenue = request.slatwallScope.formatValue(local.salesRevenueWeekCollectionList.getRecords()[1]['totalOrders'], 'currency') />
			</cfif>
			<!---this block deals with sales this week--->
			
			<!---this block deals with sales current day--->
			<cfset local.currentDayMinDateTime = CreateDateTime(Year(now()),Month(now()),Day(now()),0,0,0) />
			<cfset local.currentDayMaxDateTime = CreateDateTime(Year(now()),Month(now()),Day(now()),23,59,59) />
			<cfset local.salesRevenueDayCollectionList = attributes.hibachiScope.getService('orderService').getOrderCollectionList() />
			<cfset local.salesRevenueDayCollectionList.setDisplayProperties('') />
			<cfset local.salesRevenueDayCollectionList.addDisplayAggregate('calculatedTotal','SUM','dayTotalOrders') />
			<cfif attributes.report.getReportSite() != "ALL">
				<cfif !len(attributes.report.getReportSite())>
					<cfset local.salesRevenueDayCollectionList.addFilter('orderCreatedSite.siteID', 'NULL','IS')/>
				<cfelse>
					<cfset local.salesRevenueDayCollectionList.addFilter('orderCreatedSite.siteID', attributes.report.getReportSite(),'=')/>
				</cfif>
			</cfif>
			
			<cfset local.salesRevenueDayCollectionList.addFilter('createdDateTime', local.currentDayMinDateTime,'>=')/>
			<cfset local.salesRevenueDayCollectionList.addFilter('createdDateTime', local.currentDayMaxDateTime,'<=')/>
			<cfset local.salesRevenueDayCollectionList.addFilter('orderStatusType.systemCode','ostNotPlaced','!=') />
			<cfif local.salesRevenueDayCollectionList.getRecords()[1]['dayTotalOrders'] EQ " ">
			<cfset local.salesDayRevenue="$0" />
			<cfelse>
			<cfset local.salesDayRevenue = request.slatwallScope.formatValue(local.salesRevenueDayCollectionList.getRecords()[1]['dayTotalOrders'], 'currency') />
			</cfif>
			<!---this block deals with sales current day--->
			
			<!---this block deals with accounts --->
			<cfset local.accountCollectionList = attributes.hibachiScope.getService('accountService').getAccountCollectionList() />
			<cfset local.accountCollectionList.setDisplayProperties('') />
			<cfset local.accountCollectionList.addDisplayAggregate('accountID','COUNT','totalAccounts') />
			<cfset local.accountCollectionList.addFilter('accountCreatedSite.siteID', 'NULL','IS')/>
			<cfif attributes.report.getReportSite() != "ALL">
				<cfif !len(attributes.report.getReportSite())>
					<cfset local.accountCollectionList.addFilter('accountCreatedSite.siteID', 'NULL','IS')/>
				<cfelse>
					<cfset local.accountCollectionList.addFilter('accountCreatedSite.siteID', attributes.report.getReportSite(),'=')/>
				</cfif>
			</cfif>
			<cfset local.accountCollectionList.addFilter('createdDateTime', local.currentDayMinDateTime,'>=')/>
			<cfset local.accountCollectionList.addFilter('createdDateTime', local.currentDayMaxDateTime,'<=')/>
			<cfif local.accountCollectionList.getRecords()[1]['totalAccounts'] EQ " ">
			<cfset local.accounts="0" />
			<cfelse>
			<cfset local.accounts = local.accountCollectionList.getRecords()[1]['totalAccounts'] />
			</cfif>
			<!---this block deals with accounts --->
			
			<!---this block deals with average order current day--->
			<cfset local.averageDayOrdersCollectionList = attributes.hibachiScope.getService('orderService').getOrderCollectionList() />
			<cfset local.averageDayOrdersCollectionList.setDisplayProperties('') />
			<cfset local.averageDayOrdersCollectionList.addDisplayAggregate('calculatedTotal','AVG','dayAvergeOrders') />
			<cfif attributes.report.getReportSite() != "ALL">
				<cfif !len(attributes.report.getReportSite())>
					<cfset local.averageDayOrdersCollectionList.addFilter('orderCreatedSite.siteID', 'NULL','IS')/>
				<cfelse>
					<cfset local.averageDayOrdersCollectionList.addFilter('orderCreatedSite.siteID', attributes.report.getReportSite(),'=')/>
				</cfif>
			</cfif>
			<cfset local.averageDayOrdersCollectionList.addFilter('createdDateTime', local.currentDayMinDateTime,'>=')/>
			<cfset local.averageDayOrdersCollectionList.addFilter('createdDateTime', local.currentDayMaxDateTime,'<=')/>
			<cfset local.averageDayOrdersCollectionList.addFilter('orderStatusType.systemCode','ostNotPlaced','!=') />
			<cfif local.averageDayOrdersCollectionList.getRecords()[1]['dayAvergeOrders'] EQ " ">
			<cfset local.averageSalesDayRevenue="$0" />
			<cfelse>
			<cfset local.averageSalesDayRevenue = request.slatwallScope.formatValue(local.averageDayOrdersCollectionList.getRecords()[1]['dayAvergeOrders'], 'currency') />
			</cfif>
			<!---this block deals with average order current day--->
		
		    <div class="Mcard-wrapper col-md-12">
		        <div class="col-md-3">
					<sw-stat-widget 
						title="Sales This Week" 
						metric="#local.salesWeekRevenue#"
						img-src="/assets/images/piggy-bank-1.png"
						img-alt="Piggy Bank"
						footer-class="Mcard-footer1"
					>
					</sw-stat-widget>
		        </div>
		
		         <div class="col-md-3">
		        	<sw-stat-widget 
						title="Orders Today" 
						metric="#local.salesDayRevenue#"
						img-src="/assets/images/shopping-bag-gray.png"
						img-alt="Shopping Bags"
						footer-class="Mcard-footer2"
					>
					</sw-stat-widget>
		        </div>
		
		        <div class="col-md-3">
		    		<sw-stat-widget 
						title="Average Orders Today" 
						metric="#local.averageSalesDayRevenue#"
						img-src="/assets/images/dollar-symbol-gray.png"
						img-alt="Dollar Symbol Badge"
						footer-class="Mcard-footer4"
					>
					</sw-stat-widget>
		        </div>
		        
		    	<div class="col-md-3">
		    		<sw-stat-widget 
						title="Accounts Today" 
						metric="#local.accounts#"
						img-src="/assets/images/user-2.png"
						img-alt="User Icon"
						footer-class="Mcard-footer3"
					>
					</sw-stat-widget>
		        </div>
			</div>
			
			<!--- Chart --->
			<div class="hibachi-report-chart-container col-md-12">
				<h3 class="hibachi-report-chart-title">#attributes.report.getReportEntity().getReportTitle()#</h3>
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

