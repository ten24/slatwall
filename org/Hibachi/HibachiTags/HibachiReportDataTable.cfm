<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#" />

	<cfparam name="attributes.report" type="any" />

	<cfset variables.lDimentionDefinitions = attributes.report.getDimensions()>
	<cfset variables.lMetrics = attributes.report.getMetrics()>

	<cfoutput>
		<table class="table table-condensed table-bordered">
			<!--- Headers --->
			<tr>
				<cfloop from="1" to="#listLen(variables.lDimentionDefinitions)#" step="1" index="d">
					<cfset dimensionDefinition = attributes.report.getDimensionDefinition( listGetAt(variables.lDimentionDefinitions, d) ) />
					<th style="background-color:##e3e3e3;">#attributes.report.getDimensionTitle( dimensionDefinition.alias )#</th>
				</cfloop>
				<cfloop from="1" to="#listLen(variables.lMetrics)#" step="1" index="m">
					<cfset metricDefinition = attributes.report.getMetricDefinition( listGetAt(variables.lMetrics, m) ) />
					<th style="background-color:##e3e3e3;" <cfif attributes.report.getReportCompareFlag()>colspan="2"</cfif>>
						<span style="color:#attributes.report.getMetricColorDetails()[m].color#; font-size:26px; float:left; margin-right:3px;">&bull;</span>
						<cfif attributes.report.getReportCompareFlag()>
							<span style="color:#attributes.report.getMetricColorDetails()[m].compareColor#; font-size:26px; float:left; margin-right:3px;">&bull;</span>	
						</cfif>
						| #attributes.report.getMetricTitle( metricDefinition.alias )#
					</th>
				</cfloop>
			</tr>
			<!--- Totals --->
			<tr>
				<!--- Totals Query --->
				<cfset totalsQuery = attributes.report.getTotalsQuery() />
				<!--- Compare Totals Query --->
				<cfif attributes.report.getReportCompareFlag()>
					<cfset compareTotalsQuery = attributes.report.getCompareTotalsQuery() />
				</cfif>
				<cfloop from="1" to="#listLen(variables.lDimentionDefinitions)#" step="1" index="d">
					<td style="background-color:##f5f5f5;"></td>
				</cfloop>
				<cfloop from="1" to="#listLen(variables.lMetrics)#" step="1" index="m">
					<cfset metricDefinition = attributes.report.getMetricDefinition( listGetAt(variables.lMetrics, m) ) />
					<td style="background-color:##f5f5f5;font-size:16px;font-weight:bold;">
						#attributes.hibachiScope.formatValue(totalsQuery[metricDefinition.alias][1], attributes.report.getAliasFormatType(metricDefinition.alias), {currencyCode="USD"})#
					</td>
					<cfif attributes.report.getReportCompareFlag()>
						<td style="background-color:##f5f5f5;font-size:16px;font-weight:bold;">
							#attributes.hibachiScope.formatValue(compareTotalsQuery[metricDefinition.alias][1], attributes.report.getAliasFormatType(metricDefinition.alias), {currencyCode="USD"})#
						</td>
					</cfif>
				</cfloop>
			</tr>

			<!--- Data --->
			<cfset tableData = attributes.report.getTableDataQuery() /> 
			<cfloop query="tableData">
				<tr>
					<cfloop from="1" to="#listLen(variables.lDimentionDefinitions)#" step="1" index="d">
						<cfset dimensionDefinition = attributes.report.getDimensionDefinition( listGetAt(variables.lDimentionDefinitions, d) ) />
						<!---
							TODO: Add Filter Links
						<cfif structKeyExists(dimensionDefinition, "filterAlias")>
							<td><a href="" class="datafilter" data-filteralias="#dimensionDefinition.filterAlias#" data-filtervalue="tableData[ dimensionDefinition.filterAlias ][ tableData.currentRow ]">#tableData[ dimensionDefinition.alias ][ tableData.currentRow ]#</a>
						<cfelse>
							<td>#attributes.hibachiScope.formatValue( tableData[ dimensionDefinition.alias ][ tableData.currentRow ], attributes.report.getAliasFormatType(dimensionDefinition.alias))#</td>
						</cfif>
						--->

						<!--- Temporary --->
						<td>#attributes.hibachiScope.formatValue( tableData[ dimensionDefinition.alias ][ tableData.currentRow ], attributes.report.getAliasFormatType(dimensionDefinition.alias))#</td>
					</cfloop>
					<cfloop from="1" to="#listLen(variables.lMetrics)#" step="1" index="m">
						<cfset metricDefinition = attributes.report.getMetricDefinition( listGetAt(variables.lMetrics, m) ) />
						<td>#attributes.hibachiScope.formatValue( tableData[metricDefinition.alias][ tableData.currentRow ], attributes.report.getAliasFormatType(metricDefinition.alias), {currencyCode="USD"})#</td>
						<cfif attributes.report.getReportCompareFlag()>
							<td>#attributes.hibachiScope.formatValue( tableData[ "#metricDefinition.alias#Compare" ][ tableData.currentRow ], attributes.report.getAliasFormatType(metricDefinition.alias), {currencyCode="USD"})#</td>
						</cfif>
					</cfloop>
				</tr>
			</cfloop>
		</table>

	</cfoutput>
</cfif>