<cfcomponent accessors="true" persistent="false" output="false" extends="HibachiTransient">
	
	<!--- Title Information --->
	<cfproperty name="reportTitle" />
	
	<!--- Date / Time Properties --->
	<cfproperty name="reportStartDateTime" hb_formatType="date" />
	<cfproperty name="reportEndDateTime" hb_formatType="date" />
	<cfproperty name="reportCompareStartDateTime" hb_formatType="date" />
	<cfproperty name="reportCompareEndDateTime" hb_formatType="date" />
	<cfproperty name="reportDateTimeGroupBy" />
	<cfproperty name="reportDateTimeDataColumn" />
	<cfproperty name="reportCompareFlag" />
	
	<!--- Definition Properties --->
	<cfproperty name="metricDefinitions" />
	<cfproperty name="dimensionDefinitions" />
	<cfproperty name="reportDateTimeDefinitions" />
	
	<!--- Metric / Dimension States --->
	<cfproperty name="metrics" />
	<cfproperty name="dimensions" />
	<cfproperty name="reportDateTime" />
	
	<!--- Data Properties & Queries ---> 
	<cfproperty name="data" />
	<cfproperty name="chartDataQuery" />
	<cfproperty name="chartData" />
	<cfproperty name="tableDataQuery" />
	
	<!--- Rendered Data Properties --->
	<cfproperty name="reportDataTable" />
	
	<!--- Title Methods --->
	<cffunction name="getReportTitle">
		<cfreturn rbKey('report.#getClassName()#') />
	</cffunction>
	
	<cffunction name="getMetricTitle">
		<cfargument name="alias" type="string" required="true" />
		
		<cfset var metricDefinition = {} />
		
		<cfloop array="#getMetricDefinitions()#" index="metricDefinition">
			<cfif metricDefinition.alias eq arguments.alias and structKeyExists(metricDefinition, 'title')>
				<cfreturn metricDefinition.title />
			</cfif>
		</cfloop>
		
		<cfreturn rbKey('report.#getClassName()#.#alias#') />
	</cffunction>
	
	<cffunction name="getDimensionTitle">
		<cfargument name="alias" type="string" required="true" />
		
		<cfset var dimensionDefinition = {} />
		
		<cfloop array="#getDimensionDefinitions()#" index="dimensionDefinition">
			<cfif dimensionDefinition.alias eq arguments.alias and structKeyExists(dimensionDefinition, 'title')>
		 		<cfreturn dimensionDefinition.title />
			</cfif>
		</cfloop>
		
		<cfreturn rbKey('report.#getClassName()#.#alias#') />
	</cffunction>
	
	
	<cffunction name="getReportDateTimeTitle">
		<cfargument name="alias" type="string" required="true" />
		
		<cfset var reportDateTimeDefinition = {} />
		
		<cfloop array="#getReportDateTimeDefinitions()#" index="reportDateTimeDefinition">
			<cfif reportDateTimeDefinition.alias eq arguments.alias and structKeyExists(reportDateTimeDefinition, 'title')>
		 		<cfreturn reportDateTimeDefinition.title />
			</cfif>
		</cfloop>
		
		<cfreturn rbKey('report.#getClassName()#.#alias#') />
	</cffunction>
	
	<!--- Format Type Methods --->
	<cffunction name="getAliasFormatType">
		<cfargument name="alias" type="string" required="true" />
		
		<cfif not structKeyExists(variables, "aliasFormatType#arguments.alias#")>
			<cfset variables[ "aliasFormatType#arguments.alias#" ] = "" />
			
			<!--- Check Dimensions --->
			<cfloop array="#getDimensionDefinitions()#" index="dimensionDefinition">
				<cfif dimensionDefinition.alias eq arguments.alias and structKeyExists(dimensionDefinition, 'formatType')>
					<cfset variables[ "aliasFormatType#arguments.alias#" ] = dimensionDefinition.formatType />
					<cfreturn variables[ "aliasFormatType#arguments.alias#" ] />
				<cfelseif dimensionDefinition.alias eq arguments.alias>
					<cfbreak />
				</cfif>
			</cfloop>
			
			<!--- Check Metrics --->
			<cfloop array="#getMetricDefinitions()#" index="metricDefinition">
				<cfif metricDefinition.alias eq arguments.alias and structKeyExists(metricDefinition, 'formatType')>
					<cfset variables[ "aliasFormatType#arguments.alias#" ] = metricDefinition.formatType />
					<cfreturn variables[ "aliasFormatType#arguments.alias#" ] />
				<cfelseif metricDefinition.alias eq arguments.alias>
					<cfbreak />
				</cfif>
			</cfloop>
		</cfif>
		
		<cfreturn variables[ "aliasFormatType#arguments.alias#" ] />
	</cffunction>
	
	<!--- Date / Time Defaults --->
	<cffunction name="getReportStartDateTime">
		<cfif not structKeyExists(variables, "reportStartDateTime")>
			<cfset variables.reportStartDateTime = dateFormat(now() - 30, "yyyy-mm-dd") />
		</cfif>
		<cfreturn dateFormat(variables.reportStartDateTime,"yyyy-mm-dd") />
	</cffunction>
	
	<cffunction name="getReportEndDateTime">
		<cfif not structKeyExists(variables, "reportEndDateTime")>
			<cfset variables.reportEndDateTime = dateFormat(now(), "yyyy-mm-dd") />
		</cfif>
		<cfreturn dateFormat(variables.reportEndDateTime,"yyyy-mm-dd") />
	</cffunction>
	
	<cffunction name="getReportCompareStartDateTime">
		<cfif not structKeyExists(variables, "reportCompareStartDateTime")>
			<cfset variables.reportCompareStartDateTime = dateFormat(getReportCompareEndDateTime() - 30, "yyyy-mm-dd") />
		</cfif>
		<cfreturn dateFormat(variables.reportCompareStartDateTime,"yyyy-mm-dd") />
	</cffunction>
	
	<cffunction name="getReportCompareEndDateTime">
		<cfif not structKeyExists(variables, "reportCompareEndDateTime")>
			<cfset variables.reportCompareEndDateTime = dateFormat(getReportStartDateTime()-1, "yyyy-mm-dd") />
		</cfif>
		<cfreturn dateFormat(variables.reportCompareEndDateTime,"yyyy-mm-dd") />
	</cffunction>
	
	<cffunction name="getReportDateTimeGroupBy">
		<cfif not structKeyExists(variables, "reportDateTimeGroupBy")>
			<cfset variables.reportDateTimeGroupBy = "day" />
		</cfif>
		<cfreturn variables.reportDateTimeGroupBy />
	</cffunction>
	
	<cffunction name="getReportCompareFlag">
		<cfif not structKeyExists(variables, "reportCompareFlag")>
			<cfset variables.reportCompareFlag = 0 />
		</cfif>
		<cfreturn variables.reportCompareFlag />
	</cffunction>
	
	<!--- Date / Time Helpers --->
	<cffunction name="getReportDateTimeSelect">
		<cfset var reportDateTimeSelect="" />
		<cfsavecontent variable="reportDateTimeSelect">
			<cfoutput>
				<cfif getApplicationValue('databaseType') eq "MySQL">
					YEAR( #getReportDateTimeDefinition(getReportDateTime())['dataColumn']# ) as reportDateTimeYear,
					MONTH( #getReportDateTimeDefinition(getReportDateTime())['dataColumn']# ) as reportDateTimeMonth,
					WEEK( #getReportDateTimeDefinition(getReportDateTime())['dataColumn']# ) as reportDateTimeWeek,
					DAY( #getReportDateTimeDefinition(getReportDateTime())['dataColumn']# ) as reportDateTimeDay,
					HOUR( #getReportDateTimeDefinition(getReportDateTime())['dataColumn']# ) as reportDateTimeHour
				<cfelse>
					DATEPART( year, #getReportDateTimeDefinition(getReportDateTime())['dataColumn']# ) as reportDateTimeYear,
					DATEPART( month, #getReportDateTimeDefinition(getReportDateTime())['dataColumn']# ) as reportDateTimeMonth,
					DATEPART( week, #getReportDateTimeDefinition(getReportDateTime())['dataColumn']# ) as reportDateTimeWeek,
					DATEPART( day, #getReportDateTimeDefinition(getReportDateTime())['dataColumn']# ) as reportDateTimeDay,
					DATEPART( hour, #getReportDateTimeDefinition(getReportDateTime())['dataColumn']# ) as reportDateTimeHour  
				</cfif>
			</cfoutput>
		</cfsavecontent>
		<cfreturn reportDateTimeSelect />
	</cffunction>
	
	<cffunction name="getReportDateTimeWhere">
		<cfset var reportDateTimeWhere="" />
		
		<cfset var startDateTime = replace(replace(createDateTime(dateFormat(getReportStartDateTime(), "yyyy"),datePart("m" , getReportStartDateTime()),datePart("d" , getReportStartDateTime()),0,0,0), '{ts', ''),'}','') />
		<cfset var endDateTime = replace(replace(createDateTime(dateFormat(getReportEndDateTime(), "yyyy"),datePart("m" , getReportEndDateTime()),datePart("d" , getReportEndDateTime()),23,59,59), '{ts', ''),'}','') />
		<cfset var compareStartDateTime = replace(replace(createDateTime(dateFormat(getReportCompareStartDateTime(), "yyyy"),datePart("m" , getReportCompareStartDateTime()),datePart("d" , getReportCompareStartDateTime()),0,0,0), '{ts', ''),'}','') />
		<cfset var compareEndDateTime = replace(replace(createDateTime(dateFormat(getReportCompareEndDateTime(), "yyyy"),datePart("m" , getReportCompareEndDateTime()),datePart("d" , getReportCompareEndDateTime()),23,59,59), '{ts', ''),'}','') />
		<cfsavecontent variable="reportDateTimeWhere">
			<cfoutput>
				(
					(#getReportDateTimeDefinition(getReportDateTime())['dataColumn']# >= #startDateTime# AND #getReportDateTimeDefinition(getReportDateTime())['dataColumn']# <= #endDateTime#)
					<cfif getReportCompareFlag()>
						OR (#getReportDateTimeDefinition(getReportDateTime())['dataColumn']# >= #compareStartDateTime# AND #getReportDateTimeDefinition(getReportDateTime())['dataColumn']# <= #compareEndDateTime#)
					</cfif>
				)
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn reportDateTimeWhere />
	</cffunction>
	
	<!--- Definition Defaults --->
	<cffunction name="getMetricDefinitions">
		<cfreturn [] />
	</cffunction>
	
	<cffunction name="getDimensionDefinitions">
		<cfreturn [] />
	</cffunction>
	
	<cffunction name="getReportDateTimeDefinitions">
		<cfreturn [] />
	</cffunction>
	
	<!--- Definition Helper Methods --->
	<cffunction name="getMetricDefinition">
		<cfargument name="alias" type="string" required="true" />
		
		<cfset var metricDefinition = structNew() />
		
		<cfloop array="#getMetricDefinitions()#" index="metricDefinition">
			<cfif metricDefinition.alias eq arguments.alias>
				<cfreturn metricDefinition />
			</cfif>
		</cfloop>
	</cffunction>
	
	<cffunction name="getDimensionDefinition">
		<cfargument name="alias" type="string" required="true" />
		
		<cfset var dimensionDefinition = structNew() />
		
		<cfloop array="#getDimensionDefinitions()#" index="dimensionDefinition">
			<cfif dimensionDefinition.alias eq arguments.alias>
				<cfreturn dimensionDefinition />
			</cfif>
		</cfloop>
	</cffunction>
	
	<cffunction name="getReportDateTimeDefinition">
		<cfargument name="alias" type="string" required="true" />
		
		<cfset var reportDateTimeDefinition = structNew() />
		
		<cfloop array="#getReportDateTimeDefinitions()#" index="reportDateTimeDefinition">
			<cfif reportDateTimeDefinition.alias eq arguments.alias>
				<cfreturn reportDateTimeDefinition />
			</cfif>
		</cfloop>
	</cffunction>
	
	<!--- Metric / Dimension / ReportDateTime State Defaults --->
	<cffunction name="getMetrics">
		<cfif not structKeyExists(variables, "metrics")>
			<cfset variables.metrics = getMetricDefinitions()[1].alias />
		</cfif>
		<cfreturn variables.metrics />
	</cffunction>
	
	<cffunction name="getDimensions">
		<cfif not structKeyExists(variables, "dimensions")>
			<cfset variables.dimensions = getDimensionDefinitions()[1].alias />
		</cfif>
		<cfreturn variables.dimensions />
	</cffunction>
	
	<cffunction name="getReportDateTime">
		<cfif not structKeyExists(variables, "reportDateTime")>
			<cfset variables.reportDateTime = getReportDateTimeDefinitions()[1].alias />
		</cfif>
		<cfreturn variables.reportDateTime />
	</cffunction>
	
	<!--- Data / Query Methods --->
	<cffunction name="getChartDataQuery">
		<cfif not structKeyExists(variables, "chartDataQuery")>
			
			<cfset var m = 1 />
			<cfset var data = getData() />
			
			<cfquery name="variables.chartDataQuery" dbtype="query">
				SELECT
					<cfloop from="1" to="#listLen(getMetrics())#" step="1" index="m">
						<cfset var metricDefinition = getMetricDefinition( listGetAt(getMetrics(), m) ) />
						<cfif m gt 1>,</cfif>
						<cfif structKeyExists(metricDefinition, "calculation")>
							#metricDefinition.calculation# as #metricDefinition.alias#
						<cfelse>
							#metricDefinition.function#(#metricDefinition.alias#) as #metricDefinition.alias#
						</cfif>
					</cfloop>
					<cfif listFindNoCase('year,month,week,day,hour', getReportDateTimeGroupBy())>
						,data.reportDateTimeYear
					</cfif>
					<cfif listFindNoCase('month,week,day,hour', getReportDateTimeGroupBy())>
						,data.reportDateTimeMonth
					</cfif>
					<cfif listFindNoCase('week,day,hour', getReportDateTimeGroupBy())>
						,data.reportDateTimeWeek
					</cfif>
					<cfif listFindNoCase('day,hour', getReportDateTimeGroupBy())>
						,data.reportDateTimeDay
					</cfif>
					<cfif listFindNoCase('hour', getReportDateTimeGroupBy())>
						,data.reportDateTimeHour
					</cfif>
				FROM
					data
				GROUP BY
					<cfif listFindNoCase('year,month,week,day,hour', getReportDateTimeGroupBy())>
						data.reportDateTimeYear
					</cfif>
					<cfif listFindNoCase('month,week,day,hour', getReportDateTimeGroupBy())>
						,data.reportDateTimeMonth
					</cfif>
					<cfif listFindNoCase('week,day,hour', getReportDateTimeGroupBy())>
						,data.reportDateTimeWeek
					</cfif>
					<cfif listFindNoCase('day,hour', getReportDateTimeGroupBy())>
						,data.reportDateTimeDay
					</cfif>
					<cfif listFindNoCase('hour', getReportDateTimeGroupBy())>
						,data.reportDateTimeHour
					</cfif>
				ORDER BY
					<cfif listFindNoCase('year,month,week,day,hour', getReportDateTimeGroupBy())>
						data.reportDateTimeYear
					</cfif>
					<cfif listFindNoCase('month,week,day,hour', getReportDateTimeGroupBy())>
						,data.reportDateTimeMonth
					</cfif>
					<cfif listFindNoCase('week,day,hour', getReportDateTimeGroupBy())>
						,data.reportDateTimeWeek
					</cfif>
					<cfif listFindNoCase('day,hour', getReportDateTimeGroupBy())>
						,data.reportDateTimeDay
					</cfif>
					<cfif listFindNoCase('hour', getReportDateTimeGroupBy())>
						,data.reportDateTimeHour
					</cfif>
			</cfquery>
		</cfif>
		
		<cfreturn variables.chartDataQuery />
	</cffunction>
	
	<cffunction name="getTotalsQuery">
		<cfif not structKeyExists(variables, "totalsQuery")>
			
			<cfset var m = 1 />
			<cfset var data = getData() />
			
			<cfquery name="variables.totalsQuery" dbtype="query">
				SELECT
					<cfloop from="1" to="#listLen(getMetrics())#" step="1" index="m">
						<cfset var metricDefinition = getMetricDefinition( listGetAt(getMetrics(), m) ) />
						<cfif m gt 1>,</cfif>
						<cfif structKeyExists(metricDefinition, "calculation")>
							#metricDefinition.calculation# as #metricDefinition.alias#
						<cfelse>
							#metricDefinition.function#(#metricDefinition.alias#) as #metricDefinition.alias#
						</cfif>
					</cfloop>
				FROM
					data
			</cfquery>
		</cfif>
		
		<cfreturn variables.totalsQuery />
	</cffunction>
	
	<cffunction name="getChartData">
		<cfif not structKeyExists(variables, "chartData")>
			
			<cfset var chartDataQuery = getChartDataQuery() />
			<cfset var chartDataStruct = structNew() />
			
			<cfset var thisDate = "" />
			<cfset var m = 1 />
			<cfset var loopdatepart = "d" />
			
			<cfif getReportDateTimeGroupBy() eq 'year'>
				<cfset loopdatepart = "yyyy" />
			<cfelseif getReportDateTimeGroupBy() eq 'month'>
				<cfset loopdatepart = "m" />
			<cfelseif getReportDateTimeGroupBy() eq 'week'>
				<cfset loopdatepart = "ww" />
			<cfelseif getReportDateTimeGroupBy() eq 'hour'>
				<cfset loopdatepart = "h" />	
			</cfif>
			
			<cfset variables.chartData = {} />
			<cfset variables.chartData["chart"] = {} />
			<cfset variables.chartData["chart"]["type"] = "line" />
			<cfset variables.chartData["legend"] = {} />
			<cfset variables.chartData["legend"]["enabled"] = false />
			<cfset variables.chartData["title"] = {} />
			<cfset variables.chartData["title"]["text"] = getReportTitle() />
			<cfset variables.chartData["xAxis"] = {} />
			<cfset variables.chartData["xAxis"]["type"] = "datetime" />
			<cfset variables.chartData["yAxis"] = {} />
			<cfset variables.chartData["yAxis"]["title"] = {} />
			<cfset variables.chartData["yAxis"]["title"]["text"] = '' />
			<cfset variables.chartData["series"] = [] />
			
			<cfloop from="1" to="#listLen(getMetrics())#" step="1" index="m">
				<cfset var metricDefinition = getMetricDefinition( listGetAt(getMetrics(), m) ) />
				
				<cfset arrayAppend(variables.chartData["series"], {})>
				<cfset variables.chartData["series"][m]["name"] = getMetricTitle(metricDefinition.alias) />
				<cfset variables.chartData["series"][m]["data"] = [] />
				
				<cfset var chartRow = 1 />
				
				<cf_HibachiDateLoop index="thisDate" from="#getReportStartDateTime()#" to="#getReportEndDateTime()#" datepart="#loopdatepart#">
					<cfset var thisData = [] />
					<cfset arrayAppend(thisData, dateDiff("s", createdatetime( '1970','01','01','00','00','00' ), dateAdd("h", 1, thisDate))*1000) />
					<cfif year(thisDate) eq chartDataQuery['reportDateTimeYear'][chartRow] and 
							(!listFindNoCase('month,week,day,hour', getReportDateTimeGroupBy()) or month(thisDate) eq chartDataQuery['reportDateTimeMonth'][chartRow]) and
							(!listFindNoCase('week,day,hour', getReportDateTimeGroupBy()) or (week(thisDate) - 1) eq chartDataQuery['reportDateTimeWeek'][chartRow]) and
							(!listFindNoCase('day,hour', getReportDateTimeGroupBy()) or day(thisDate) eq chartDataQuery['reportDateTimeDay'][chartRow]) and
							(!listFindNoCase('hour', getReportDateTimeGroupBy()) or hour(thisDate) eq chartDataQuery['reportDateTimeHour'][chartRow])>
						<cfset arrayAppend(thisData, chartDataQuery[ metricDefinition.alias ][ chartRow ]) />
						<cfset chartRow ++ />
					<cfelse>
						<cfset arrayAppend(thisData, 0) />
					</cfif>
					<cfset arrayAppend(variables.chartData["series"][m]["data"], thisData) />
				</cf_HibachiDateLoop>
			</cfloop>
		</cfif>
		
		<cfreturn variables.chartData />
	</cffunction>
	
	<cffunction name="getTableDataQuery">
		<cfif not structKeyExists(variables, "tableDataQuery")>
			
			<cfset var data = getData() />
			<cfset var unsortedData = "" />
			<cfset var m = 1 />
			<cfset var d = 1 />
			
			<cfquery name="unsortedData" dbtype="query">
				SELECT
					<cfloop from="1" to="#listLen(getMetrics())#" step="1" index="m">
						<cfset var metricDefinition = getMetricDefinition( listGetAt(getMetrics(), m) ) />
						<cfif m gt 1>,</cfif>
						<cfif structKeyExists(metricDefinition, "calculation")>
							#metricDefinition.calculation# as #metricDefinition.alias#
						<cfelse>
							#metricDefinition.function#(#metricDefinition.alias#) as #metricDefinition.alias#
						</cfif>
					</cfloop>
					<cfloop from="1" to="#listLen(getDimensions())#" step="1" index="d">
						<cfset var dimensionDefinition = getDimensionDefinition( listGetAt(getDimensions(), d) ) />
						,#dimensionDefinition.alias#
						<cfif structKeyExists(dimensionDefinition, "filterAlias")>
							,#dimensionDefinition.filterAlias#
						</cfif>
					</cfloop>
				FROM
					data
				GROUP BY
					<cfloop from="1" to="#listLen(getDimensions())#" step="1" index="d">
						<cfset var dimensionDefinition = getDimensionDefinition( listGetAt(getDimensions(), d) ) />
						<cfif d gt 1>,</cfif>
						#dimensionDefinition.alias#
						<cfif structKeyExists(dimensionDefinition, "filterAlias")>
							,#dimensionDefinition.filterAlias#
						</cfif>
					</cfloop>
			</cfquery>
			
			<cfquery name="variables.tableDataQuery" dbtype="query">
				SELECT
					*
				FROM
					unsortedData
				ORDER BY
					<cfloop from="1" to="#listLen(getMetrics())#" step="1" index="m">
						<cfset var metricDefinition = getMetricDefinition( listGetAt(getMetrics(), m) ) />
						<cfif m gt 1>,</cfif>#metricDefinition.alias# DESC
					</cfloop>
			</cfquery>
		</cfif>
		
		<cfreturn variables.tableDataQuery />
	</cffunction>
	
	<cffunction name="getReportDataTable">
		<cfif(!structKeyExists(variables, "reportDataTable"))>
			<cfsavecontent variable="variables.reportDataTable">
				<cf_HibachiReportDataTable report="#this#">
			</cfsavecontent>
		</cfif>
		
		<cfreturn variables.reportDataTable />
	</cffunction>
	
	<cffunction name="getReportConfigureBar">
		<cfif(!structKeyExists(variables, "reportConfigureBar"))>
			<cfsavecontent variable="variables.reportConfigureBar">
				<cf_HibachiReportConfigureBar report="#this#">
			</cfsavecontent>
		</cfif>
		
		<cfreturn variables.reportConfigureBar />
	</cffunction>
</cfcomponent>