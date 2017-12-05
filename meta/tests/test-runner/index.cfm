<cfparam name="url.target" 		default="">
<cfparam name="url.reporter" 	default="simple">
<cfparam name="url.opt_recurse" default="true">
<cfparam name="url.labels"		default="">
<cfparam name="url.opt_run"		default="false">
<cfparam name="url.done"		default="false">
<cfparam name="url.init"   	    default="false">
<cfparam name="url.dest"		default="/Slatwall/meta/tests/testresults">
<cfparam name="url.reportPath"  default="/xml/unit">
<cfparam name="url.debugPath"  default="/debug">
<cfif structKeyExists(url,'testBundles')>
	<cfset url.target = url.testBundles/>
	<cfset url.opt_run = true/>
</cfif>
<cfsetting requesttimeout="3600">
<cfscript>
// remove trailing '/' from dest directory
if (right(url.dest, 1) == '/') {
	url.dest = mid(url.dest, 1, len(url.dest) - 1);
}

// prefix reportPath with '/'
if (left(url.reportPath, 1) != '/') {
	url.reportPath &= '/';
}

// prefix debugPath with '/'
if (left(url.debugPath, 1) != '/') {
	url.debugPath &= '/';
}

// Output files for debugging details
debugDestination = expandPath('#url.dest##url.debugPath#');
reportOutputFileDest = '#debugDestination#/report-output.xml';
stackTraceFileDest = '#debugDestination#/stacktrace.html';

// Output files for results
reportDestination = expandPath('#url.dest##url.reportPath#');
filedest = reportDestination & "/results.txt";
testPropertiesDest = reportDestination & '/test.properties';

// create testbox
testBox = new testbox.system.TestBox();
// create reporters
reporters = [ "ANTJunit", "Console", "Codexwiki", "Doc", "Dot", "JSON", "JUnit", "Min", "Raw", "Simple", "Tap", "Text", "XML" ];

void function setupRunner() {
	application.testrunner = {};
	application.testrunner.results = [];
	application.testrunner.totals = {
		totalDuration = 0,
		totalPass = 0,
		totalFail = 0,
		totalError = 0,
		totalSkipped = 0
	};
}

// Persist test results in testrunner application scope
if (!structKeyExists(application, "testrunner") || url.init) {
	setupRunner();

	// Nothing to output, just resetting
	if (url.init) {
		abort;
	}
}

// Write out results that will be consumed by ANT task build.xml (nothing to output)
if (url.done) {
	// Make sure directory exists
	if (!directoryExists(reportDestination)) {
		directoryCreate(reportDestination);
	}

	// Save results in file
	//fileWrite( filedest, '{"failures":#application.testrunner.totals.totalFail#,"errors":#application.testrunner.totals.totalError#}' );

	// Save results to properties file
	testPropertiesContent = (application.testrunner.totals.totalFail + application.testrunner.totals.totalError) > 0 ? "test.failed=true" : "test.passed=true";
	testPropertiesContent &= "#chr(10)#test.duration=#application.testrunner.totals.totalDuration#";
	testPropertiesContent &= "#chr(10)#test.pass=#application.testrunner.totals.totalPass#";
	testPropertiesContent &= "#chr(10)#test.fail=#application.testrunner.totals.totalFail#";
	testPropertiesContent &= "#chr(10)#test.error=#application.testrunner.totals.totalError#";
	testPropertiesContent &= "#chr(10)#test.skipped=#application.testrunner.totals.totalSkipped#";
	fileWrite( testPropertiesDest, testPropertiesContent );

	// Clean up
	structDelete(application, "testrunner");
	setupRunner();
	abort;
}

if( url.opt_run ){
	// clean up
	for( key in URL ){
		url[ key ] = xmlFormat( trim( url[ key ] ) );
	}
	// execute tests
	if( len( url.target ) ){		
		
		// directory or CFC, check by existence
		if( !directoryExists( expandPath( "/#replace( url.target, '.', '/', 'all' )#" ) ) ){
			results = testBox.run( bundles=url.target, reporter=url.reporter, labels=url.labels );
		} else {
			results = testBox.run( directory={ mapping=url.target, recurse=url.opt_recurse }, reporter=url.reporter, labels=url.labels );
		}

		// NOTE: testBox.run report sets the response contentType automatically, override with line below
		// getPageContext().getResponse().setContentType( "text/html" );

		// Keep track of result objects across requests
		testResult = testBox.getResult();
		lock name="testrunner-results" type="exclusive" timeout="30" {
			arrayAppend(application.testrunner.results, testResult);
			application.testrunner.totals.totalDuration += testResult.getTotalDuration();
			application.testrunner.totals.totalPass += testResult.getTotalPass();
			application.testrunner.totals.totalFail += testResult.getTotalFail();
			application.testrunner.totals.totalError += testResult.getTotalError();
			application.testrunner.totals.totalSkipped += testResult.getTotalSkipped();
		}

		// TestBox does not escape any invalid special characters (eg 0x2 'start of heading' which causes XML parsing errors)
		results = replaceNoCase(results, "#chr(2)#", "", "all");

		if( isSimpleValue( results ) ){
			switch( lcase(url.reporter) ){
				case "xml" : case "text" : case "tap" : {
					writeOutput( "<textarea name='tb-results-data' id='tb-results-data' rows='20' cols='100'>#results#</textarea>" );break;
				}
				case "junit":  {
					xmlReport = xmlParse( results );
					

				     for( thisSuite in xmlReport.testsuites.XMLChildren ){
				          fileWrite( reportdestination & "results.xml", toString( thisSuite ) );
				     }
				     break;
				}
				case "antjunit": {
					
					try {
						if (!isXML(results)) {
							throw("XML produced by TestBox is not valid. You can manually inspect raw results '#debugDestination#/report-output.xml' file.");
						}

						writeOutput( trim(results) ); 

					// Graceful error handling, provide more detailed information for debugging
					} catch (any e) {
						// Make sure debug directory exists

						if (!directoryExists(debugDestination)) {
							writeDump("Create directory");
							directoryCreate(debugDestination);
						}
						
						// Write file raw results from TestBox
						fileWrite(reportOutputFileDest, results);

						// Write file stack trace information
						stackTraceContent = "";
						savecontent variable="stackTraceContent" {
							writeDump(e);
						};
						fileWrite(stackTraceFileDest, stackTraceContent);

						// Continue with valid XML response
						writeOutput(('<error>
							<message>#e.message#</message>
							<errorCode>#e.errorCode#</errorCode>
							<detail>#e.detail#</detail>
							<type>#e.type#</type>
							<extendedinfo>#e.extendedInfo#</extendedinfo>
							<stacktrace>#e.stackTrace#</stacktrace>
						</error>'));
					}
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
		
	});
	function runTests(){
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
<body>

<!--- Title --->
<div id="tb-runner" class="box" style="min-height:220px">
<form name="runnerForm" id="runnerForm">
<input type="hidden" name="opt_run" id="opt_run" value="true">

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
				
			<input type="text" name="target" value="#trim( inputValue )#" size="50"  placeholder="Bundle(s) or Directory Mapping"/>
			<label title="Enable directory recursion for directory runner">
				<input name="opt_recurse" id="opt_recurse" type="checkbox" value="true" <cfif url.opt_recurse>checked="true"</cfif> /> Recurse Directories
			</label>
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
