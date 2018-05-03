<!--- This import allows for the custom tags required by this page to work --->
<cfimport prefix="sw" taglib="../../../tags" />
<cfoutput>
<h5>Forgot Password</h5>
	<!--- Sets up the account login processObject --->
	<cfset forgotPasswordObj = $.slatwall.getAccount().getProcessObject('forgotPassword') />
	
	<cfif $.slatwall.hasSuccessfulAction( "public:account.forgotPassword" )>
		<div class="alert alert-success">
			An email has been sent to the address you provided with a link to reset your password. 
		</div>
	</cfif>
	
	<!--- Start: Forgot Password Form --->
	<form action="?s=1" method="post">
		
		<!--- This hidden input is what tells slatwall to try and login the account --->
		<input type="hidden" name="slatAction" value="public:account.forgotPassword" />
		
		<!--- Email Address --->
		<div class="control-group">
			<label class="control-label" for="rating">Email Address</label>
			<div class="controls">
				
				<sw:FormField type="text" valueObject="#accountLoginObj#" valueObjectProperty="emailAddress" class="span6" />
				<sw:ErrorDisplay object="#forgotPasswordObj#" errorName="emailAddress" />
				
			</div>
	  	</div>
		
		<!--- Reset Email Button --->
		<div class="control-group">
			<div class="controls">
	  			<button type="submit" class="btn">Send Me Reset Email</button>
			</div>
	  	</div>
		
	</form>
	<!--- End: Forgot Password Form --->
</cfoutput>