<!--- This import allows for the custom tags required by this page to work --->
<cfimport prefix="sw" taglib="../../../tags" />
<cfoutput>
	<!--- START: ADDRESS BOOK --->
	<h5>Address Book</h5>
	<hr style="margin-top:10px;border-top-color:##ddd;" />
		
	<ul class="thumbnails">
		
		<cfset accountAddressIndex = 0 />
		
		<!--- Loop over each of the addresses that are saved against the account --->
		<cfloop array="#$.slatwall.getAccount().getAccountAddressesSmartList().getRecords()#" index="accountAddress">
			
			<cfset accountAddressIndex++ />
			
			<li class="span4">
				
				<!--- Display an address block --->	
				<div class="thumbnail">
					
					<!--- Display Address --->
					<div class="aa#accountAddressIndex#<cfif accountAddress.hasErrors()> hide</cfif>">
						<!--- Administration options --->
						<div class="pull-right">
							
							<span class="pull-right">
								<a href="##" onClick="$('.aa#accountAddressIndex#').toggle()" title="Edit Address"><i class="icon-pencil"></i></a>
								<a href="?slatAction=public:account.deleteAccountAddress&accountAddressID=#accountAddress.getAccountAddressID()#" title="Delete Address"><i class="icon-trash"></i></a>
								<!--- If this is the primary address, then just show the astricks --->
								<cfif accountAddress.getAccountAddressID() eq $.slatwall.getAccount().getPrimaryAddress().getAccountAddressID()>
									<i class="icon-asterisk" title="This is the primary address for your account"></i>
								<!--- Otherwise add buttons to be able to delete the address, or make it the primary --->
								<cfelse>
									<a href="?slatAction=public:account.update&primaryAddress.accountAddressID=#accountAddress.getAccountAddressID()#" title="Set this as your primary phone address"><i class="icon-asterisk"></i></a>
								</cfif>
							</span>
							
						</div>
						
						<!--- Address Nickname if it exists --->
						<cfif not isNull(accountAddress.getAccountAddressName())>
							<strong>#htmlEditFormat( accountAddress.getAccountAddressName() )#</strong>
						</cfif>
						
						<!--- Actual Address Details --->
						<sw:AddressDisplay address="#accountAddress.getAddress()#" />
					</div>
					
					<!--- Edit Address --->
					<div class="aa#accountAddressIndex#<cfif not accountAddress.hasErrors()> hide</cfif>">
						
						<!--- Start: Edit Address Form --->
						<form action="?s=1" method="post">
							
							<!--- This hidden input is what tells slatwall to 'create' an account, it is then chained by the 'login' method so that happens directly after --->
							<input type="hidden" name="slatAction" value="public:account.update" />
							
							<input type="hidden" name="accountAddresses[1].accountAddressID" value="#accountAddress.getAccountAddressID()#" />
							
							<!--- Nickname --->
							<div class="control-group">
		    					<label class="control-label" for="firstName">Nickname</label>
		    					<div class="controls">
		    						
									<sw:FormField type="text" name="accountAddresses[1].accountAddressName" valueObject="#accountAddress#" valueObjectProperty="accountAddressName" class="span3" />
									<sw:ErrorDisplay object="#accountAddress#" errorName="accountAddressName" />
									
		    					</div>
		  					</div>
							
							<!--- Address --->
							<sw:AddressForm address="#accountAddress.getAddress()#" fieldNamePrefix="accountAddresses[1].address." fieldClass="span3" />
							
							<!--- Update Button --->
							<div class="control-group">
		    					<div class="controls">
		      						<button type="submit" class="btn btn-primary">Save</button>
									<button type="button" class="btn" onClick="$('.aa#accountAddressIndex#').toggle()">Cancel</button>
		    					</div>
		  					</div>
							
						</form>
						<!--- End: Edit Address Form --->
						
					</div>
					
				</div>
				
			</li>
			
		</cfloop>
		
		<!--- Start: New Address --->
		<li class="span4">
			
			<div class="accordion" id="add-account-address">
			
				<div class="accordion-group">
				
					<!--- This is the top accordian header row --->
					<div class="accordion-heading">
						<a class="accordion-toggle" data-toggle="collapse" data-parent="##add-account-address" href="##new-account-address-form"><i class="icon-plus"></i>Add Account Address</a>
					</div>
				
					<!--- get the newPropertyEntity for accountAddress --->
					<cfset newAccountAddress = $.slatwall.getAccount().getNewPropertyEntity( 'accountAddresses' ) />
					
					<!--- This is the accordian details when expanded --->
					<div id="new-account-address-form" class="accordion-body collapse<cfif newAccountAddress.hasErrors()> in</cfif>">
					
						<div class="accordion-inner">
							
							<!--- Start: New Address Form --->
							<form action="?s=1" method="post">
								
								<!--- This hidden input is what tells slatwall to 'create' an account, it is then chained by the 'login' method so that happens directly after --->
								<input type="hidden" name="slatAction" value="public:account.update" />
								
								<!--- Set the accountAddressID to blank so tha it creates a new one --->
								<input type="hidden" name="accountAddresses[1].accountAddressID" value="" />
								
								<!--- Nickname --->
								<div class="control-group">
			    					<label class="control-label" for="firstName">Nickname</label>
			    					<div class="controls">
			    						
										<sw:FormField type="text" name="accountAddresses[1].accountAddressName" valueObject="#newAccountAddress#" valueObjectProperty="accountAddressName" class="span3" />
										<sw:ErrorDisplay object="#newAccountAddress#" errorName="accountAddressName" />
										
			    					</div>
			  					</div>
								
								<!--- New Address --->
								<sw:AddressForm id="newAccountAddress" address="#newAccountAddress.getAddress()#" fieldNamePrefix="accountAddresses[1].address." fieldClass="span3" />
								
								<!--- Add Button --->
								<div class="control-group">
			    					<div class="controls">
			      						<button type="submit" class="btn btn-primary"><i class="icon-plus icon-white"></i> Add Address</button>
			    					</div>
			  					</div>
								
							</form>
							<!--- End: New Address Form --->
							
						</div>
					</div>
				</div>
			</div>
		</li>
		<!--- End: New Address --->
			
	</ul>
	<!--- END: ADDRESS BOOK --->
</cfoutput>