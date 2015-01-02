<!---

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.

    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms
    of your choice, provided that you follow these specific guidelines:

	- You also meet the terms and conditions of the license of each
	  independent module
	- You must not alter the default display of the Slatwall name or logo from
	  any part of the application
	- Your custom code must not alter or create any files inside Slatwall,
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets
	the above guidelines as a combined work under the terms of GPL for this program,
	provided that you include the source code of that other code when and as the
	GNU GPL requires distribution of source code.

    If you modify this program, you may extend this exception to your version
    of the program, but you are not obligated to do so.

Notes:

--->
<cfparam name="rc.jspath" default="client/js" />

<cfset local.jsOutput = "" />

<!--- Let's have this page persist on the client for 60 days or until the version changes. --->
<cfset dtExpires = (Now() + 60) />
 
<cfset strExpires = GetHTTPTimeString( dtExpires ) />
 
<cfheader
    name="expires"
    value="#strExpires#"
/>

<cfcontent type="text/javascript">
<cfif !request.slatwallScope.hasApplicationValue('ngCompressor_#hash(rc.jspath)#')>
	<!---the order these are loaded matters --->
	<cfset local.jsDirectoryArray = [
		expandPath( '/Slatwall/#rc.jspath#' ),
		expandPath( '/Slatwall/#rc.jspath#/services' ),
		expandPath( '/Slatwall/#rc.jspath#/controllers' ),
		expandPath( '/Slatwall/#rc.jspath#/directives' )
	]>
	
	<cfloop array="#local.jsDirectoryArray#" index="local.jsDirectory">
		<cfdirectory
		    action="list"
		    directory="#local.jsDirectory#"
		    listinfo="name"
		    name="local.jsFileList"
		    filter="*.js"
	    />
	    
	    <cfloop query="local.jsFileList">
		    <cfset local.jsFilePath = local.jsDirectory & '/' & name>
		    <cfset local.fileContent = fileRead(local.jsFilePath, 'utf-8')>
			<cfset local.jsOutput &= local.fileContent />
	    </cfloop>
	</cfloop>
	
	<cfif request.slatwallScope.getApplicationValue('debugFlag')>
		<cfset getPageContext().getOut().clearBuffer() />
		<cfset request.slatwallScope.setApplicationValue('ngCompressor_#hash(rc.jspath)#',local.jsOutput)>
	<cfelse>
		<cfset getPageContext().getOut().clearBuffer() />
		<cfset local.oYUICompressor = createObject("component", "Slatwall.org.Hibachi.YUIcompressor.YUICompressor").init(javaLoader = 'Slatwall.org.Hibachi.YUIcompressor.javaloader.JavaLoader', libPath = expandPath('/Slatwall/org/Hibachi/YUIcompressor/lib')) />
		<cfset local.jsOutputCompressed = oYUICompressor.compress(
													inputType = 'js'
													,inputString = local.jsOutput
													).results />
													
		<cfscript>
			ioOutput = CreateObject("java","java.io.ByteArrayOutputStream");
			gzOutput = CreateObject("java","java.util.zip.GZIPOutputStream");
			
			ioOutput.init();
			gzOutput.init(ioOutput);
			
			gzOutput.write(local.jsOutputCompressed.getBytes(), 0, Len(local.jsOutputCompressed.getBytes()));
			
			gzOutput.finish();
			gzOutput.close();
			ioOutput.flush();
			ioOutput.close();
			
			toOutput=ioOutput.toByteArray();
		</cfscript>
		
		<cfset request.slatwallScope.setApplicationValue('ngCompressor_#hash(rc.jspath)#',toOutput)>
		<cfset local.jsOutput = toOutput>
	</cfif>
<cfelse>
	<cfset local.jsOutput = request.slatwallScope.getApplicationValue('ngCompressor_#hash(rc.jspath)#')>
</cfif>

<cfif request.slatwallScope.getApplicationValue('debugFlag')>
	<cfoutput>#local.jsOutput#</cfoutput>
<cfelse>
	<cfheader name="Content-Encoding" value="gzip">
	<cfheader name="Content-Length" value="#ArrayLen(local.jsOutput)#" >
	<cfcontent reset="yes" variable="#local.jsOutput#" />
	<cfabort />
</cfif>
