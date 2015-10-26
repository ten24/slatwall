<cfoutput>
<cfinclude template="header.cfm" >
<div>
  <div ng-controller="swfController as slatwall">
    <section>
        <div>           
            <div class="container" >
                <div class="s-ds-header">
                    <h2>Form Field Display:</h2>
                    <h3>This directive is used to build all the other frontend tags.</h3>
                </div>
                <p class="directives">
                    
                    <dl>
                        <h4>Type Attribute Values</h4>
                        <hr>
                        <dt> checkbox</dt>            <dd>   As a single checkbox this doesn't require any options, but it will create a hidden field for you so that the key gets submitted even when not checked.  The value of the checkbox will be 1 
                                                            <br><swf:form-field type="checkbox" name="checkbox label:" class="formControl" value="1"></swf:form-field>
                                                     </dd>
                        <dt> checkboxgroup</dt>       <dd>   Requires the valueOptions to be an array of simple value if name and value is same or array of structs with the format of {value="", name=""}
                                                            <br><swf:form-field type="checkboxgroup" name="checkbox group label:" class="formControl" options="option1,option2,option3"></swf:form-field>
                                                     </dd>
                        <dt> File</dt>                <dd>   No value can be passed in
                                                            <br><swf:form-field type="file" name="File label:" class="formControl"></swf:form-field></dd>
                        
                        <dt> Multiselect</dt>         <dd>   Requires the valueOptions to be an array of simple value if name and value is same or array of structs with the format of {value="", name=""}
                                                            <br><swf:form-field type="multiselect" options="option1,option2,option3" name="Multiselect label:" class="formControl"></swf:form-field>
                                                     </dd>
                        
                        <dt> Password</dt>            <dd>   No Value can be passed in
                                                            <br><swf:form-field type="password" name="Password label:" class="formControl"></swf:form-field>
                                                     </dd>
                        
                        <dt> Radiogroup</dt>          <dd>   Requires the valueOptions to be an array of simple value if name and value is same or array of structs with the format of {value="", name=""}
                                                            <br><swf:form-field type="radiogroup" name="Radio Group label:" class="formControl" options="option1,option2,option3"></swf:form-field>
                                                     </dd>
                        
                        <dt> Select</dt>              <dd>   Requires the valueOptions to be an array of simple value if name and value is same or array of structs with the format of {value="", name=""}
                                                            <br><swf:form-field type="select" name="Select label:" options="option1,option2,option3" class="formControl"></swf:form-field>   
                                                     </dd>
                        
                        <dt> Text</dt>                <dd>   Simple Text Field
                                                            <br><swf:form-field name="Text label:" type="text" class="formControl" value="someValue" value-object-property="test"></swf:form-field>
                                                     </dd>you have entered a 
                        
                        <dt> Textarea</dt>            <dd>   Simple Textarea
                                                            <br><swf:form-field type="textarea" name="textArea label:" class="formControl"></swf:form-field>
                                                     </dd>
                        
                        <dt> Yesno</dt>               <dd>   This is used by booleans and flags to create a radio group of Yes and No
                                                            <br><swf:form-field type="yesno" name="yesno" class="formControl"></swf:form-field>
                                                     </dd>
                         <dt>Submit</dt>               <dd>  Used by a form (added to the end of all forms when using processDisplay)
                                                            <br><swf:form-field type="submit" name="submit" class="formControl" doprocess="Account_login"></swf:form-field>
                                                     </dd>                            
                         <hr>                            
                         
                         <div>
                            <small>
                            <p>The swf-form-field has a number of attributes used to configure the field. Generally - just use a property display setting these two
                               options rather than manually setting all the fields.
                            </p>
                            <p>Property Display (see below) - Use the valueObject and ValueObjectProperty to auto pull the other attributes.</p>
                            <ul>
                                <li>valueObject</li>
                                <li>valueObjectProperty"</li>
                            </ul>
                            If you need to configure it manually - Use the below options.
                            <ul>
                                <li>type {string}</li>
                                <li>name {string}</li> 
                                <li>class {string}</li>
                                <li>value type="any"</li>
                                <li>valueOptions {listItem1,listItem2,listItem3} This is used with select, checkbox group, multiselect</li>
                                <li>fieldAttributes {string}</li> 
                            </ul>
                            </small>
                        </div>                            
                    </dl>
                    <hr>
                </p>
            </div>
        </div>
    </section>
    <section>
        <div>           
            <div class="container" >
                <div class="s-ds-header">
                    <h2>Building Forms</h2>
                    <h3>Using regular html or a combination of swf-form and swf-form-field</h3>
                    <h4>There are a couple restrictions on valid form naming characters. A field can't start with a '$'</h4>
                </div>
               <section>
               <!---<section>
                    <div>           
                        <div class="container" > 
                            <dl>
                                <h4>Example Forms</h4>
                                <hr>
                                <dt>Login Using Decoratoed Bootstrap Form</dt>            
                                <dd>
                                   <!-- start decorated bootstrap form -->
                                   <swf-form process-object="Account_login" action="$login">
                                        <div class="form-group">
                                            <label for="email">Email</label>
                                            <input type="email" class="form-control" id="email" placeholder="Email" sw-model="Account_login.emailAddress">
                                        </div>
                                        <div class="form-group">
                                            <label for="password">Password</label>
                                            <input type="password" class="form-control" id="password" placeholder="Password" sw-model="Account_login.password">
                                        </div>
                                        <input type="submit" class="btn btn-primary" ng-click="submit()">Login</button>
                                   </swf-form>
                                </dd>
                            </dl>
                        </div>
                    </div>
               </section>--->
               
               <section>
                    <div>           
                        <div class="container" > 
                       <dl>
                            <h4>Example Forms</h4>
                            <hr>
                            <dt>Login/Logout</dt>            
                            <dd>
                            <!-- start login form -->
                            <swf-login></swf-login>
                            
                            <!-- start logout form -->
                            <swf-form 
                                process-object="Account_logout" 
                                action="$logout"
                                hide-until="Account_login">
                                <span>Signed in as {{slatwall.account.firstName}} {{slatwall.account.lastName}}</span><br>      
                                <swf-form-field 
                                    name="Logout" 
                                    type="submit" 
                                    class="formControl">Logout</swf-form-field>
                            </swf-form>
                            
                            
                            
                            </dd>
                        </div>
                    </div>
                </section>
                
                <section>
                    <div>           
                        <div class="container" > 
                            <dl>
                                <h4>Example Forms</h4>
                                <hr>
                            <dt>Promo Codes</dt>            
                            <dd>
                                <!-- add promo code -->
                                <!-------------------->
                                <swf-form process-object="Order_addPromotionCode" action="$addPromotionCode">
                                   <swf-form-field name="promotionCode" label-text="Promo Code:" type="text" class="formControl" sw-model="Order_addPromotionCode.promotionCode"></swf-form-field>
                                   <swf-form-field name="Add Promo Code" type="submit" class="formControl"></swf-form-field>
                                </swf-form>
                                <!-------------------->
                            </dd>
                        </div>
                    </div>
                </section>
                <section>
                    <div>           
                        <div class="container" > 
                            <dl>
                                <h4>Example Forms</h4>
                                <hr>
                            <dt>create a new account and then login</dt>            
                            <dd>
                                <!---------Create an Account----------->
                                <swf-form process-object="Account_create" actions="$createAccount,$login">
                                   <swf-form-field name="firstName" label-text="First Name:" type="text" class="formControl" sw-model="Account_create.firstName"></swf-form-field>
                                   <swf-form-field name="lastName" label-text="Last Name:" type="text" class="formControl" sw-model="Account_create.lastName"></swf-form-field>
                                   <swf-form-field name="phone" label-text="Phone:" type="text" placeholder="xxx-xxx-xxxx" class="formControl" sw-model="Account_create.phone"></swf-form-field>
                                   <swf-form-field name="company" label-text="Company:" type="text" class="formControl" sw-model="Account_create.company"></swf-form-field>
                                   <swf-form-field name="emailAddress" label-text="Email:" type="text" class="formControl" sw-model="Account_create.emailAddress"></swf-form-field>
                                   <swf-form-field name="emailAddressConfirm" label-text="Confirm Email:" type="text" class="formControl" sw-model="Account_create.emailAddressConfirm"></swf-form-field>
                                   <swf-form-field name="password" label-text="Password:" type="password" class="formControl" sw-model="Account_create.password"></swf-form-field>
                                   <swf-form-field name="passwordConfirm" label-text="Confirm Password:" type="password" class="formControl" sw-model="Account_create.passwordConfirm"></swf-form-field>
                                   <swf-form-field name="Create Account" type="submit" class="formControl"></swf-form-field>
                                </swf-form>
                                <!----End create account and login------>
                            </dd>
                        </div>
                    </div>
                </section>
                <section>
                    <div>           
                        <div class="container" > 
                        	<dl>
                            <h4>Cart</h4>
                            <hr>
                            <dt>Using the cart object to display cart data</dt>             
                            <dd>
                                <pre><small>{{slatwall.cart | json}}</small></pre>
                            </dd>
                        </div>
                    </div>
                </section>
                
                <section>
                    <div>           
                        <div class="container" > 
                            <dl>
                            <h4>Account</h4>
                            <hr>
                            <dt>Using the account object to display cart data</dt>            
                            <dd>
                                <pre><small>{{slatwall.account | json}}</small></pre>
                            </dd>
                        </div>
                    </div>
                </section>
                
            </div>
        </div>
    </section>
    
  </div>
    <!-- Validations Section                                                  -->
    <!-- rules: minQuantity,maxQuantity,required,equalTo,lessThan,greaterThan -->
    <!-- set the throttle on entire form or single fields                     -->
    <!-- will focus to the first invalid validation                           -->
    <!-- Before a field is marked as invalid, the validation is lazy          -->
    <!-- Once a field is marked invalid, it is eagerly validated              -->
    <!-- If the user enters something in a non-marked field, and tabs/clicks away from it (onblur), it is validated -->
    <!-- Built in validation messages: 
            required – Makes the element required.
            remote – Requests a resource to check the element for validity.
            minlength – Makes the element require a given minimum length.
            maxlength – Makes the element require a given maxmimum length.
            rangelength – Makes the element require a given value range.
            min – Makes the element require a given minimum.
            max – Makes the element require a given maximum.
            range – Makes the element require a given value range.
            email – Makes the element require a valid email
            url – Makes the element require a valid url
            date – Makes the element require a date.
            dateISO – Makes the element require an ISO date.
            number – Makes the element require a decimal number.
            digits – Makes the element require digits only.
            creditcard – Makes the element require a credit card number.
            equalTo – Requires the element to be the same as another one
    
    --->
    <!---<swf-forms-validation validation-for="login">
    	<!-- this form has two elements: email and password -->
        <swf-validation for="email" rules="email,required" position="right" validation-class="error">
            <validation-message for="minQuantity">Must be above 0!</validation-message>
            <validation-message for="maxQuantity">Must be below 100!</validation-message>
            <validation-message for="required">email address required *</validation-message>
        </swf-validation>
        
        <swf-validation for="password" rules="required,alphanumeric">
            <validation-message for="required">password required *</validation-message>
            <validation-message for="alphanumeric">valid characters are a-z A-Z 0-9</validation-message>
        </swf-validation>
        
        <swf-validation for="firstName" rules="required">
            <validation-message for="required">password required *</validation-message>
        </swf-validation>
        
    </swf-forms-validation>--->
                            
  
  
  
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
