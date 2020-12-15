<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfoutput>
	<div class="row s-body-nav">
	    <nav class="navbar navbar-default" role="navigation">
	      <div class="col-md-4 s-header-info">

				<!--- Page Title --->
				<h1 class="actionbar-title">#$.slatwall.rbKey('admin.main.system')#</h1>
			</div>
		 </div>
	   </nav>
	 </div>
	<div style="padding: 20px;padding-top: 70px;">
	    <div class="svohelpabout">
	        <hb:HibachiActionCaller action="admin:main.about" type="list">
            <hb:HibachiActionCaller action="admin:main.update" type="list">
            <hb:HibachiActionCaller action="admin:main.processBouncedEmails" type="list">
            <hb:HibachiActionCaller action="admin:main.log" type="list">
            <hb:HibachiActionCaller action="admin:entity.listsession" type="list">
            <cfif $.slatwall.getAccount().getSuperUserFlag()>
				<hb:HibachiActionCaller action="admin:main.encryptionupdatepassword" type="list">
				<hb:HibachiActionCaller action="admin:main.encryptionreencryptdata" type="list">
				<hb:HibachiActionCaller action="admin:main.default" querystring="#getHibachiScope().getApplicationValue('applicationReloadKey')#=#getHibachiScope().getApplicationValue('applicationReloadPassword')#" type="list" text="Reload Slatwall">
			</cfif>
	    </div><br>
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
