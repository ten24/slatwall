LICENSE 
Copyright 2006 Mike Schierberl

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.


varScoper
Project Homepage:
http://www.schierberl.com/varscoper


Installation Instructions:
	Extract all files to a publicly accesible directory on your CFMX 6 or 7 server.  
	Navigate to index.cfm or varscoper.cfm and enter the absolute or relative 
	path to the template or directory that you would like to check. 

History
	-v1.3
		-CF Builder Extension Support
		-Recognizes var statements anywhere in a function (CF9)
		-Issues (13,14,15,16,17,18,19,20,21,23,25,26,27,28,30,31,32) Fixed
		-Open BD/Railo Supported
		-CFScript comments parsed correctly
	-v1.2
		-Significant improvements to cfscript parsing engine
		-Issues (6,7,8,9,10,11) fixed
		-Ability to exclude files/folders using properties.xml (only when parsing a folder)
		-Ability to identify tags with "multiple personalities" i.e. cffeed/cfprocparam that can have different behaviors for output variables based on params
		-More agressive var scope checking (newly identified scenarios that were missed before)
		-Addition of unit testing suite
	-v1.12
		-added new tags to the parsing engine
		-added XML output support
		-fixed some bugs related to directory parsing in CF6
	-v1.1
		-added support for cfscript
	-v1.0
		-initial release
		-cf tag support
		-Find unscoped variables created with a cfset within a cffunction
		-Find unscoped variables created with cftags (cfloop, cfquery, etc)
		-Report line numbers and link directly to the line in the file
		-Output to screen or csv






Features:
	-Identifies unscoped variables within cffunctions
	-can return line numbers of functions/variables

Known Limitations:
	
	-(fixed 1.13) Returns false positive when variables are set within a comments block 
	-(fixed 1.13) If you don't scope an argument value, and then reference that value it 
	 will "technically" return a false positive...
		<cfargument name="foo">
		<cfset foo.foo2 = bar /> 
	instead of...
		<cfset arguments.foo.foo2 />

Future TODOs:
	-(fixed 1.13) create a library of all cf tags that can create variables
	-(fixed 1.13) cfscript
	-(fixed 1.13) ignore things in comments (May need to use lookbehind?  Not supported in CF as far as I know)
	-Integration with cfeclipse

How can I help?
	-I need help extending the testCaseCFC file.  If you come across false positives (or negatives)
	 within your code, please send me a snippet so I can add it to the testCaseCFC
	-I need help finding all cftags that create variables (cfloop, cfquery, etc)
	 I'm sure there are some corner cases out there, I'd like to compile a comprehensive list.
	-Send all requests for help or suggestions to mike@schierberl.com



