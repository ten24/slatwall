<cfimport prefix="hb" taglib="./HibachiTags" />

<cfcomponent accessors="true" persistent="false" output="false" extends="HibachiTransient">

	<!--- Title Information --->
	<cfproperty name="reportTitle" />
	<cfproperty name="reportEntity" />

	<!--- Date / Time Properties --->
	<cfproperty name="reportStartDateTime" hb_formatType="date" />
	<cfproperty name="reportEndDateTime" hb_formatType="date" />
	<cfproperty name="reportCompareStartDateTime" hb_formatType="date" />
	<cfproperty name="reportCompareEndDateTime" hb_formatType="date" />
	<cfproperty name="reportDateTimeGroupBy" />
	<cfproperty name="reportCompareFlag" />

	<!--- Definition Properties --->
	<cfproperty name="metricDefinitions" />
	<cfproperty name="dimensionDefinitions" />
	<cfproperty name="orderByType" />
	<cfproperty name="reportDateTimeDefinitions" />
	<cfproperty name="reportType" />
	<cfproperty name="limitResults" />
	<cfproperty name="showReport" />

	<!--- Metric / Dimension States --->
	<cfproperty name="metrics" />
	<cfproperty name="dimensions" />
	<cfproperty name="reportDateTime" />

	<!--- Data Properties & Queries --->
	<cfproperty name="data" />
	<cfproperty name="chartDataQuery" />
	<cfproperty name="chartData" />
	<cfproperty name="tableDataQuery" />

	<!--- Paging --->
	<cfproperty name="currentPage"  />
	<cfproperty name="pageShow" />
	<cfproperty name="dataTableStartRow" />
	<cfproperty name="dataTableEndRow" />

	<!--- Rendered Data Properties --->
	<cfproperty name="reportDataTable" />

	<!--- Currency Code --->
	<cfproperty name="currencyCode" />

	<cffunction name="getLimitResults" access="public" output="false">
		<cfif not structKeyExists(variables, "limitResults")>
			<cfset variables.limitResults = 0 />
		</cfif>
		<cfreturn variables.limitResults />
	</cffunction>

	<cffunction name="getShowReport" access="public" output="false">
		<cfif not structKeyExists(variables, "showReport")>
			<cfset variables.showReport = false />
		</cfif>
		<cfreturn variables.showReport />
	</cffunction>

	<cffunction name="getCurrentPage" access="public" output="false">
		 <cfif not structKeyExists(variables, "currentPage")>
		 	<cfset variables.currentPage = 1 />
		 </cfif>

		 <cfreturn variables.currentPage />
	</cffunction>

	<cffunction name="getPageShow" access="public" output="false">
		 <cfif not structKeyExists(variables, "pageShow")>
		 	<cfset variables.pageShow = 25 />
		 </cfif>

		 <cfreturn variables.pageShow />
	</cffunction>

	<cffunction name="getDataTableStartRow" access="public" output="false">
		 <cfreturn ((getCurrentPage() * getPageShow()) - getPageShow()) + 1 />
	</cffunction>

	<cffunction name="getDataTableEndRow" access="public" output="false">
		 <cfreturn getDataTableStartRow() + getPageShow() - 1 />
	</cffunction>


	<!--- Currency Code Method --->
	<cffunction name="getCurrencyCode" access="public" output="false">
		<cfreturn 'USD' />
	</cffunction>

	<!--- Format Type Method --->
	<cffunction name="getAliasFormatType" access="public" output="false">
		<cfargument name="alias" type="string" required="true" />

		<cfif not structKeyExists(variables, "aliasFormatType#arguments.alias#")>
			<cfset variables[ "aliasFormatType#arguments.alias#" ] = "" />

			<!--- Check Dimensions --->
			<cfloop array="#getDimensionDefinitions()#" index="local.dimensionDefinition">
				<cfif dimensionDefinition.alias eq arguments.alias and structKeyExists(dimensionDefinition, 'formatType')>
					<cfset variables[ "aliasFormatType#arguments.alias#" ] = dimensionDefinition.formatType />
					<cfreturn variables[ "aliasFormatType#arguments.alias#" ] />
				<cfelseif dimensionDefinition.alias eq arguments.alias>
					<cfbreak />
				</cfif>
			</cfloop>

			<!--- Check Metrics --->
			<cfloop array="#getMetricDefinitions()#" index="local.metricDefinition">
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

	<!--- ================= START: QUERY HELPER METHODS ====================== --->

	<cffunction name="getReportDateTimeSelect" access="public" output="false">
		<cfset var reportDateTimeSelect="" />
		<cfsavecontent variable="reportDateTimeSelect">
			<cfoutput>
				<cfif getApplicationValue('databaseType') eq "MySQL">
					#getReportDateTimeDefinition(getReportDateTime())['dataColumn']# as reportDateTime,
					YEAR( #getReportDateTimeDefinition(getReportDateTime())['dataColumn']# ) as reportDateTimeYear,
					MONTH( #getReportDateTimeDefinition(getReportDateTime())['dataColumn']# ) as reportDateTimeMonth,
					WEEK( #getReportDateTimeDefinition(getReportDateTime())['dataColumn']# ) + 1 as reportDateTimeWeek,
					DAY( #getReportDateTimeDefinition(getReportDateTime())['dataColumn']# ) as reportDateTimeDay,
					HOUR( #getReportDateTimeDefinition(getReportDateTime())['dataColumn']# ) as reportDateTimeHour
				<cfelseif getApplicationValue('databaseType') eq "Oracle10g">
					#getReportDateTimeDefinition(getReportDateTime())['dataColumn']# as reportDateTime,
					TO_CHAR( #getReportDateTimeDefinition(getReportDateTime())['dataColumn']#, 'YYYY' ) as reportDateTimeYear,
					TO_CHAR( #getReportDateTimeDefinition(getReportDateTime())['dataColumn']#, 'MM' ) as reportDateTimeMonth,
					TO_CHAR( #getReportDateTimeDefinition(getReportDateTime())['dataColumn']#, 'WW' ) as reportDateTimeWeek,
					TO_CHAR( #getReportDateTimeDefinition(getReportDateTime())['dataColumn']#, 'DD' ) as reportDateTimeDay,
					TO_CHAR( #getReportDateTimeDefinition(getReportDateTime())['dataColumn']#, 'HH24' ) as reportDateTimeHour
				<cfelse>
					#getReportDateTimeDefinition(getReportDateTime())['dataColumn']# as reportDateTime,
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

	<cffunction name="getReportDateTimeWhere" access="public" output="false">
		<cfset var reportDateTimeWhere="" />

		<cfset var startDateTime = createDateTime(dateFormat(getReportStartDateTime(), "yyyy"),datePart("m" , getReportStartDateTime()),datePart("d" , getReportStartDateTime()),0,0,0) />
		<cfset var endDateTime = createDateTime(dateFormat(getReportEndDateTime(), "yyyy"),datePart("m" , getReportEndDateTime()),datePart("d" , getReportEndDateTime()),23,59,59) />
		<cfset var compareStartDateTime = createDateTime(dateFormat(getReportCompareStartDateTime(), "yyyy"),datePart("m" , getReportCompareStartDateTime()),datePart("d" , getReportCompareStartDateTime()),0,0,0) />
		<cfset var compareEndDateTime = createDateTime(dateFormat(getReportCompareEndDateTime(), "yyyy"),datePart("m" , getReportCompareEndDateTime()),datePart("d" , getReportCompareEndDateTime()),23,59,59) />

		<cfif getApplicationValue('databaseType') neq "Oracle10g">
			<cfset startDateTime = replace(replace(startDateTime, '{ts', ''),'}','') />
			<cfset endDateTime = replace(replace(endDateTime, '{ts', ''),'}','') />
			<cfset compareStartDateTime = replace(replace(compareStartDateTime, '{ts', ''),'}','') />
			<cfset compareEndDateTime = replace(replace(compareEndDateTime, '{ts', ''),'}','') />
		</cfif>

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

	<!--- =================  END: QUERY HELPER METHODS ======================= --->

	<!--- ================= START: TITLE HELPER METHODS ====================== --->

	<cffunction name="getReportTitle" access="public" output="false">
		<cfif not isNull(getReportEntity())>
			<cfreturn getReportEntity().getReportTitle() & " - " & rbKey('report.#getClassName()#') />
		</cfif>

		<cfreturn rbKey('report.#getClassName()#') />
	</cffunction>

	<cffunction name="getMetricTitle" access="public" output="false">
		<cfargument name="alias" type="string" required="true" />

		<cfset var metricDefinition = {} />

		<cfloop array="#getMetricDefinitions()#" index="local.metricDefinition">
			<cfif metricDefinition.alias eq arguments.alias and structKeyExists(metricDefinition, 'title')>
				<cfreturn metricDefinition.title />
			</cfif>
		</cfloop>

		<cfreturn rbKey('report.#getClassName()#.#alias#') />
	</cffunction>

	<cffunction name="getDimensionTitle" access="public" output="false">
		<cfargument name="alias" type="string" required="true" />

		<cfset var dimensionDefinition = {} />

		<cfloop array="#getDimensionDefinitions()#" index="local.dimensionDefinition">
			<cfif dimensionDefinition.alias eq arguments.alias and structKeyExists(dimensionDefinition, 'title')>
		 		<cfreturn dimensionDefinition.title />
			</cfif>
		</cfloop>

		<cfreturn rbKey('report.#getClassName()#.#alias#') />
	</cffunction>

	<cffunction name="getReportDateTimeTitle" access="public" output="false">
		<cfargument name="alias" type="string" required="true" />

		<cfset var reportDateTimeDefinition = {} />

		<cfloop array="#getReportDateTimeDefinitions()#" index="local.reportDateTimeDefinition">
			<cfif reportDateTimeDefinition.alias eq arguments.alias and structKeyExists(reportDateTimeDefinition, 'title')>
		 		<cfreturn reportDateTimeDefinition.title />
			</cfif>
		</cfloop>

		<cfreturn rbKey('report.#getClassName()#.#alias#') />
	</cffunction>

	<!--- =================  END: TITLE HELPER METHODS ======================= --->

	<!--- ================== START: DEFINITION METHODS ======================= --->

	<cffunction name="getMetricDefinitions" access="public" output="false">
		<cfreturn [] />
	</cffunction>

	<cffunction name="getDimensionDefinitions" access="public" output="false">
		<cfreturn [] />
	</cffunction>

	<cffunction name="getReportDateTimeDefinitions" access="public" output="false">
		<cfreturn [] />
	</cffunction>

	<cffunction name="getMetricDefinition" access="public" output="false">
		<cfargument name="alias" type="string" required="true" />

		<cfset var metricDefinition = structNew() />

		<cfloop array="#getMetricDefinitions()#" index="local.metricDefinition">
			<cfif metricDefinition.alias eq arguments.alias>
				<cfreturn metricDefinition />
			</cfif>
		</cfloop>

		<cfreturn getMetricDefinitions()[1] />
	</cffunction>

	<cffunction name="getDimensionDefinition" access="public" output="false">
		<cfargument name="alias" type="string" required="true" />

		<cfset var dimensionDefinition = structNew() />

		<cfloop array="#getDimensionDefinitions()#" index="local.dimensionDefinition">
			<cfif dimensionDefinition.alias eq arguments.alias>
				<cfreturn dimensionDefinition />
			</cfif>
		</cfloop>

		<cfreturn getDimensionDefinitions()[1] />
	</cffunction>

	<cffunction name="getReportDateTimeDefinition" access="public" output="false">
		<cfargument name="alias" type="string" required="true" />

		<cfset var reportDateTimeDefinition = structNew() />

		<cfloop array="#getReportDateTimeDefinitions()#" index="local.reportDateTimeDefinition">
			<cfif reportDateTimeDefinition.alias eq arguments.alias>
				<cfreturn reportDateTimeDefinition />
			</cfif>
		</cfloop>

		<cfreturn getReportDateTimeDefinitions()[1] />
	</cffunction>

	<!--- ==================  END: DEFINITION METHODS ======================== --->

	<!--- ================== START: DATE/TIME DEFAULTS ======================= --->

	<cffunction name="getReportStartDateTime" access="public" output="false">
		<cfif not structKeyExists(variables, "reportStartDateTime")>
			<cfset variables.reportStartDateTime = dateFormat(now() - 30, "yyyy-mm-dd") />
		</cfif>
		<cfreturn dateFormat(variables.reportStartDateTime,"yyyy-mm-dd") />
	</cffunction>

	<cffunction name="getReportEndDateTime" access="public" output="false">
		<cfif not structKeyExists(variables, "reportEndDateTime")>
			<cfset variables.reportEndDateTime = dateFormat(now(), "yyyy-mm-dd") />
		</cfif>
		<cfreturn dateFormat(variables.reportEndDateTime,"yyyy-mm-dd") />
	</cffunction>

	<cffunction name="getReportCompareStartDateTime" access="public" output="false">
		<cfif not structKeyExists(variables, "reportCompareStartDateTime")>
			<cfset variables.reportCompareStartDateTime = dateFormat(getReportCompareEndDateTime() - dateDiff("d", getReportStartDateTime(), getReportEndDateTime()), "yyyy-mm-dd") />
		</cfif>
		<cfreturn dateFormat(variables.reportCompareStartDateTime,"yyyy-mm-dd") />
	</cffunction>

	<cffunction name="getReportCompareEndDateTime" access="public" output="false">
		<cfif not structKeyExists(variables, "reportCompareEndDateTime")>
			<cfset variables.reportCompareEndDateTime = dateFormat(dateAdd("d", -1, getReportStartDateTime()), "yyyy-mm-dd") />
		</cfif>
		<cfreturn dateFormat(variables.reportCompareEndDateTime,"yyyy-mm-dd") />
	</cffunction>

	<cffunction name="getReportDateTimeGroupBy" access="public" output="false">
		<cfif not structKeyExists(variables, "reportDateTimeGroupBy")>
			<cfset variables.reportDateTimeGroupBy = "day" />
		</cfif>
		<cfreturn variables.reportDateTimeGroupBy />
	</cffunction>

	<cffunction name="getReportCompareFlag" access="public" output="false">
		<cfif not structKeyExists(variables, "reportCompareFlag")>
			<cfset variables.reportCompareFlag = 0 />
		</cfif>
		<cfreturn variables.reportCompareFlag />
	</cffunction>

	<!--- ==================  END: DATE/TIME DEFAULTS ======================== --->

	<!--- ================== START: SELECTION DEFAULTS ======================= --->

	<cffunction name="getMetrics" access="public" output="false">
		<cfif not structKeyExists(variables, "metrics")>
			<cfset variables.metrics = getMetricDefinitions()[1].alias />
		</cfif>
		<cfreturn variables.metrics />
	</cffunction>

	<cffunction name="getDimensions" access="public" output="false">
		<cfif not structKeyExists(variables, "dimensions")>
			<cfset variables.dimensions = getDimensionDefinitions()[1].alias />
		</cfif>
		<cfreturn variables.dimensions />
	</cffunction>

	<cffunction name="getReportDateTime" access="public" output="false">
		<cfif not structKeyExists(variables, "reportDateTime")>
			<cfset variables.reportDateTime = getReportDateTimeDefinitions()[1].alias />
		</cfif>
		<cfreturn variables.reportDateTime />
	</cffunction>

	<!--- ==================  END: SELECTION DEFAULTS ======================== --->

	<!--- ==================== START: CHART FUNCTIONS ======================== --->

	<cffunction name="getChartDataQuery" access="public" output="false">
		<cfif not structKeyExists(variables, "chartDataQuery")>

			<cfset var m = 1 />
			<cfset var data = getData() />
			<cfset var reportEndDateTimePlusOne = dateAdd("d", 1, getReportEndDateTime()) />

			<cfif getReportType() NEQ "line">
				<cfif getLimitResults() EQ 0>
					<cfset variables.limitResults = 5>
				</cfif>
				<cfquery name="variables.sortedPieAndBarChartData" dbtype="query" maxrows="#variables.limitResults#">
					SELECT
						<cfloop from="1" to="#listLen(getDimensions())#" step="1" index="local.d">
							<cfset var dimensionDefinition = getDimensionDefinition( listGetAt(getDimensions(), d) ) />
							<cfif d GT "1">,</cfif>
							#dimensionDefinition.alias#, count(#dimensionDefinition.alias#) AS #dimensionDefinition.alias#Total
						</cfloop>
					FROM data
					WHERE
						reportDateTime >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#getReportStartDateTime()#" />
					AND
				 	 	reportDateTime <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#reportEndDateTimePlusOne#" />
					GROUP BY
						<cfloop from="1" to="#listLen(getDimensions())#" step="1" index="local.d">
							<cfset var dimensionDefinition = getDimensionDefinition( listGetAt(getDimensions(), d) ) />
							<cfif d gt 1>,</cfif>
							#dimensionDefinition.alias#
							<cfif structKeyExists(dimensionDefinition, "filterAlias")>
								,#dimensionDefinition.filterAlias#
							</cfif>
						</cfloop>
					ORDER BY
						<cfset var dimensionDefinition = getDimensionDefinition( listGetAt(getDimensions(), 1) ) />
						#dimensionDefinition.alias#Total DESC
				</cfquery>
				<cfreturn variables.sortedPieAndBarChartData/>
			</cfif>

			<cfquery name="variables.chartDataQuery" dbtype="query">
				SELECT
					<cfloop from="1" to="#listLen(getMetrics())#" step="1" index="local.m">
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
				WHERE
					reportDateTime >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#getReportStartDateTime()#" />
				  AND
				  	reportDateTime <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#reportEndDateTimePlusOne#" />
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

	<cffunction name="getChartCompareDataQuery" access="public" output="false">
		<cfif not structKeyExists(variables, "chartCompareDataQuery")>

			<cfset var m = 1 />
			<cfset var data = getData() />
			<cfset var reportCompareEndDateTimePlusOne = dateAdd("d", 1, getReportCompareEndDateTime()) />

			<cfquery name="variables.chartCompareDataQuery" dbtype="query">
				SELECT
					<cfloop from="1" to="#listLen(getMetrics())#" step="1" index="local.m">
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
				WHERE
					reportDateTime >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#getReportCompareStartDateTime()#" />
				  AND
				  	reportDateTime <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#reportCompareEndDateTimePlusOne#" />
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

		<cfreturn variables.chartCompareDataQuery />
	</cffunction>

	<cffunction name="getMetricColorDetails" access="public" output="false">
		<cfreturn [
			{color="##058DC7",compareColor="##63BEE5"},
			{color="##ED7E17",compareColor="##FEBD81"},
			{color="##50B432",compareColor="##88DC6F"},
			{color="##AF49C5",compareColor="##DB88ED"},
			{color="##EDEF00",compareColor="##FDFE94"},
			{color="##8080FF",compareColor="##B9B9FF"},
			{color="##A0A424",compareColor="##CACE4F"},
			{color="##E3071C",compareColor="##FF606F"}
		] />
	</cffunction>

	<cffunction name="getChartData" access="public" output="false">
		<cfif NOT structKeyExists(variables, "chartData") AND getReportType() NEQ "none">

			<cfset var chartDataStruct = structNew() />
			<cfset var chartDataQuery = getChartDataQuery() />

			<cfif getReportCompareFlag()>
				<cfset var chartCompareDataQuery = getChartCompareDataQuery() />
			</cfif>

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

			<cfset var chartReportEndDateTime = getReportEndDateTime() />
			<cfset var chartReportCompareEndDateTime = getReportCompareEndDateTime() />

			<!---
			<cfif getReportDateTimeGroupBy() eq 'week'>
				<cfset chartReportEndDateTime = dateAdd('d', 7 - dayOfWeek( getReportEndDateTime() ), getReportEndDateTime()) />
				<cfset chartReportCompareEndDateTime = dateAdd('d', 7 - dayOfWeek( getReportCompareEndDateTime() ), getReportCompareEndDateTime()) />
			</cfif>
			--->

			<cfset variables.chartData = {} />
			<cfset variables.chartData["chart"] = {} />
			<cfset variables.chartData["chart"]["type"] = getReportType() />
			<cfset variables.chartData["chart"]["renderTo"]="hibachi-report-chart" />
			<cfset variables.chartData["legend"] = {} />
			<cfset variables.chartData["legend"]["enabled"] = false />
			<cfset variables.chartData["title"] = {} />
			<cfset variables.chartData["title"]["text"] = getReportTitle() />

			<cfif getReportType() EQ 'column'>
				<cfset variables.chartData["plotOptions"] = {} />
				<cfset variables.chartData["plotOptions"]["column"] = {} />
				<cfset variables.chartData["plotOptions"]["column"]["pointPadding"] = 0 />
				<cfset variables.chartData["plotOptions"]["column"]["borderWidth"] = 0 />
				<cfset variables.chartData["plotOptions"]["column"]["groupPadding"] = 0 />
				<cfset variables.chartData["plotOptions"]["column"]["shadow"] = false />
			</cfif>

			<!--- Setup xAxis --->
			<cfset variables.chartData["xAxis"] = [] />

			<cfif getReportCompareFlag()>
				<cfset var xAxisCompareData = {} />
				<cfset xAxisCompareData["opposite"] = true />
			</cfif>

			<!--- Setup yAxis --->
			<cfset variables.chartData["yAxis"] = {} />
			<cfset variables.chartData["yAxis"]["title"] = {} />
			<cfset variables.chartData["yAxis"]["title"]["text"] = '' />

			<cfset variables.chartData["series"] = [] />

			<cfset var dataSeriesID = 0 />
			<cfset var chartRow = 0 />
			<cfset var xAxisData = {} />

			<cfif getReportType() EQ "line">
				<cfset xAxisData["type"] = "datetime" />
				<cfset xAxisData["opposite"] = true />
				<cfset arrayAppend(variables.chartData["xAxis"], xAxisData) />
				<cfloop from="1" to="#listLen(getMetrics())#" step="1" index="local.m">

					<cfset var metricDefinition = getMetricDefinition( listGetAt(getMetrics(), m) ) />

					<cfset chartRow = 1 />
					<cfset dataSeriesID++ />

					<!--- Setup Data Series --->
					<cfset arrayAppend(variables.chartData["series"], {})>
					<cfset variables.chartData["series"][dataSeriesID]["name"] = getMetricTitle(metricDefinition.alias) />
					<cfset variables.chartData["series"][dataSeriesID]["data"] = [] />
					<cfset variables.chartData["series"][dataSeriesID]["xAxis"] = 0 />
					<cfset variables.chartData["series"][dataSeriesID]["color"] = getMetricColorDetails()[m]['color'] />
					<cfset variables.chartData["series"][dataSeriesID]["type"] = getReportType() />

					<hb:HibachiDateLoop index="thisDate" from="#getReportStartDateTime()#" to="#chartReportEndDateTime#" datepart="#loopdatepart#">
						<cfset var thisData = [] />
						<cfset arrayAppend(thisData, dateDiff("s", createdatetime( '1970','01','01','00','00','00' ), dateAdd("h", 1, thisDate))*1000) />
	 					<cfif addChartSeriesDataCheck(thisDate, getReportDateTimeGroupBy(), chartDataQuery, chartRow)>
							<cfset arrayAppend(thisData, chartDataQuery[ metricDefinition.alias ][ chartRow ]) />
							<cfset chartRow ++ />
						<cfelse>
							<cfset arrayAppend(thisData, 0) />
						</cfif>
						<cfset arrayAppend(variables.chartData["series"][dataSeriesID]["data"], thisData) />
					</hb:HibachiDateLoop>

					<!--- Setup Compare data Series --->
					<cfif getReportCompareFlag()>

						<cfset chartRow = 1 />
						<cfset dataSeriesID++ />

						<cfset arrayAppend(variables.chartData["series"], {})>
						<cfset variables.chartData["series"][dataSeriesID]["name"] = getMetricTitle(metricDefinition.alias) />
						<cfset variables.chartData["series"][dataSeriesID]["data"] = [] />
						<cfset variables.chartData["series"][dataSeriesID]["xAxis"] = 1 />
						<cfset variables.chartData["series"][dataSeriesID]["color"] = getMetricColorDetails()[m]['compareColor'] />

						<hb:HibachiDateLoop index="thisDate" from="#getReportCompareStartDateTime()#" to="#chartReportEndDateTime#" datepart="#loopdatepart#">
							<cfset var thisData = [] />
							<cfset arrayAppend(thisData, dateDiff("s", createdatetime( '1970','01','01','00','00','00' ), dateAdd("h", 1, thisDate))*1000) />
							<cfif addChartSeriesDataCheck(thisDate, getReportDateTimeGroupBy(), chartDataQuery, chartRow)>
								<cfset arrayAppend(thisData, chartCompareDataQuery[ metricDefinition.alias ][ chartRow ]) />
								<cfset chartRow ++ />
							<cfelse>
								<cfset arrayAppend(thisData, 0) />
							</cfif>

							<cfset arrayAppend(variables.chartData["series"][dataSeriesID]["data"], thisData) />
						</hb:HibachiDateLoop>

					</cfif>
				</cfloop>

			<cfelse><!---Pie Or Bar Chart--->
				<cfset var metricDefinition = getMetricDefinition( listGetAt(getMetrics(), 1) ) />
				<cfset var dimensionDefinition = getDimensionDefinition( listGetAt(getDimensions(), 1) ) />
				<cfset variables.chartData["series"][1]["name"] = getMetricTitle(metricDefinition.alias) />
				<cfset variables.chartData["series"][1]["colorByPoint"] = true />
				<cfset variables.chartData["series"][1]["data"] = [] />
				<cfset xAxisData["opposite"] = true />
				<cfset xAxisData["type"] = "category">
				<cfloop query="chartDataQuery">
					<cfset var data = [] />
					<cfset arrayAppend(data, evaluate("chartDataQuery.#dimensionDefinition.alias#"))>
					<cfset arrayAppend(data, evaluate("chartDataQuery.#dimensionDefinition.alias#Total"))>
					<cfset arrayAppend(variables.chartData["series"][1]["data"], data)/>
				</cfloop>
				<cfset arrayAppend(variables.chartData["xAxis"], xAxisData) />

			</cfif>

			<cfif getReportCompareFlag()>
				<cfset arrayAppend(variables.chartData["xAxis"], xAxisCompareData) />
			</cfif>
		</cfif>



		<cfreturn variables.chartData />
	</cffunction>

	<cffunction name="addChartSeriesDataCheck" access="private" output="false">
		<cfargument name="thisDate" />
		<cfargument name="reportDateTimeGroupBy" />
		<cfargument name="chartDataQuery" />
		<cfargument name="chartRow" />

		<cfif 	(
					year(thisDate) eq chartDataQuery['reportDateTimeYear'][chartRow]
				)
				AND
				(
					!listFindNoCase('month,week,day,hour', reportDateTimeGroupBy)
				  OR
					( listFindNoCase('month,week,day,hour', reportDateTimeGroupBy) AND month(thisDate) eq chartDataQuery['reportDateTimeMonth'][chartRow] )
				)
				AND
				(
					!listFindNoCase('week,day,hour', reportDateTimeGroupBy)
				  OR
				  	( listFindNoCase('week,day,hour', reportDateTimeGroupBy) AND week(thisDate) eq chartDataQuery['reportDateTimeWeek'][chartRow])
				)
				AND
				(
					!listFindNoCase('day,hour', reportDateTimeGroupBy)
				  OR
				  	( listFindNoCase('day,hour', reportDateTimeGroupBy) AND day(thisDate) eq chartDataQuery['reportDateTimeDay'][chartRow])
				)
				AND
				(
					!listFindNoCase('hour', reportDateTimeGroupBy)
				  OR
				  	( listFindNoCase('hour', reportDateTimeGroupBy) AND hour(thisDate) eq chartDataQuery['reportDateTimeHour'][chartRow])
			)>

			<cfreturn true />
		</cfif>

		<cfreturn false />
	</cffunction>

	<!--- ====================  END: CHART FUNCTIONS ========================= --->

	<!--- ==================== START: TABLE FUNCTIONS ======================== --->

	<cffunction name="getTotalsQuery" access="public" output="false">
		<cfif not structKeyExists(variables, "totalsQuery")>

			<cfset var m = 1 />
			<cfset var data = getData() />
			<cfset var reportEndDateTimePlusOne = dateAdd("d", 1, getReportEndDateTime()) />

			<cfquery name="variables.totalsQuery" dbtype="query">
				SELECT
					<cfloop from="1" to="#listLen(getMetrics())#" step="1" index="local.m">
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
				WHERE
					reportDateTime >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#getReportStartDateTime()#" />
				  AND
				  	reportDateTime <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#reportEndDateTimePlusOne#" />
			</cfquery>
		</cfif>

		<cfreturn variables.totalsQuery />
	</cffunction>

	<cffunction name="getCompareTotalsQuery" access="public" output="false">
		<cfif not structKeyExists(variables, "compareTotalsQuery")>

			<cfset var m = 1 />
			<cfset var data = getData() />
			<cfset var reportCompareEndDateTimePlusOne = dateAdd("d", 1, getReportCompareEndDateTime()) />

			<cfquery name="variables.compareTotalsQuery" dbtype="query">
				SELECT
					<cfloop from="1" to="#listLen(getMetrics())#" step="1" index="local.m">
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
				WHERE
					reportDateTime >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#getReportCompareStartDateTime()#" />
				  AND
				  	reportDateTime <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#reportCompareEndDateTimePlusOne#" />
			</cfquery>
		</cfif>

		<cfreturn variables.compareTotalsQuery />
	</cffunction>

	<cffunction name="getTableDataQuery" access="public" output="false">

		<cfif not structKeyExists(variables, "tableDataQuery")>

			<cfset var data = getData() />
			<cfset var unsortedData = "" />
			<cfset var unsortedCompareData = "" />
			<cfset var allDimensions = "" />
			<cfset var dataValue = "" />
			<cfset var compareDataValue = "" />
			<cfset var allUnsortedData = "" />
			<cfset var m = 1 />
			<cfset var d = 1 />
			<cfset var reportEndDateTimePlusOne = dateAdd("d", 1, getReportEndDateTime()) />
			<cfquery name="unsortedData" dbtype="query">
				SELECT
					<cfloop from="1" to="#listLen(getMetrics())#" step="1" index="local.m">
						<cfset var metricDefinition = getMetricDefinition( listGetAt(getMetrics(), m) ) />
						<cfif m gt 1>,</cfif>
						<cfif structKeyExists(metricDefinition, "calculation")>
							#metricDefinition.calculation# as #metricDefinition.alias#
						<cfelse>
							#metricDefinition.function#(#metricDefinition.alias#) as #metricDefinition.alias#
						</cfif>
					</cfloop>
					<cfloop from="1" to="#listLen(getDimensions())#" step="1" index="local.d">
						<cfset var dimensionDefinition = getDimensionDefinition( listGetAt(getDimensions(), d) ) />
						,#dimensionDefinition.alias#
						<cfif structKeyExists(dimensionDefinition, "filterAlias")>
							,#dimensionDefinition.filterAlias#
						</cfif>
					</cfloop>
				FROM
					data
				WHERE
					reportDateTime >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#getReportStartDateTime()#" />
				  AND
				  	reportDateTime <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#reportEndDateTimePlusOne#" />
				GROUP BY
					<cfloop from="1" to="#listLen(getDimensions())#" step="1" index="local.d">
						<cfset var dimensionDefinition = getDimensionDefinition( listGetAt(getDimensions(), d) ) />
						<cfif d gt 1>,</cfif>
						#dimensionDefinition.alias#
						<cfif structKeyExists(dimensionDefinition, "filterAlias")>
							,#dimensionDefinition.filterAlias#
						</cfif>
					</cfloop>
			</cfquery>

			<cfif getReportCompareFlag()>

				<cfset var reportCompareEndDateTimePlusOne = dateAdd("d", 1, getReportCompareEndDateTime()) />

				<cfquery name="unsortedCompareData" dbtype="query">
					SELECT
						<cfloop from="1" to="#listLen(getMetrics())#" step="1" index="local.m">
							<cfset var metricDefinition = getMetricDefinition( listGetAt(getMetrics(), m) ) />
							<cfif m gt 1>,</cfif>
							<cfif structKeyExists(metricDefinition, "calculation")>
								#metricDefinition.calculation# as #metricDefinition.alias#Compare
							<cfelse>
								#metricDefinition.function#(#metricDefinition.alias#) as #metricDefinition.alias#Compare
							</cfif>
						</cfloop>
						<cfloop from="1" to="#listLen(getDimensions())#" step="1" index="local.d">
							<cfset var dimensionDefinition = getDimensionDefinition( listGetAt(getDimensions(), d) ) />
							,#dimensionDefinition.alias#
							<cfif structKeyExists(dimensionDefinition, "filterAlias")>
								,#dimensionDefinition.filterAlias#
							</cfif>
						</cfloop>
					FROM
						data
					WHERE
						reportDateTime >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#getReportCompareStartDateTime()#" />
					  AND
					  	reportDateTime <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#reportCompareEndDateTimePlusOne#" />
					GROUP BY
						<cfloop from="1" to="#listLen(getDimensions())#" step="1" index="local.d">
							<cfset var dimensionDefinition = getDimensionDefinition( listGetAt(getDimensions(), d) ) />
							<cfif d gt 1>,</cfif>
							#dimensionDefinition.alias#
							<cfif structKeyExists(dimensionDefinition, "filterAlias")>
								,#dimensionDefinition.filterAlias#
							</cfif>
						</cfloop>
				</cfquery>

				<cfquery name="allDimensions" dbtype="query">
					SELECT DISTINCT
						<cfloop from="1" to="#listLen(getMetrics())#" step="1" index="local.m">
							<cfset var metricDefinition = getMetricDefinition( listGetAt(getMetrics(), m) ) />
							<cfif m gt 1>,</cfif>
							0 as #metricDefinition.alias#
							,0 as #metricDefinition.alias#Compare
						</cfloop>
						<cfloop from="1" to="#listLen(getDimensions())#" step="1" index="local.d">
							<cfset var dimensionDefinition = getDimensionDefinition( listGetAt(getDimensions(), d) ) />
							,#dimensionDefinition.alias#
							<cfif structKeyExists(dimensionDefinition, "filterAlias")>
								,#dimensionDefinition.filterAlias#
							</cfif>
						</cfloop>
					FROM
						data
				</cfquery>

				<cfloop query="allDimensions">
					<cfloop from="1" to="#listLen(getMetrics())#" step="1" index="local.m">
						<cfset var metricDefinition = getMetricDefinition( listGetAt(getMetrics(), m) ) />

						<cfquery name="dataValue" dbtype="query">
							SELECT
								#metricDefinition.alias# as dataValue
							FROM
								unsortedData
							WHERE
								<cfloop from="1" to="#listLen(getDimensions())#" step="1" index="local.d">
									<cfset var dimensionDefinition = getDimensionDefinition( listGetAt(getDimensions(), d) ) />
									<cfif d gt 1>AND</cfif>
									unsortedData.#dimensionDefinition.alias# = '#allDimensions[ dimensionDefinition.alias ][ allDimensions.currentRow ]#'
									<cfif structKeyExists(dimensionDefinition, "filterAlias")>
										AND unsortedData.#dimensionDefinition.filterAlias# = '#allDimensions[ dimensionDefinition.filterAlias ][ allDimensions.currentRow ]#'
									</cfif>
								</cfloop>
						</cfquery>

						<cfquery name="compareDataValue" dbtype="query">
							SELECT
								#metricDefinition.alias#Compare as dataValue
							FROM
								unsortedCompareData
							WHERE
								<cfloop from="1" to="#listLen(getDimensions())#" step="1" index="local.d">
									<cfset var dimensionDefinition = getDimensionDefinition( listGetAt(getDimensions(), d) ) />
									<cfif d gt 1>AND</cfif>
									unsortedCompareData.#dimensionDefinition.alias# = '#allDimensions[ dimensionDefinition.alias ][ allDimensions.currentRow ]#'
									<cfif structKeyExists(dimensionDefinition, "filterAlias")>
										AND unsortedCompareData.#dimensionDefinition.filterAlias# = '#allDimensions[ dimensionDefinition.filterAlias ][ allDimensions.currentRow ]#'
									</cfif>
								</cfloop>
						</cfquery>

						<cfif dataValue.recordCount>
							<cfset querySetCell(allDimensions, "#metricDefinition.alias#", dataValue.dataValue, allDimensions.currentRow) />
						</cfif>
						<cfif compareDataValue.recordCount>
							<cfset querySetCell(allDimensions, "#metricDefinition.alias#Compare", compareDataValue.dataValue, allDimensions.currentRow) />
						</cfif>


					</cfloop>
				</cfloop>

				<cfset allUnsortedData = allDimensions />
			<cfelse>
				<cfset allUnsortedData = unsortedData />
			</cfif>

			<cfquery name="variables.tableDataQuery" dbtype="query">
				SELECT
					*
				FROM
					allUnsortedData
				ORDER BY
				<cfif getOrderByType() EQ "dimensions">
					<cfloop from="1" to="#listLen(getDimensions())#" step="1" index="local.d">
						<cfset var dimensionDefinition = getDimensionDefinition( listGetAt(getDimensions(), d) ) />
						<cfif d gt 1>,</cfif>#dimensionDefinition.alias# DESC
					</cfloop>
				<cfelse>
					<cfloop from="1" to="#listLen(getMetrics())#" step="1" index="local.m">
						<cfset var metricDefinition = getMetricDefinition( listGetAt(getMetrics(), m) ) />
						<cfif m gt 1>,</cfif>#metricDefinition.alias# DESC
					</cfloop>
				</cfif>
			</cfquery>
		</cfif>

		<cfreturn variables.tableDataQuery />
	</cffunction>

	<!--- ====================  END: TABLE FUNCTIONS ========================= --->

	<!--- =============== START: CUSTOM TAG OUTPUT METHODS =================== --->

	<cffunction name="getReportDataTable" access="public" output="false">
		<cfif(!structKeyExists(variables, "reportDataTable"))>
			<cfsavecontent variable="variables.reportDataTable">
				<hb:HibachiReportDataTable report="#this#">
			</cfsavecontent>
		</cfif>

		<cfreturn variables.reportDataTable />
	</cffunction>

	<cffunction name="getReportConfigureBar" access="public" output="false">
		<cfif(!structKeyExists(variables, "reportConfigureBar"))>
			<cfsavecontent variable="variables.reportConfigureBar">
				<hb:HibachiReportConfigureBar report="#this#">
			</cfsavecontent>
		</cfif>

		<cfreturn variables.reportConfigureBar />
	</cffunction>

	<!--- ===============  END: CUSTOM TAG OUTPUT METHODS ==================== --->

	<!--- =============== START: EXPORT SPREADSHEET FUNCTIONS ================ --->

	<cffunction name="getSpreadsheetHeaderRow">
		<cfargument name="includeQuotes" default="false" />

		<cfset var headers = "" />
		<cfset var i = "" />

		<cfloop list="#getDimensions()#" index="local.i">
			<cfif arguments.includeQuotes>
				<cfset headers = listAppend(headers, '"#getDimensionTitle(i)#"') />
			<cfelse>
				<cfset headers = listAppend(headers, getDimensionTitle(i)) />
			</cfif>
		</cfloop>
		<cfloop list="#getMetrics()#" index="local.i">
			<cfif arguments.includeQuotes>
				<cfset headers = listAppend(headers, '"#getMetricTitle(i)#"') />
			<cfelse>
				<cfset headers = listAppend(headers, getMetricTitle(i)) />
			</cfif>
			<cfif getReportCompareFlag()>
				<cfset headers = listAppend(headers, ' ') />
			</cfif>
		</cfloop>

		<cfreturn headers />
	</cffunction>

	<cffunction name="getSpreadsheetHeaderCompareRow">
		<cfargument name="includeQuotes" default="false" />

		<cfset var headerCompare = "" />
		<cfset var i = "" />

		<cfloop list="#getDimensions()#" index="local.i">
			<cfset headerCompare = listAppend(headerCompare, ' ') />
		</cfloop>
		<cfloop list="#getMetrics()#" index="local.i">
			<cfif arguments.includeQuotes>
				<cfset headerCompare = listAppend(headerCompare, '"#dateFormat(getReportStartDateTime(), 'yyyy/mm/dd')# - #dateFormat(getReportEndDateTime(), 'yyyy/mm/dd')#"') />
				<cfset headerCompare = listAppend(headerCompare, '"#dateFormat(getReportCompareStartDateTime(), 'yyyy/mm/dd')# - #dateFormat(getReportCompareEndDateTime(), 'yyyy/mm/dd')#"') />
			<cfelse>
				<cfset headerCompare = listAppend(headerCompare, '#dateFormat(getReportStartDateTime(), 'yyyy/mm/dd')# - #dateFormat(getReportEndDateTime(), 'yyyy/mm/dd')#') />
				<cfset headerCompare = listAppend(headerCompare, '#dateFormat(getReportCompareStartDateTime(), 'yyyy/mm/dd')# - #dateFormat(getReportCompareEndDateTime(), 'yyyy/mm/dd')#') />
			</cfif>
		</cfloop>

		<cfreturn headerCompare />
	</cffunction>

	<cffunction name="getSpreadsheetTotals">
		<cfargument name="includeQuotes" default="false" />

		<cfset var totals = "" />
		<cfset var i = "" />

		<cfset var totalsQuery = getTotalsQuery() />
		<cfif getReportCompareFlag()>
			<cfset var totalsCompareQuery = getCompareTotalsQuery() />
		</cfif>

		<cfloop list="#getDimensions()#" index="local.i">
			<cfset totals = listAppend(totals, ' ') />
		</cfloop>
		<cfloop list="#getMetrics()#" index="local.i">
			<cfif arguments.includeQuotes>
				<cfset totals = listAppend(totals, '"#totalsQuery[ i ][1]#"' ) />
			<cfelse>
				<cfset totals = listAppend(totals, totalsQuery[ i ][1] ) />
			</cfif>
			<cfif getReportCompareFlag()>
				<cfif arguments.includeQuotes>
					<cfset totals = listAppend(totals, '"#totalsCompareQuery[ i ][1]#"' ) />
				<cfelse>
					<cfset totals = listAppend(totals, totalsCompareQuery[ i ][1] ) />
				</cfif>
			</cfif>
		</cfloop>

		<cfreturn totals />
	</cffunction>

	<cffunction name="getSpreadsheetData">
		<cfset var data = "" />
		<cfset var i = "" />
		<cfset var tableData = getTableDataQuery() />

		<cfquery name="data" dbtype="query">
			SELECT
				<cfloop from="1" to="#listLen(getDimensions())#" index="local.i">
					<cfif i gt 1>,</cfif>#listGetAt(getDimensions(), i)#
				</cfloop>
				<cfloop from="1" to="#listLen(getMetrics())#" index="local.i">
					,#listGetAt(getMetrics(), i)#
					<cfif getReportCompareFlag()>
						,#listGetAt(getMetrics(), i)#Compare
					</cfif>
				</cfloop>
			FROM
				tableData
		</cfquery>

		<cfreturn data />
	</cffunction>

	<cffunction name="getExportFilename">
		<cfargument name="extension" default="xls" />

		<!--- Create the filename variables --->
		<cfset var filename = "" />
		<cfif !isNull(getReportEntity()) && !isNull(getReportEntity().getReportTitle()) >
			<cfset filename = getService("HibachiUtilityService").createSEOString(getReportEntity().getReportTitle()) />
			<cfset filename &= "_" />
		<cfelse>
			<cfset filename = "#getClassName()#_" />
		</cfif>
		<cfset filename = replace(filename, "Report_", "_") />
		<cfset filename &= replace(getReportStartDateTime(), "-", "", "all") />
		<cfset filename &= "-" />
		<cfset filename &= replace(getReportEndDateTime(), "-", "", "all") />
		<cfset filename &= ".#arguments.extension#" />
		<cfif structKeyExists(server, "railo") || structKeyExists(server,'lucee')>
			<cfset filename = right(filename, 31) />
		</cfif>
		<cfreturn filename />
	</cffunction>

	<cffunction name="exportSpreadsheet" access="public" output="false">

		<!--- Create the filename variables --->
		<cfset var filename = getExportFilename('xls') />
		<cfset var filepath = "#getHibachiTempDirectory()#" />
		<cfset var fullFilename = filepath & filename />

		<cfset var totalColumns = listLen(getDimensions()) />
		<cfif getReportCompareFlag()>
			<cfset var totalColumns += listLen(getMetrics()) * 2 />
		<cfelse>
			<cfset var totalColumns += listLen(getMetrics()) />
		</cfif>
		<cftry>
			<!--- Create spreadsheet object --->
			<cfset var spreadsheet = spreadsheetNew( filename ) />
			<cfset var spreadsheetrowcount = 0 />

			<!--- Add the column headers --->
			<cfset spreadsheetAddRow(spreadsheet, getSpreadsheetHeaderRow()) />
			<cfset spreadsheetrowcount += 1 />
			<cfset spreadsheetFormatRow(spreadsheet, {bold=true}, 1) />

			<!--- Add compare row --->
			<cfif getReportCompareFlag()>
				<cfset var i = 1 />

				<cfloop from="1" to="#listLen(getMetrics())#" index="local.i">
					<cfset var startColumn = (listLen(getDimensions()) + (i*2)) - 1 />
					<cfset spreadsheetMergeCells(spreadsheet, 1, 1, startColumn, startColumn + 1 ) />
				</cfloop>

				<cfset spreadsheetAddRow(spreadsheet, getSpreadsheetHeaderCompareRow()) />
				<cfset spreadsheetrowcount += 1 />

				<cfset spreadsheetFormatRow(spreadsheet, {fontsize=8}, spreadsheet.rowcount) />
				<cfset spreadsheetMergeCells(spreadsheet, spreadsheetrowcount, spreadsheetrowcount, 1, listLen(getDimensions()) ) />
			</cfif>

			<!--- Add Header border --->
			<cfset spreadsheetFormatCellRange (spreadsheet, {bottomborder='thin'}, spreadsheetrowcount, 1, spreadsheetrowcount, totalColumns) />

			<!--- Add the data --->
			<cfset var dataQuery = getSpreadsheetData() />
			<cfset spreadsheetAddRows(spreadsheet, dataQuery) />
			<cfset spreadsheetrowcount += dataQuery.recordcount />

			<!--- Add the totals --->
			<cfset spreadsheetAddRow(spreadsheet, getSpreadsheetTotals()) />
			<cfset spreadsheetrowcount += 1 />

			<cfset spreadsheetMergeCells(spreadsheet, spreadsheetrowcount, spreadsheetrowcount, 1, listLen(getDimensions())) />
			<cfset spreadsheetSetCellValue(spreadsheet, rbKey('define.totals'), spreadsheetrowcount, 1) />
			<cfset spreadsheetFormatRow(spreadsheet, {bold=true}, spreadsheetrowcount) />

			<!--- Add Totals border --->
			<cfset spreadsheetFormatCellRange (spreadsheet, {topborder='thin'}, spreadsheetrowcount, 1, spreadsheetrowcount, totalColumns) />

			<cfset spreadsheetWrite( spreadsheet, fullFilename, true ) />
			<cfset getService("hibachiUtilityService").downloadFile( filename, fullFilename, "application/msexcel", true ) />
			<cfcatch>
				<cfif (structKeyExists(server, "railo") or structKeyExists(server, "lucee")) and cfcatch.message eq "No matching function [SPREADSHEETADDROW] found">
					<cfthrow type="Application" message="It appears that you are running Slatwall on Railo and have tried to export a report, but you do not have the cfspreadsheet extension installed on this instance of Railo.  Please install the cfspreadsheet extension and try again.">
				</cfif>
				<cfrethrow />
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="exportCSV" access="public" output="false">
		<!--- Create the filename variables --->
		<cfset var filename = getExportFilename('csv') />
		<cfset var filepath = "#getHibachiTempDirectory()#" />
		<cfset var fullFilename = filepath & filename />

		<!--- Fields --->
		<cfset var fields = "" />
		<cfset var i = "" />

		<cfloop list="#getDimensions()#" index="local.i">
			<cfset fields = listAppend(fields, i) />
		</cfloop>
		<cfloop list="#getMetrics()#" index="local.i">
			<cfset fields = listAppend(fields, i) />
			<cfif getReportCompareFlag()>
				<cfset fields = listAppend(fields, '#i#Compare') />
			</cfif>
		</cfloop>

		<cffile action="write" file="#fullFilename#" output="#getSpreadsheetHeaderRow( includeQuotes=true )#" />
		<cfif getReportCompareFlag()>
			<cffile action="append" file="#fullFilename#" output="#getSpreadsheetHeaderCompareRow( includeQuotes=true )#" />
		</cfif>
		<cffile action="append" file="#fullFilename#" output="#getService("hibachiUtilityService").queryToCSV( getSpreadsheetData(), fields, false )##getSpreadsheetTotals( includeQuotes=true )#" />

		<cfset getService("hibachiUtilityService").downloadFile( filename, fullFilename, "application/msexcel", true ) />
	</cffunction>

	<!--- ===============  END: EXPORT SPREADSHEET FUNCTIONS  ================ --->

</cfcomponent>
