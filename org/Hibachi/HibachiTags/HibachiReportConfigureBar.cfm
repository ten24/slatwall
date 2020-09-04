<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#" />
	
	<cfparam name="attributes.report" type="any" />
	
	<cfoutput>
		<cfform action="?s=1" method="post" style="margin:0px;">
			<input type="hidden" name="reportName" value="#attributes.report.getClassName()#" />
			<cfif not isNull(attributes.report.getReportEntity())>
				<input type="hidden" name="reportID" value="#attributes.report.getReportEntity().getReportID()#" />
			<cfelse>
				<input type="hidden" name="reportID" value="" />
			</cfif>

			<div class="row s-report-info">
		<!--- Report DateTime GroupBy ---> 
					
		<div class="col-md-12">
			<div style="display: flex; width: 90%; margin: 0 auto; justify-content: space-between; align-items: flex-end;">
				<div>
					<div style="margin-bottom: 20px;">
						<a href="" class="hibachi-report-date-group btn btn-xs btn-default<cfif attributes.report.getReportDateTimeGroupBy() eq 'hour'> activated</cfif>" data-groupby="hour">Hour</a>
						<a href="" class="hibachi-report-date-group btn btn-xs btn-default<cfif attributes.report.getReportDateTimeGroupBy() eq 'day'> activated</cfif>" data-groupby="day">Day</a>
						<a href="" class="hibachi-report-date-group btn btn-xs btn-default<cfif attributes.report.getReportDateTimeGroupBy() eq 'week'> activated</cfif>" data-groupby="week">Week</a>
						<a href="" class="hibachi-report-date-group btn btn-xs btn-default<cfif attributes.report.getReportDateTimeGroupBy() eq 'month'> activated</cfif>" data-groupby="month">Month</a>
						<a href="" class="hibachi-report-date-group btn btn-xs btn-default<cfif attributes.report.getReportDateTimeGroupBy() eq 'year'> activated</cfif>" data-groupby="year">Year</a>
						<button class="hibachi-report-date-group btn btn-xs btn-default">Custom</button>
					</div>
				</div>
				<div style="margin-bottom: 20px; width: 300px;">
					<cfset siteCollectionList = attributes.hibachiScope.getService('siteService').getSiteCollectionList() />
					<cfset siteCollectionList.setDisplayProperties('siteID,siteName', { isVisible=true }) />
					<h4>Site</h4>
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
		</cfform>
	</cfoutput>
</cfif>