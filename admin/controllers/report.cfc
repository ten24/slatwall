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
component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiController" {

	property name="hibachiReportService" type="any";

	this.secureMethods='';
	this.secureMethods=listAppend(this.secureMethods,'default');
	this.secureMethods=listAppend(this.secureMethods,'exportxls');
	this.secureMethods=listAppend(this.secureMethods,'exportcsv');

	public void function default(required struct rc) {
		param name="arguments.rc.reportID" default="";
		
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
			
			if(arguments.rc.report.getShowReport()){ 
				arguments.rc.ajaxResponse["report"]["dataTable"] = arguments.rc.report.getReportDataTable();
			} else { 
				arguments.rc.ajaxResponse["report"]["hideReport"] = true; 	
			}
			
		} else {
			arguments.rc.pageTitle = arguments.rc.report.getReportTitle();
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
