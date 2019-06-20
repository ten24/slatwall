<cfparam name="rc.subscriptionType" default=""/>
<cfparam name="rc.productType" default=""/>
<cfparam name="rc.productID" default=""/>
<cfparam name="rc.minDate" default="#CreateDate(Year(now()),1,1)#"/>
<cfparam name="rc.maxDate" default="#CreateDate(Year(now()),Month(now()),Day(now()))#"/>

<cfparam name="showProducts" default="true"/>
<!---axe the output--->
<cfsilent>
    <cfinclude template="./revenuerecognitionreport.cfm"/>
</cfsilent>

<cffunction name="renderReport">
    <cfargument name="reportData"/>
    <cfargument name="renderEarnedRevenue" type="boolean"/>
    <cfscript>
        var fileName = createUUID() ;
		
        var fileNameWithExt = fileName & ".csv" ;
		var filePath = GetTempDirectory() & "/" & fileNameWithExt;
			
        var newLine     = (chr(13) & chr(10));
    	var buffer      = CreateObject('java','java.lang.StringBuffer').Init();
    
    	fileWrite(filePath,",#ListQualify(arrayToList(arguments.reportData.headers),'"',',','all')##newLine#");
    
    	var dataFile = fileOpen(filePath,"append");
    	var thisRow = 'Opening Deferred Revenue Balance,#arrayToList(reportData.openingDeferredRevenue)#';
    	fileWriteLine(dataFile,thisRow);
    	
    	thisRow = 'New Orders,#arrayToList(reportData.newOrders)#';
    	fileWriteLine(dataFile,thisRow);
    	
    	thisRow = 'Cancellations,#arrayToList(reportData.cancelledOrders)#';
    	fileWriteLine(dataFile,thisRow);
    	
    	thisRow = 'Earned Revenue,#arrayToList(reportData.earnedRevenue)#';
    	fileWriteLine(dataFile,thisRow);
    	
    	thisRow = 'Closing Deferred Revenue Balance,#arrayToList(reportData.closingDeferredRevenue)#';
    	fileWriteLine(dataFile,thisRow);
    	
    	if(arguments.renderEarnedRevenue){
    	    thisRow = '#newLine#Earned Revenue By Issue';
    	    fileWriteLine(dataFile,thisRow);
    	    
    	    for(var nameValue in reportData.earnedRevenueByIssueNames){
    	        thisRow = '#nameValue#,#arrayToList(reportData.earnedRevenueByIssue[nameValue])#';
    	        fileWriteLine(dataFile,thisRow);
    	    }
    	}
    	
    	fileClose(dataFile);
    	getHibachiScope().getService('HibachiUtilityService').downloadFile(fileNameWithExt,filePath,"application/csv",true);
    </cfscript>
    
</cffunction>
<cfset renderReport(reportData,structKeyExists(rc,'productID') && len(rc.productID))/>