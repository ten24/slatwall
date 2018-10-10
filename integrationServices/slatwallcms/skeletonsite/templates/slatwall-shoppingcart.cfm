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
	
--->
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

<cfoutput>
<div class="container" ng-cloak ng-if="slatwall.cart.orderItems.length">
        <h1 class="my-4">Shopping Cart</h1>
        <div class="card mb-5">
            <div class="card-header bg-dark text-light">
                <div class="row">
                    <div class="col-sm-9">
                        <h5 class="mb-0 pt-2 pb-2"><span ng-bind="slatwall.cart.orderItems.length"></span> cart item(s)</h5>
                    </div>
                    <div class="col-sm-3">
                        <a href="/checkout/" class="btn-block btn btn-success float-right">Checkout</a>
                        <!----- loader can be used inside button if it's made into ajax call ------->
                        <!--<i class="fa fa-refresh fa-spin fa-fw"></i>-->
                    </div>
                </div>
            </div>
            <div class="card-body">
                <cfinclude template="inc/cartItems.cfm" />
            </div>
            <div class="card-footer">
                <div class="row">
                    <div class="col-sm-9 pull-left">

                    </div>
                    <div class="col-sm-3">
                        <a href="/checkout/" class="btn-block btn btn-success float-right">Checkout</a>
                        <!----- loader can be used inside button if it's made into ajax call ------->
                        <!--<i class="fa fa-refresh fa-spin fa-fw"></i>-->
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-md-5">
                <cfinclude template="inc/promoBox.cfm" />
            </div>
            <div class="col-md-5 offset-md-2">
                <cfinclude template="inc/orderSummary.cfm" />
            </div>
        </div>

        <div class="text-center m-4">
            <a href="/checkout/" class="btn btn-lg btn-success">Continue to Checkout</a>
            <!----- loader can be used inside button if it's made into ajax call ------->
            <!--<i class="fa fa-refresh fa-spin fa-fw"></i>-->
        </div>
    </div>
    <div ng-if="!slatwall.getRequestByAction('getCart').loading && !slatwall.cart.orderItems.length">
        <div class="alert alert-danger">There are no items in your cart.</div>
    </div>
    <!----- div for custom loader ----->
    <div ng-if="slatwall.getRequestByAction('getCart').loading">
        <i class="center fa fa-refresh fa-spin fa-fw"></i>
    </div>
</cfoutput>
<cfinclude template="_slatwall-footer.cfm" />
