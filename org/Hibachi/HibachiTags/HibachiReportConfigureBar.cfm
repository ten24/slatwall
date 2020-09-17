<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#" />
	
	<cfparam name="attributes.report" type="any" />
	
	<cfoutput>
		<form action="?s=1" method="post" style="margin:0px;">
			<input type="hidden" name="reportName" value="#attributes.report.getClassName()#" />
			<cfif not isNull(attributes.report.getReportEntity())>
				<input type="hidden" name="reportID" value="#attributes.report.getReportEntity().getReportID()#" />
			<cfelse>
				<input type="hidden" name="reportID" value="" />
			</cfif>

			<div class="row s-report-info">
		<span ng-init="toggleCustomDate = false"></span>			
		<!--- Report DateTime GroupBy ---> 
		<div class="col-md-12">
			<div class="configure-bar-container">
				<div class="col-md-6">
					<div class="report-btn-container">
						<a href="" class="hibachi-report-date-group btn btn-xs btn-default<cfif attributes.report.getReportDateTimeGroupBy() eq 'hour'> active</cfif>" data-groupby="hour">Hour</a>
						<a href="" class="hibachi-report-date-group btn btn-xs btn-default<cfif attributes.report.getReportDateTimeGroupBy() eq 'day'> active</cfif>" data-groupby="day">Day</a>
						<a href="" class="hibachi-report-date-group btn btn-xs btn-default<cfif attributes.report.getReportDateTimeGroupBy() eq 'week'> active</cfif>" data-groupby="week">Week</a>
						<a href="" class="hibachi-report-date-group btn btn-xs btn-default<cfif attributes.report.getReportDateTimeGroupBy() eq 'month'> active</cfif>" data-groupby="month">Month</a>
						<a href="" class="hibachi-report-date-group btn btn-xs btn-default<cfif attributes.report.getReportDateTimeGroupBy() eq 'year'> active</cfif>" data-groupby="year">Year</a>
						<button type="button" class="hibachi-report-date-group-custom-toggle btn btn-xs btn-default">Custom</button>
					</div>
				</div>
				<div class="site-selector-container col-md-3">
					<cfset siteCollectionList = attributes.hibachiScope.getService('siteService').getSiteCollectionList() />
					<cfset siteCollectionList.setDisplayProperties('siteID,siteName', { isVisible=true }) />
					<h4 class="site-selector-title">Site</h4>
					<select 
						class="form-control j-custom-select" 
						name="siteSelector"
						onChange="updateReport()"
						>
						<option value="all" selected>All Sites</option>
						<cfloop array="#siteCollectionList.getRecords()#" index="siteRecord" >
					        <cfset siteName = siteRecord['siteName'] />
					        <cfset siteID = siteRecord['siteID'] />
					        <option value="#siteID#">#siteName#</option>
						</cfloop>
						<option value="">* No Site Provided *</option>
					</select>
				</div>
			</div>
	
				</div>
			</div>
		</form>
	</cfoutput>
</cfif>