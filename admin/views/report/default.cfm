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

<cfoutput>
	<div class="row-fluid">
		<div class="span2">
			<ul class="nav">
				<cf_HibachiDividerHider>
					<cfif arrayLen(rc.savedReports)>
						<li><h5>#$.slatwall.rbKey('entity.report_plural')#</h5></li>
						<cfloop array="#rc.savedReports#" index="report">
							<cf_HibachiActionCaller action="admin:report.default" queryString="reportID=#report.getReportID()#" text="#report.getReportTitle()#" type="list" />
						</cfloop>
					</cfif>
					<cfif listLen(rc.builtInReportsList)>
						<li><h5>#$.slatwall.rbKey('admin.report.default.builtInReports')#</h5></li>
						<cfloop list="#rc.builtInReportsList#" index="reportName">
							<cf_HibachiActionCaller action="admin:report.default" queryString="reportName=#reportName#" text="#$.slatwall.rbKey('report.#reportName#')#" type="list" />
						</cfloop> 
					</cfif>
					<cfif listLen(rc.customReportsList)>
						<li><h5>#$.slatwall.rbKey('admin.report.default.customReports')#</h5></li>
						<cfloop list="#rc.customReportsList#" index="reportName">
							<cf_HibachiActionCaller action="admin:report.default" queryString="reportName=#reportName#" text="#$.slatwall.rbKey('report.#reportName#')#" type="list" />
						</cfloop> 
					</cfif>
					<cfif listLen(rc.integrationReportsList)>
						<li><h5>#$.slatwall.rbKey('admin.report.default.integrationReports')#</h5></li>
						<cfloop list="#rc.integrationReportsList#" index="reportName">
							<cf_HibachiActionCaller action="admin:report.default" queryString="reportName=#reportName#" text="#$.slatwall.rbKey('report.#reportName#')#" type="list" />
						</cfloop> 
					</cfif>
				</cf_HibachiDividerHider>
			</ul>
		</div>
		<div class="span10">
			<cf_HibachiMessageDisplay />
			<cf_HibachiReportViewer report="#rc.report#" />
		</div>
	</div>
	
</cfoutput>
