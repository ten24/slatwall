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

			<div class="row-fluid">
				<div class="span7">
					<dl class="dl-horizontal">
						
						<!--- Metrics --->
						<input type="hidden" name="metrics" value="#trim(attributes.report.getMetrics())#" />
						<dt style="width:100px;"><strong>Metrics</strong></dt>
						<dd style="margin-left:100px;">
							<span id="hibachi-report-metric-sort">
								<cfloop from="1" to="#listLen(attributes.report.getMetrics())#" step="1" index="m">
									<cfset metric = listGetAt(attributes.report.getMetrics(), m) />
									<span class="label" style="background-color: ##f5f5f5; border:1px solid ##cccccc; color:##333333; margin-bottom:5px; padding-left:10px; cursor:pointer;" data-metric="#trim(metric)#">
										<span style="color:#attributes.report.getMetricColorDetails()[m].color#; font-size:26px; float:left; margin-right:2px;">&bull;</span>
										<cfif attributes.report.getReportCompareFlag()>
											<span style="color:#attributes.report.getMetricColorDetails()[m].compareColor#; font-size:26px; float:left; margin-right:2px;">&bull;</span>
										</cfif>
										<cfoutput>| #attributes.report.getMetricTitle(metric)#</cfoutput>
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
						<dt style="width:100px;"><strong>Dimensions</strong></dt>
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
						
						<!--- Action Buttons --->
						<dt style="width:100px;"><strong>#attributes.hibachiScope.rbKey('define.actions')#</strong></dt>
						<dd style="margin-left:100px;">
							<cfif not isNull(attributes.report.getReportEntity())>
								<cf_HibachiActionCaller action="admin:entity.editreport" queryString="reportID=#attributes.report.getReportEntity().getReportID()#&reportName=#attributes.report.getClassName()#&reportDateTime=#attributes.report.getReportDateTime()#&reportDateTimeGroupBy=#attributes.report.getReportDateTimeGroupBy()#&reportCompareFlag=#attributes.report.getReportCompareFlag()#&dimensions=#attributes.report.getDimensions()#&metrics=#attributes.report.getMetrics()#&redirectAction=admin:report.default" icon="pencil" class="btn btn-mini" modal=true />
								<cf_HibachiActionCaller action="admin:entity.deletereport" queryString="reportID=#attributes.report.getReportEntity().getReportID()#&redirectAction=admin:report.default" icon="remove" class="btn btn-mini" />
							</cfif>	
							<cf_HibachiActionCaller action="admin:entity.createreport" queryString="reportName=#attributes.report.getClassName()#&reportDateTime=#attributes.report.getReportDateTime()#&reportDateTimeGroupBy=#attributes.report.getReportDateTimeGroupBy()#&reportCompareFlag=#attributes.report.getReportCompareFlag()#&dimensions=#attributes.report.getDimensions()#&metrics=#attributes.report.getMetrics()#&redirectAction=admin:report.default" icon="plus" class="btn btn-mini" modal=true /><br />
							<cf_HibachiActionCaller action="admin:report.exportxls" name="slatAction" icon="share" type="button" class="btn-mini" submit="true" />
							<cf_HibachiActionCaller action="admin:report.exportcsv" name="slatAction" icon="share" type="button" class="btn-mini" submit="true" />	
						</dd>
					</dl>
				</div>
				<div class="span5">
					
					<!--- Report DateTime GroupBy ---> 
					<div class="btn-group-vertical pull-right" style="vertical-align:top; margin-bottom:5px;">
						<a href="" class="hibachi-report-date-group btn btn-mini<cfif attributes.report.getReportDateTimeGroupBy() eq 'hour'> active</cfif>" data-groupby="hour">Hour</a>
						<a href="" class="hibachi-report-date-group btn btn-mini<cfif attributes.report.getReportDateTimeGroupBy() eq 'day'> active</cfif>" data-groupby="day">Day</a>
						<a href="" class="hibachi-report-date-group btn btn-mini<cfif attributes.report.getReportDateTimeGroupBy() eq 'week'> active</cfif>" data-groupby="week">Week</a>
						<a href="" class="hibachi-report-date-group btn btn-mini<cfif attributes.report.getReportDateTimeGroupBy() eq 'month'> active</cfif>" data-groupby="month">Month</a>
					</div>
					
					<!--- DateTime Selector --->
					<div class="pull-right" style="margin-right:10px;">
						<div style="margin-bottom:-5px;">
							<select name="reportDateTime" class="hibachi-report-date" style="width:192px;">
								<cfloop array="#attributes.report.getReportDateTimeDefinitions()#" index="dateTimeAlias">
									<option value="#dateTimeAlias['alias']#" <cfif dateTimeAlias['alias'] eq attributes.report.getReportDateTime()>selected="selected"</cfif>>#attributes.report.getReportDateTimeTitle(dateTimeAlias['alias'])#</option>
								</cfloop>
							</select>
						</div>
						<div style="margin-bottom:-5px;">
							<span style="display:block;font-size:11px;font-weight:bold;">Start - End: <a href="##" id="hibachi-report-enable-compare" class="pull-right<cfif attributes.report.getReportCompareFlag()> hide</cfif>">+Compare</a></span>
							<input type="text" name="reportStartDateTime" class="datepicker hibachi-report-date" style="width:80px;" value="#attributes.report.getFormattedValue('reportStartDateTime')#" /> - <input type="text" name="reportEndDateTime" class="datepicker hibachi-report-date" style="width:80px;" value="#attributes.report.getFormattedValue('reportEndDateTime')#" />
							<input type="hidden" name="reportCompareFlag" value="#attributes.report.getReportCompareFlag()#" />
						</div>
						<div id="hibachi-report-compare-date" <cfif not attributes.report.getReportCompareFlag()>class="hide"</cfif>>
							<span style="display:block;font-size:11px;font-weight:bold;">Compare Start - End:<a href="" id="hibachi-report-disable-compare" class="pull-right">-Remove</a></span>
							<input type="text" name="reportCompareStartDateTime" class="datepicker hibachi-report-date" style="width:80px;" value="#attributes.report.getFormattedValue('reportCompareStartDateTime')#" /> - <input type="text" name="reportCompareEndDateTime" class="datepicker hibachi-report-date" style="width:80px;" value="#attributes.report.getFormattedValue('reportCompareEndDateTime')#" />
						</div>
					</div>
					
				</div>
			</div>
		</form>
	</cfoutput>
</cfif>