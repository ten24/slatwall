<!---
	
    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC
	
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
	
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
	
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
	
    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your 
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms 
    of your choice, provided that you follow these specific guidelines: 

	- You also meet the terms and conditions of the license of each 
	  independent module 
	- You must not alter the default display of the Slatwall name or logo from  
	  any part of the application 
	- Your custom code must not alter or create any files inside Slatwall, 
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets 
	the above guidelines as a combined work under the terms of GPL for this program, 
	provided that you include the source code of that other code when and as the 
	GNU GPL requires distribution of source code.
    
    If you modify this program, you may extend this exception to your version 
    of the program, but you are not obligated to do so.
	
Notes: 																			
																				
	This "My Account" example template is designed to give you an idea			
	of what is possible through the frontend subsystem in the way of pulling	
	information as well as updating account info.								
																				
	IMPORTANT: any of the individual components or different aspects	of this	
	page can be copied into a seperate template and referenced as a seperate	
	URL either in your CMS or custom application.  We have done this all in one	
	place only for example purposes.  You may find that because this page is so	
	data intesive that you may need to break it up into smaller pages.			
																				
--->

<!--- IMPORTANT: This is here so that the account layout is never cached by the browser --->
<cfheader name="cache-control" value="no-cache, no-store, must-revalidate" /> 
<cfheader name="cache-control" value="post-check=0, pre-check=0" /> 
<cfheader name="last-modified" value="#now()#" />
<cfheader name="pragma"  value="no-cache" />

<!--- This header include should be changed to the header of your site.  Make sure that you review the header to include necessary JS elements for slatwall templates to work --->
<cfinclude template="_slatwall-header.cfm" />

<!--- This import allows for the custom tags required by this page to work --->
<cfimport prefix="sw" taglib="../tags" />

<!---[DEVELOPER NOTES]															
																				
	If you would like to customize any of the public tags used by this			
	template, the recommended method is to uncomment the below import,			
	copy the tag you'd like to customize into the directory defined by			
	this import, and then reference with swc:tagname instead of sw:tagname.		
	Technically you can define the prefix as whatever you would like and use	
	whatever directory you would like but we recommend using this for			
	the sake of convention.														
																				
	<cfimport prefix="swc" taglib="/Slatwall/custom/public/tags" />				
																				
--->

<cfset paymentFormAction="?s=1">

<!--- If using HTTP, override the form to send over http if the setting Force Credit Card Over SSL is true --->
<cfif $.slatwall.setting('globalForceCreditCardOverSSL') EQ true AND (findNoCase("off", CGI.HTTPS) OR NOT CGI.SERVER_PORT_SECURE)>
	<cfset paymentFormAction = replace($.slatwall.getURL(), 'http://', 'https://') />
</cfif>

<cfoutput>
	<div class="container">
		
		
		<!--- USER MY-ACCOUNT SECTION IF LOGGED IN --->
		<cfif $.slatwall.getLoggedInFlag()>
			<div class="row">
				<div class="span12">
					
					<h2>#htmlEditFormat( $.slatwall.getAccount().getFullName() )# - My Account <span class="pull-right" style="font-size:14px;"><a href="?slatAction=public:account.logout">logout</a></span></h2>
					
					<!--- PRIMARY TAB NAV --->
					<div class="tabable">
						<ul class="nav nav-tabs" id="myTab">
							<li class="active"><a href="##profile" data-toggle="tab">Profile</a></li>
							<li><a href="##orders" data-toggle="tab">Orders</a></li>
							<li><a href="##carts-and-quotes" data-toggle="tab">Carts & Quotes</a></li>
							<li><a href="##subscriptions" data-toggle="tab">Subscriptions</a></li>
							<li><a href="##purchased-content" data-toggle="tab">Purchased Content</a></li>
						</ul>
						
						<!--- PRIMARY TAB CONTENT --->
						<div class="tab-content">
							
							<!--- ================== PROFILE TAB ======================== --->
							<div class="tab-pane active" id="profile">
								
								<div class="row">
									
									<!--- Left Side General Details --->
									<div class="col-md-5">
										<div class="card">
											<h5 class="card-title">Profile Details</h5>
											<cfinclude template="./inc/myaccount/profileDetails.cfm" />
										</div>
										<br />
										<h5>Change Password</h5>
										<hr style="margin-top:10px;border-top-color:##ddd;" />
											<cfinclude template="./inc/myaccount/changePassword.cfm" />
										<br />
									</div>
									<!--- Start: Right Side Contact & Payment Methods --->
									<div class="col-md-5 col-md-offset-2">
										
										<!--- Start: Email & Phone --->
										<div class="row">
											
											<cfinclude template="./inc/myaccount/phoneNumbers.cfm" />
											
											<cfinclude template="./inc/myaccount/emailAddresses.cfm" />
											
										</div>
										<!--- End: Email & Phone --->
										
										
										<cfinclude template="./inc/myaccount/addressBook.cfm" />
											
										<br />
										
										<cfinclude template="./inc/myaccount/paymentMethods.cfm" />
										
									</div>
									<!--- End: Right Side Contact & Payment Methods --->
									
								</div>
								
							</div>
							
							<!--- ================== ORDER HISTORY TAB ================== --->
							
							<cfinclude template="./inc/myaccount/orderHistoryTab.cfm" />
							
							<!--- =================== CARTS & QUOTES ===================== --->
							
							<cfinclude template="./inc/myaccount/cartsAndQuotesTab.cfm" />
							
							<!--- ==================== SUBSCRIPTIONS ==================== --->
							
							<cfinclude template="./inc/myaccount/subscriptionsTab.cfm" />
							
							<!--- ==================== PURCHASED CONTENT ==================== --->
							
							<cfinclude template="./inc/myaccount/purchasedContentTab.cfm" />
							
						</div> <!--- END OF TABLE --->
						
					</div>
				</div>
			</div>
		
		<!--- RESET PASSWORD --->
		<cfelseif structKeyExists(url, "swprid") and len(url.swprid) eq 64>
			
			<cfinclude template="./inc/myaccount/resetPassword.cfm" />
			
		<!--- CREATE / LOGIN FORMS --->
		<cfelse>
			<cfif $.slatwall.hasFailureAction( "public:account.login" )>
				<div class="alert alert-danger">
					<!--- Display whatever errors might have been associated with the account --->
					<sw:ErrorDisplay object="#$.slatwall.getAccount().getProcessObject('login')#" />
				</div>
			</cfif>
			<div class="row">
				<div class="span12">
					<h2>My Account</h2>
				</div>
			</div>
			<div class="row">
				<!--- LOGIN --->
				<div class="span6">
					
					<h5>Login with Existing Account</h5>
					
					<!--- Sets up the account login processObject --->
					<cfset accountLoginObj = $.slatwall.getAccount().getProcessObject('login') />
					
					<cfinclude template="./inc/myaccount/login.cfm" />
						
					<hr />
					
					<cfinclude template="./inc/myaccount/forgotPassword.cfm" />
					
				</div>
			</div>	
			<div class="row">
				<cfinclude template="./inc/myaccount/createAccount.cfm" />
			</div>
		</cfif>
	</div>
</cfoutput>
<cfinclude template="_slatwall-footer.cfm" />

