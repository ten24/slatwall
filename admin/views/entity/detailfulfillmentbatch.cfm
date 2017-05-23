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
<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />


<cfparam name="rc.fulfillmentBatch" type="any" />
<cfparam name="rc.edit" type="boolean" default="false" />
<cfoutput>
<hb:HibachiEntityDetailForm object="#rc.fulfillmentBatch#" edit="#rc.edit#">
	<hb:HibachiEntityActionBar type="detail" object="#rc.fulfillmentBatch#" edit="#rc.edit#"></hb:HibachiEntityActionBar>
	
	<section class="s-pick-pack-detail container" ng-init="expanded = true">
		<div class="row s-detail-modules-wrapper">
			<div class="col-sm-6 col-md-6 col-lg-4 s-detail-module s-md-content-block">
				<!--- Icon Properties --->
				<sw-card-view id="batchNumber" card-size="sm">
					<sw-card-icon icon-name="shopping-cart"></sw-card-icon>
					<sw-card-header style="border-bottom:none">Batch ID</sw-card-header>
					<sw-card-body>#rc.fulfillmentBatch.getFulfillmentBatchNumber()#</sw-card-body>
				</sw-card-view>
				
				<sw-card-view id="assignedAccount" card-size="sm">
					<sw-card-icon icon-name="user"></sw-card-icon>
					<sw-card-header style="border-bottom:none">User</sw-card-header>
					<cfif !isNull(rc.fulfillmentBatch.getAssignedAccount())>
					<sw-card-body>#rc.fulfillmentBatch.getAssignedAccount().getFirstName()# #rc.fulfillmentBatch.getAssignedAccount().getLastName()#</sw-card-body>
					</cfif>
				</sw-card-view>

				<sw-card-view id="location" card-size="sm">
					<sw-card-icon icon-name="building"></sw-card-icon>
					<sw-card-header style="border-bottom:none">Location</sw-card-header>
					<sw-card-body>New York</sw-card-body>
				</sw-card-view>
				
			</div>
			
			<div class="col-sm-6 col-md-6 col-lg-4 s-detail-module s-md-content-block">	
				<!--- Description --->
				<sw-card-view id="description" card-title="Description" card-body="#rc.fulfillmentBatch.getDescription()#"></sw-card-view>
			</div>
			
			<div class="col-sm-6 col-md-6 col-lg-4 s-detail-module s-md-content-block">	
				<!--- Status --->
				<sw-card-view id="status">
					<sw-card-header>Status</sw-card-header>
					
					<!--- Number of fulfillments total --->
					<sw-card-list-item title="Fulfillments" value="#arrayLen(rc.fulfillmentBatch.getFulfillmentBatchItems())#" strong="true"></sw-card-list-item>
					
					<!--- Number of fulfillments fulfilled --->
					<sw-card-list-item title="Completed" value="2"></sw-card-list-item>
					
					<!--- Progress Bar --->
					<sw-card-progress-bar value-min="0" value-max="100" value-now="50"></sw-card-progress-bar>
					
				</sw-card-view>
			</div>
		</div>
		
		<sw-fulfillment-batch-detail fulfillment-batch-id="#rc.fulfillmentBatch.getFulfillmentBatchID()#">Loading</sw-fulfillment-batch-detail>
		
		<!--- Expand View --->
		<!---<div class="row s-detail-content-wrapper" ng-show="expanded"   ng-cloak>
			<div class="col-xs-12">
				<div class="s-content-header">
					<h2>Fulfillments</h2>
					<span class="pull-right s-compress-icon s-detail-show-content" ng-click="expanded = !expanded">
		                <a href="##" class="s-compress-table">
		                    <i class="fa fa-compress"></i>
		                </a>
		            </span>  
				
		        <sw-listing-display
					data-collection="'FulfillmentBatchItem'"
					data-edit="true"
					data-has-search="true"
					data-record-detail-action="admin:entity.detailfulfillmentBatchItem"
					data-is-angular-route="false"
					data-angular-links="true"
					data-has-action-bar="true" 
					data-persisted-collection-config="true" 
					data-multiselectable="true"
					data-multiselect-field-name="fulfillmentBatchItemID" 
					data-name="fulfillmentBatchItemTable1" 
					data-multi-slot="true">
					
					<!--- Filters --->
					<sw-listing-filter data-property-identifier="fulfillmentBatch.fulfillmentBatchID" data-comparison-operator="=" data-comparison-value="#rc.fulfillmentBatch.getFulfillmentBatchID()#"></sw-listing-column>
					<sw-listing-columns>
						<!--- Columns --->
						<sw-listing-column data-property-identifier="orderFulfillment.order.orderNumber" data-title="Fulfillments"></sw-listing-column>
						<sw-listing-column data-property-identifier="orderFulfillment.order.orderOpenDateTime" data-title="Date"></sw-listing-column>
						<sw-listing-column data-property-identifier="orderFulfillment.shippingMethod.shippingMethodName" data-title="Shipping"></sw-listing-column>
						<sw-listing-column data-property-identifier="orderFulfillment.shippingAddress.stateCode" data-title="State"></sw-listing-column>
						<sw-listing-column data-property-identifier="orderFulfillment.orderFulfillmentStatusType.typeName" data-title="Status"></sw-listing-column>
					</sw-listing-columns>
				</sw-listing-display>
		        </div> 
			</div>
		</div>
		
		<!--- Shrink View --->
		<div class="row s-detail-content-wrapper" ng-show="!expanded"  ng-cloak>
			<div class="col-xs-4">
		    	<div class="s-content-header">
				<h2>Fulfillments</h2>
	            <a href="##" class="s-expand-table pull-right" ng-click="expanded = !expanded">
	                <i class="fa fa-expand"></i>
	            </a> 
	                            
		        <sw-listing-display
					data-collection="'FulfillmentBatchItem'"
					data-edit="true"
					data-has-search="false"
					data-record-detail-action="admin:entity.detailfulfillmentBatchItem"
					data-is-angular-route="false"
					data-angular-links="true"
					data-has-action-bar="true" 
					data-persisted-collection-config="true" 
					data-multiselectable="true"
					data-multiselect-field-name="fulfillmentBatchItemID" 
					data-name="fulfillmentBatchItemTable2" 
					data-multi-slot="true">
					
					<sw-listing-filter data-property-identifier="fulfillmentBatch.fulfillmentBatchID" data-comparison-operator="=" data-comparison-value="#rc.fulfillmentBatch.getFulfillmentBatchID()#"></sw-listing-column>
					<sw-listing-columns>
						<sw-listing-column data-property-identifier="orderFulfillment.order.orderNumber" data-title="Order Number"></sw-listing-column>
						<sw-listing-column data-property-identifier="orderFulfillment.order.orderOpenDateTime" data-title="Date"></sw-listing-column>
						<sw-listing-column data-property-identifier="orderFulfillment.shippingMethod.shippingMethodName" data-title="Shipping"></sw-listing-column>
						<sw-listing-column data-property-identifier="fulfillmentBatchItemID"></sw-listing-column>
					</sw-listing-columns>
				</sw-listing-display>
		    	</div>
			</div>
			
			<!--- Stuff on this size here --->
			<div class="col-xs-8 ">
				
				<!--- Need to make this into lg size card and create event connection between listing and directive.  --->
                
                <div class="s-detail-body s-arrow">
                    <div class="s-content-header">
                        <h2>Order ##66</h2>
                        <span class="pull-right">
                            
                            <div class="btn-toolbar" role="toolbar"> 
                                <div class="btn-group" role="group"> 
                                    <button class="btn btn-xs btn-default" role="button" data-toggle="collapse" data-target="##j-comments" aria-expanded="false" aria-controls="j-comments">2 <i class="fa fa-comment"></i></button>
                                </div> 
                                
                                <div class="btn-group">
                                    <button type="button" class="btn btn-default btn-xs dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                        <i class="fa fa-print"></i>
                                    </button>
                                    <ul class="dropdown-menu">
                                        <li><a href="#">Picking List</a></li>
                                        <li><a href="#">Standard Packing List</a></li>
                                    </ul>
                                </div>
                                
                                <div class="btn-group">
                                    <button type="button" class="btn btn-default btn-xs dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                        <i class="fa fa-envelope"></i>
                                    </button>
                                    <ul class="dropdown-menu">
                                        <li><a href="##">Cancellation</a></li>
                                        <li><a href="##">Confirmation</a></li>
                                        <li><a href="##">Order Stutus</a></li>
                                    </ul>
                                </div>
                                
                                <div class="btn-group" role="group"> 
                                    <button class="btn btn-xs btn-default s-remove"><i class="fa fa-trash"></i></button>
                                </div> 
                                
                                <div class="btn-group s-btn-dropdown" role="group"> 
                                    <button type="button" class="btn btn-primary btn-xs">
				                    	<span>Capture &amp; Fulfill</span> 
				                    </button>
                                    <ul class="dropdown-menu" role="menu">
										<li><a href="##">Fulfill</a></li>
				                    </ul>
                                    <button type="button" class="btn btn-primary s-btn-select btn-xs" data-toggle="dropdown">
										<span class="caret"></span>
				                    </button>
                                </div>
                                 
                            </div>
                        </span>
                    </div>
                    
                    
                    <ul class="collapse s-item-comments list-unstyled" id="j-comments">
                        
                        <li class="s-comment-item">
                            <div class="s-info">
                                <span class="s-user">
                                    <a href="">Reinaldo Solares</a>
                                </span>
                                <span class="s-date"> 10 hours ago</span>
                                <!-- <span class="s-actions">
                                    <a href="##" type="button"><i class="fa fa-remove"></i></a>
                                    <a href="##" type="button"><i class="fa fa-pencil"></i></a>
                                </span> -->
                            </div>
                            <p>Integer posuere erat a ante venenatis dapibus posuere velit aliquet.</p>
                        </li>
                        
                        <li class="s-comment-item">
                            <div class="s-info">
                                <span class="s-user">
                                    <a href="">Tom Evens</a>
                                </span>
                                <span class="s-date"> 2/23/16</span>
                                <span class="s-actions">
                                    <a href="##" type="button"><i class="fa fa-remove"></i></a>
                                    <a href="##" type="button"><i class="fa fa-pencil"></i></a>
                                </span>
                            </div>
                            <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec sed odio dui. Etiam porta sem malesuada magna mollis euismod. Cras justo odio, dapibus ac facilisis in, egestas eget quam. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor. Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
                        </li>
                        
                        <li class="s-comment-item">
                            <textarea class="form-control" name="name" rows="3" cols=""></textarea>
                            <button class="btn btn-sm btn-primary">Add Comment</button>
                        </li>
                        
                    </ul>
                    
                    <div class="s-item-detail">
                        
                        <!--- Item Header --->
                        <div class="s-item-detail-header">
                            <div class="col-xs-4">
                                <div class="s-item-detail-header-block">
                                    <h4>Basic</h4>
                                    <ul class="list-unstyled">
                                        <li>
                                            <div class="row s-line-item">
                                                <div class="col-xs-5 s-title">Account:</div>
                                                <div class="col-xs-7 s-value"><a href="##">Tom Evens</a></div>
                                            </div>
                                        </li>        
                                        <li>
                                            <div class="row s-line-item">
                                                <div class="col-xs-5 s-title">Date Placed:</div>
                                                <div class="col-xs-7 s-value">2/23/16</div>
                                            </div>
                                        </li>        
                                    </ul>
                                </div>
                            </div>
                            <div class="col-xs-4">
                                <div class="s-item-detail-header-block">
                                    <h4>Payment</h4>
                                    <ul class="list-unstyled">
                                        <li>
                                            <div class="row s-line-item">
                                                <div class="col-xs-5 s-title">Original Total:</div>
                                                <div class="col-xs-7 s-value">$100.34</div>
                                            </div>
                                        </li>        
                                        <li>
                                            <div class="row s-line-item">
                                                <div class="col-xs-5 s-title">Balance Due:</div>
                                                <div class="col-xs-7 s-value">$100.34</div>
                                            </div>
                                        </li>            
                                    </ul>
                                </div>
                            </div>
                            <div class="col-xs-4">
                                <div class="s-item-detail-header-block">
                                    <h4>Shipping</h4>
                                    <ul class="list-unstyled">
                                        <li>
                                            <div class="row s-line-item">
                                                <div class="col-xs-5 s-title">Method:</div>
                                                <div class="col-xs-7 s-value">Ground</div>
                                            </div>
                                        </li>        
                                        <li>
                                            <div class="row s-line-item">
                                                <div class="col-xs-5 s-title">Location:</div>
                                                <div class="col-xs-7 s-value">
                                                    <div class="s-city-state">Encinitas CA.</div>
                                                </div>
                                            </div>
                                        </li>             
                                    </ul>
                                </div>
                            </div>
                        </div>
                        <!--- //Item Header --->
                        
                    </div>
                </div>
			</div>
		</div>
	</section>
	--->
</hb:HibachiEntityDetailForm>
</cfoutput>
