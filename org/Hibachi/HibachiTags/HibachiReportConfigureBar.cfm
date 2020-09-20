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
			<cfset local.startOfToday = CreateDateTime(Year(now()),Month(now()),Day(now()),0,0,0) />
			<cfset local.endOfToday = CreateDateTime(Year(now()),Month(now()),Day(now()),23,59,59) />
			<cfset local.startOfMonth = CreateDateTime(Year(now()),Month(now()),1,0,0,0) />
			<cfset local.endOfMonth = CreateDateTime(Year(now()),Month(DateAdd('m', 1, now())),1,0,0,0) />
			<cfset local.endOfHour = CreateDateTime(Year(now()),Month(now()),Day(now()),Hour(now()),59,59) />
			<cfset local.lastTwentyFourHours = DateAdd("h", -24, local.endOfHour) />
			<cfset local.lastTwoWeeks = DateAdd("d", -13, local.endOfToday) />
			<cfset local.weekGrouping = DateAdd("ww", -11, local.endOfToday) />
			<cfset local.monthGrouping = DateAdd("m", -11, local.endOfMonth) />

			<div class="row s-report-info">
		<span ng-init="toggleCustomDate = false"></span>			
		<!--- Report DateTime GroupBy ---> 
		<div class="col-md-12">
			<div class="configure-bar-container">
				<div class="col-md-6">
					<div class="report-btn-container">
						<a 
							href="" 
							class="hibachi-report-date-group btn btn-xs btn-default<cfif attributes.report.getReportDateTimeGroupBy() eq 'hour'> active</cfif>" 
							data-groupby="hour"
							data-start="#local.lastTwentyFourHours#"
							data-end="#local.endOfHour#"
							>Hour</a>
						<a 
							href="" 
							class="hibachi-report-date-group btn btn-xs btn-default<cfif attributes.report.getReportDateTimeGroupBy() eq 'day'> active</cfif>" 
							data-groupby="day" 
							data-start="#local.lastTwoWeeks#" 
							data-end="#local.endOfToday#"
							>Day</a>
						<a 
							href="" 
							class="hibachi-report-date-group btn btn-xs btn-default<cfif attributes.report.getReportDateTimeGroupBy() eq 'week'> active</cfif>" 
							data-groupby="week" 
							data-start="#local.weekGrouping#" 
							data-end="#local.endOfToday#"
							>Week</a>
						<a 
							href="" 
							class="hibachi-report-date-group btn btn-xs btn-default<cfif attributes.report.getReportDateTimeGroupBy() eq 'month'> active</cfif>" 
							data-groupby="month" 
							data-start="#local.monthGrouping#" 
							data-end="#local.endOfMonth#"
							>Month</a>
						<a 
							href="" 
							class="hibachi-report-date-group btn btn-xs btn-default<cfif attributes.report.getReportDateTimeGroupBy() eq 'year'> active</cfif>" 
							data-groupby="year" 
							data-start="#CreateDateTime(Year(DateAdd('yyyy', -10, now())),1,1,0,0,0)#" 
							data-end="#CreateDateTime(Year(DateAdd('yyyy', 1, now())),Month(now()),1,0,0,0)#"
							>Year</a>
						<button type="button" class="hibachi-report-date-group-custom-toggle btn btn-xs btn-default">Custom</button>
					</div>
				</div>
				<div class="site-selector-container col-md-3">
					<cfset siteCollectionList = attributes.hibachiScope.getService('siteService').getSiteCollectionList() />
					<cfset siteCollectionList.setDisplayProperties('siteID,siteName', { isVisible=true }) />
					<select 
						class="form-control j-custom-select" 
						name="siteSelector"
						onChange="updateReport()"
						>
						<cfloop array="#siteCollectionList.getRecords()#" index="siteRecord" >
					        <cfset siteName = siteRecord['siteName'] />
					        <cfset siteID = siteRecord['siteID'] />
					        <option value="#siteID#">#siteName#</option>
						</cfloop>
					</select>
				</div>
			</div>
	
				</div>
			</div>
		</form>
	</cfoutput>
</cfif>