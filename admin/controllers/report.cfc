/*

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

*/
component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiController" {

	property name="hibachiReportService" type="any";

	this.secureMethods='';
	this.secureMethods=listAppend(this.secureMethods,'default');
	this.secureMethods=listAppend(this.secureMethods,'export');

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
			
		} else if (!structKeyExists(arguments.rc, "reportName")) {
			
			arguments.rc.reportName = listFirst(getHibachiReportService().getBuiltInReportsList());
			
		}
		
		arguments.rc.report = getHibachiReportService().getReportCFC(arguments.rc.reportName, arguments.rc);
		
		if(!isNull(reportEntity)) {
			arguments.rc.report.setReportEntity( reportEntity );	
		}
		
		if(arguments.rc.ajaxRequest && structKeyExists(arguments.rc, "reportName")) {
			arguments.rc.ajaxResponse["report"] = {};
			arguments.rc.ajaxResponse["report"]["chartData"] = arguments.rc.report.getChartData();
			arguments.rc.ajaxResponse["report"]["configureBar"] = arguments.rc.report.getReportConfigureBar();
			arguments.rc.ajaxResponse["report"]["dataTable"] = arguments.rc.report.getReportDataTable();
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