<!--- This import allows for the custom tags required by this page to work --->
<cfimport prefix="sw" taglib="../../../tags" />
<cfoutput>
	<!--- Start: Login Form --->
	<form action="?s=1" method="post">
		
		<!--- This hidden input is what tells slatwall to try and login the account --->
		<input type="hidden" name="slatAction" value="public:account.login" />
		
		<!--- Email Address --->
		<div class="control-group">
			<label class="control-label" for="rating">Email Address</label>
			<div class="controls">
				
				<sw:FormField type="text" valueObject="#accountLoginObj#" valueObjectProperty="emailAddress" class="span6" />
				<sw:ErrorDisplay object="#accountLoginObj#" errorName="emailAddress" />
				
			</div>
	  	</div>
		
		<!--- Password --->
		<div class="control-group">
			<label class="control-label" for="rating">Password</label>
			<div class="controls">
				
				<sw:FormField type="password" valueObject="#accountLoginObj#" valueObjectProperty="password" class="span6" />
				<sw:ErrorDisplay object="#accountLoginObj#" errorName="password" />
				
			</div>
	  	</div>
		
		<!--- Login Button --->
		<div class="control-group">
			<div class="controls">
	  			<button type="submit" class="btn btn-primary">Login & Continue</button>
			</div>
	  	</div>
		
	</form>
	<!--- End: Login Form --->
</cfoutput>