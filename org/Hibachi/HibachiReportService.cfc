<cfcomponent output="false" accessors="true" extends="HibachiService">
	
	<!--- ===================== START: Logical Methods =========================== --->
	
	<cfscript>
		public any function getReportCFC( required string reportName, required struct data={} ) {
			var reportCFC = getBean( arguments.reportName );
			reportCFC.populate( arguments.data );
			return reportCFC;
		}
	</cfscript>
	
	<cffunction name="getBuiltInReportsList">
		<cfset var reportFiles = "" />
		<cfset var reportsList = "" />
		
		<cfdirectory action="list" directory="#getApplicationValue('applicationRootMappingPath')#/model/report" name="reportFiles" />
		
		<cfloop query="reportFiles">
			<cfif reportFiles.name neq "HibachiReport.cfc">
				<cfset reportsList = listAppend(reportsList, listFirst(reportFiles.name, '.')) />
			</cfif>
		</cfloop>
		
		<cfreturn reportsList />
	</cffunction>
	
	<cffunction name="getCustomReportsList">
		<cfset var reportFiles = "" />
		<cfset var reportsList = "" />
		
		<cfdirectory action="list" directory="#getApplicationValue('applicationRootMappingPath')#/custom/model/report" name="reportFiles" />
		
		<cfloop query="reportFiles">
			<cfif reportFiles.name neq "HibachiReport.cfc">
				<cfset reportsList = listAppend(reportsList, listFirst(reportFiles.name, '.')) />
			</cfif>
		</cfloop>
		
		<cfreturn reportsList />
	</cffunction>
	
	<!--- =====================  END: Logical Methods ============================ --->
	
	<!--- ===================== START: DAO Passthrough =========================== --->
	
	<!--- ===================== START: DAO Passthrough =========================== --->
	
	<!--- ===================== START: Process Methods =========================== --->
	
	<!--- =====================  END: Process Methods ============================ --->
	
	<!--- ====================== START: Status Methods =========================== --->
	
	<!--- ======================  END: Status Methods ============================ --->
	
	<!--- ====================== START: Save Overrides =========================== --->
	
	<!--- ======================  END: Save Overrides ============================ --->
	
	<!--- ==================== START: Smart List Overrides ======================= --->
	
	<!--- ====================  END: Smart List Overrides ======================== --->
	
	<!--- ====================== START: Get Overrides ============================ --->
	
	<!--- ======================  END: Get Overrides ============================= --->
	
</cfcomponent>