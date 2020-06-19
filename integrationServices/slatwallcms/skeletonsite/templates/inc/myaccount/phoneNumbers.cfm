<!--- This import allows for the custom tags required by this page to work --->
<cfimport prefix="sw" taglib="../../../tags" />
<cfoutput>
    	<!--- START: PHONE NUMBERS --->
		<div class="span4">
			<h5>Phone Numbers</h5>
			<hr style="margin-top:10px;border-top-color:##ddd;" />
			<!--- Start: Existing Phone Numbers --->
			<table class="table table-condensed">
				
				<cfset accountPhoneNumberIndex=0 />
				
				<!--- Loop over the phone numbers to display them --->
				<cfloop array="#$.slatwall.getAccount().getAccountPhoneNumbersSmartList().getRecords()#" index="accountPhoneNumber">
					
					<cfset accountPhoneNumberIndex++ />
					
					<tr>
						<td>
							<!--- Display Number --->
							<div class="apn#accountPhoneNumberIndex#<cfif accountPhoneNumber.hasErrors()> hide</cfif>">
								<span>#accountPhoneNumber.getPhoneNumber()#</span>
								<span class="pull-right">
									<a href="##" onClick="$('.apn#accountPhoneNumberIndex#').toggle()" title="Edit Phone Number"><i class="icon-pencil"></i></a>
									<a href="?slatAction=public:account.deleteAccountPhoneNumber&accountPhoneNumberID=#accountPhoneNumber.getAccountPhoneNumberID()#" title="Delete Phone Number - #accountPhoneNumber.getPhoneNumber()#"><i class="icon-trash"></i></a>
									<cfif accountPhoneNumber.getAccountPhoneNumberID() eq $.slatwall.getAccount().getPrimaryPhoneNumber().getAccountPhoneNumberID()>
										<i class="icon-asterisk" title="#accountPhoneNumber.getPhoneNumber()# is the primary phone number for this account" style="margin-right:5px;"></i>
									<cfelse>
										<a href="?slatAction=public:account.update&primaryPhoneNumber.accountPhoneNumberID=#accountPhoneNumber.getAccountPhoneNumberID()#" title="Set #accountPhoneNumber.getPhoneNumber()# as your primary phone number"><i class="icon-asterisk"></i></a>&nbsp;	
									</cfif>
								</span>
							</div>
							
							<!--- Edit Number --->
							<div class="apn#accountPhoneNumberIndex#<cfif not accountPhoneNumber.hasErrors()> hide</cfif>">
								
								<!--- Start: Edit Phone Number --->
								<form action="?s=1" method="post">
									
									<input type="hidden" name="slatAction" value="public:account.update" />
									<input type="hidden" name="accountPhoneNumbers[1].accountPhoneNumberID" value="#accountPhoneNumber.getAccountPhoneNumberID()#" />
										
									<!--- Phone Number --->
									<div class="control-group">
				    					<div class="controls">
				    						
											<div class="input-append">
												<sw:FormField type="text" name="accountPhoneNumbers[1].phoneNumber" valueObject="#accountPhoneNumber#" valueObjectProperty="phoneNumber" class="span3" />
												<button type="button" class="btn" onClick="$('.apn#accountPhoneNumberIndex#').toggle()">x</button>
												<button type="submit" class="btn btn-primary">Save</button>
											</div>
											
											<sw:ErrorDisplay object="#accountPhoneNumber#" errorName="phoneNumber" />
											
				    					</div>
				  					</div>
									
								</form>
								<!--- End: Edit Phone Number --->
							</div>
							
						</td>
					</tr>
				</cfloop>
			</table>
			<!--- End: Existing Phone Numbers --->
			
			<!--- Start: Add Phone Number Form --->
			<form action="?s=1" method="post">
				<input type="hidden" name="slatAction" value="public:account.update" />
				<input type="hidden" name="accountPhoneNumbers[1].accountPhoneNumberID" value="" />
				<div class="control-group">
					<div class="controls">
						
						<cfset newAccountPhoneNumber = $.slatwall.getAccount().getNewPropertyEntity( 'accountPhoneNumbers' ) />
						
						<div class="input-append">
							<sw:FormField type="text" name="accountPhoneNumbers[1].phoneNumber" valueObject="#newAccountPhoneNumber#" valueObjectProperty="phoneNumber" fieldAttributes='placeholder="Add Phone Number"' class="span3" />
							<button type="submit" class="btn btn-primary"><i class="icon-plus icon-white"></i></button>
						</div>
						
						<sw:ErrorDisplay object="#newAccountPhoneNumber#" errorName="phoneNumber" />
						
					</div>
  				</div>
			</form>
			<!--- End: Add Phone Number Form --->
			
			<br />		
		</div>
		<!--- END: PHONE NUMBERS --->
</cfoutput>