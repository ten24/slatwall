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
<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfoutput>
	<div class="row s-body-nav">
	    <nav class="navbar navbar-default" role="navigation">
	      <div class="col-md-4 s-header-info">

				<!--- Page Title --->
				<h1 class="actionbar-title">#$.slatwall.rbKey('admin.main.about')#</h1>
			</div>
		 </div>
	   </nav>
	 </div>
	<div style="padding: 20px;padding-top: 70px;">
		<div class="svohelpabout">
			<strong>Documentation: </strong><a href="http://docs.getslatwall.com">http://docs.getslatwall.com</a><br /><br />
			<strong>Google Group: </strong><a href="http://groups.google.com/group/slatwallecommerce">http://groups.google.com/group/slatwallecommerce</a><br /><br />
			<strong>Feature & Bug Tracking: </strong><a href="https://github.com/ten24/Slatwall/issues">https://github.com/ten24/Slatwall/issues</a><br /><br />
			<strong>Debugging Details: </strong>Please Copy & Paste these debugging details to any issues submitted<br /><br />
			<textarea name="debugDetails" style="width:100%; height:500px;">
		Operating System:	#server.os.name#
		CFML Server:		#server.coldfusion.productName#: <cfif structKeyExists(server,"railo")>#server.railo.version#<cfelseif structKeyExists(server,'lucee')>#server.lucee.version#<cfelse>#server.coldfusion.productVersion#</cfif>
		DB Dialect: 		#$.slatwall.getApplicationValue('databaseType')#
		Slatwall Version:	#$.slatwall.getApplicationValue('version')#
			</textarea>
		</div>
	</div>
</cfoutput>
