<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<div class="row s-body-nav">
	<nav class="navbar navbar-default" role="navigation">
		<div class="col-md-4 s-header-info">
			<ul class="list-unstyled list-inline">
				<li><a href="##">Dashboard</a></li>
				<li><a href="##">Products</a></li>
				<li><a href="##">Skateboard Bundle</a></li>
			</ul>
			<h1>Skateboard Bundle</h1>
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

				<div class="panel-body s-panel-header-info">

					<div class="col-md-6">
						<dl class="dl-horizontal">
							<dt class="title">Product Name: <i class="fa fa-question-circle" ></i></dt>
							<dd class="value">Skateboard</dd>
							<dt class="title" >Product Code: <i class="fa fa-question-circle" ></i></dt>
							<dd class="value">6765456</dd>
							<dt class="title" >Price: <i class="fa fa-question-circle" ></i></dt>
							<dd class="value">$75</dd>
						</dl>
					</div>
					<div class="col-md-6">
						<dl class="dl-horizontal">
							<dt class="title" >Product Type: <i class="fa fa-question-circle" ></i></dt>
							<dd class="value">Merch</dd>
							<dt class="title" >Brand: <i class="fa fa-question-circle" ></i></dt>
							<dd class="value">Kingo</dd>
						</dl>
					</div>

				</div>

			</content>
		</div>
	</div>

	<div class="panel panel-default">
		<a data-toggle="collapse"  href="#collapseSystem">
			<div class="panel-heading">
				<h4 class="panel-title">
					<span>Bundle Groups</span>
					<i class="fa fa-caret-left"></i>
				</h4>
			</div>
		</a>
		<div id="collapseSystem" class="panel-collapse collapse">
			<content class="s-body-box">


				<div class="s-bundle-group-section">

					<ul class="list-unstyled s-bundle-group">
						<li class="s-bundle-group-item">
							<div class="row">
								<div class="col-xs-8 s-bundle-group-title">
									<div class="s-bundle-group-range">
										<ul class="list-unstyled s-bundle-group-min">
										<li>Min</li>
										<li>1</li>
										</ul>
										<ul class="list-unstyled s-bundle-group-max">
										<li>Max</li>
										<li>1</li>
										</ul>
									</div>
									<span class="s-bundle-group-title-text">T-Shirts: Closeout Selections</span>
									<span class="s-bundle-group-title-edit"><input type="text" class="form-control" value="T-Shirts: Closeout Selections"><button class="btn btn-xs s-btn-ten24 s-save-btn">Save</button></span>
								</div>
								<div class="col-xs-4">
									<div class="btn-group s-bundle-group-options">
										<a class="btn btn-default s-edit j-tool-tip-item" data-toggle="collapse" data-target="#demo" data-toggle="tooltip" data-placement="bottom" data-original-title="Edit"><i class="fa fa-pencil"></i></a>
										<a class="btn btn-default s-remove j-tool-tip-item" data-toggle="tooltip" data-placement="bottom" data-original-title="Remove"><i class="fa fa-times"></i></a>
									</div>
								</div>
							</div>

							<div id="demo" class="collapse s-bundle-group-dropdown">
								<div class="s-bundle-group-dropdown-content">

									<div class="s-filter-content">

										<!--- Header nav with title starts --->
										<div class="row s-header-bar">
											<div class="col-xs-12 s-header-nav">
													<ul class="nav nav-tabs" role="tablist">
													<li class="active"><a href="##j-default-tab" role="tab" data-toggle="tab">Basic</a></li>
													<li><a href="##j-selections-tab" role="tab" data-toggle="tab">Selections</a></li>
												</ul>
											</div>
										</div>
										<!--- //Header nav with title end --->

										<!--- Tab panes for menu options start--->
										<div class="s-options">
											<div class="tab-content" id="j-property-box">

												<div class="tab-pane active" id="j-default-tab">
													<div class="form-group">
														<label for="">Bundle Group Type:</label>
														<input type="text" class="form-control" value="T-Shirts: Closeout Selections">
													</div>

													<div class="row form-group">
														<div class="col-xs-2">
															<label for="">Minimum Quantity:</label>
															<input type="number" class="form-control" value="1">
														</div>

														<div class="col-xs-2">
															<label for="">Maximum Quantity:</label>
															<input type="number" class="form-control" value="1">
														</div>
													</div>

													<div class="form-group s-bundle-group-active">
														<label class="control-label">Active: </label>
														<div class="radio">
															<input type="radio" name="radio1" id="radio1" checked="checked" value="option2">
															<label for="radio1">
																Yes
															</label>
														</div>
														<div class="radio">
															<input type="radio" name="radio1" id="radio2" value="option2">
															<label for="radio2">
																No
															</label>
														</div>
														<div class="clearfix"></div>
													</div>
												</div>

												<div class="tab-pane" id="j-selections-tab">

													<!-- Selected filters -->
													<div class="s-bundle-add-items s-workflow-objs">
														<ul class="list-unstyled s-order-item-options">

															<li class="s-bundle-add-obj">
																<ul class="list-unstyled list-inline s-middle">
																	<li class="j-tool-tip-item s-bundle-details">Howling Wolf T-Shirt<span></span></li>
																	<li class="j-tool-tip-item s-bundle-details"><span>Size XL (TShirtHowl-XL)</span></li>
																	<li class="j-tool-tip-item s-bundle-details"><span>WOLF-01</span></li>
																	<li class="j-tool-tip-item s-bundle-details"><span>$9.99</span></li>
																</ul>
																<ul class="list-unstyled list-inline s-last">
																	<li class="col-xs-1 j-tool-tip-item s-bundle-details-add"><a class="btn s-btn-dgrey s-remove"><i class="fa fa-trash"></i></a></li>
																</ul>
																<div class="clearfix"></div>
															</li>

														</ul>
													</div>
													<!-- //Selected filters -->

													<!-- Search for product -->
													<div class="row s-bundle-group-items">
														<div class="col-xs-12">
															<div class="input-group">
																<div class="dropdown input-group-btn search-panel">
																	<button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown">
																		<span id="j-search-concept">Product Type</span>
																		<span class="caret"></span>
																	</button>
																	<ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
																		<li><a href="#greather_than">Product Type</a></li>
																		<li><a href="#contains">Collections</a></li>
																		<li><a href="#its_equal">Brand</a></li>
																		<li><a href="#less_than">Products</a></li>
																		<li><a href="#all">Skus</a></li>
																	</ul>
																</div>
																<input id="j-temp-class-search" type="text" class="form-control s-search-input" name="x" placeholder="Search term...">
																<span class="input-group-btn">
																	<button class="btn btn-default s-search-button" type="button"><span class="glyphicon glyphicon-search"></span></button>
																</span>
															</div>
														</div>

														<div class="col-xs-12 s-bundle-add-items">
															<div class="col-xs-12 s-bundle-add-items-inner">
																<!--- <h4 id="j-temp-class">There are no items selected</h4> --->

																<!-- Selected filters -->
																<div class="s-bundle-add-items s-workflow-objs">
																	<ul class="list-unstyled s-order-item-options">

																		<li class="s-bundle-add-obj">
																			<ul class="list-unstyled list-inline s-middle">
																				<li class="j-tool-tip-item s-bundle-details">Howling Wolf T-Shirt<span></span></li>
																				<li class="j-tool-tip-item s-bundle-details"><span>Size XL (TShirtHowl-XL)</span></li>
																				<li class="j-tool-tip-item s-bundle-details"><span>WOLF-01</span></li>
																				<li class="j-tool-tip-item s-bundle-details"><span>$9.99</span></li>
																			</ul>
																			<ul class="list-unstyled list-inline s-last">
																				<li class="col-xs-1 j-tool-tip-item s-bundle-details-add"><a class="btn s-btn-ten24"><i class="fa fa-plus"></i></a></li>
																			</ul>
																			<div class="clearfix"></div>
																		</li>

																	</ul>
																</div>
																<!-- //Selected filters -->

															</div>
														</div>
													</div>
													<!-- //Search for product -->

												</div>
											</div><!-- //content-tab -->
										</div>
									</div>
								</div>
							</div>
						</li>

						<li class="s-bundle-group-item">
							<div class="row">
								<div class="col-xs-8 s-bundle-group-title">
									<div class="s-bundle-group-range">
										<ul class="list-unstyled s-bundle-group-min">
											<li>Min</li>
											<li>1</li>
										</ul>
										<ul class="list-unstyled s-bundle-group-max">
											<li>Max</li>
											<li>1</li>
										</ul>
									</div>
									<span class="s-bundle-group-title-text">T-Shirts: Closeout Selections</span>
									<span class="s-bundle-group-title-edit"><input type="text" class="form-control" value="T-Shirts: Closeout Selections"><button class="btn btn-xs s-btn-ten24 s-save-btn">Save</button></span>
								</div>
								<div class="col-xs-4">
									<div class="btn-group s-bundle-group-options">
										<a class="btn btn-default s-edit j-tool-tip-item" data-toggle="collapse" data-target="#demo" data-toggle="tooltip" data-placement="bottom" data-original-title="Edit"><i class="fa fa-pencil"></i></a>
										<a class="btn btn-default s-remove j-tool-tip-item" data-toggle="tooltip" data-placement="bottom" data-original-title="Remove"><i class="fa fa-times"></i></a>
									</div>
								</div>
							</div>

							<div id="demo" class="collapse s-bundle-group-dropdown">
								<div class="s-bundle-group-dropdown-content">

									<div class="s-filter-content">

										<!--- Header nav with title starts --->
										<div class="row s-header-bar">
											<div class="col-xs-12 s-header-nav">
												<ul class="nav nav-tabs" role="tablist">
													<li class="active"><a href="##j-default-tab" role="tab" data-toggle="tab">Basic</a></li>
													<li><a href="##j-selections-tab" role="tab" data-toggle="tab">Selections</a></li>
												</ul>
											</div>
										</div>
										<!--- //Header nav with title end --->

										<!--- Tab panes for menu options start--->
										<div class="s-options">
											<div class="tab-content" id="j-property-box">

												<div class="tab-pane active" id="j-default-tab">
													<div class="form-group">
														<label for="">Bundle Group Type:</label>
														<input type="text" class="form-control" value="T-Shirts: Closeout Selections">
													</div>

													<div class="row form-group">
														<div class="col-xs-2">
														<label for="">Minimum Quantity:</label>
														<input type="number" class="form-control" value="1">
														</div>

														<div class="col-xs-2">
														<label for="">Maximum Quantity:</label>
														<input type="number" class="form-control" value="1">
														</div>
													</div>

													<div class="form-group s-bundle-group-active">
														<label class="control-label">Active: </label>
														<div class="radio">
															<input type="radio" name="radio1" id="radio1" checked="checked" value="option2">
															<label for="radio1">
																Yes
															</label>
														</div>
														<div class="radio">
															<input type="radio" name="radio1" id="radio2" value="option2">
															<label for="radio2">
																No
															</label>
														</div>
														<div class="clearfix"></div>
													</div>
												</div>

												<div class="tab-pane" id="j-selections-tab">

													<!-- Selected filters -->
													<div class="s-bundle-add-items s-workflow-objs">
														<ul class="list-unstyled s-order-item-options">

															<li class="s-bundle-add-obj">
																<ul class="list-unstyled list-inline s-middle">
																	<li class="j-tool-tip-item s-bundle-details">Howling Wolf T-Shirt<span></span></li>
																	<li class="j-tool-tip-item s-bundle-details"><span>Size XL (TShirtHowl-XL)</span></li>
																	<li class="j-tool-tip-item s-bundle-details"><span>WOLF-01</span></li>
																	<li class="j-tool-tip-item s-bundle-details"><span>$9.99</span></li>
																</ul>
																<ul class="list-unstyled list-inline s-last">
																	<li class="col-xs-1 j-tool-tip-item s-bundle-details-add"><a class="btn s-btn-dgrey s-remove"><i class="fa fa-trash"></i></a></li>
																</ul>
																<div class="clearfix"></div>
															</li>

														</ul>
													</div>
													<!-- //Selected filters -->

													<!-- Search for product -->
													<div class="row s-bundle-group-items">
														<div class="col-xs-12">
															<div class="input-group">
																<div class="dropdown input-group-btn search-panel">
																	<button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown">
																		<span id="j-search-concept">Product Type</span>
																		<span class="caret"></span>
																	</button>
																	<ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
																		<li><a href="#greather_than">Product Type</a></li>
																		<li><a href="#contains">Collections</a></li>
																		<li><a href="#its_equal">Brand</a></li>
																		<li><a href="#less_than">Products</a></li>
																		<li><a href="#all">Skus</a></li>
																	</ul>
																</div>
																<input id="j-temp-class-search" type="text" class="form-control s-search-input" name="x" placeholder="Search term...">
																<span class="input-group-btn">
																	<button class="btn btn-default s-search-button" type="button"><span class="glyphicon glyphicon-search"></span></button>
																</span>
															</div>
														</div>

														<div class="col-xs-12 s-bundle-add-items">
															<div class="col-xs-12 s-bundle-add-items-inner">
																<!--- <h4 id="j-temp-class">There are no items selected</h4> --->

																<!-- Selected filters -->
																<div class="s-bundle-add-items s-workflow-objs">
																	<ul class="list-unstyled s-order-item-options">

																		<li class="s-bundle-add-obj">
																			<ul class="list-unstyled list-inline s-middle">
																				<li class="j-tool-tip-item s-bundle-details">Howling Wolf T-Shirt<span></span></li>
																				<li class="j-tool-tip-item s-bundle-details"><span>Size XL (TShirtHowl-XL)</span></li>
																				<li class="j-tool-tip-item s-bundle-details"><span>WOLF-01</span></li>
																				<li class="j-tool-tip-item s-bundle-details"><span>$9.99</span></li>
																			</ul>
																			<ul class="list-unstyled list-inline s-last">
																				<li class="col-xs-1 j-tool-tip-item s-bundle-details-add"><a class="btn s-btn-ten24"><i class="fa fa-plus"></i></a></li>
																			</ul>
																			<div class="clearfix"></div>
																		</li>

																	</ul>
																</div>
																<!-- //Selected filters -->

															</div>
														</div>
													</div>
													<!-- //Search for product -->

												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</li>

						<li class="s-bundle-group-item">
							<div class="row">
								<div class="col-xs-8 s-bundle-group-title">
									<div class="s-bundle-group-range">
										<ul class="list-unstyled s-bundle-group-min">
											<li>Min</li>
											<li>1</li>
										</ul>
										<ul class="list-unstyled s-bundle-group-max">
											<li>Max</li>
											<li>1</li>
										</ul>
									</div>
									<span class="s-bundle-group-title-text">T-Shirts: Closeout Selections</span>
									<span class="s-bundle-group-title-edit"><input type="text" class="form-control" value="T-Shirts: Closeout Selections"><button class="btn btn-xs s-btn-ten24 s-save-btn">Save</button></span>
								</div>
								<div class="col-xs-4">
									<div class="btn-group s-bundle-group-options">
										<a class="btn btn-default s-edit j-tool-tip-item" data-toggle="collapse" data-target="#demo" data-toggle="tooltip" data-placement="bottom" data-original-title="Edit"><i class="fa fa-pencil"></i></a>
										<a class="btn btn-default s-remove j-tool-tip-item" data-toggle="tooltip" data-placement="bottom" data-original-title="Remove"><i class="fa fa-times"></i></a>
									</div>
								</div>
							</div>

							<div id="demo" class="collapse s-bundle-group-dropdown">
								<div class="s-bundle-group-dropdown-content">

									<div class="s-filter-content">

										<!--- Header nav with title starts --->
										<div class="row s-header-bar">
											<div class="col-xs-12 s-header-nav">
												<ul class="nav nav-tabs" role="tablist">
													<li class="active"><a href="##j-default-tab" role="tab" data-toggle="tab">Basic</a></li>
													<li><a href="##j-selections-tab" role="tab" data-toggle="tab">Selections</a></li>
												</ul>
											</div>
										</div>
										<!--- //Header nav with title end --->

										<!--- Tab panes for menu options start--->
										<div class="s-options">
											<div class="tab-content" id="j-property-box">

												<div class="tab-pane active" id="j-default-tab">
													<div class="form-group">
														<label for="">Bundle Group Type:</label>
														<input type="text" class="form-control" value="T-Shirts: Closeout Selections">
													</div>

													<div class="row form-group">
														<div class="col-xs-2">
															<label for="">Minimum Quantity:</label>
															<input type="number" class="form-control" value="1">
														</div>

														<div class="col-xs-2">
															<label for="">Maximum Quantity:</label>
															<input type="number" class="form-control" value="1">
														</div>
													</div>

													<div class="form-group s-bundle-group-active">
														<label class="control-label">Active: </label>
														<div class="radio">
															<input type="radio" name="radio1" id="radio1" checked="checked" value="option2">
															<label for="radio1">
																Yes
															</label>
														</div>
														<div class="radio">
															<input type="radio" name="radio1" id="radio2" value="option2">
															<label for="radio2">
																No
															</label>
														</div>
														<div class="clearfix"></div>
													</div>
												</div>

												<div class="tab-pane" id="j-selections-tab">

													<!-- Selected filters -->
													<div class="s-bundle-add-items s-workflow-objs">
														<ul class="list-unstyled s-order-item-options">

															<li class="s-bundle-add-obj">
																<ul class="list-unstyled list-inline s-middle">
																	<li class="j-tool-tip-item s-bundle-details">Howling Wolf T-Shirt<span></span></li>
																	<li class="j-tool-tip-item s-bundle-details"><span>Size XL (TShirtHowl-XL)</span></li>
																	<li class="j-tool-tip-item s-bundle-details"><span>WOLF-01</span></li>
																	<li class="j-tool-tip-item s-bundle-details"><span>$9.99</span></li>
																</ul>
																<ul class="list-unstyled list-inline s-last">
																	<li class="col-xs-1 j-tool-tip-item s-bundle-details-add"><a class="btn s-btn-dgrey s-remove"><i class="fa fa-trash"></i></a></li>
																</ul>
																<div class="clearfix"></div>
															</li>

														</ul>
													</div>
													<!-- //Selected filters -->

													<!-- Search for product -->
													<div class="row s-bundle-group-items">
														<div class="col-xs-12">
															<div class="input-group">
																<div class="dropdown input-group-btn search-panel">
																	<button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown">
																		<span id="j-search-concept">Product Type</span>
																		<span class="caret"></span>
																	</button>
																	<ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
																		<li><a href="#greather_than">Product Type</a></li>
																		<li><a href="#contains">Collections</a></li>
																		<li><a href="#its_equal">Brand</a></li>
																		<li><a href="#less_than">Products</a></li>
																		<li><a href="#all">Skus</a></li>
																	</ul>
																</div>
																<input id="j-temp-class-search" type="text" class="form-control s-search-input" name="x" placeholder="Search term...">
																<span class="input-group-btn">
																	<button class="btn btn-default s-search-button" type="button"><span class="glyphicon glyphicon-search"></span></button>
																</span>
															</div>
														</div>

														<div class="col-xs-12 s-bundle-add-items">
															<div class="col-xs-12 s-bundle-add-items-inner">
																<!--- <h4 id="j-temp-class">There are no items selected</h4> --->

																<!-- Selected filters -->
																<div class="s-bundle-add-items s-workflow-objs">
																	<ul class="list-unstyled s-order-item-options">

																		<li class="s-bundle-add-obj">
																			<ul class="list-unstyled list-inline s-middle">
																				<li class="j-tool-tip-item s-bundle-details">Howling Wolf T-Shirt<span></span></li>
																				<li class="j-tool-tip-item s-bundle-details"><span>Size XL (TShirtHowl-XL)</span></li>
																				<li class="j-tool-tip-item s-bundle-details"><span>WOLF-01</span></li>
																				<li class="j-tool-tip-item s-bundle-details"><span>$9.99</span></li>
																			</ul>
																			<ul class="list-unstyled list-inline s-last">
																				<li class="col-xs-1 j-tool-tip-item s-bundle-details-add"><a class="btn s-btn-ten24"><i class="fa fa-plus"></i></a></li>
																			</ul>
																			<div class="clearfix"></div>
																		</li>

																	</ul>
																</div>
																<!-- //Selected filters -->

															</div>
														</div>
													</div>
													<!-- //Search for product -->

												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</li>

					</ul>
				</div>
				<button class="btn btn-sm btn-default s-create-bundle-btn" data-toggle="collapse" data-target="#j-edit-filter-9"><i class="fa fa-plus"></i> Bundle Group</button>


				<!--- Edit Filter Box --->
				<div class="col-xs-12 collapse s-add-filter s-bundle-group-dropdown s-create-bundle-item" id="j-edit-filter-9">
					<div class="row">
						<h4> Define Bundle Group<i class="fa fa-times" data-toggle="collapse" data-target="#j-edit-filter-9"></i></h4>

						<div class="s-bundle-group-dropdown-content">
							<div class="s-filter-content">

								<!--- Header nav with title starts --->
								<div class="row s-header-bar">
									<div class="col-xs-12 s-header-nav">
										<ul class="nav nav-tabs" role="tablist">
											<li class="active"><a href="#j-default-tab-9" role="tab" data-toggle="tab">Basic</a></li>
											<li><a href="#j-selections-tab-9" role="tab" data-toggle="tab">Selections</a></li>
										</ul>
									</div>
								</div>
								<!--- //Header nav with title end --->

								<!--- Tab panes for menu options start--->
								<div class="s-options">
									<div class="tab-content" id="j-property-box">

										<div class="tab-pane active" id="j-default-tab-9">

											<div class="row form-group" ng-app="filterSelect">
												<div class="col-xs-4">
													<label for="">Bundle Group Type:</label>
													<!--- search --->
													<div class="s-search-filter">
														<div class="input-group">
															<input type="text" class="form-control input-sm j-search-input" placeholder="Search&hellip;">
															<ul class="dropdown-menu s-search-options">
																<li><button type="button" class="btn s-btn-dgrey" data-toggle="collapse" data-target="#j-toggle-add-bundle-type"><i class="fa fa-plus"></i> Add "This should be the name"</button></li>
																<li><a>OnOrderItemUpdate</a></li>
																<li><a>OnOrderItemCancel</a></li>
																<li><a>OnOrderItemDelete</a></li>
																<li><hr/></li>
																<li><a>OnOrderItemDelete</a></li>
															</ul>
															<div class="input-group-btn">
																<button type="button" class="btn btn-sm btn-default j-dropdown-options"><span class="caret"></span></button>
															</div>
														</div>

														<div class="s-add-content collapse" id="j-toggle-add-bundle-type">
															<form id="form_id" action="index.html" method="post" style="background-color: #FFF;border: 1px solid #DDD;padding:20px;">
																<div class="form-group has-error">
																	<label for="">Group Name <i class="fa fa-asterisk"></i></label>
																	<input type="text" class="form-control" id="" value="" placeholder="">
																	<p class="help-block">Example Of Error</p>
																</div>
																<div class="form-group">
																	<label for="">Group Code</label>
																	<input type="text" class="form-control" id="" value="" placeholder="">
																</div>
																<div class="form-group">
																	<label for="">Group Description</label>
																	<textarea class="field form-control" id="textarea" rows="4" placeholder=""></textarea>
																</div>
																<div class="form-group">
																	<button type="button" class="btn btn-sm s-btn-ten24"><i class="fa fa-plus"></i> Add Group Type</button>
																</div>
															</form>
														</div>

													</div>
													<!--- // search --->

													<script charset="utf-8">
														$('#s-search-input').keyup(function(){
															if($(this).val().length > 0){
																$(this).parent().parent().find('.s-search-options').show();
															}else{
																$(this).parent().parent().find('.s-search-options').hide();
																$(this).parent().parent().find('.s-add-content').hide();
															};
														});
														$('.s-search-options li:first-child').click(function(){
															$(this).parent().parent().find('.s-search-options').hide();
														});
														$('#j-dropdown-options').click(function(){
															$(this).parent().parent().parent().find('.s-search-options').toggle();
														});
													</script>

												</div>
											</div>

											<div class="row form-group">
												<div class="col-xs-2">
													<label for="">Minimum Quantity:</label>
													<input type="number" class="form-control" value="1">
												</div>

												<div class="col-xs-2">
													<label for="">Maximum Quantity:</label>
													<input type="number" class="form-control" value="1">
												</div>
											</div>

											<div class="form-group s-bundle-group-active">
												<label class="control-label">Active: </label>
												<div class="radio">
													<input type="radio" name="radio1" id="radio1" checked="checked" value="option2">
													<label for="radio1">
														Yes
													</label>
												</div>
												<div class="radio">
													<input type="radio" name="radio1" id="radio2" value="option2">
													<label for="radio2">
														No
													</label>
												</div>
												<div class="clearfix"></div>
											</div>
											<button class="btn btn-xs s-btn-ten24" style="display:block;margin-bottom:10px;"><i class="fa fa-plus"></i> Save & Select Options</button>
										</div>

										<div class="tab-pane" id="j-selections-tab-9">

											<!-- Selected filters -->

												<ul class="list-unstyled s-order-item-options">

													<li class="s-bundle-add-obj">
														<ul class="list-unstyled list-inline s-middle">
															<li class="j-tool-tip-item s-bundle-details">Howling Wolf T-Shirt<span></span></li>
															<li class="j-tool-tip-item s-bundle-details"><span>Size XL (TShirtHowl-XL)</span></li>
															<li class="j-tool-tip-item s-bundle-details"><span>WOLF-01</span></li>
															<li class="j-tool-tip-item s-bundle-details"><span>$9.99</span></li>
														</ul>
														<ul class="list-unstyled list-inline s-last">
															<li class="col-xs-1 j-tool-tip-item s-bundle-details-add"><a class="btn s-btn-dgrey s-remove"><i class="fa fa-trash"></i></a></li>
														</ul>
														<div class="clearfix"></div>
													</li>

												</ul>
											</div>
											<!-- //Selected filters -->

											<!-- Search for product -->
											<div class="row s-bundle-group-items">
												<div class="col-xs-12">
													<div class="input-group">
														<div class="dropdown input-group-btn search-panel">
															<button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown">
																<span id="j-search-concept">Product Type</span>
																<span class="caret"></span>
															</button>
															<ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
																<li><a href="#greather_than">Product Type</a></li>
																<li><a href="#contains">Collections</a></li>
																<li><a href="#its_equal">Brand</a></li>
																<li><a href="#less_than">Products</a></li>
																<li><a href="#all">Skus</a></li>
															</ul>
														</div>
														<input id="j-temp-class-search" type="text" class="form-control s-search-input" name="x" placeholder="Search term...">
														<span class="input-group-btn">
															<button class="btn btn-default s-search-button" type="button"><span class="glyphicon glyphicon-search"></span></button>
														</span>
													</div>
												</div>

												<div class="col-xs-12 s-bundle-add-items">
													<div class="col-xs-12 s-bundle-add-items-inner">
														<!--- <h4 id="j-temp-class">There are no items selected</h4> --->

														<!-- Selected filters -->
														<div class="s-bundle-add-items s-workflow-objs">
															<ul class="list-unstyled s-order-item-options">

																<li class="s-bundle-add-obj">
																	<ul class="list-unstyled list-inline s-middle">
																		<li class="j-tool-tip-item s-bundle-details">Howling Wolf T-Shirt<span></span></li>
																		<li class="j-tool-tip-item s-bundle-details"><span>Size XL (TShirtHowl-XL)</span></li>
																		<li class="j-tool-tip-item s-bundle-details"><span>WOLF-01</span></li>
																		<li class="j-tool-tip-item s-bundle-details"><span>$9.99</span></li>
																	</ul>
																	<ul class="list-unstyled list-inline s-last">
																		<li class="col-xs-1 j-tool-tip-item s-bundle-details-add"><a class="btn s-btn-ten24"><i class="fa fa-plus"></i></a></li>
																	</ul>
																	<div class="clearfix"></div>
																</li>

															</ul>
														</div>
														<!-- //Selected filters -->

													</div>
												</div>
											</div>
											<!-- //Search for product -->

											<button class="btn btn-xs s-btn-ten24" style="display:block;margin-bottom:10px;"><i class="fa fa-plus"></i> Save & Add</button>
										</div>

									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<!--- //Edit Filter Box --->


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
