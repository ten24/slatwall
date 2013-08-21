<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.report" type="any" />
	
	<cfoutput>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/js/highcharts.js"></script>
		
		<div id="hibachi-report" data-reportname="#attributes.report.getClassName()#">
			<!--- Chart --->
			<div class="well" style="padding:10px;">
				<div id="hibachi-report-chart" style="height:300px;"></div>
			</div>
			<!--- Configure --->
			<div id="hibachi-report-configure-bar" class="well" style="padding:10px;">
				
			</div>
			<!--- Table --->
			<div id="hibachi-report-table">
				
			</div>
			
			<script type="text/javascript">
				jQuery(document).ready(function(){
					updateReport();
				});
			</script>
		</div>
	</cfoutput>
</cfif>
