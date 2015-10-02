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


<cfparam name="rc.orderItem" type="any" />
<cfparam name="rc.processObject" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<hb:HibachiEntityProcessForm entity="#rc.orderItem#" edit="#rc.edit#" sRedirectAction="admin:entity.detailorderitem">

		<span ng-controller="preprocessorderitem_addorderitemgiftrecipient as giftRecipientControl">
			<hb:HibachiEntityActionBar type="preprocess" object="#rc.orderItem#">
			</hb:HibachiEntityActionBar>

			<hb:HibachiPropertyRow>
				<hb:HibachiPropertyList>
					<input value="#rc.orderItem.getNumberOfUnassignedGiftCards()#" name="quantity" ng-model="giftRecipientControl.quantity" sw-numbers-only min-number="giftRecipientControl.getAssignedCount()" class="hide" readonly>
					<!--- Process Add Order Item Gift Recipient --->


					<h5>Assign Gift Cards</h5>
	                <input type="hidden" name="assignedGiftRecipientQuantity" ng-value="giftRecipientControl.getAssignedCount()" />
					<div class="table-responsive s-gift-card-table">
						<div ng-show="giftRecipientControl.getUnassignedCount()" class="alert alert-info" role="alert">Use the "search or add recipient" field below to assign recipients to gift cards.  </br><strong>You have ({{giftRecipientControl.getUnassignedCount()}}) gift card<span ng-hide="giftRecipientControl.getUnassignedCount() == 1">s</span> to assign</strong></div>
						<div ng-show="giftRecipientControl.getUnassignedCount() != giftRecipientControl.quantity">
							<table class="table table-bordered table-hover">
						        <thead>
						            <tr>
						                <th>#$.slatwall.rbKey('define.firstName')#</th>
	                                    <th>#$.slatwall.rbKey('define.lastName')#</th>
								        <th>#$.slatwall.rbKey('define.email')#</th>
								        <th>#$.slatwall.rbKey('define.giftMessage')#</th>
								        <th>#$.slatwall.rbKey('define.quantity')#</th>
								        <th></th>
						            </tr>
						        </thead>
						        <tbody>
						        	<tr sw-order-item-gift-recipient-row ng-repeat="recipient in giftRecipientControl.orderItemGiftRecipients" ng-show="giftRecipientControl.orderItemGiftRecipients.length != 0" ng-class="{'s-save-row':recipient.editing}" recipient="recipient" index="$index" recipients="giftRecipientControl.orderItemGiftRecipients" quantity="giftRecipientControl.quantity">

						        	</tr>
						        </tbody>
						    </table>
						</div>
					</div>

					<div class="form-group " ng-show="giftRecipientControl.getUnassignedCount() > 0">
						<div class="s-search-filter s-gift-card">
	                        <div class="input-group">
								<form>
									<div class="s-search">
	                  					<input type="text" placeholder="search or add recipient..." class="form-control input-sm" ng-model="giftRecipientControl.searchText" ng-change="giftRecipientControl.updateResults(giftRecipientControl.searchText)">
										<i class="fa fa-search"></i>
									</div>
								</form>

	            				<ul ng-show="giftRecipientControl.searchText.length > 0" ng-hide="giftRecipientControl.currentGiftRecipient.firstName" class="dropdown-menu">
									<!-- Item-->
									<li ng-repeat="account in collection.pageRecords">
										<a ng-click="giftRecipientControl.addGiftRecipientFromAccountList(account)">
											<div class="row">
												<div class="col-xs-2 s-photo">
													<img src="{{account.gravatar}}">
												</div>
												<div class="col-xs-10 s-info">
													<div class="s-name">
														<span ng-bind="account.firstName"></span>
														<span ng-bind="account.lastName"></span>
													</div>
													<div class="s-email" ng-bind="account.primaryEmailAddress_emailAddress"></div>
												</div>
											</div>
										</a>
									</li>
									<!-- //Item-->
	                			</ul>

	                        </div>
	                        <div>
	                            <!-- Only show if there is text -->
	                            <button type="button" class="btn btn-primary" ng-show="giftRecipientControl.searchText != ''" ng-hide="giftRecipientControl.currentGiftRecipient.firstName" ng-click="giftRecipientControl.startFormWithName()">
	                            	<i class="fa fa-plus" ></i> Add "<span ng-bind="giftRecipientControl.searchText"></span>"
	                            </button>
	                        </div>
							<div class="s-add-info-dropdown" ng-hide="!giftRecipientControl.adding">
								<div class="s-add-info-dropdown-inner">

									<h5>Create New Recipient</h5>
									<div class="form-group">
										<label>First Name<i class="fa fa-asterisk"></i></label>
										<input name="_recipientFirstName" type="text" class="form-control" ng-model="giftRecipientControl.currentGiftRecipient.firstName" required>
									</div>
									<div class="form-group">
										<label>Last Name<i class="fa fa-asterisk"></i></label>
										<input name="_recipientLastName" type="text" class="form-control" ng-model="giftRecipientControl.currentGiftRecipient.lastName" required>
									</div>
									<div class="form-group">
										<label>Email<i class="fa fa-asterisk"></i></label>
										<input name="_recipientEmail" type="email" class="form-control" ng-model="giftRecipientControl.currentGiftRecipient.email" required>
									</div>
									<div class="form-group">
										<label>Message (limited to 250)</label>
										<textarea name="_recipientMessage" class="form-control" rows="4" ng-model="giftRecipientControl.currentGiftRecipient.giftMessage" ng-trim="false"></textarea>
										<div class="s-character-count">
											Remaining characters: <strong><span ng-bind="giftRecipientControl.getMessageCharactersLeft()"></span></strong>
										</div>
									</div>
									<div class="form-group">
										<label>Qty</label>
										<select class="form-control"
                                                    name="_recipientQuantity"
                                                    type="number"
													ng-model="giftRecipientControl.currentGiftRecipient.quantity"
													ng-options="quantity for quantity in giftRecipientControl.getUnassignedCountArray() track by quantity"
                                                    required
											>
										</select>
									</div>
									<div>
										<button type="button" class="btn btn-sm btn-primary" ng-click="giftRecipientControl.addGiftRecipient()">Add Recipient</button>
										<button type="button" class="btn btn-sm btn-default">Cancel</button>
									</div>
								</div>
							</div>
						</div>
	        			<!---End Search--->
					</div>
					<!---End Gift Recipient--->
				</span>
			</hb:HibachiPropertyList>

		</hb:HibachiPropertyRow>

	</hb:HibachiEntityProcessForm>
</cfoutput>
