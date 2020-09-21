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
<cfparam name="rc.orderSmartList" type="any" />
<cfparam name="rc.report" type="any" />

<cfoutput>
	<div class="col-md-12">
		<hb:HibachiMessageDisplay />
	</div>
	
	<hb:HibachiReportViewer report="#rc.report#" />

	<div class="navTabs-Container" id="navTabs-Container">
		<ul class="nav nav-tabs" role="tablist">
			  <li class="active tab-selector"><a href="##reports-overview" role="tab" data-toggle="tab">My Custom Reports</a></li>
			  <li class="tab-selector"><a href="##popular-reports" role="tab" data-toggle="tab">Popular Reports</a></li>
			  <li class="tab-selector"><a href="##all-reports" role="tab" data-toggle="tab">All Reports</a></li>
		</ul>
		
		<!-- Markup for reporting tab panes -->
		<div class="tab-content col-md-12">
		  <div class="tab-pane active flex" id="reports-overview">
		  	<div class="col-sm-3">
		  		<ul class="list-unstyled">
					<cfif arrayLen(rc.savedReports)>
						<cfloop array="#rc.savedReports#" index="report">
							<hb:HibachiActionCaller action="admin:report.default" queryString="reportID=#report.getReportID()#" text="#report.getReportTitle()#" type="list" />
						</cfloop>
					</cfif>
		  		</ul>
		  	</div>
		  </div>
		  
		  <div class="tab-pane flex" id="popular-reports">			  	
			<div class="col-sm-3">
		  		<ul class="list-unstyled">
				<cfif listLen(rc.builtInReportsList)>
					<cfloop list="#rc.builtInReportsList#" index="reportName">
						<hb:HibachiActionCaller action="admin:report.default" queryString="reportName=#reportName#" text="#$.slatwall.rbKey('report.#reportName#')#" type="list" />
					</cfloop>
				</cfif>
		  		</ul>
		  	</div>
		  </div>
		  
		  <div class="tab-pane flex" id="all-reports">
		  	<div class="col-sm-3">
		  		<ul class="list-unstyled">
					<cfif arrayLen(rc.savedReports)>
						<cfloop array="#rc.savedReports#" index="report">
							<hb:HibachiActionCaller action="admin:report.default" queryString="reportID=#report.getReportID()#" text="#report.getReportTitle()#" type="list" />
						</cfloop>
					</cfif>
		  		</ul>
		  	</div>
		  	
		  	<div class="col-sm-3">
		  		<ul class="list-unstyled">
					<cfif listLen(rc.builtInReportsList)>
						<cfloop list="#rc.builtInReportsList#" index="reportName">
							<hb:HibachiActionCaller action="admin:report.default" queryString="reportName=#reportName#" text="#$.slatwall.rbKey('report.#reportName#')#" type="list" />
						</cfloop>
					</cfif>
		  		</ul>					  		
		  	</div>
		  	<div class="col-sm-3">
		  		<ul class="list-unstyled">
					<cfif listLen(rc.customReportsList)>
						<li><h5><strong>#$.slatwall.rbKey('admin.report.default.customReports')#</strong></h5></li>
						<cfloop list="#rc.customReportsList#" index="reportName">
							<hb:HibachiActionCaller action="admin:report.default" queryString="reportName=#reportName#" text="#$.slatwall.rbKey('report.#reportName#')#" type="list" />
						</cfloop>
					</cfif>
					<cfif listLen(rc.integrationReportsList)>
						<li><h5><strong>#$.slatwall.rbKey('admin.report.default.integrationReports')#</strong></h5></li>
						<cfloop list="#rc.integrationReportsList#" index="reportName">
							<hb:HibachiActionCaller action="admin:report.default" queryString="reportName=#reportName#" text="#$.slatwall.rbKey('report.#reportName#')#" type="list" />
						</cfloop>
					</cfif>
		  		</ul>					  		
		  	</div>	
		  </div>
		</div>
	</div>
</cfoutput>
