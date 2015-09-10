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


<cfparam name="rc.giftCard" type="any">
<cfparam name="rc.edit" type="boolean">

<div class="col-md-12">
	<div class="alert alert-danger alert-dismissible" role="alert">
		<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
		<strong>Recipient Email Failure!</strong> There was an issue sending your gift card to the provided recipient email <button class="btn btn-danger btn-xs">Resend Recipient Email</button>
	</div>
	<div class="row s-detail-modules-wrapper">

		<div class="col-md-3">

			<!--Small content block-->
			<div class="s-sm-content-block">

				<div class="col-xs-1 col-sm-2 col-md-3 s-icon">
					<i class="fa fa-credit-card"></i>
				</div>
				<div class="col-xs-11 col-sm-10 col-md-9 s-content">
					<div class="s-title">
						Gift Card Number
					</div>
					<div class="s-body">
						6475TU83D98732DG5KJY
					</div>
				</div>
			</div>
			<!--//Small content block-->

			<!--Small content block-->
			<div class="s-sm-content-block s-status s-active">
				<div class="col-xs-1 col-sm-2 col-md-3 s-icon">
					<i class="fa fa-circle"></i>
				</div>
				<div class="col-xs-11 col-sm-10 col-md-9 s-content">
					<div class="s-title">
						Status
					</div>
					<div class="s-body">
						Active (2/24/15)
						<div class="dropdown s-action">
							<a href="##" class="dropdown-toggle" id="dropdownMenu1" data-toggle="dropdown">
								<i class="fa fa-ellipsis-h" title="actions"></i>
							</a>
							<ul class="dropdown-menu pull-right" aria-labelledby="dropdownMenu1">
								<li><a href="#">Activate</a></li>
								<li><a href="#">Close</a></li>
								<li><a href="#">Pause</a></li>
							</ul>
						</div>
					</div>
				</div>
			</div>
			<!--//Small content block-->

			<!--Small content block-->
			<div class="s-sm-content-block">
				<div class="col-xs-1 col-sm-2 col-md-3 s-icon">
					<i class="fa fa-clock-o"></i>
				</div>
				<div class="col-xs-11 col-sm-10 col-md-9 s-content">
					<div class="s-title">
						Expiration
					</div>
					<div class="s-body">
						Never
						<a href="##" class="s-action" title="edit">
							<i class="fa fa-pencil"></i>
						</a>
					</div>
				</div>
			</div>
			<!--//Small content block-->

		</div>
		<div class="col-md-3 s-md-content-block">
			<div class="s-md-content-block-inner">
				<div class="s-title">
					Balance
					<div class="dropdown s-action">
						<a href="##" class="dropdown-toggle" id="dropdownMenu" data-toggle="dropdown">
							<i class="fa fa-ellipsis-h" title="actions"></i>
						</a>
						<ul class="dropdown-menu pull-right" aria-labelledby="dropdownMenu1">
							<li><a href="#">Add Funds</a></li>
						</ul>
					</div>
				</div>
				<div class="s-body">
					<ul class="list-unstyled">
						<li>
							<div class="row s-line-item s-strong">
								<div class="col-xs-6">Remaining Balance:</div>
								<div class="col-xs-6">$248.97</div>
							</div>
						</li>

						<li>
							<div class="row s-line-item">
								<div class="col-xs-6">Original Balance:</div>
								<div class="col-xs-6">$300.00</div>
							</div>
						</li>

						<li>
							<div class="row s-line-item">
								<div class="col-xs-12">
									<div class="progress">
										<div class="progress-bar" role="progressbar" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100" style="width: 60%;">
											<!-- You can add a value in here in the future -->
										</div>
									</div>
								</div>
							</div>
						</li>

					</ul>
				</div>
			</div>
		</div>
		<div class="col-md-3 s-md-content-block">
			<div class="s-md-content-block-inner">
				<div class="s-title">
					Order Info
					<div class="dropdown s-action">
						<a href="##" class="dropdown-toggle" id="dropdownMenu" data-toggle="dropdown">
							<i class="fa fa-ellipsis-h" title="actions"></i>
						</a>
						<ul class="dropdown-menu pull-right" aria-labelledby="dropdownMenu1">
							<li><a href="#">View Order</a></li>
						</ul>
					</div>
				</div>
				<div class="s-body">
					<ul class="list-unstyled">
						<li>
							<div class="row s-line-item">
								<div class="col-xs-6">Customer Name:</div>
								<div class="col-xs-6"><a href="##">Joe Smith</a></div>
							</div>
						</li>

						<li>
							<div class="row s-line-item">
								<div class="col-xs-6">Order Number:</div>
								<div class="col-xs-6"><a href="##">367465</a></div>
							</div>
						</li>

						<li>
							<div class="row s-line-item">
								<div class="col-xs-6">Order Date:</div>
								<div class="col-xs-6">2/12/15</div>
							</div>
						</li>

						<li>
							<div class="row s-line-item">
								<div class="col-xs-6">Product:</div>
								<div class="col-xs-6"><a href="##">Fathers Day Gift Card</a></div>
							</div>
						</li>

					</ul>
				</div>
			</div>
		</div>
		<div class="col-md-3 s-md-content-block">
			<div class="s-md-content-block-inner">
				<div class="s-title">
					Recipient Info
					<div class="dropdown s-action">
						<a href="##" class="dropdown-toggle" id="dropdownMenu" data-toggle="dropdown">
							<i class="fa fa-ellipsis-h" title="actions"></i>
						</a>
						<ul class="dropdown-menu pull-right" aria-labelledby="dropdownMenu1">
							<li><a href="#">Change/Edit Recipient</a></li>
						</ul>
					</div>
				</div>
				<div class="s-body">
					<ul class="list-unstyled">
						<li>
							<div class="row s-line-item">
								<div class="col-xs-6">First Name:</div>
								<div class="col-xs-6">Bob</div>
							</div>
						</li>

						<li>
							<div class="row s-line-item">
								<div class="col-xs-6">Last Name:</div>
								<div class="col-xs-6">Smith</div>
							</div>
						</li>

						<li>
							<div class="row s-line-item">
								<div class="col-xs-6">Email:</div>
								<div class="col-xs-6">bobsmith@gmail.com</div>
							</div>
						</li>

						<li>
							<div class="row s-line-item">
								<div class="col-xs-6">Message:</div>
								<div class="col-xs-6">
									<a href="##" data-toggle="collapse" data-target="#j-recipient-message" aria-expanded="false" aria-controls="collapseExample">View Message</a>
								</div>
							</div>
							<div>
								<div class="collapse" id="j-recipient-message">
									<textarea class="form-control s-recipient-message" disabled>Donec id elit non mi porta gravida at eget metus.  Donec id elit non mi porta gravida at eget metus.</textarea>
								</div>
							</div>
						</li>

					</ul>
				</div>
			</div>
		</div>
	</div>

	<div class="row s-detail-content-wrapper">

		<div class="col-xs-12">
			<div class="s-detail-body">
				<h2>History & Orders</h2>
				<div class="row">
					<div class="col-xs-3 s-detail-info">
						<p>This timeline provides details on all actions that have taken place on this gift card.</p>
						<div class="s-search-table">
							<input placeholder="Search timeline" class="form-control">
							<i class="fa fa-search"></i>
							<i class="fa fa-spinner fa-spin"></i>
						</div>
					</div>
					<div class="col-xs-9 s-detail-header-table">


						<div class="responsive-table">
						    <table class="table">
						        <thead>
						            <tr>
						                <th></th>
						                <th>Type <i class="fa fa-sort"></i></th>
						                <th>Date <i class="fa fa-sort"></i></th>
						                <th>Info</th>
										<th>Transaction</th>
										<th>Balance</th>
						            </tr>
						        </thead>
						        <tbody>
						            <tr class="s-purchase">
										<td><i class="fa fa-shopping-cart"></i></td>
						                <td>Purchase Applied </td>
						                <td>July 8, 2015 - 11:43 am</td>
						                <td>Order: <a href="##">263546</a></td>
										<td>-$51.03</td>
										<td>$248.97</td>
						            </tr>
						            <tr class="s-success">
										<td><i class="fa fa-check"></i></td>
						                <td>Card Activated</td>
						                <td>July 8, 2015 - 11:43 am</td>
						                <td></td>
										<td>--</td>
										<td>$300.00</td>
						            </tr>
						            <tr class="s-notify">
										<td><i class="fa fa-times"></i></td>
						                <td>Card Deactivated </td>
						                <td>July 8, 2015 - 11:43 am</td>
						                <td></td>
										<td>--</td>
										<td>$300.00</td>
						            </tr>
									<tr>
										<td><i class="fa fa-user-plus"></i></td>
						                <td>Card Assigned</td>
						                <td>July 8, 2015 - 11:43 am</td>
						                <td></td>
										<td>--</td>
										<td>$300.00</td>
						            </tr>
									<tr>
										<td><i class="fa fa-envelope"></i></td>
						                <td>Recipient Email Opened</td>
						                <td>July 8, 2015 - 11:43 am</td>
						                <td>Recipient: Bob Smith (bobsmith@gmail.com)</td>
										<td>--</td>
										<td>$300.00</td>
						            </tr>
									<tr class="s-error">
										<td><i class="fa fa-envelope"></i></td>
						                <td>Recipient Email Failure </td>
						                <td>July 8, 2015 - 11:43 am</td>
						                <td>Recipient: John Smith (johnsmith@gmail.com)</td>
										<td>--</td>
										<td>$300.00</td>
						            </tr>
									<tr>
										<td><i class="fa fa-envelope"></i></td>
						                <td>Recipient email updated </td>
						                <td>July 8, 2015 - 11:43 am</td>
						                <td>Recipient: John Smith (johnsmith@gmail.com)</td>
										<td>--</td>
										<td>$300.00</td>
						            </tr>
									<tr>
										<td><i class="fa fa-envelope"></i></td>
						                <td>Recipient notification resent </td>
						                <td>July 8, 2015 - 11:43 am</td>
						                <td>Recipient: John Smith (johnsmith@gmail.com)</td>
										<td>--</td>
										<td>$300.00</td>
						            </tr>
									<tr>
										<td><i class="fa fa-plus"></i></td>
						                <td>Card Purchased </td>
						                <td>July 8, 2015 - 11:43 am</td>
						                <td>Customer: <a href="##">John Smith (johnsmith@gmail.com)</a></td>
										<td>+$300.00</td>
										<td>$300.00</td>
						            </tr>
						        </tbody>
						    </table>
							<div class="s-load-more-wrapper">
								<button type="button" name="button" class="btn btn-default btn-sm s-load-more">Load More <span>(showing 9 of 200)</span></button>
							</div>
						</div>

					</div>
				</div>
			</div>
		</div>
	</div>
</div>