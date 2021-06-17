<!--- This import allows for the custom tags required by this page to work --->
<cfimport prefix="sw" taglib="../../../tags" />
<cfoutput>
    	<!--- Start: Change Password Form --->
		<form action="?s=1" method="post">
			
			<!--- Get the change password process object --->
			<cfset changePasswordObj = $.slatwall.getAccount().getProcessObject('changePassword') />
			
			<!--- This hidden input is what tells slatwall to 'create' an account, it is then chained by the 'login' method so that happens directly after --->
			<input type="hidden" name="slatAction" value="public:account.changePassword" />
				
			<!--- New Password --->
			<div class="control-group">
				<label class="control-label" for="lastName">New Password</label>
				<div class="controls">
					
					<sw:FormField type="password" valueObject="#changePasswordObj#" valueObjectProperty="password" class="span4" />
					<sw:ErrorDisplay object="#changePasswordObj#" errorName="password" />
					
				</div>
  			</div>
			
			<!--- Confirm New Password --->
			<div class="control-group">
				<label class="control-label" for="lastName">Confirm New Password</label>
				<div class="controls">
					
					<sw:FormField type="password" valueObject="#changePasswordObj#" valueObjectProperty="passwordConfirm" class="span4" />
					<sw:ErrorDisplay object="#changePasswordObj#" errorName="passwordConfirm" />
					
				</div>
  			</div>
			
			<!--- Change Button --->
			<div class="control-group">
				<div class="controls">
  					<button type="submit" class="btn btn-primary">Change Password</button>
				</div>
  			</div>
			
		</form>
		<!--- End: Change Password Form --->
</cfoutput>