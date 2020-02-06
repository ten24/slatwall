<cfset templateStore = "true">
<cfheader name="cache-control" value="no-cache, no-store, must-revalidate" /> 
<cfheader name="cache-control" value="post-check=0, pre-check=0" /> 
<cfheader name="last-modified" value="#now()#" />
<cfheader name="pragma"  value="no-cache" />

<cfoutput>
    <cfinclude template="_slatwall-header.cfm" />
        <!--- Account login force refresh --->
        <span ng-if="slatwall.getRequestByAction('login').hasSuccessfulAction()">
            <span ng-init="slatwall.$window.location.reload()"></span>
        </span>

        <div class="container my-5">
            <!--- Forgot Password Account Reset --->
            <cfif structKeyExists(url, "swprid") and len(url.swprid) eq 64>
                <cfinclude template = "inc/account/account_reset_password.cfm">
            <cfelse>
                <!--- Logged in template views --->
                <cfif $.slatwall.getLoggedInFlag()>
                    <a href="/my-account/" class="text-muted">My Account</a>
                    <h1 class="mb-4">#$.slatwall.content('title')#</h1>
                    
                    <div class="row">
                        <!--- Account navigation sidebar --->
                        <div class="col-md-3 col-sm-12">
                            <cfinclude template = "inc/account/account_left_nav.cfm">
                        </div>
                  
                        <!--- Account body display --->
                        <div class="col-md-9">
                            <cfswitch expression = "#$.slatwall.content('urlTitle')#">
                            	<cfcase value = "login-information">
                            		<cfinclude template = "inc/account/account_login_update.cfm">
                            	</cfcase>
                            	<cfcase value = "my-account">
                            		<cfinclude template = "inc/account/account_dashboard.cfm">
                            	</cfcase>
                            	<cfcase value = "order-history">
                            		<cfinclude template = "inc/account/account_order_history.cfm">
                            	</cfcase>
                            	<cfcase value = "order">
                            		<cfinclude template = "inc/account/account_order_details.cfm">
                            	</cfcase>
                            	<cfcase value = "quotes">
                            		<cfinclude template = "inc/account/account_order_history.cfm">
                            	</cfcase>
                            	<cfcase value = "quote">
                            		<cfinclude template = "inc/account/account_order_details.cfm">
                            	</cfcase>
                            	<cfcase value = "profile">
                            		<cfinclude template = "inc/account/account_profile.cfm">
                            	</cfcase>
                            	<cfcase value = "address-book">
                            		<cfinclude template = "inc/account/account_address_book.cfm">
                            	</cfcase>
                            	<cfcase value = "reset-password">
                            		<cfinclude template = "inc/account/account_reset_password.cfm">
                            	</cfcase>
                            	<cfcase value = "phone-numbers">
                            		<cfinclude template = "inc/account/account_phone_numbers.cfm">
                            	</cfcase>
                            	<cfcase value = "email-addresses">
                            		<cfinclude template = "inc/account/account_email_addresses.cfm">
                            	</cfcase>
                            	<cfcase value = "subscriptions">
                            		<cfinclude template = "inc/account/account_subscriptions.cfm">
                            	</cfcase>
                            	<cfcase value = "subscription">
                            		<cfinclude template = "inc/account/account_subscription_details.cfm">
                            	</cfcase>
                            	
                            </cfswitch>
                        </div>
                    </div>
                </cfif>
                
                <!--- Login / Signup --->
             <cfif !$.slatwall.getLoggedInFlag()>   
             <div ng-show="!slatwall.loadingThisRequest('getAccount')" ng-cloak class="row">
                    <div ng-show="!slatwall.hasAccount()" ng-cloak class="col-md-6 offset-md-3">
                        
                        <div class="text-center my-3">
                            <h1>My Account</h1>
                            <p>Please login or signup to continue.</p>
                        </div>
    
                        <!--- Sets a default for create account toggle --->
                        <span ng-init="slatwall.showCreateAccount = false"></span>
                        <span ng-init="slatwall.showSigningIn = true"></span>

                        <!--- Login/Signup Tabs --->
                        <ul class="nav nav-pills nav-fill mb-1">
                            <li class="nav-item">
                                <a href="##" class="nav-link" ng-class="{ 'active' : slatwall.isSigningIn() }" ng-click="slatwall.showCreateAccount = !slatwall.showCreateAccount">Login</a>
                            </li>
                            <li class="nav-item">
                                <a href="##" class="nav-link" ng-class="{ 'active' : slatwall.isCreatingAccount() }" ng-click="slatwall.showCreateAccount = !slatwall.showCreateAccount; slatwall.showForgotPassword = false">Signup</a>
                            </li>
                        </ul>

                        <!--- Login/Signup Forms  --->
                        <div class="card">
                            <div class="card-body">
                                <!--- Login Form --->
                                <div ng-show="slatwall.isSigningIn()">
                                    <cfinclude template="inc/account/account_login.cfm">
                                </div>
                                <!--- Signup Form --->
                                <div ng-show="slatwall.isCreatingAccount()">
                                    <cfinclude template="inc/account/account_create_account.cfm">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </cfif>
            </cfif>
        </div>
    <cfinclude template="_slatwall-footer.cfm" />
</cfoutput>