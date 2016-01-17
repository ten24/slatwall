<cfoutput>
<cfinclude template="header.cfm" >
<div>
  <div>
    <section>
        <div>     
        	<div ng-init="Account_Login = slatwall.getProcessObject('Account_Login') "></div>
                      {{(Account_Login|json)}}                         
            <div class="container" >
                <div>
                    <h2>Examples:</h2>
                    <h3>These are basic examples of using frontend directives</h3>
                </div>
                
                <div class="directives">
                	<p>
                    	<b>Example: Basic Account Info </b>  
                    	can be accessed from anywhere within the frontend app
                    	by referencing slatwall.account or cart . fieldname
                    	<br>
                    	For example: slatwall.account.firstName, slatwall.account.lastName or slatwall.userIsLoggedIn()
                    	will reference those values.
                    	<br>
                    	<span>{{slatwall.account.firstName}}</span><br>
                	</p>
                	
                	<p>
                        <b>Example login/logout using custom partial</b><br>       
                        Accepts a email and password and logs in the user.
                        <br><swf-directive partial-path="custom/assets/frontend/components/custom/" partial-name="customlogindirective"  ng-if="!slatwall.userIsLoggedIn()"></swf-directive>
                     
                        <span ng-bind="(slatwall.account.firstName + ' ' + slatwall.account.lastName)"></span><br>
                        <br><swf-directive partial-name="logoutdirectivepartial"  ng-if="slatwall.userIsLoggedIn()"></swf-directive>
                    </p>
                    <p>
                    	<b>Example: List, Add, and Remove Promo Codes</b>
                        <br>
                         Cart is accessed the same way as Account. hibachiScope.cart.subtotal or hibachiScope.cart.discounttotal
                         or hibachiScope.cart.calculatedtotal yeild totals on the order while hibachiScope.cart.orderitems is
                         an array of objects that contain the items on the order.
                         <br><br>
                         <b>
                            Listing the promotion codes with delete button:
                            {{slatwall.getPromotionCodeList()}}</b>
                         <br><br>
                         
                         
                         <swf-directive partial-name="promopartial"></swf-directive>
                         <span ng-repeat="promoCode in slatwall.getPromotionCodes()">
                            <span ng-bind="('PromotionCode: ' + promoCode)"></span><button ng-click="slatwall.doAction('removePromotionCode', {'promotionCode': promoCode })">Delete</button>
                         </span>
                     </p>
                     <br><br>
                     <p>
                          <b>swf-directive</b> example for specifying the directive path to use.
                            This directive allows you to use one directive to wrap any partial custom or built in.
                          <br>
                             path is /org/Hibachi/src/frontend/components/
                             partial-name is createaccountpartial
                             
                             *Note you do not need to provide an .html ext on the partial-name attribute.
                             Also, there is no need to provide the path attribute if using the default partial directory.
                             
                             Cart lists should be able to provide an image as well as a delete button for the items.
                          <br>
                        <br><swf-directive partial-name="createaccountpartial"></swf-directive><br>
                     </p>
                     
                      
                      
                      <!--- Example just using HTML --->
                      <b>Example login using HTML</b><br>
                 	   <sw-form data-is-process-form="true" 
                 	         data-object="Account_Login" 
                 	         data-on-success="show:Account_Logout" 
                 	         data-form-class="cssform" 
                 	         data-error-class="error" 
                 	         data-action="login">
                       <div> 
                            <label>Email: <input name="emailAddress" type="email" ng-model="Account_Login.emailAddress"/></label>
                            <span error-for="emailAddress" class="error"></span>
                       </div>
                       
                       <div>
                            <label>Password:<input name="password"  type="password" ng-model="Account_Login.password"/></label>
                            <span error-for="password" class="error"></span>
                            <input type="submit" ng-click="$parent.swForm.submit()" />
                       </div>
                      </sw-form>
                      <br>
                      
                      
                      
                      <br>
                      <!--- Example just using formFields --->
                      
                      <b>Example login using swfFormFields</b><br>
                      
                      <sw-form data-is-process-form="true" 
                             data-object="Account_Login" 
                             data-on-success="hide:this" 
                             data-form-class="cssform" 
                             data-error-class="error" 
                             data-action="login">
                       
                            <div>
                            	<label>
                            		Email Address {{Account_Login.validations.properties.emailAddress.value}}
                            	</label>
                                <swf-form-field type="email" object="Account_Login.validations.properties.emailAddress.value" class="formControl" name="emailAddress"></swf-form-field>
                                <span error-for="emailAddress"></span>
                            </div>
                            <div>
                                <label>
                                    Password
                                </label>
                                <swf-form-field type="password" object="Account_Login.validations.properties.password" class="formControl" name="password"></swf-form-field>
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
<style type="text/css">
  .css-form input.ng-invalid.ng-touched {
    border: 1px solid red;
  }

  .css-form input.ng-valid.ng-touched {
    border: 1px solid gray;
  }
  
  .error {
  	color: red;
  	font-size: 11px;
  	padding-top:10px;
  	padding-bottom: 10px;
  }
</style>
<style >
    dl {
        
        border: 1px dotted gray;
        padding:1.5em;
        background-color:white;
        color:#666666;
        margin-left: 20px;
        margin-right: 20px;
        
        }
    dt {
        float: left;
        clear: left;
        width: 100px;
        text-align: right;
        font-weight: bold;
        color: gray;
          }
          dt:after {
            content: ":";
          }
    dd {
        margin: 0 0 0 110px;
        padding: 0 0 0.5em 0;
    }
    dl p {
        text-size: 2em;
    }
    dl h4 {
        border-radius: 10px;
        background-color: #428BCA;
        color: white;
        padding: 20px;
        margin:20px;
    }
    
            
    /*Header*/
    .s-ds-header {
        background: #F58620;
        color: #fff;
        padding: 100px;
        margin:20px;
    }
    /* body */
    .directives {
        padding: 2px;
        padding-left:100px;
    }
    .att_header {
        background: #ffffff;
        color: #000001;
        padding: 10px;
        margin:10px;
    }
    .s-ds-header h1 {
        margin-top:0px;
    }
    .s-ds-header a {
        color: #fff;
        text-decoration: underline;
    }
    .s-ds-header a:hover {
        color: #eee;
    }
    
    /*Sidebar*/
    .s-ds-sidebar h2 {
        font-size: 22px;
        margin-bottom: 3px;
    }
    
    /*Type Object Group*/
    .s-ds-type-group > h2 {
        border-bottom: 2px solid #AAA;
        font-weight: 600;
        text-transform: uppercase;
    }
    .s-ds-obj-listing li {
        margin-bottom: 10px;
    }
    .s-ds-type-item-objs .s-ds-type-item-obj {
        padding: 20px;
        background: #fff;
        border-radius: 4px;
    }
</style>
                            <!--
                            <swf-form process-object="Account_login" action="$login">
                                <label>Email Address: <input type="text" name="inputEmailAddress" ng-model="Account_login.inputEmailAddress"></input></label>
                                <label>Password: <input type="password" name="inputPassword" ng-model="Account_login.inputPassword"></input></label>
                                <input type="submit" name="submitLogin" ng-click="submit()"></input>
                            </swf-form>
                            -->
