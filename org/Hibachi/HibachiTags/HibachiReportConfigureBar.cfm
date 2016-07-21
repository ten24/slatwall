<cfimport prefix="swa" taglib="../../../tags" />
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
				<div class="col-md-7">
					<dl class="dl-horizontal">
						<style>
							.s-report-info dd, .s-report-info dt {line-height:30px;}
							.s-report-info dt {margin-right:10px;}
						</style>
						
						<!--- Metrics --->
						<input type="hidden" name="metrics" value="#trim(attributes.report.getMetrics())#" />
						<dt style="width:100px;"><strong>#attributes.hibachiScope.rbKey('define.metrics')#</strong></dt>
						<dd style="margin-left:100px;">
							<span id="hibachi-report-metric-sort">
								<cfloop from="1" to="#listLen(attributes.report.getMetrics())#" step="1" index="m">
									<cfset metric = listGetAt(attributes.report.getMetrics(), m) />
									<span class="label s-metric-bullet-icon" style="background-color: ##f5f5f5;color:##333333; border:1px solid ##cccccc; margin-bottom:5px; padding-left:10px; cursor:pointer;" data-metric="#trim(metric)#">
										<span style="color:#attributes.report.getMetricColorDetails()[m].color#;"></span>
										<cfif attributes.report.getReportCompareFlag()>
											<span style="color:#attributes.report.getMetricColorDetails()[m].color#;"></span>
										</cfif>
										<cfoutput> | #attributes.report.getMetricTitle(metric)#</cfoutput>
										<cfif listLen(attributes.report.getMetrics()) gt 1>
											<a href="" class="hibachi-report-remove-metric" style="color:##000000; margin:0px 5px 0px 10px;" data-metric="#metric#">x</a>
										</cfif>
									</span>
								</cfloop>
							</span>
							<cfif arrayLen(attributes.report.getMetricDefinitions()) gt listLen(attributes.report.getMetrics()) && listLen(attributes.report.getMetrics()) lt 8>
								<span class="dropdown">
									<span data-toggle="dropdown" class="dropdown-toggle label" style="background:none; border:1px solid ##cccccc; color:##333333; cursor:pointer;"></a>+</span>
									<ul class="dropdown-menu">
										<cfloop array="#attributes.report.getMetricDefinitions()#" index="metricDefinition">
											<cfif not listFindNoCase(attributes.report.getMetrics(), metricDefinition.alias)><li><a href="" class="hibachi-report-add-metric" data-metric="#metricDefinition.alias#">#attributes.report.getMetricTitle(metricDefinition.alias)#</a></li></cfif>
										</cfloop>		 
									</ul>
								</span>
							</cfif>
						</dd>
						
						<!--- Dimensions --->
						<input type="hidden" name="dimensions" value="#trim(attributes.report.getDimensions())#" />
						<dt style="width:100px;"><strong>#attributes.hibachiScope.rbKey('define.dimensions')#</strong></dt>
						<dd style="margin-left:100px;">
							<span id="hibachi-report-dimension-sort">
								<cfloop list="#attributes.report.getDimensions()#" index="dimension">
									<span class="label" style="background-color: ##f5f5f5; border:1px solid ##cccccc; color:##333333; margin-bottom:5px; padding-left:10px; cursor:pointer;" data-dimension="#trim(dimension)#">#attributes.report.getDimensionTitle(dimension)#<cfif listLen(attributes.report.getDimensions()) gt 1><a href="" class="hibachi-report-remove-dimension" style="color:##000000; margin:0px 5px 0px 10px;" data-dimension="#dimension#">x</a></cfif></span>
								</cfloop>
							</span>
							<cfif arrayLen(attributes.report.getDimensionDefinitions()) gt listLen(attributes.report.getDimensions())>
								<span class="dropdown">
									<span data-toggle="dropdown" class="dropdown-toggle label" style="background:none; border:1px solid ##cccccc; color:##333333; cursor:pointer;"></a>+</span>
									<ul class="dropdown-menu">
										<cfloop array="#attributes.report.getDimensionDefinitions()#" index="dimensionDefinition">
											<cfif not listFindNoCase(attributes.report.getDimensions(), dimensionDefinition.alias)><li><a href="" class="hibachi-report-add-dimension" data-dimension="#dimensionDefinition.alias#">#attributes.report.getDimensionTitle(dimensionDefinition.alias)#</a></li></cfif>
										</cfloop>		 
									</ul>
								</span>
							</cfif>
						</dd>
						
						<!--- Order By Metric / Dimension ---> 
						
						<dt style="width:100px;"><strong>#attributes.hibachiScope.rbKey('define.orderby')#</strong></dt>
						<dd style="margin-left:100px;">
							<select id="hibachi-order-by" name="orderbytype">
								<option value="metrics" <cfif attributes.report.getOrderByType() EQ "metrics">selected</cfif>>#attributes.hibachiScope.rbKey('define.metrics')#</option>
								<option value="dimensions" <cfif attributes.report.getOrderByType() EQ "dimensions">selected</cfif>>#attributes.hibachiScope.rbKey('define.dimensions')#</option>
							</select>
						</dd>

						<!--- Limit Results --->
						<cfif attributes.report.getReportType() EQ "column" OR attributes.report.getReportType() EQ "pie">
							<!--- Order By Metric / Dimension --->
							<dt style="width:100px;"><strong>#attributes.hibachiScope.rbKey('define.limitResults')#</strong></dt>
							<dd style="margin-left:100px;">
								<select id="hibachi-limit-results" name="limitresults">
									<option value="5" <cfif attributes.report.getLimitResults() EQ 5>selected</cfif>>5</option>
									<option value="10" <cfif attributes.report.getLimitResults() EQ 10>selected</cfif>>10</option>
									<option value="15" <cfif attributes.report.getLimitResults() EQ 15>selected</cfif>>15</option>
									<option value="20" <cfif attributes.report.getLimitResults() EQ 20>selected</cfif>>20</option>
									<option value="25" <cfif attributes.report.getLimitResults() EQ 25>selected</cfif>>25</option>
									<option value="50" <cfif attributes.report.getLimitResults() EQ 50>selected</cfif>>50</option>
								</select>
							</dd>
						</cfif>
						
						<!--- Graph Type --->
						<dt style="width:100px;"><strong>#attributes.hibachiScope.rbKey('define.reportType')#</strong></dt>
						<dd style="margin-left:100px;">
							<select id="hibachi-report-type" name="reporttype">
								<option value="line" <cfif attributes.report.getReportType() EQ "line">selected</cfif>>#attributes.hibachiScope.rbKey('define.line')#</option>
								<option value="column" <cfif attributes.report.getReportType() EQ "column">selected</cfif>>#attributes.hibachiScope.rbKey('define.bar')#</option>
								<option value="pie" <cfif attributes.report.getReportType() EQ "pie">selected</cfif>>#attributes.hibachiScope.rbKey('define.pie')#</option>
								<option value="none" <cfif attributes.report.getReportType() EQ "none">selected</cfif>>#attributes.hibachiScope.rbKey('define.none')#</option>
							</select>
						</dd>
						
						<!--- Show/Hide Report --->
						<dt style="width:100px;"><strong>#attributes.hibachiScope.rbKey('define.showReport')#</strong></dt>
						<dd style="margin-left:100px;">
							<input id="hibachi-show-report" type="checkbox" name="showReport" value="true" <cfif attributes.report.getShowReport()>checked</cfif> />
						</dd>
						
						<!--- Action Buttons --->
						<dt style="width:100px;"><strong>#attributes.hibachiScope.rbKey('define.actions')#</strong></dt>
						<dd style="margin-left:100px;">
							<cfif not isNull(attributes.report.getReportEntity())>
								<hb:HibachiActionCaller action="admin:entity.editreport" queryString="reportID=#attributes.report.getReportEntity().getReportID()#&reportName=#attributes.report.getClassName()#&reportDateTime=#attributes.report.getReportDateTime()#&reportDateTimeGroupBy=#attributes.report.getReportDateTimeGroupBy()#&reportCompareFlag=#attributes.report.getReportCompareFlag()#&dimensions=#attributes.report.getDimensions()#&metrics=#attributes.report.getMetrics()#&redirectAction=admin:report.default&reportType=#attributes.report.getReportType()#&limitResults=#attributes.report.getLimitResults()#&showReport=#attributes.report.getShowReport()#&" icon="pencil" class="btn btn-xs btn-dgrey" modal=true />
								<hb:HibachiActionCaller action="admin:entity.deletereport" queryString="reportID=#attributes.report.getReportEntity().getReportID()#&redirectAction=admin:report.default" icon="remove" class="btn btn-xs btn-dgrey" />
							</cfif>	
							<hb:HibachiActionCaller action="admin:entity.createreport" queryString="reportName=#attributes.report.getClassName()#&reportDateTime=#attributes.report.getReportDateTime()#&reportDateTimeGroupBy=#attributes.report.getReportDateTimeGroupBy()#&reportCompareFlag=#attributes.report.getReportCompareFlag()#&dimensions=#attributes.report.getDimensions()#&metrics=#attributes.report.getMetrics()#&redirectAction=admin:report.default&reportType=#attributes.report.getReportType()#&limitResults=#attributes.report.getLimitResults()#&showReport=#attributes.report.getShowReport()#&" icon="plus" class="btn btn-xs btn-dgrey" modal=true />
							<hb:HibachiActionCaller action="admin:report.exportxls" name="slatAction" icon="share" type="button" class="btn btn-xs btn-dgrey" submit="true" />
							<hb:HibachiActionCaller action="admin:report.exportcsv" name="slatAction" icon="share" type="button" class="btn btn-xs btn-dgrey" submit="true" />	
						</dd>
					</dl>
				</div>
				<div class="col-md-5">
					
					<!--- Report DateTime GroupBy ---> 
					<div class="btn-group-vertical pull-right" style="vertical-align:top; margin-bottom:5px;">
						<a href="" class="hibachi-report-date-group btn btn-xs btn-default<cfif attributes.report.getReportDateTimeGroupBy() eq 'hour'> active</cfif>" data-groupby="hour">Hour</a>
						<a href="" class="hibachi-report-date-group btn btn-xs btn-default<cfif attributes.report.getReportDateTimeGroupBy() eq 'day'> active</cfif>" data-groupby="day">Day</a>
						<a href="" class="hibachi-report-date-group btn btn-xs btn-default<cfif attributes.report.getReportDateTimeGroupBy() eq 'week'> active</cfif>" data-groupby="week">Week</a>
						<a href="" class="hibachi-report-date-group btn btn-xs btn-default<cfif attributes.report.getReportDateTimeGroupBy() eq 'month'> active</cfif>" data-groupby="month">Month</a>
						<a href="" class="hibachi-report-date-group btn btn-xs btn-default<cfif attributes.report.getReportDateTimeGroupBy() eq 'year'> active</cfif>" data-groupby="year">Year</a>
					</div>
					
					<!--- DateTime Selector --->
					<div class="pull-right" style="margin-right:10px;">
						<div style="margin-bottom:5px;">
							<select name="reportDateTime" class="hibachi-report-date form-control j-custom-select" style="width:192px;margin-bottom:15px;">
								<cfloop array="#attributes.report.getReportDateTimeDefinitions()#" index="dateTimeAlias">
									<option value="#dateTimeAlias['alias']#" <cfif dateTimeAlias['alias'] eq attributes.report.getReportDateTime()>selected="selected"</cfif>>#attributes.report.getReportDateTimeTitle(dateTimeAlias['alias'])#</option>
								</cfloop>
							</select>
						</div>
						<div style="margin-bottom:-5px;">
							<span style="display:block;font-size:11px;font-weight:bold;padding-bottom:2px;">Start - End: <a href="##" id="hibachi-report-enable-compare" class="pull-right<cfif attributes.report.getReportCompareFlag()> hide</cfif>">+Compare</a></span>
							<input type="text" name="reportStartDateTime" class="datepicker hibachi-report-date" style="width:80px;margin-right:15px;" value="#attributes.report.getFormattedValue('reportStartDateTime')#" /> - <input type="text" name="reportEndDateTime" class="datepicker hibachi-report-date" style="width:80px;margin-left:10px;" value="#attributes.report.getFormattedValue('reportEndDateTime')#" />
							<input type="hidden" name="reportCompareFlag" value="#attributes.report.getReportCompareFlag()#" />
						</div>
						<div id="hibachi-report-compare-date" <cfif not attributes.report.getReportCompareFlag()>class="hide"</cfif>>
							<span style="display:block;font-size:11px;font-weight:bold;margin-top:5px;padding-bottom:2px;">Compare Start - End:<a href="" id="hibachi-report-disable-compare" class="pull-right">-Remove</a></span>
							<input type="text" name="reportCompareStartDateTime" class="datepicker hibachi-report-date" style="width:80px;margin-right:10px;" value="#attributes.report.getFormattedValue('reportCompareStartDateTime')#" /> - <input type="text" name="reportCompareEndDateTime" class="datepicker hibachi-report-date" style="width:80px;margin-left:10px;" value="#attributes.report.getFormattedValue('reportCompareEndDateTime')#" />
						</div>
					</div>
					
				</div>
			</div>
		</form>
	</cfoutput>
</cfif>