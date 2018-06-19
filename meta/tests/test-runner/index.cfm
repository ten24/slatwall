<cfparam name="url.target" 		default="">
<cfparam name="url.reporter" 	default="simple">
<cfparam name="url.opt_recurse" default="true">
<cfparam name="url.labels"		default="">
<cfparam name="url.opt_run"		default="false">
<cfparam name="url.method" 		default="notRemote">
<cfparam name="url.testSpecs" 	default="">

<cfif structKeyExists(url,'testBundles')>
	<cfset url.target = url.testBundles/>
	<cfset url.opt_run = true/>
</cfif>
<cfsetting requesttimeout="3600">
<cfscript>
// curate the base url for reference to root
baseUrl = replaceNoCase(replace(replaceNoCase( getDirectoryFromPath(getCurrentTemplatePath()) , expandPath('/'), '/' ), '\', '/', 'all'),'/meta/tests/test-runner/','');
// create testbox
testBox = new testbox.system.TestBox();
// create reporters
reporters = [ "ANTJunit", "Console", "Codexwiki", "Doc", "Dot", "JSON", "JUnit", "Min", "Raw", "Simple", "Tap", "Text", "XML" ];

if( url.opt_run ){
	// clean up
	for( key in URL ){
		url[ key ] = xmlFormat( trim( url[ key ] ) );
	}
	// execute tests
	if( len( url.target ) ){
		if(url.method == "runRemote"){
			results = testBox.run( bundles=url.target, reporter=url.reporter, testSpecs=url.testSpecs, labels=url.labels );
		}else{
			// directory or CFC, check by existence
			if( !directoryExists( expandPath( "/#replace( url.target, '.', '/', 'all' )#" ) ) ){
				results = testBox.run( bundles=url.target, reporter=url.reporter, labels=url.labels );
			} else {
				results = testBox.run( directory={ mapping=url.target, recurse=url.opt_recurse }, reporter=url.reporter, labels=url.labels );
			}
		}
		if( isSimpleValue( results ) ){
			switch( lcase(url.reporter) ){
			
				case "xml" : case "text" : case "tap" : {
					writeOutput( "<textarea name='tb-results-data' id='tb-results-data' rows='20' cols='100'>#results#</textarea>" );break;
				}
				case "junit":  {
					getPageContext().clear();
					writeOutput("#trim(results)#" );abort;
					xmlReport = xmlParse( results );
					
					
				     for( thisSuite in xmlReport.testsuites.XMLChildren ){
				          fileWrite( reportdestination & "results.xml", toString( thisSuite ) );
				     }
					
				     break;
				}
				case "antjunit": {
					errors = 0;
					failures = 0;

					reportdestination = expandPath('/Slatwall/meta/tests/testresults/xml/unit/');
					filedest = reportdestination & "results.txt";

//					pc = getpagecontext().getresponse();
//						pc.setHeader("Content-Type","text/html");
					if(directoryExists(reportdestination) && fileExists(filedest)){
						txtData = deserializeJson(fileRead(filedest));
						errors = txtData.errors;
						failures = txtData.failures;
					}

					xmlReport = xmlParse( results );
				    for( thisSuite in xmlReport.testsuites.XMLChildren ){
				     	errors += thisSuite.XmlAttributes.errors;
				     	failures += thisSuite.XmlAttributes.failures;
				    }

					fileWrite( filedest, '{"failures":#failures#,"errors":#errors#}' );
					writeOutput( trim(results) );
					break;
				}
				default: {

					writeOutput( trim(results) );
				}
			}
		} else {
			writeDump( trim(results) );
		}
	} else {
		writeOutput( '<h2>No tests selected for running!</h2>' );
	}
	abort;
}
</cfscript>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta name="generator" content="TestBox v#testbox.getVersion()#">
	<title>TestBox Global Runner</title>
	<script><cfinclude template="/testbox/system/reports/assets/js/jquery.js"></script>
	<script>
	$(document).ready(function() {
		$("#testFolder").change(function(){
			var selectedFolder = $('#testFolder').val();
		 	$("#testFile").find("option:gt(0)").remove();
	 		$("#testMethod").find("option:gt(0)").remove();
	 		$("#testFile").prop('disabled', true);
	 		$("#testMethod").prop('disabled', true);
	 		$("#method").val("notRemote");
			$("#testSpecs").val("");
			if(selectedFolder != "default"){
		 		testFilesAjax(selectedFolder);
		 	}
		});

		$("#testFile").change(function(){
			var selectedFolder = $('#testFolder').val();
			var selectedFile = $('#testFile').val();
			$("#testMethod").find("option:gt(0)").remove();
	 		$("#testMethod").prop('disabled', true);
	 		$("#method").val("notRemote");
			$("#testSpecs").val("");
			if(selectedFolder != "default" && selectedFile != "default" ){
		 		testMethodsAjax(selectedFolder,selectedFile);
			 }
		});
	});
	function runTests(){
		setTargetValue();
		$("#tb-results").html( "" );
		$("#btn-run").html( 'Running...' ).css( "opacity", "0.5" );
		$("#tb-results").load( "index.cfm", $("#runnerForm").serialize(), function( data ){
			$("#btn-run").html( 'Run' ).css( "opacity", "1" );
		} );
	}
	function clearResults(){
		$("#tb-results").html( '' );
		$("#target").html( '' );
		$("#labels").html( '' );
		$("#method").val("notRemote");
		$("#testSpecs").val("");
	}

	function testFoldersAjax() {
	    $.ajax({
	        type: "GET",
	        url: "<cfoutput>#baseUrl#</cfoutput>/meta/tests/test-runner/directoryMapping.cfc?method=getTestFolders",
	        data: {
	        },
	        success: function (data) {
	             displayTestFolders(data);
	        },
	        error: function (e) {
	            alert("ERROR: ", "Something went wrong");
	        }
	    });
	}

	function displayTestFolders(data){
		var parent = document.getElementById("testFolder");
		var response = JSON.parse(data);
		for (i in response.TestFolders) {
		 	var option = document.createElement("option");
		 	option.text = response.TestFolders[i];
		 	option.value = response.TestFolders[i];
		 	parent.add(option);
		 }
	}

	function testFilesAjax(selectedFolder) {
		    $.ajax({
		        type: "GET",
		        url: "<cfoutput>#baseUrl#</cfoutput>/meta/tests/test-runner/directoryMapping.cfc?method=getTestFiles&testFolder="+selectedFolder,
		        data: {
		        },
		        success: function (data) {
		             displayTestFiles(data);
		        },
		        error: function (e) {
		            alert("ERROR: ", "Something went wrong");
		        }
		    });

	}

	function displayTestFiles(data){
		var parent = document.getElementById("testFile");
		var response = JSON.parse(data);
		for (i in response.TestFiles) {
		 	var option = document.createElement("option");
		 	option.text = response.TestFiles[i];
		 	option.value = response.TestFiles[i];
		 	parent.add(option);
		}
		$("#testFile").prop('disabled', false);
	}

	function testMethodsAjax(selectedFolder, selectedFile) {
		    $.ajax({
		        type: "GET",
		        url: "<cfoutput>#baseUrl#</cfoutput>/meta/tests/test-runner/directoryMapping.cfc?method=getTestMethods&testFolder="+selectedFolder+"&testFile="+selectedFile,
		        data: {
		        },
		        success: function (data) {
		             displayTestMethods(data);
		        },
		        error: function (e) {
		            alert("ERROR: ", "Something went wrong");
		        }
		    });

	}

	function displayTestMethods(data){
		var parent = document.getElementById("testMethod");
		var response = JSON.parse(data);
		for (i in response.TestMethods) {
		 	var option = document.createElement("option");
		 	option.text = response.TestMethods[i];
		 	option.value = response.TestMethods[i];
		 	parent.add(option);
		}
		$("#testMethod").prop('disabled', false);
	}

	function setTargetValue(){
		var testFolder = $("#testFolder").val();
		var testFile = $("#testFile").val();
		var testMethod = $("#testMethod").val();
		var url="meta/tests/unit/";
		if(testFolder != "default"){
			url += testFolder;
			if(testFile != "default"){
				url += "/"+testFile;
			}
			$("#target").val(url);
		}
		else{
			alert("Select a Test Folder first");
		}
		if(testMethod != "default"){
				$("#method").val("runRemote");
				$("#testSpecs").val(testMethod);
			}
		else{
			$("#method").val("notRemote");
			$("#testSpecs").val("");
		}
	}

	</script>
	<style>
	body{
		font-family:  Monaco, "Lucida Console", monospace;
		font-size: 10.5px;
		line-height: 14px;
	}
	h1,h2,h3,h4{ margin-top: 3px;}
	h1{ font-size: 14px;}
	h2{ font-size: 13px;}
	h3{ font-size: 12px;}
	h4{ font-size: 11px; font-style: italic;}
	ul{ margin-left: -10px;}
	li{ margin-left: -10px; list-style: none;}
	a{ text-decoration: none;}
	a:hover{ text-decoration: underline;}
	/** utility **/
	.centered { text-align: center !important; }
	.inline{ display: inline !important; }
	.margin10{ margin: 10px; }
	.padding10{ padding: 10px; }
	.margin0{ margin: 0px; }
	.padding0{ padding: 0px; }
	.box{ border:1px solid gray; margin: 10px 0px; padding: 10px; background-color: #f5f5f5}
	.pull-right{ float: right;}
	.pull-left{ float: left;}
	.clear { clear: both; }
	#tb-runner{ min-height: 135px}
	#tb-runner #tb-left{ width: 17%; margin-right: 10px; margin-top: 15px; float:left;}
	#tb-runner #tb-right{ width: 80%; }
	#tb-runner fieldset{ padding: 10px; margin: 10px 0px; border: 1px dotted gray;}
	#tb-runner input{ padding: 5px; margin: 2px 0px;}
	#tb-runner .btn-red {
		background:-webkit-gradient( linear, left top, left bottom, color-stop(0.05, #f24537), color-stop(1, #c62d1f) );
		background:-moz-linear-gradient( center top, #f24537 5%, #c62d1f 100% );
		filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#f24537', endColorstr='#c62d1f');
		background-color:#f24537;
		-webkit-border-top-left-radius:5px;
		-moz-border-radius-topleft:5px;
		border-top-left-radius:5px;
		-webkit-border-top-right-radius:5px;
		-moz-border-radius-topright:5px;
		border-top-right-radius:5px;
		-webkit-border-bottom-right-radius:5px;
		-moz-border-radius-bottomright:5px;
		border-bottom-right-radius:5px;
		-webkit-border-bottom-left-radius:5px;
		-moz-border-radius-bottomleft:5px;
		border-bottom-left-radius:5px;
		text-indent:1.31px;
		border:1px solid #d02718;
		display:inline-block;
		color:#ffffff;
		font-weight:bold;
		font-style:normal;
		height:25px;
		width:71px;
		text-decoration:none;
		text-align:center;
		cursor: pointer;
	}
	#tb-runner .btn-red:hover {
		background:-webkit-gradient( linear, left top, left bottom, color-stop(0.05, #c62d1f), color-stop(1, #f24537) );
		background:-moz-linear-gradient( center top, #c62d1f 5%, #f24537 100% );
		filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#c62d1f', endColorstr='#f24537');
		background-color:#c62d1f;
	}
	#tb-runner .btn-red:active {
		position:relative;
		top:1px;
	}
	#tb-results{ padding: 10px;}
	</style>
</head>
<cfoutput>
<body onload="testFoldersAjax()">

<!--- Title --->
<div id="tb-runner" class="box" style="min-height:220px">
<form name="runnerForm" id="runnerForm">
<input type="hidden" name="opt_run" id="opt_run" value="true">
<input type="hidden" name="method" id="method" value="notRemote">
<input type="hidden" name="testSpecs" id="testSpecs" value="">

	<div id="tb-left" class="centered">
		<img src="http://www.ortussolutions.com/__media/testbox-185.png" alt="TestBox" id="tb-logo"/><br>v#testbox.getVersion()#
	</div>

	<div id="tb-right">
		<h1>TestBox Global Runner</h1>
		<p>Please use the form below to run test bundle(s), directories and more.</p>
			<cfset inputValue = "meta/tests/unit/"/>
			<cfif len(url.target)>
				<cfset inputValue = url.target/>
			</cfif>

			<input type="hidden" name="target" id="target" value=""/>
			<div>
			<p style="font-size:15px;">Bundle(s) or Directory Mapping :-</p>
			<select id="testFolder">
			  <option value="default">Select Folder</option>
			</select>
			<select id="testFile" disabled="true">
			  <option value="default">Select File</option>
			</select>
			<select id="testMethod" disabled="true">
			  <option value="default">Select Method</option>
			</select>
			<label title="Enable directory recursion for directory runner">
				<input name="opt_recurse" id="opt_recurse" type="checkbox" value="true" <cfif url.opt_recurse>checked="true"</cfif> /> Recurse Directories
			</label>
			</div>
			<br>
			<label title="List of labels to apply to tests">
				<input type="text" name="labels" id="labels" value="#url.labels#" size="50" placeholder="Label(s)"/>
			</label>
			<br>
			<select name="reporter">
				<cfloop array="#reporters#" index="thisReporter">
					<option <cfif url.reporter eq thisReporter>selected="selected"</cfif> value="#thisReporter#">#thisReporter# Reporter</option>
				</cfloop>
			</select>
			<button class="btn-red" type="button" onclick="clearResults()">Clear</button>
			<button class="btn-red" type="button" id="btn-run" title="Run all the tests" onclick="runTests()">Run</button>
	</div>
	<div class="clear"></div>
</form>
</div>

<!--- Results --->
<div id="tb-results"></div>

</body>
</html>
</cfoutput>
