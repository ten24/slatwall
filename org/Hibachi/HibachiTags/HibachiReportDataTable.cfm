<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#" />

	<cfparam name="attributes.report" type="any" />

	<cfset thisTag.dimentionDefinitions = attributes.report.getDimensions()>
	<cfset thisTag.metricDefinitions = attributes.report.getMetrics()>
	<cfset thisTag.orderByType = attributes.report.getOrderByType()>
	<cfset thisTag.defaultCurrency = attributes.report.getCurrencyCode()>
	<cfset thisTag.currentPage = attributes.report.getCurrentPage()>

	<cfoutput>
		<cfif attributes.report.getShowReport()>
			<div id="reportDataTable">
				<table class="table table-condensed table-bordered">
					<!--- Headers --->
					<tr>
						<cfloop from="1" to="#listLen(thisTag.dimentionDefinitions)#" step="1" index="d">
							<cfset dimensionDefinition = attributes.report.getDimensionDefinition( listGetAt(thisTag.dimentionDefinitions, d) ) />
							<th style="background-color:##e3e3e3;">#attributes.report.getDimensionTitle( dimensionDefinition.alias )#</th>
						</cfloop>
						<cfloop from="1" to="#listLen(thisTag.metricDefinitions)#" step="1" index="m">
							<cfset metricDefinition = attributes.report.getMetricDefinition( listGetAt(thisTag.metricDefinitions, m) ) />
							<th class="s-metric-bullet-icon" style="background-color:##e3e3e3;" <cfif attributes.report.getReportCompareFlag()>colspan="2"</cfif>>
								<span style="color:#attributes.report.getMetricColorDetails()[m].color#;"></span>
								<cfif attributes.report.getReportCompareFlag()>
									<span style="color:#attributes.report.getMetricColorDetails()[m].compareColor#;"></span>
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
						<cfloop from="1" to="#listLen(thisTag.dimentionDefinitions)#" step="1" index="d">
							<td style="background-color:##f5f5f5;"></td>
						</cfloop>
						<cfloop from="1" to="#listLen(thisTag.metricDefinitions)#" step="1" index="m">
							<cfset metricDefinition = attributes.report.getMetricDefinition( listGetAt(thisTag.metricDefinitions, m) ) />
							<td style="background-color:##f5f5f5;font-size:16px;font-weight:bold;">
								#attributes.hibachiScope.formatValue(totalsQuery[metricDefinition.alias][1], attributes.report.getAliasFormatType(metricDefinition.alias), {currencyCode=thisTag.defaultCurrency})#
							</td>
							<cfif attributes.report.getReportCompareFlag()>
								<td style="background-color:##f5f5f5;font-size:16px;font-weight:bold;">
									#attributes.hibachiScope.formatValue(compareTotalsQuery[metricDefinition.alias][1], attributes.report.getAliasFormatType(metricDefinition.alias), {currencyCode=thisTag.defaultCurrency})#
								</td>
							</cfif>
						</cfloop>
					</tr>

					<!--- Data --->
					<cfset tableData = attributes.report.getTableDataQuery() />
					<cfloop query="tableData" startrow="#attributes.report.getCurrentPage()#" endrow="#attributes.report.getCurrentPage()+25#">
						<tr>
							<cfloop from="1" to="#listLen(thisTag.dimentionDefinitions)#" step="1" index="d">
								<cfset dimensionDefinition = attributes.report.getDimensionDefinition( listGetAt(thisTag.dimentionDefinitions, d) ) />
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
							<cfloop from="1" to="#listLen(thisTag.metricDefinitions)#" step="1" index="m">
								<cfset metricDefinition = attributes.report.getMetricDefinition( listGetAt(thisTag.metricDefinitions, m) ) />
								<td>#attributes.hibachiScope.formatValue( tableData[metricDefinition.alias][ tableData.currentRow ], attributes.report.getAliasFormatType(metricDefinition.alias), {currencyCode=thisTag.defaultCurrency})#</td>
								<cfif attributes.report.getReportCompareFlag()>
									<td>#attributes.hibachiScope.formatValue( tableData[ "#metricDefinition.alias#Compare" ][ tableData.currentRow ], attributes.report.getAliasFormatType(metricDefinition.alias), {currencyCode=thisTag.defaultCurrency})#</td>
								</cfif>
							</cfloop>
						</tr>
					</cfloop>
				</table>

				<!--- Reporting Items Pagination --->
				<nav class="pull-right" >
					<!--- Set the previous item number --->
					<cfset previousItem = attributes.report.getCurrentPage() - 25 />

					<!--- Set the next item number --->
					<cfset nextItem = attributes.report.getCurrentPage() + 25 />

					<ul class="pagination" >

						<!--- Get Previous page --->
				        <li <cfif previousItem LTE 0>class="disabled" disabled</cfif> >
				            <a href="##" data-pagination="#previousItem#" class="hibachi-report-pagination" aria-label="Previous">
				            	<span aria-hidden="true">&laquo;</span>
				            </a>
				        </li>

						<!--- Show all pages --->
						<cfloop from="1" to="#tableData.recordCount#" step="25" index="p">
							<cfif attributes.report.getCurrentPage() EQ p>
								<li class="active">
									<a href="##">#((p-1)/25)+1#</a>
								</li>
							<cfelse>
								<li>
									<a href="##" data-pagination="#p#" class="hibachi-report-pagination">#((p-1)/25)+1#</a>
								</li>
							</cfif>
						</cfloop>

						<!--- Get next page --->
						<li <cfif tableData.RecordCount LTE attributes.report.getDataTableEndRow()>class="disabled" disabled</cfif> >
				            <a href="##" data-pagination="#nextItem#" class="hibachi-report-pagination" aria-label="Next">
				            	<span aria-hidden="true">&raquo;</span>
				            </a>
				        </li>

				    </ul>

				</nav>
			</div>
		</cfif>
	</cfoutput>
</cfif>
