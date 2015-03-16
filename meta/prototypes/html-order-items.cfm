<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<div class="row s-body-nav">
	<nav class="navbar navbar-default" role="navigation">
		<div class="col-md-4 s-header-info">
			<ul class="list-unstyled list-inline">
				<li><a href="##">Dashboard</a></li>
				<li><a href="##">Order Items</a></li>
				<li><a href="##">Order ##2635</a></li>
			</ul>
			<h1>Order ##2635</h1>
		</div>

		<div class="col-md-8">
			<div class="btn-toolbar">

				<div class="btn-group btn-group-sm">
					<div class="btn-group btn-group-sm">
						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
							Actions
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu" role="menu">
							<li><a title="Update Skus" class="modalload" href="#" data-confirm="Are you sure that you want to override the default image filename?  Doing this may remove your existing default images.">Reset Default Image Filenames</a></li>
							<li class="divider"></li>
							<li><a title="Add Sku" class="modalload" href="#" data-toggle="modal" data-target="#adminModal">Add Sku</a></li> <li><a title="Add Image" class="adminentitycreateImage  modalload" href="#" data-toggle="modal" data-target="#adminModal">Add Image</a></li> <li><a title="Add File" class="modalload" href="#" data-toggle="modal" data-target="#adminModal">Add File</a></li> <li><a title="Add Comment" class="modalload" href="#" data-toggle="modal" data-target="#adminModal">Add Comment</a></li>
						</ul>
					</div>
				</div>

				<div class="btn-group btn-group-sm">
					<button type="button" class="btn btn-default s-remove">Delete</button>
					<button type="button" class="btn btn-default">Cancel</button>
					<button type="button" class="btn btn-success">Save</button>
				</div>

			</div>
		</div>
	</nav>
</div>

<div class="row s-pannel-control">
	<div class="col-md-12"><a href="#" class="openall">Open All</a> / <a href="#" class="closeall">Close All</a></div>
</div>

<div class="panel-group s-pannel-group" id="accordion">
	<div class="panel panel-default">
		<a data-toggle="collapse"  href="#collapseOne">
			<div class="panel-heading">
				<h4 class="panel-title">
					<span>Basic</span>
					<i class="fa fa-caret-left"></i>
				</h4>
			</div>
		</a>

		<div id="collapseOne" class="panel-collapse collapse in">
			<content class="s-body-box s-panel-header-info">

				<div class="col-md-6 s-header-left">
					<div class="s-header-detail">
						<img src="http://placehold.it/500x500">
						<dl class="dl-horizontal">
							<dt class="title">Price: <i class="fa fa-question-circle" ></i></dt>
							<dd class="value">$69.99</dd>
							<dt class="title">Qty: <i class="fa fa-question-circle" ></i></dt>
							<dd class="value">1</dd>
						</dl>
					</div>
				</div>
				<div class="col-md-6 s-header-right">
					<div class="s-header-detail">
						<h2>Sku Details</h2>
						<dl class="dl-horizontal">
							<dt class="title" >Sku Price When Ordered:</dt>
							<dd class="value">$209.99</dd>
							<dt class="title" >Current Sku Price:</dt>
							<dd class="value">$209.99</dd>
							<dt class="title" >SKU Code:</dt>
							<dd class="value">CL-00003-1</dd>
							<dt class="title" >Color:</dt>
							<dd class="value">Black / Black / Total Crimson</dd>
							<dt class="title" >Cleat Size ( US - Mens ):</dt>
							<dd class="value">6</dd>
						</dl>
					</div>
					<div class="s-header-detail">
						<h2>Status</h2>
						<dl class="dl-horizontal">
							<dt class="title" >Order Item Status:</dt>
							<dd class="value">Processing</dd>
							<dt class="title" >Qty. Received:</dt>
							<dd class="value">1</dd>
							<dt class="title" >Qty. Unreceived:</dt>
							<dd class="value">0</dd>
						</dl>
					</div>
					<div class="s-header-detail">
						<h2>Price Totals</h2>
						<dl class="dl-horizontal">
							<dt class="title" >Extended Price:</dt>
							<dd class="value">$69.99</dd>
							<dt class="title" >Tax Amount:</dt>
							<dd class="value">$0.00</dd>
							<dt class="title" >Discounts:</dt>
							<dd class="value">$0.00</dd>
							<dt class="title s-total">Total:</dt>
							<dd class="value s-total">$69.99</dd>
						</dl>
					</div>
				</div>

			</content>
		</div>
	</div>

	<div class="panel panel-default">
		<a data-toggle="collapse"  href="#collapseTwo">
			<div class="panel-heading">
				<h4 class="panel-title">
					<span>Configuration<span>2</span></span>
					<i class="fa fa-caret-left"></i>
				</h4>
			</div>
		</a>

		<div id="collapseTwo" class="panel-collapse collapse">
			<content class="s-body-box s-status-active">
				<h2 class="s-filter-header">
					<span class="s-title">Deck</span>
					<ul class="list-unstyled list-inline">
						<li>Min<span>1</span></li>
						<li>Max<span>2</span></li>
					</ul>
				</h2>
				<div class="table-responsive s-order-item-box">

					<table class="table" border="1" cellpadding="0" cellspacing="0">
						<tr>
							<th></th>
							<th>SKU</th>
							<th>Title</th>
							<th>Price</th>
							<th>Qty</th>
							<th>Discount</th>
							<th>Total</th>
							<th>Fullfilment</th>
							<th></th>
						</tr>

						<tr class="s-item">
							<td class="s-image"><img src="http://placehold.it/50x50"></td>
							<td class="s-sku">bundle-01</td>
							<td class="s-title">
								<ul class="list-unstyled">
									<li><span>Skateboard Bundle</span> <a href="#" class="j-test-button" ng-click="openPageDialog( 'editorderitems' )"><i class="fa fa-pencil"></i></a></li>
									<li>
										<span><span>Base Price</span> <a href="#" class="j-test-button" ng-click="openPageDialog( 'editorderitems' )"><i class="fa fa-pencil"></i></a></span>
										<ul>
											<li><span>Custom Grip Tape</span></li>
											<li><span>Hardware Kit</span></li>
										</ul>
									</li>
									<li><span>Indi Trucks</span> <a href="#" class="j-test-button" ng-click="openPageDialog( 'editorderitems' )"><i class="fa fa-pencil"></i></a></li>
								</ul>
							</td>
							<td class="s-price">
								<ul class="list-unstyled">
									<li><span>$99.00</span></li>
									<li>
										<span>$10.00</span>
										<ul>
											<li><span>$5.00</span></li>
											<li><span>$5.00</span></li>
										</ul>
									</li>
									<li><span>$0.00</span></li>
								</ul>
							</td>
							<td class="s-qty">
								<ul class="list-unstyled">
									<li><span>3</span></li>
									<li>
										<span>1 (3 total)</span>
										<ul>
											<li><span>2 (12 total)</span></li>
											<li><span>1 (6 total)</span></li>
										</ul>
									</li>
									<li><span>1 (3 total)</span></li>
								</ul>
							</td>
							<td class="s-discount">
								<ul class="list-unstyled">
									<li><span>$0.00</span></li>
									<li>
										<span>$0.00</span>
										<ul>
											<li><span>$0.00</span></li>
											<li><span>$0.00</span></li>
										</ul>
									</li>
									<li><span>$0.00</span></li>
								</ul>
							</td>
							<td class="s-total">
								<ul class="list-unstyled">
									<li><span>$297.00</span></li>
									<li>
										<span>$10.00</span>
										<ul>
											<li><span>$5.00</span></li>
											<li><span>$5.00</span></li>
										</ul>
									</li>
									<li><span>$0.00</span></li>
								</ul>
							</td>
							<td class="s-shipping">
								<ul class="list-unstyled">
									<li><span>Ship To: </span><a href="#"><i class="fa fa-pencil"></i></a></li>
									<li><span>123 Main St.</span> </li>
									<li><span>Northboro, MA 01532</span></li>
								</ul>
							</td>
							<td class="s-order-edit-group">
								<ul class="list-unstyled">
									<li class="s-edit-btn"><button><i class="fa fa-eye"></i></button></li>
									<li class="s-remove-btn"><button><i class="fa fa-trash"></i></button></li>
								</ul>
							</td>
						</tr>

					</table>

				</div>

				<!-- Search for product -->
				<div class="row s-bundle-group-items">
					<div class="col-xs-12 s-search-bar">

						<ul class="list-unstyled s-search-bar-box">
							<li>
								<div class="dropdown input-group-btn search-panel">
									<button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown">
										<span id="j-search-concept">Any</span>
										<span class="caret"></span>
									</button>
									<ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
										<li><a href="#all">Any</a></li>
										<li><a href="#less_than">Product</a></li>
										<li><a href="#all">Skus</a></li>
									</ul>
								</div>
							</li>
							<li><input id="j-temp-class-search" type="text" class="form-control s-search-input" name="x" placeholder="Search product or sku"></li>
							<li>
								<ul class="list-unstyled">
									<li>
										<div class="s-checkbox"><input type="checkbox" id="j-checkbox25" checked="checked" ><label for="j-checkbox25"> In stock</label></div>
									</li>
									<li>
										<div class="dropdown input-group-btn search-panel">
											<button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown">
												<span id="j-search-concept">All Locations</span>
												<span class="caret"></span>
											</button>
											<ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
												<li><input type="text" class="form-control" name="x" placeholder="Search"></li>
												<li><a href="#all">All Locations</a></li>
												<li><a href="#less_than">San Diego</a></li>
												<li><a href="#all">New York</a></li>
												<li><a href="#all">France</a></li>
											</ul>
										</div>
									</li>
								</ul>
							</li>
						</ul>

					</div>

					<div class="col-xs-12 s-bundle-add-items s-hide-trans">
						<div class="col-xs-12 s-bundle-add-items-inner">
							<h4 id="j-temp-class">There are no items selected</h4>

							<ul class="list-unstyled s-order-item-options">
								<li class="s-bundle-add-obj">
									<ul class="list-unstyled list-inline">
										<li class="s-item-type">Product</li>
									</ul>
									<ul class="list-unstyled list-inline s-middle">
										<li class="j-tool-tip-item s-bundle-details">Howling Wolf T-Shirt <span>WOLF-01</span></li>
										<li class="j-tool-tip-item s-bundle-details">Qty: <span>4</span></li>
										<li class="j-tool-tip-item s-bundle-details">Location: <span>Boston</span></li>
									</ul>
									<ul class="list-unstyled list-inline s-last">
										<li class="col-xs-1 j-tool-tip-item s-bundle-details-add"><a class="btn s-btn-ten24"><i class="fa fa-plus"></i></a></li>
									</ul>
									<div class="clearfix"></div>
								</li>

								<li class="s-bundle-add-obj">
									<ul class="list-unstyled list-inline">
										<li class="s-item-type">Product</li>
									</ul>
									<ul class="list-unstyled list-inline s-middle">
										<li class="j-tool-tip-item s-bundle-details">Howling Wolf T-Shirt <span>WOLF-01</span></li>
										<li class="j-tool-tip-item s-bundle-details">Qty: <span>4</span></li>
										<li class="j-tool-tip-item s-bundle-details">Location: <span>Boston</span></li>
									</ul>
									<ul class="list-unstyled list-inline s-last">
										<li class="col-xs-1 j-tool-tip-item s-bundle-details-add"><a class="btn s-btn-ten24"><i class="fa fa-plus"></i></a></li>
									</ul>
									<div class="clearfix"></div>
								</li>

							</ul>
						</div>
					</div>
				</div>
				<!-- //Search for product -->

			</content>

			<hr/class="s-dotted">

			<content class="s-body-box">

				<h2 class="s-filter-header">
					<span class="s-title">Trucks</span>
					<ul class="list-unstyled list-inline">
						<li>Min<span>1</span></li>
						<li>Max<span>2</span></li>
					</ul>
				</h2>
				<div class="table-responsive s-order-item-box">
					<p class="s-no-items">There are no items selected</p>
					<!--- <table class="table" border="1" cellpadding="0" cellspacing="0">
						<tr>
							<th></th>
							<th>SKU</th>
							<th>Title</th>
							<th>Price</th>
							<th>Qty</th>
							<th>Discount</th>
							<th>Total</th>
							<th>Fullfilment</th>
							<th></th>
						</tr>

						<tr class="s-item">
							<td class="s-image"><img src="http://placehold.it/150x150"></td>
							<td class="s-sku"><span>bundle-02</span></td>
							<td class="s-title">
								<ul class="list-unstyled">
									<li><span>Skate Shoe</span> <a href="#" class="j-test-button" ng-click="openPageDialog( 'editorderitems' )"><i class="fa fa-pencil"></i></a></li>
								</ul>
							</td>
							<td class="s-price">
								<ul class="list-unstyled">
									<li><span>$59.00</span></li>
								</ul>
							</td>
							<td class="s-qty">
								<ul class="list-unstyled">
									<li><span>1</span></li>
								</ul>
							</td>
							<td class="s-discount">
								<ul class="list-unstyled">
									<li><span>$0.00</span></li>
								</ul>
							</td>
							<td class="s-total">
								<ul class="list-unstyled">
									<li><span>$59.00</span></li>
								</ul>
							</td>
							<td class="s-shipping">
								<ul class="list-unstyled">
									<li><span>Ship To:</span> <a href="#"><i class="fa fa-pencil"></i></a></li>
									<li><span>123 Main St. </span></li>
									<li><span>Northboro, MA 01532</span></li>
								</ul>
							</td>
							<td class="s-order-edit-group">
								<ul class="list-unstyled">
									<li class="s-edit-btn"><button><i class="fa fa-eye"></i></button></li>
									<li class="s-remove-btn"><button><i class="fa fa-trash"></i></button></li>
								</ul>
							</td>
						</tr>

					</table> --->

				</div>

				<!-- Search for product -->
				<div class="row s-bundle-group-items">
					<div class="col-xs-12 s-search-bar">

						<ul class="list-unstyled s-search-bar-box">
							<li>
								<div class="dropdown input-group-btn search-panel">
									<button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown">
										<span id="j-search-concept">Any</span>
										<span class="caret"></span>
									</button>
									<ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
										<li><a href="#all">Any</a></li>
										<li><a href="#less_than">Product</a></li>
										<li><a href="#all">Skus</a></li>
									</ul>
								</div>
							</li>
							<li><input id="j-temp-class-search" type="text" class="form-control s-search-input" name="x" placeholder="Search product or sku"></li>
							<li>
								<ul class="list-unstyled">
									<li>
										<div class="s-checkbox"><input type="checkbox" id="j-checkbox25" checked="checked" ><label for="j-checkbox25"> In stock</label></div>
									</li>
									<li>
										<div class="dropdown input-group-btn search-panel">
											<button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown">
												<span id="j-search-concept">All Locations</span>
												<span class="caret"></span>
											</button>
											<ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
												<li><input type="text" class="form-control" name="x" placeholder="Search"></li>
												<li><a href="#all">All Locations</a></li>
												<li><a href="#less_than">San Diego</a></li>
												<li><a href="#all">New York</a></li>
												<li><a href="#all">France</a></li>
											</ul>
										</div>
									</li>
								</ul>
							</li>
						</ul>

					</div>

					<div class="col-xs-12 s-bundle-add-items s-hide-trans">
						<div class="col-xs-12 s-bundle-add-items-inner">
							<h4 id="j-temp-class">There are no items selected</h4>

							<ul class="list-unstyled s-order-item-options">
								<li class="s-bundle-add-obj">
									<ul class="list-unstyled list-inline">
										<li class="s-item-type">Product</li>
									</ul>
									<ul class="list-unstyled list-inline s-middle">
										<li class="j-tool-tip-item s-bundle-details">Howling Wolf T-Shirt <span>WOLF-01</span></li>
										<li class="j-tool-tip-item s-bundle-details">Qty: <span>4</span></li>
										<li class="j-tool-tip-item s-bundle-details">Location: <span>Boston</span></li>
									</ul>
									<ul class="list-unstyled list-inline s-last">
										<li class="col-xs-1 j-tool-tip-item s-bundle-details-add"><a class="btn s-btn-ten24"><i class="fa fa-plus"></i></a></li>
									</ul>
									<div class="clearfix"></div>
								</li>

								<li class="s-bundle-add-obj">
									<ul class="list-unstyled list-inline">
										<li class="s-item-type">Product</li>
									</ul>
									<ul class="list-unstyled list-inline s-middle">
										<li class="j-tool-tip-item s-bundle-details">Howling Wolf T-Shirt <span>WOLF-01</span></li>
										<li class="j-tool-tip-item s-bundle-details">Qty: <span>4</span></li>
										<li class="j-tool-tip-item s-bundle-details">Location: <span>Boston</span></li>
									</ul>
									<ul class="list-unstyled list-inline s-last">
										<li class="col-xs-1 j-tool-tip-item s-bundle-details-add"><a class="btn s-btn-ten24"><i class="fa fa-plus"></i></a></li>
									</ul>
									<div class="clearfix"></div>
								</li>

							</ul>
						</div>
					</div>
				</div>
				<!-- //Search for product -->

			</content>

			<hr/class="s-dotted">

			<content class="s-body-box s-disabled">

				<h2 class="s-filter-header">
					<span class="s-title">Wheels</span>
					<ul class="list-unstyled list-inline">
						<li>Min<span>1</span></li>
						<li>Max<span>2</span></li>
					</ul>
				</h2>
				<div class="table-responsive s-order-item-box">
					<p clas="s-no-items">There are no items selected</p>
					<!--- <table class="table" border="1" cellpadding="0" cellspacing="0">
						<tr>
							<th></th>
							<th>SKU</th>
							<th>Title</th>
							<th>Price</th>
							<th>Qty</th>
							<th>Discount</th>
							<th>Total</th>
							<th>Fullfilment</th>
							<th></th>
						</tr>

						<tr class="s-item">
							<td class="s-image"><img src="http://placehold.it/150x150"></td>
							<td class="s-sku"><span>bundle-02</span></td>
							<td class="s-title">
								<ul class="list-unstyled">
									<li><span>Skate Shoe</span> <a href="#" class="j-test-button" ng-click="openPageDialog( 'editorderitems' )"><i class="fa fa-pencil"></i></a></li>
								</ul>
							</td>
							<td class="s-price">
								<ul class="list-unstyled">
									<li><span>$59.00</span></li>
								</ul>
							</td>
							<td class="s-qty">
								<ul class="list-unstyled">
									<li><span>1</span></li>
								</ul>
							</td>
							<td class="s-discount">
								<ul class="list-unstyled">
									<li><span>$0.00</span></li>
								</ul>
							</td>
							<td class="s-total">
								<ul class="list-unstyled">
									<li><span>$59.00</span></li>
								</ul>
							</td>
							<td class="s-shipping">
								<ul class="list-unstyled">
									<li><span>Ship To:</span> <a href="#"><i class="fa fa-pencil"></i></a></li>
									<li><span>123 Main St. </span></li>
									<li><span>Northboro, MA 01532</span></li>
								</ul>
							</td>
							<td class="s-order-edit-group">
								<ul class="list-unstyled">
									<li class="s-edit-btn"><button><i class="fa fa-eye"></i></button></li>
									<li class="s-remove-btn"><button><i class="fa fa-trash"></i></button></li>
								</ul>
							</td>
						</tr>

					</table> --->

				</div>

				<!-- Search for product -->
				<div class="row s-bundle-group-items">
					<div class="col-xs-12 s-search-bar">

						<ul class="list-unstyled s-search-bar-box">
							<li>
								<div class="dropdown input-group-btn search-panel">
									<button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown">
										<span id="j-search-concept">Any</span>
										<span class="caret"></span>
									</button>
									<ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
										<li><a href="#all">Any</a></li>
										<li><a href="#less_than">Product</a></li>
										<li><a href="#all">Skus</a></li>
									</ul>
								</div>
							</li>
							<li><input id="j-temp-class-search" type="text" class="form-control s-search-input" name="x" placeholder="Search product or sku"></li>
							<li>
								<ul class="list-unstyled">
									<li>
										<div class="s-checkbox"><input type="checkbox" id="j-checkbox25" checked="checked" ><label for="j-checkbox25"> In stock</label></div>
									</li>
									<li>
										<div class="dropdown input-group-btn search-panel">
											<button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown">
												<span id="j-search-concept">All Locations</span>
												<span class="caret"></span>
											</button>
											<ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
												<li><input type="text" class="form-control" name="x" placeholder="Search"></li>
												<li><a href="#all">All Locations</a></li>
												<li><a href="#less_than">San Diego</a></li>
												<li><a href="#all">New York</a></li>
												<li><a href="#all">France</a></li>
											</ul>
										</div>
									</li>
								</ul>
							</li>
						</ul>

					</div>

					<div class="col-xs-12 s-bundle-add-items s-hide-trans">
						<div class="col-xs-12 s-bundle-add-items-inner">
							<h4 id="j-temp-class">There are no items selected</h4>

							<ul class="list-unstyled s-order-item-options">
								<li class="s-bundle-add-obj">
									<ul class="list-unstyled list-inline">
										<li class="s-item-type">Product</li>
									</ul>
									<ul class="list-unstyled list-inline s-middle">
										<li class="j-tool-tip-item s-bundle-details">Howling Wolf T-Shirt <span>WOLF-01</span></li>
										<li class="j-tool-tip-item s-bundle-details">Qty: <span>4</span></li>
										<li class="j-tool-tip-item s-bundle-details">Location: <span>Boston</span></li>
									</ul>
									<ul class="list-unstyled list-inline s-last">
										<li class="col-xs-1 j-tool-tip-item s-bundle-details-add"><a class="btn s-btn-ten24"><i class="fa fa-plus"></i></a></li>
									</ul>
									<div class="clearfix"></div>
								</li>

								<li class="s-bundle-add-obj">
									<ul class="list-unstyled list-inline">
										<li class="s-item-type">Product</li>
									</ul>
									<ul class="list-unstyled list-inline s-middle">
										<li class="j-tool-tip-item s-bundle-details">Howling Wolf T-Shirt <span>WOLF-01</span></li>
										<li class="j-tool-tip-item s-bundle-details">Qty: <span>4</span></li>
										<li class="j-tool-tip-item s-bundle-details">Location: <span>Boston</span></li>
									</ul>
									<ul class="list-unstyled list-inline s-last">
										<li class="col-xs-1 j-tool-tip-item s-bundle-details-add"><a class="btn s-btn-ten24"><i class="fa fa-plus"></i></a></li>
									</ul>
									<div class="clearfix"></div>
								</li>

							</ul>
						</div>
					</div>
				</div>
				<!-- //Search for product -->

			</content>

		</div>
	</div>

	<div class="panel panel-default">
		<a data-toggle="collapse"  href="#collapseImages">
			<div class="panel-heading">
				<h4 class="panel-title">
					<span>Customization</span>
					<i class="fa fa-caret-left"></i>
				</h4>
			</div>
		</a>
		<div id="collapseImages" class="panel-collapse collapse">
			<content class="s-body-box">
				<div class="col-xs-12 s-filter-content">

					<div class="form-group">
						<label for="">Name Etching</label>
						<input type="text" class="form-control" id="" placeholder="">
					</div>

					<div class="form-group">
						<label for="" style="width:100%;">Name Etching</label>
						<textarea class="form-control" name="Name" rows="6"></textarea>
					</div>

				</div>
			</content>
		</div>
	</div>

	<div class="panel panel-default">
		<a data-toggle="collapse"  href="#collapseComments">
			<div class="panel-heading">
				<h4 class="panel-title">
					<span>Comments <span>1</span></span>
					<i class="fa fa-caret-left"></i>
				</h4>
			</div>
		</a>
		<div id="collapseComments" class="panel-collapse collapse">
			<content class="s-body-box">
				<div class="table-responsive s-order-item-box">
					<table class="table" border="1" cellpadding="0" cellspacing="0">
						<tr>
							<th>Comment</th>
							<th>Public</th>
							<th>Created By</th>
							<th>Created Date Time</th>
							<th></th>
						</tr>
						<tr class="s-item">
							<td>
								<ul class="list-unstyled">
									<li>
										<p>Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec id elit non mi porta gravida at eget metus. Curabitur blandit tempus porttitor. Curabitur blandit tempus porttitor. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Integer posuere erat a ante venenatis dapibus posuere velit aliquet. Praesent commodo cursus magna, vel scelerisque nisl consectetur et.</p>
										<p>Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Sed posuere consectetur est at lobortis. Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor. Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum. Vestibulum id ligula porta felis euismod semper.</p>
										<p>Nullam quis risus eget urna mollis ornare vel eu leo. Nulla vitae elit libero, a pharetra augue. Donec ullamcorper nulla non metus auctor fringilla. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Cras mattis consectetur purus sit amet fermentum. Donec id elit non mi porta gravida at eget metus.</p>
									</li>
								</ul>
							</td>
							<td>
								<ul class="list-unstyled">
									<li>No</li>
								</ul>
							</td>
							<td>
								<ul class="list-unstyled">
									<li>Reyjay Solares</li>
								</ul>
							</td>
							<td>
								<ul class="list-unstyled">
									<li>Sep 23, 2014 10:46 PM</li>
								</ul>
							</td>
							<td class="s-order-edit-group">
								<ul class="list-unstyled">
									<li class="s-edit-btn"><button><i class="fa fa-eye"></i></button></li>
									<li class="s-remove-btn"><button><i class="fa fa-trash"></i></button></li>
								</ul>
							</td>
						</tr>

						<tr class="s-item">
							<td>
								<ul class="list-unstyled">
									<li>
										<p>Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Sed posuere consectetur est at lobortis. Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor. Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum. Vestibulum id ligula porta felis euismod semper.</p>
									</li>
								</ul>
							</td>
							<td>
								<ul class="list-unstyled">
									<li>Yes</li>
								</ul>
							</td>
							<td>
								<ul class="list-unstyled">
									<li>Pablo Sangla</li>
								</ul>
							</td>
							<td>
								<ul class="list-unstyled">
									<li>Dec 2, 2013 4:34 AM</li>
								</ul>
							</td>
							<td class="s-order-edit-group">
								<ul class="list-unstyled">
									<li class="s-edit-btn"><button><i class="fa fa-eye"></i></button></li>
									<li class="s-remove-btn"><button><i class="fa fa-trash"></i></button></li>
								</ul>
							</td>
						</tr>

					</table>
				</div>
			</content>
		</div>
	</div>

	<div class="panel panel-default">
		<a data-toggle="collapse"  href="#collapseSystem">
			<div class="panel-heading">
				<h4 class="panel-title">
					<span>System</span>
					<i class="fa fa-caret-left"></i>
				</h4>
			</div>
		</a>
		<div id="collapseSystem" class="panel-collapse collapse">
			<content class="s-body-box">

				<div class="col-md-6 s-header-left">
					<div class="s-header-detail">
						<dl class="dl-horizontal">
							<dt class="title">Order Item ID:</dt>
							<dd class="value"></dd>
							<dt class="title">Remote ID:</dt>
							<dd class="value">5124bffa4883fc6e0148858cf8da0051</dd>
						</dl>
					</div>
				</div>
				<div class="table-responsive s-order-item-box">
					<table class="table" border="1" cellpadding="0" cellspacing="0">
						<tr>
							<th>Wednesday, September 17, 2014</th>
							<th></th>
							<th></th>
						</tr>
						<tr class="s-item">
							<td>
								<ul class="list-unstyled">
									<li>
										<p>05:42 PM - Greg Moser</p>
									</li>
								</ul>
							</td>
							<td>
								<ul class="list-unstyled">
									<li><strong>Updated:</strong> <a href="#">adidas 11Nova Indoor Soccer Shoes - MP-00001-1 </a></li>
									<li><strong>Changed:</strong> Order Item Status</li>
								</ul>
							</td>
							<td class="s-order-edit-group">
								<ul class="list-unstyled">
									<li class="s-edit-btn"><button><i class="fa fa-eye"></i></button></li>
									<li class="s-remove-btn"><button><i class="fa fa-trash"></i></button></li>
								</ul>
							</td>
						</tr>

					</table>
				</div>
			</content>

		</div>
	</div>

</div>


<script charset="utf-8">
	//activate tooltips
		$('.j-tool-tip-item').tooltip();
</script>

<script charset="utf-8">
	//This was created for example only to toggle the edit save icons

		$('#j-edit-btn').click(function(){
			$(this).toggle();
			$(this).siblings('#j-save-btn').toggle();
			$('.s-properties p').toggle();
			$('.s-properties input').toggle();
		});
		$('#j-save-btn').click(function(){
			$(this).toggle();
			$(this).siblings('#j-edit-btn').toggle();
			$('.s-properties p').toggle();
			$('.s-properties input').toggle();
		});

</script>

<script charset="utf-8">
	$('.s-filter-item .panel-body').click(function(){
		$(this).parent().parent().parent().siblings('li').toggleClass('s-disabled');
		$(this).parent().toggleClass('s-focus');
	});
</script>


<script charset="utf-8">
	$('.btn-toggle').click(function() {
		$(this).find('.btn').toggleClass('active');

		if ($(this).find('.btn-primary').size()>0) {
				$(this).find('.btn').toggleClass('btn-primary');
		}
		if ($(this).find('.btn-danger').size()>0) {
				$(this).find('.btn').toggleClass('btn-danger');
		}
		if ($(this).find('.btn-success').size()>0) {
				$(this).find('.btn').toggleClass('btn-success');
		}
		if ($(this).find('.btn-info').size()>0) {
				$(this).find('.btn').toggleClass('btn-info');
		}

		$(this).find('.btn').toggleClass('btn-default');

});

$('form').submit(function(){
		alert($(this["options"]).val());
		return false;
});
</script>

<script charset="utf-8">
	//Make panels dragable
	jQuery(function($) {
		var panelList = $('.s-j-draggablePanelList');

		panelList.sortable({
			handle: '.s-pannel-name',
			update: function() {
				$('.s-pannel-name', panelList).each(function(index, elem) {
					 var $listItem = $(elem),
					 newIndex = $listItem.index();
				});
			}
		});
	});
</script>

<script charset="utf-8">
	//Dragable pannel for filters
	$('.s-j-draggablePanelList .btn-group a').click(function(e){
		e.preventDefault();
		if($(this).hasClass('s-sort')){
			$(this).children('i').toggle();
		}else{
			$(this).toggleClass('active');
		};
	});
</script>

<script charset="utf-8">
	//Remove sortable items and add message when none are left
	$('.s-remove').click(function(){
		$(this).closest('.list-group-item').remove();
		if($('.s-j-draggablePanelList .list-group-item').length < 1){$('.s-none-selected').show()};
	});
</script>

<script charset="utf-8">
	//Sort filter - rename header
	$('.list-group-item .s-pannel-name .s-pannel-title').click(function(){
		$(this).fadeToggle('fast');
		$(this).siblings(".s-title-edit-menu").toggle('slide', { direction: 'left' }, 300);
	});
	$('.list-group-item .s-pannel-name .s-save-btn').click(function(){
		$(this).parent().siblings('.s-pannel-title').fadeToggle();
		$(this).parent().toggle('slide', { direction: 'left' }, 300);
	});
</script>

<script charset="utf-8">
	jQuery('body').on('click', '.s-bundle-box .s-bundle-box-head .s-toggle-btn', function(e){
		$(this).parent().parent().toggleClass('s-active');
	});
</script>

<script charset="utf-8">
	//Hide and show the filter search content depending if search has text
	$('body').on('keyup','.s-search-bar',function() {
		if( $(this).find('.s-search-input').val().length > 0 ){
			$(this).parent().find('.s-bundle-add-items').removeClass('s-hide-trans');
		}else{
			$(this).parent().find('.s-bundle-add-items').addClass('s-hide-trans');
		};
	});
</script>
