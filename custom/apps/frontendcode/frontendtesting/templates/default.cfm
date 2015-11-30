<cfoutput>
<cfinclude template="header.cfm" >
<div>
  <div>
    <section>
        <div>           
            <div class="container" >
                <div class="s-ds-header">
                    <h2>Examples:</h2>
                    <h3>These are examples of using frontend directives</h3>
                </div>
                <p class="directives">
                    
                    <dl>
                        <h4>This will demo all the frontend tags</h4>
                        <hr>
                        <dt> login (swf-login)</dt>            
                        <dd>  Accepts a emailaddress and password and logs in the user.
                               <br><swf-login></swf-login>
                        </dd>
                                                
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
  <!--- This is a template for the form fields on * the forms.
    <swf-form-field-template template-for='*'>
        
        <div class="form-group">
            <label label-for="*"></label>
            <input primary-type="*">
        </div>
        
        <input name="" primary-type="submit" class="btn btn-primary"></input>
    </swf-form-field-template>
    --->
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
   <h1>Example using a getSkusFilteredBy(column, direction)</h1>                      
   <cfscript>
        
    </cfscript>
  
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
