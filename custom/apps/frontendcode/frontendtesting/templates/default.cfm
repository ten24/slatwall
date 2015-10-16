<cfoutput>
<cfinclude template="header.cfm" >
<div>
  <div ng-controller="slatwall">
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
        <hr>
            <br>
        <div>           
            <div class="container"> 
                <h2>Create Account:</h2>
                <swf:form entity-name="Account" process-object="create"></swf:process>
            </div>
        </div>
    </section>
    
    <section>
        <div>           
            <div class="container" > 
                <h2>Login Account:</h2>
                <swf:form entity-name="Account" process-object="login"></swf:process>
            </div>
        </div>
    </section>
    <section>
        <div>           
            <div class="container" > 
                <h2>Add Promotion Code:</h2>
                <swf:form entity-name="Cart" process-object="addPromotionCode"></swf:process>
            </div>
        </div>
    </section>
    <section>
        <div>           
            <div class="container" > 
                <h2>Cart Data</h2>
                <pre><small>{{cart | json}}</small></pre>
            </div>
        </div>
    </section>
    <section>
        <div>           
            <div class="container" > 
                <h2>Account Data</h2>
                <pre><small>{{account | json}}</small></pre>
            </div>
        </div>
    </section>
    <section>
        <div>           
            <div class="container" > 
                <h2>Testing</h2>
                <b>Basic Info:</b>
                {{account.firstName}} {{account.lastName}}
                
                <b>Shipping Address:</b>
                {{cart.shippingAddress | json}}
                
                <b>OrderItems:</b>
                <ul>
                <div ng-repeat="item in cart.orderitems"><li>{{item}}</li></div>
                </ul>
            </div>
        </div>
    </section>

<form slatwall-submit="login">

    Email: <input type="text" name="emailAddress" ng-model="slatwall.processObjects.login.emailAddress" />
    <span class="error" ng-repeat="error in slatwall.processObjects.login.errors.emaillAddress" ng-bind="error"></span>
        
    Password: <input type="password" name="password" ng-model="slatwall.processObjects.login.password" />
    <span class="error" ng-repeat="error in slatwall.processObjects.login.errors.password" ng-bind="error"></span>

    <button type="submit">Login</button>
    
</form>



  </div>
</div>
</cfoutput>
<cfinclude template="footer.cfm" >
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
