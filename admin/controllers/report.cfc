/*

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

*/
component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiControllerEntity" {

	property name="hibachiReportService" type="any";
	property name="orderService" type="any";
	property name="accountService" type="any";

	this.secureMethods='';
	this.secureMethods=listAppend(this.secureMethods,'default');
	this.secureMethods=listAppend(this.secureMethods,'exportxls');
	this.secureMethods=listAppend(this.secureMethods,'exportcsv');

	public void function default(required struct rc) {
		param name="arguments.rc.reportID" default="";
		
		rc.orderCollectionList = getOrderService().getOrderCollectionList();
		rc.orderCollectionList.setDisplayProperties('orderNumber,account.calculatedFullName,orderOpenDateTime,orderStatusType.typeName,calculatedTotal',{isVisible:true});
		rc.orderCollectionList.addDisplayProperty('orderID',javacast('null',''),{hidden=true});
		rc.orderCollectionList.addFilter('orderStatusType.systemCode','ostNotPlaced','!=');
		rc.orderCollectionList.setOrderBy('orderOpenDateTime|DESC');

		if(!arguments.rc.ajaxRequest) {
			var savedReportsSmartList = getHibachiReportService().getReportSmartList();
			savedReportsSmartList.addOrder('reportTitle');
			
			arguments.rc.savedReports = savedReportsSmartList.getRecords();	
			arguments.rc.builtInReportsList = getHibachiReportService().getBuiltInReportsList();
			arguments.rc.customReportsList = getHibachiReportService().getCustomReportsList();
			arguments.rc.integrationReportsList = "";
		}
		
		var reportEntity = getHibachiReportService().getReport(arguments.rc.reportID);
		
		if(isNull(reportEntity) && !structKeyExists(arguments.rc, "reportName") && arrayLen(arguments.rc.savedReports)) {
			reportEntity = arguments.rc.savedReports[1];
		}
		
		if(!isNull(reportEntity)) {
			
			arguments.rc.reportID = reportEntity.getReportID();
			arguments.rc.reportName = reportEntity.getReportName();
			
			param name="arguments.rc.reportName" default="#reportEntity.getReportName()#";
			param name="arguments.rc.reportStartDateTime" default="#reportEntity.getReportStartDateTime()#";
			param name="arguments.rc.reportEndDateTime" default="#reportEntity.getReportEndDateTime()#";
			param name="arguments.rc.reportDateTimeGroupBy" default="#reportEntity.getReportDateTimeGroupBy()#";
			param name="arguments.rc.reportCompareFlag" type="any" default="#reportEntity.getReportCompareFlag()#";
			param name="arguments.rc.reportDateTime" default="#reportEntity.getReportDateTime()#";
			param name="arguments.rc.dimensions" type="any" default="#reportEntity.getDimensions()#";
			param name="arguments.rc.metrics" type="any" default="#reportEntity.getMetrics()#";
			param name="arguments.rc.orderByType" type="any" default="metric";
			param name="arguments.rc.reportType" type="any" default="#reportEntity.getReportType()#";
			param name="arguments.rc.limitResults" type="any" default="#reportEntity.getLimitResults()#";
			param name="arguments.rc.showReport" type="any" default="#reportEntity.getShowReport()#";
			
		} else if (!structKeyExists(arguments.rc, "reportName")) {
			
			arguments.rc.reportName = listFirst(getHibachiReportService().getBuiltInReportsList());
			
		}
		
		arguments.rc.report = getHibachiReportService().getReportCFC(arguments.rc.reportName, arguments.rc);
		
		if(!isNull(reportEntity)) {
			arguments.rc.report.setReportEntity( reportEntity );	
		}
		
		if(arguments.rc.ajaxRequest && structKeyExists(arguments.rc, "reportName")) {
			
			arguments.rc.ajaxResponse["report"] = {};		

			if(arguments.rc.report.getReportType() NEQ "none"){
				arguments.rc.ajaxResponse["report"]["chartData"] = arguments.rc.report.getChartData();
			} else { 
				arguments.rc.ajaxResponse["report"]["hideChart"] = true; 
			}
			
			arguments.rc.ajaxResponse["report"]["configureBar"] = arguments.rc.report.getReportConfigureBar();
			arguments.rc.ajaxResponse["report"]["reportDateTimeGroupBy"] = arguments.rc.report.getReportDateTimeGroupBy();
			
		} else {
			arguments.rc.pageTitle = arguments.rc.report.getReportTitle();
		}
		
		arguments.rc.ajaxResponse["report"]["period"] = "Today";
		var currentPeriodMinDateTime = CreateDateTime(Year(now()),Month(now()),Day(now()),0,0,0);
		var currentPeriodMaxDateTime = CreateDateTime(Year(now()),Month(now()),Day(now()),23,59,59);

		if(arguments.rc.report.getReportDateTimeGroupBy() == "hour") {
			currentPeriodMinDateTime = CreateDateTime(Year(now()),Month(now()),Day(now()),Hour(now()),0,0);
			currentPeriodMaxDateTime = CreateDateTime(Year(now()),Month(now()),Day(now()),Hour(now()),59,59);
			arguments.rc.ajaxResponse["report"]["period"] = "This Hour";
		}
		
		if(arguments.rc.report.getReportDateTimeGroupBy() == "day") {
			currentPeriodMinDateTime = CreateDateTime(Year(now()),Month(now()),Day(now()),0,0,0);
			currentPeriodMaxDateTime = CreateDateTime(Year(now()),Month(now()),Day(now()),23,59,59);
			arguments.rc.ajaxResponse["report"]["period"] = "Today";
		}
		
		if(arguments.rc.report.getReportDateTimeGroupBy() == "week") {
			currentPeriodMinDateTime = CreateDateTime(Year(now()),Month(now()),Day(DateAdd('d', -7, now())),0,0,0);
			currentPeriodMaxDateTime = CreateDateTime(Year(now()),Month(now()),Day(now()),23,59,59);
			arguments.rc.ajaxResponse["report"]["period"] = "This Week";
		}
		
		if(arguments.rc.report.getReportDateTimeGroupBy() == "month") {
			// first day of the month to the current day
			currentPeriodMinDateTime = CreateDateTime(Year(now()),Month(now()),1,0,0,0);
			currentPeriodMaxDateTime = CreateDateTime(Year(now()),Month(now()),Day(now()),23,59,59);
			arguments.rc.ajaxResponse["report"]["period"] = "This Month";
		}
		
		if(arguments.rc.report.getReportDateTimeGroupBy() == "year") {
			// first day of the year to the current day
			currentPeriodMinDateTime = CreateDateTime(Year(now()),1,1,0,0,0);
			currentPeriodMaxDateTime = CreateDateTime(Year(now()),Month(now()),Day(now()),23,59,59);
			arguments.rc.ajaxResponse["report"]["period"] = "This Year";
		}
		
		var salesRevenueThisPeriodCollectionList = getOrderService().getOrderCollectionList();
		salesRevenueThisPeriodCollectionList.setDisplayProperties("");
		salesRevenueThisPeriodCollectionList.addDisplayAggregate('calculatedTotal','SUM','totalSalesRevenue');
		salesRevenueThisPeriodCollectionList.addDisplayAggregate('orderID','COUNT','orderCount');
		salesRevenueThisPeriodCollectionList.addDisplayAggregate('calculatedTotal','AVG','averageOrderTotal');

		if(arguments.rc.report.getReportSite() != "ALL") {
			salesRevenueThisPeriodCollectionList.addFilter('orderCreatedSite.siteID', 'NULL','IS');
		} else {
			salesRevenueThisPeriodCollectionList.addFilter('orderCreatedSite.siteID', arguments.rc.report.getReportSite(),'=');
		}
		salesRevenueThisPeriodCollectionList.addFilter('createdDateTime', currentPeriodMinDateTime, '>=');
		salesRevenueThisPeriodCollectionList.addFilter('createdDateTime', currentPeriodMaxDateTime, '<=');
		salesRevenueThisPeriodCollectionList.addFilter('orderStatusType.systemCode','ostNotPlaced','!=');
		if(salesRevenueThisPeriodCollectionList.getRecords()[1]['totalSalesRevenue'] EQ " ") {
			arguments.rc.ajaxResponse["report"]["salesRevenueThisPeriod"] = "$0";
			arguments.rc.ajaxResponse["report"]["orderCount"] = 0;
			arguments.rc.ajaxResponse["report"]["averageOrderTotal"] = "$0";
		} else {
			arguments.rc.ajaxResponse["report"]["salesRevenueThisPeriod"] = formatValue(salesRevenueThisPeriodCollectionList.getRecords()[1]['totalSalesRevenue'], 'currency');
			arguments.rc.ajaxResponse["report"]["orderCount"] = salesRevenueThisPeriodCollectionList.getRecords()[1]['orderCount'];
			arguments.rc.ajaxResponse["report"]["averageOrderTotal"] = formatValue(salesRevenueThisPeriodCollectionList.getRecords()[1]['averageOrderTotal'], 'currency');
		}
		
		var accountsThisPeriodCollectionList = getAccountService().getAccountCollectionList();
		accountsThisPeriodCollectionList.setDisplayProperties("");
		accountsThisPeriodCollectionList.addDisplayAggregate('accountID','COUNT','accountCount');
		accountsThisPeriodCollectionList.addFilter('createdDateTime', currentPeriodMinDateTime, '>=');
		accountsThisPeriodCollectionList.addFilter('createdDateTime', currentPeriodMaxDateTime, '<=');
		if(accountsThisPeriodCollectionList.getRecords()[1]['accountCount'] EQ " ") {
			arguments.rc.ajaxResponse["report"]["accountCount"] = 0;
		} else {
			arguments.rc.ajaxResponse["report"]["accountCount"] = accountsThisPeriodCollectionList.getRecords()[1]['accountCount'];
		}
	}
	
	public void function exportxls(required struct rc) {
		param name="arguments.rc.reportID" default="";
		
		var report = getHibachiReportService().getReportCFC( arguments.rc.reportName, arguments.rc );
		
		var reportEntity = getHibachiReportService().getReport( arguments.rc.reportID );
		if(!isNull(reportEntity)){
			report.setReportEntity( reportEntity );
		}	
		
		report.exportSpreadsheet();
		
		getFW().redirect(action="admin:report.default", queryString="reportName=#report.getClassName()#");
	}
	
	public void function exportcsv(required struct rc) {
		param name="arguments.rc.reportID" default="";
		
		var report = getHibachiReportService().getReportCFC( arguments.rc.reportName, arguments.rc );
		
		var reportEntity = getHibachiReportService().getReport( arguments.rc.reportID );
		if(!isNull(reportEntity)){
			report.setReportEntity( reportEntity );
		}	
		
		report.exportCSV();
		
		getFW().redirect(action="admin:report.default", queryString="reportName=#report.getClassName()#");
	}
}
