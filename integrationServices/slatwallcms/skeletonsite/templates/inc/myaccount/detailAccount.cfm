<!--- This import allows for the custom tags required by this page to work --->
<cfimport prefix="sw" taglib="../../../tags" />
<cfoutput>
    	<!--- Start: Update Account Form --->
		<form action="?s=1" method="post">
			
			<!--- This hidden input is what tells slatwall to 'create' an account, it is then chained by the 'login' method so that happens directly after --->
			<input type="hidden" name="slatAction" value="public:account.update" />
				
			<!--- First Name --->
			<div class="control-group">
				<label class="control-label" for="firstName">First Name</label>
				<div class="controls">
					
					<sw:FormField type="text" valueObject="#$.slatwall.getAccount()#" valueObjectProperty="firstName" class="span4" />
					<sw:ErrorDisplay object="#$.slatwall.getAccount()#" errorName="firstName" />
					
				</div>
  			</div>
			
			<!--- Last Name --->
			<div class="control-group">
				<label class="control-label" for="lastName">Last Name</label>
				<div class="controls">
					
					<sw:FormField type="text" valueObject="#$.slatwall.getAccount()#" valueObjectProperty="lastName" class="span4" />
					<sw:ErrorDisplay object="#$.slatwall.getAccount()#" errorName="lastName" />
					
				</div>
  			</div>
			
			<!--- Start: Custom "Account" Attribute Sets --->
			<cfset accountAttributeSets = $.slatwall.getAccount().getAssignedAttributeSetSmartList().getRecords() />
			
			<!--- Only display if there are attribute sets assigned --->
			<cfif arrayLen(accountAttributeSets)>
				
				<!--- Loop over all of the attribute sets --->
				<cfloop array="#accountAttributeSets#" index="attributeSet">
					
					<!--- display the attribute set name --->
					<h5>#attributeSet.getAttributeSetName()#</h5>
					
					<!--- Loop over all of the attributes --->
					<cfloop array="#attributeSet.getAttributes()#" index="attribute">
						
						<!--- Pull this attribute value object out of the order entity ---> 
						<cfset thisAttributeValueObject = $.slatwall.getAccount().getAttributeValue(attribute.getAttributeCode(), true) />
						
						<cfif isObject(thisAttributeValueObject)>
							<!--- Display the attribute value --->
							<div class="control-group">
								
		    					<label class="control-label" for="rating">#attribute.getAttributeName()#</label>
		    					<div class="controls">
		    						
									<sw:FormField type="#attribute.getFormFieldType()#" name="#attribute.getAttributeCode()#" valueObject="#thisAttributeValueObject#" valueObjectProperty="attributeValue" valueOptions="#thisattributeValueObject.getAttributeValueOptions()#" class="span4" />
									<sw:ErrorDisplay object="#thisAttributeValueObject#" errorName="password" />
									
		    					</div>
		  					</div>
		  				<cfelse>
		  					<div class="control-group">
								
		    					<label class="control-label" for="rating">#attribute.getAttributeName()#</label>
		    					<div class="controls">
		    						
			  						<sw:FormField type="#attribute.getFormFieldType()#" valueObject="#$.slatwall.getAccount()#" valueObjectProperty="#attribute.getAttributeCode()#" valueOptions="#attribute.getAttributeOptionsOptions()#" class="span4" />
									<sw:ErrorDisplay object="#$.slatwall.getAccount()#" errorName="#attribute.getAttributeCode()#" />
									
		    					</div>
		  					</div>
		  				</cfif>
						
					</cfloop>
					
				</cfloop>
			</cfif>
			<!--- End: Custom Attribute Sets --->
			
			<!--- Update Button --->
			<div class="control-group">
				<div class="controls">
  					<button type="submit" class="btn btn-primary">Update Account</button>
				</div>
  			</div>
			
		</form>
		<!--- End: Update Account Form --->
</cfoutput>