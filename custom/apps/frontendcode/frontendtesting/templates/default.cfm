<cfoutput>
<cfinclude template="header.cfm" >
<div>
  <div>
    <section>
        <div>     
        	
                                               
            <div class="container" >
                <div>
                    <h2>Examples:</h2>
                </div>
                
                <div class="directives">
                	
                	
                     <b>Example Create Account </b><br>
                        <swf-directive partial-name="createaccountpartial"></swf-directive>
                     </p>
                     
                     <b>Example Login </b><br>
                        <swf-directive partial-name="logindirectivepartial"></swf-directive>
                     </p>
                    
                     <b>Example Logout </b><br>
                        <swf-directive partial-name="logoutdirectivepartial"></swf-directive>
                     </p>
                      
                     <b>Example login using custom HTML</b><br>
                      
                     <div ng-init="Account_LoginObj = slatwall.getProcessObject('Account_Login') "></div> 
                 	 <sw-form data-is-process-form="true" 
                 	         data-object="Account_LoginObj"
                 	         data-on-success="show:Account_Logout" 
                 	         data-form-class="cssform" 
                 	         data-error-class="error" 
                 	         data-action="login"
                 	         data-name="Account_Login">
                     <div>
                            <label>Email: <input name="emailAddress" type="email" ng-model="Account_LoginObj.emailAddress"/></label>
                            <span error-for="emailAddress" class="error"></span>
                     </div>
                       
                     <div>
                            <label>Password:<input name="password"  type="password" ng-model="Account_LoginObj.password"/></label>
                            <span error-for="password" class="error"></span>
                            <input type="submit" ng-click="$parent.swForm.submit()" />
                     </div>
                     </sw-form>
                     <br>
                      
                      
                      <b>Example login using just form fields</b><br>
                      <div ng-init="AccountLoginObjTwo = slatwall.getProcessObject('Account_Login') "></div> 
                      {{AccountLoginObjTwo}}
                      <sw-form data-is-process-form="true" 
                             data-object="AccountLoginObjTwo" 
                             data-on-success="hide:this" 
                             data-form-class="cssform" 
                             data-error-class="error"
                             data-name="Account_Login"
                             data-action="login">
                       
                            <div>
                            	<label>Email Address</label>
                                <swf-form-field type="email" 
                                    object="AccountLoginObjTwo" 
                                    property-identifier="emailAddress" 
                                    class="formControl" 
                                    name="emailAddress"></swf-form-field>          
                                    <span error-for="emailAddress"></span>
                            </div>
                            
                            <div>
                                <label>Password</label>
                                <swf-form-field 
                                    type="password" 
                                    object="AccountLoginObjTwo" 
                                    property-identifier="password" 
                                    class="formControl" 
                                    name="password"></swf-form-field>
                                    <div error-for="password"></div>
                            </div>
                            
                            <input type="submit" ng-click="$parent.swForm.submit()" />
                      </sw-form>
                </div>
            </div>
        </div>
    </section>
  </div>
   </dd> 

</div>
</cfoutput>
<cfinclude template="footer.cfm" >
