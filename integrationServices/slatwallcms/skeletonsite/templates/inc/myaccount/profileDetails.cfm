<!--- This import allows for the custom tags required by this page to work --->
<cfimport prefix="sw" taglib="../../../tags" />
<cfoutput>
    	<!--- Start: Update Account Form - Server Side --->
    	<h6>Server Side</h6>
		<form class="card-body" action="?s=1" method="post">
			
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
					<hr style="margin-top:10px;border-top-color:##ddd;" />
					
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
		<!--- End: Update Account Form - Server Side --->
		
		<!--- Start: Update Account Form - Client Side --->
		
		<sw-form
		data-is-process-form="true"
	    data-object="'Account'"
	    data-error-class="error"
	    data-name="Account_Update"
		data-event-announcers="click,blur,change"
	    >
			
		<h6>Update Account - Client Side</h6>
		   <div class="col-sm-12 form-group">
		        <swf-property-display
		            data-name="firstName"
		            data-type="string"
		            data-property-identifier="firstName"
		            data-label-text="First Name"
		            data-class="form-control"
		            >
		        </swf-property-display>
		    </div>
		    <div class="col-sm-12 form-group">
		        <swf-property-display
		            data-name="lastName"
		            data-type="string"
		            data-property-identifier="lastName"
		            data-label-text="Last Name"
		            data-class="form-control"
		            >
		        </swf-property-display>
		    </div>
		    <div class="col-sm-12 form-group">
			    <sw-action-caller
			        data-action="updateAccount"
			        data-modal="false"
			        data-type="button"
			        data-class="btn-yellow"
			        data-error-class="error"
			        data-text="{{(slatwall.getRequestByAction('login').loading ? 'Loading...' : 'Update Account')}}">
			    </sw-action-caller>
			</div>
		</sw-form>
</cfoutput>