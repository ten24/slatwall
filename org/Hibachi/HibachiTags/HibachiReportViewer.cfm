<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.report" type="any" />
	
	<cfoutput>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/js/highcharts.js"></script>
		
		<div id="hibachi-report" data-reportname="#attributes.report.getClassName()#">
			<!--- Chart --->
			<div id="hibachi-report-chart-wrapper" class="well" style="padding:10px;">
				<div id="hibachi-report-chart" style="height:300px;"></div>
			</div>
			
			<!--- Configure --->
			<div id="hibachi-report-configure-bar" class="well" style="padding:10px;">
				#attributes.report.getReportConfigureBar()#
			</div>
			
			<!--- Table --->
			<div id="hibachi-report-table">
				#attributes.report.getReportDataTable()#
			</div>
			
			<script type="text/javascript">
				jQuery(document).ready(function(){
					//jQuery('##hibachi-report-chart').highcharts(#serializeJSON(attributes.report.getChartData())#);
					addLoadingDiv( 'hibachi-report' );
					updateReport();
				});
			</script>
		</div>
	</cfoutput>
</cfif>

