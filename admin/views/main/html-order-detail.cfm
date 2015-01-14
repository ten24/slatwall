<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<div class="row s-body-nav">
	<nav class="navbar navbar-default" role="navigation">
		<div class="col-md-4">
			<h1>ProgelTM Pleural Air Leak Sealant</h1>
		</div>
		<div class="col-md-8">
			<div class="btn-toolbar">

				<div class="btn-group btn-group-sm">
					<button type="button" class="btn btn-default"><i class="fa fa-reply"></i> Products</button>

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
					<span>Bundle Detail</span>
					<i class="fa fa-caret-left"></i>
				</h4>
			</div>
		</a>

		<div id="collapseOne" class="panel-collapse collapse">
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
		</div>
	</div>




	<div class="panel panel-default">
		<a data-toggle="collapse"  href="#collapseOne">
			<div class="panel-heading">
				<h4 class="panel-title">
					<span>Basic</span>
					<i class="fa fa-caret-left"></i>
				</h4>
			</div>
		</a>

		<div id="collapseOne" class="panel-collapse collapse">
			<div class="panel-body s-panel-header-info">

				<div class="col-md-6">
					<dl class="dl-horizontal">
						<dt class="title">Active <i class="fa fa-question-circle" ></i></dt>
						<dd class="value">Yes</dd>
						<dt class="title" >Published <i class="fa fa-question-circle" ></i></dt>
						<dd class="value">Yes</dd>
						<dt class="title" >Product Name <i class="fa fa-question-circle" ></i></dt>
						<dd class="value">ProgelTM Pleural Air Leak Sealant</dd>
						<dt class="title" >Product Code <i class="fa fa-question-circle" ></i></dt>
						<dd class="value">PGPS002</dd>
						<dt class="title" >URL Title <i class="fa fa-question-circle" ></i></dt>
						<dd class="value">progeltm-pleural-air-leak-sealant</dd>
					</dl>
				</div>
				<div class="col-md-6">
					<dl class="dl-horizontal">
						<dt class="title" >Brand <i class="fa fa-question-circle" ></i></dt>
						<dd class="value">Mozys</dd>
						<dt class="title" >Product Type <i class="fa fa-question-circle" ></i></dt>
						<dd class="value">Main Product</dd>
						<dt class="title" >Available To Sell <i class="fa fa-question-circle" ></i></dt>
						<dd class="value">1000</dd>
					</dl>
				</div>

			</div>
		</div>
	</div>

	<div class="panel panel-default">
		<a data-toggle="collapse"  href="#collapseTwo">
			<div class="panel-heading">
				<h4 class="panel-title">
					<span>Order Items <span>2</span></span>
					<i class="fa fa-caret-left"></i>
				</h4>
			</div>
		</a>

		<div id="collapseTwo" class="panel-collapse collapse in">
			<div class="panel-body">
				<div class="col-md-6" style="padding:0px;">

					<!--- //Tab panes for menu options end--->
					<div class="s-table-header-nav">
						<div class="col-xs-6">
							<ul class="list-inline list-unstyled">
								<li><h4>Example Title</h4></li>
							</ul>
						</div>
						<div class="col-xs-6 s-table-view-options">
							<ul class="list-inline list-unstyled">
								<li>
									<form class="s-table-header-search">
										<div class="input-group">
											<input type="text" class="form-control input-sm" placeholder="Search" name="srch-term" id="j-srch-term">
											<div class="input-group-btn">
												<button class="btn btn-default btn-sm" type="submit"><i class="fa fa-search"></i></button>
											</div>
										</div>
									</form>
								</li>
								<li>
									<div class="btn-group navbar-left">
										<button type="button" class="btn btn-sm btn-default"><i class="fa fa-plus"></i></button>
									</div>
								</li>
							</ul>

						</div>
					</div>

					<div class="table-responsive s-filter-table-box">
						<table class="table table-bordered table-striped">
							<thead>
								<tr>
									<th>Row</th>
									<th class="s-sortable">ID</th>
									<th class="s-sortable">Brand</th>
									<th class="s-sortable">Style</th>
									<th></th>
								</tr>
							</thead>
							<tbody>

								<!---TR 1--->
								<tr class="even-tr">
									<td><div class="s-checkbox"><input type="checkbox" id="j-checkbox"><label for="j-checkbox"></label></div></td>
									<td>2691402</td>
									<td>Ario</td>
									<td>Square Toe</td>
									<td class="s-edit-elements">
										<ul>
											<li><span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="View"><a href="##"><i class="fa fa-eye"></i></a></span></li>
											<li><span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="Edit"><a href="##"><i class="fa fa-pencil"></i></a></span></li>
										</ul>
									</td>
								</tr>

								<!---TR 2--->
								<tr class="even-tr">
									<td><div class="s-checkbox"><input type="checkbox" id="j-checkbox2"><label for="j-checkbox2"></label></div></td>
									<td>2691402</td>
									<td>Ario</td>
									<td>Square Toe</td>
									<td class="s-edit-elements">
										<ul>
											<li><span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="View"><a href="##"><i class="fa fa-eye"></i></a></span></li>
											<li><span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="Edit"><a href="##"><i class="fa fa-pencil"></i></a></span></li>
										</ul>
									</td>
								</tr>

								<!---TR 3--->
								<tr class="even-tr">
									<td><div class="s-checkbox"><input type="checkbox" id="j-checkbox3"><label for="j-checkbox3"></label></div></td>
									<td>2691402</td>
									<td>Ario</td>
									<td>Square Toe</td>
									<td class="s-edit-elements">
										<ul>
											<li><span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="View"><a href="##"><i class="fa fa-eye"></i></a></span></li>
											<li><span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="Edit"><a href="##"><i class="fa fa-pencil"></i></a></span></li>
										</ul>
									</td>
								</tr>

								<!---TR 4--->
								<tr class="even-tr">
									<td><div class="s-checkbox"><input type="checkbox" id="j-checkbox4"><label for="j-checkbox4"></label></div></td>
									<td>2691402</td>
									<td>Ario</td>
									<td>Square Toe</td>
									<td class="s-edit-elements">
										<ul>
											<li><span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="View"><a href="##"><i class="fa fa-eye"></i></a></span></li>
											<li><span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="Edit"><a href="##"><i class="fa fa-pencil"></i></a></span></li>
										</ul>
									</td>
								</tr>

								<!---TR 11--->
								<tr class="even-tr">
									<td><div class="s-checkbox"><input type="checkbox" id="j-checkbox11"><label for="j-checkbox11"></label></div></td>
									<td>2691402</td>
									<td>Ario</td>
									<td>Square Toe</td>
									<td class="s-edit-elements">
										<ul>
											<li><span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="View"><a href="##"><i class="fa fa-eye"></i></a></span></li>
											<li><span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="Edit"><a href="##"><i class="fa fa-pencil"></i></a></span></li>
										</ul>
									</td>
								</tr>

								<!---TR 12--->
								<tr class="even-tr">
									<td><div class="s-checkbox"><input type="checkbox" id="j-checkbox12"><label for="j-checkbox12"></label></div></td>
									<td>2691402</td>
									<td>Ario</td>
									<td>Square Toe</td>
									<td class="s-edit-elements">
										<ul>
											<li><span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="View"><a href="##"><i class="fa fa-eye"></i></a></span></li>
											<li><span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="Edit"><a href="##"><i class="fa fa-pencil"></i></a></span></li>
										</ul>
									</td>
								</tr>

								<!---TR 13--->
								<tr class="even-tr">
									<td><div class="s-checkbox"><input type="checkbox" id="j-checkbox13"><label for="j-checkbox13"></label></div></td>
									<td>2691402</td>
									<td>Ario</td>
									<td>Square Toe</td>
									<td class="s-edit-elements">
										<ul>
											<li><span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="View"><a href="##"><i class="fa fa-eye"></i></a></span></li>
											<li><span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="Edit"><a href="##"><i class="fa fa-pencil"></i></a></span></li>
										</ul>
									</td>
								</tr>

								<!---TR 14--->
								<tr class="even-tr">
									<td><div class="s-checkbox"><input type="checkbox" id="j-checkbox14"><label for="j-checkbox14"></label></div></td>
									<td>2691402</td>
									<td>Ario</td>
									<td>Square Toe</td>
									<td class="s-edit-elements">
										<ul>
											<li><span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="View"><a href="##"><i class="fa fa-eye"></i></a></span></li>
											<li><span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="Edit"><a href="##"><i class="fa fa-pencil"></i></a></span></li>
										</ul>
									</td>
								</tr>
							</tbody>
						</table>
					</div>

				</div>
				<div class="col-md-6" style="padding-right:0px;">



				</div>
			</div>
		</div>
	</div>

	<div class="panel panel-default">
		<a data-toggle="collapse"  href="#collapseImages">
			<div class="panel-heading">
				<h4 class="panel-title">
					<span>Images</span>
					<i class="fa fa-caret-left"></i>
				</h4>
			</div>
		</a>
		<div id="collapseImages" class="panel-collapse collapse">
			<div class="panel-body">
				<div class="col-xs-12 s-filter-content">

					<!--- Header nav with title starts --->
					<div class="row s-header-bar">
						<div class="col-md-12 s-header-nav">
							<ul class="nav nav-tabs" role="tablist">
								<li class="active"><a href="##j-default-images" role="tab" data-toggle="tab">Default Images</a></li>
								<li><a href="##j-alternative" role="tab" data-toggle="tab">Alternative Images</a></li>
							</ul>
						</div>
					</div>
					<!--- //Header nav with title end --->

					<!--- Tab panes for menu options start--->
					<div class="row s-options">
						<div class="tab-content" id="j-property-box">

							<div class="tab-pane active" id="j-default-images">
								<img src="http://placehold.it/280x320" alt="" />
								<img src="http://placehold.it/280x320" alt="" />
							</div>

							<div class="tab-pane" id="j-alternative">
								<img src="http://placehold.it/280x320" alt="" />
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="panel panel-default">
		<a data-toggle="collapse"  href="#collapseFour">
			<div class="panel-heading">
				<h4 class="panel-title">
					<span>Venders</span>
					<i class="fa fa-caret-left"></i>
				</h4>
			</div>
		</a>
		<div id="collapseFour" class="panel-collapse collapse">
			<div class="panel-body">
				Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. 3 wolf moon officia aute, non cupidatat skateboard dolor brunch. Food truck quinoa nesciunt laborum eiusmod. Brunch 3 wolf moon tempor, sunt aliqua put a bird on it squid single-origin coffee nulla assumenda shoreditch et. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident. Ad vegan excepteur butcher vice lomo. Leggings occaecat craft beer farm-to-table, raw denim aesthetic synth nesciunt you probably haven't heard of them accusamus labore sustainable VHS.
			</div>
		</div>
	</div>
	<div class="panel panel-default">
		<a data-toggle="collapse"  href="#collapseBest">
			<div class="panel-heading">
				<h4 class="panel-title">
					<span>Best Selling Mens T-Shirts <span>4</span></span>
					<i class="fa fa-caret-left"></i>
				</h4>
			</div>
		</a>

		<div id="collapseBest" class="panel-collapse collapse">
			<div class="panel-body">

				<div class="col-xs-12 s-filter-content">

					<!--- Header nav with title starts --->
					<div class="row s-header-bar">
						<div class="col-md-12 s-header-nav">
							<ul class="nav nav-tabs" role="tablist">
								<li class="active"><a href="##j-properties" role="tab" data-toggle="tab">PROPERTIES</a></li>
								<li><a href="##j-filters" role="tab" data-toggle="tab">FILTERS <span>(6)</span></a></li>
								<li><a href="##j-display-options" role="tab" data-toggle="tab">DISPLAY OPTIONS</a></li>
							</ul>
						</div>
					</div>
					<!--- //Header nav with title end --->

					<!--- Tab panes for menu options start--->
					<div class="row s-options">
						<div class="tab-content" id="j-property-box">

							<div class="tab-pane active" id="j-properties">
								<!--- <span class="s-edit-btn-group">
									<button class="btn btn-xs s-btn-ten24" id="j-save-btn" style="display:none;"><i class="fa fa-floppy-o"></i> Save</button>
									<button class="btn btn-xs s-btn-dgrey" id="j-edit-btn"><i class="fa fa-pencil"></i> Edit</button>
								</span> --->
								<form class="row form-horizontal s-properties" role="form">
									<div class="col-sm-6">
										<div class="form-group">
											<label class="col-sm-3 control-label">Title:<span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="The collection title"> <i class="fa fa-question-circle"></i></span></label>

											<div class="col-sm-9">
												<input style="display:none" type="text" class="form-control" id="inputPassword" value="Best Selling Mens & Womens Boots From July 2014">
												<p class="form-control-static">Best Selling Mens & Womens Boots From July 2014</p>
											</div>
										</div>
										<div class="form-group">
											<label for="inputPassword" class="col-sm-3 control-label">Code: <span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="The collection code"> <i class="fa fa-question-circle"></i></span></label>
											<div class="col-sm-9">
												<input style="display:none" type="text" class="form-control" id="inputPassword" value="876567">
												<p class="form-control-static">876567</p>
											</div>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="form-group">
											<label for="inputPassword" class="col-sm-3 control-label">Description: <span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="The collection description"> <i class="fa fa-question-circle"></i></span></label>
											<div class="col-sm-9">
												<input style="display:none" type="text" class="form-control" id="inputPassword" value="A selection for the best selling mens and womens boots from the month of july 2014. These will be used to display on the product listing pages for b15 marketing strategy plan.">
												<p class="form-control-static">A selection for the best selling mens boots.</p>
											</div>
										</div>
										<div class="form-group">
											<label for="inputPassword" class="col-sm-3 control-label">Collection Type: <span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="The collection type"> <i class="fa fa-question-circle"></i></span></label>
											<div class="col-sm-9">
												<input style="display:none" type="text" class="form-control" id="inputPassword" value="Type">
												<p class="form-control-static">Type</p>
											</div>
										</div>
									</div>
								</form>

							</div>

							<div class="tab-pane" id="j-filters">
								<div class="s-setting-options">
									<div class="row s-setting-options-body">

										<!--- Start Filter Group --->
										<div class="col-xs-12 s-filters-selected">
											<div class="row">
												<ul class="col-xs-12 list-unstyled">

													<li >

														<!--- Filter display --->
														<div class="s-filter-item">
															<div class="panel panel-default">
																<div class="panel-heading">Gender <a href="##" class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="" data-original-title="Remove"><i class="fa fa-times"></i></a></div>
																<div data-toggle="collapse" data-target="#j-edit-filter-1" class="panel-body j-tool-tip-item" data-toggle="tooltip" data-placement="bottom" title="Click To Edit">
																	Male <a href="##"><i class="fa fa-pencil-square-o"></i></a>
																</div>
															</div>
															<div class="btn-group-vertical">
																<button class="btn btn-xs btn-default">OR</button>
																<button class="btn btn-xs btn-default active">AND</button>

															</div>
														</div>
														<!--- //Filter display --->

														<!--- Edit Filter Box --->
														<div class="col-xs-12 collapse s-add-filter" id="j-edit-filter-1">
															<div class="row">
																<h4> Define Filters: <span>Orders</span><i class="fa fa-times" data-toggle="collapse" data-target="#j-edit-filter-1"></i></h4>
																<div class="col-xs-12">

																	<div class="row">
																		<div class="col-xs-2">
																			<div class="form-group form-group-sm">
																				<label class="col-sm-12 control-label s-no-paddings" for="formGroupInputSmall">Select From Orders</label>
																				<div class="col-sm-12 s-no-paddings">
																					<select class="form-control input-sm">
																						<option disabled="disabled" selected="selected">Select From Orders</option>
																						<option value="one">One</option>
																						<option value="two">Two</option>
																						<option value="three">Three</option>
																						<option value="four">Four</option>
																						<option value="five">Five</option>
																					</select>
																				</div>
																				<div class="clearfix"></div>
																			</div>
																		</div>
																		<div class="col-xs-6 s-criteria">

																			<h4>Criteria</h4>

																			<!--- Filter Criteria Start --->
																			<form action="index.html" method="post">
																				<div class="s-filter-group-item">

																					<div class="alert alert-warning" role="alert">Select field or dataset to begin</div>

																				</div>
																			</form>
																			<!--- //Filter Criteria End --->

																			<br/><br/><br/>


																			<h4>Criteria</h4>

																			<!--- Filter Criteria Start --->
																			<form action="index.html" method="post">
																				<div class="s-filter-group-item">
																					<span>
																						<button class="btn btn-xs s-btn-ten24" style="display:none;"> <button class="btn btn-xs s-btn-dgrey" id="j-edit-btn"><i class="fa fa-times"></i> Remove</button>
																					</span>
																					<div class="form-group form-group-sm">
																						<label class="col-sm-12 control-label s-no-paddings" for="formGroupInputSmall">Date Conditions:</label>
																						<div class="col-sm-12 s-no-paddings">
																							<select class="form-control input-sm">
																								<option>1 week</option>
																								<option>2 week</option>
																								<option>3 week</option>
																								<option>4 week</option>
																								<option>5 week</option>
																							</select>
																						</div>
																						<div class="clearfix"></div>
																					</div>
																					<div class="form-group form-group-sm">
																						<label class="col-sm-12 control-label s-no-paddings" for="formGroupInputSmall">Number of Weeks Ago:</label>
																						<div class="col-sm-12 s-no-paddings">
																							<input type="text" class="form-control" id="input" placeholder="12">
																						</div>
																						<div class="clearfix"></div>
																					</div>
																				</div>
																				<div>
																					<div class="btn-group btn-toggle">
																						<button class="btn btn-xs btn-default">AND</button>
																						<button class="btn btn-xs btn-defualt active">OR</button>
																					</div>
																				</div>
																				<div class="s-filter-group-item">
																					<span>
																						<button class="btn btn-xs s-btn-ten24" style="display:none;"> <button class="btn btn-xs s-btn-dgrey" id="j-edit-btn"><i class="fa fa-times"></i> Remove</button>
																					</span>
																					<div class="form-group form-group-sm">
																						<label class="col-sm-12 control-label s-no-paddings" for="formGroupInputSmall">Date Conditions:</label>
																						<div class="col-sm-12 s-no-paddings">
																							<select class="form-control input-sm">
																								<option>1 week</option>
																								<option>2 week</option>
																								<option>3 week</option>
																								<option>4 week</option>
																								<option>5 week</option>
																							</select>
																						</div>
																						<div class="clearfix"></div>
																					</div>
																					<div class="form-group form-group-sm">
																						<label class="col-sm-12 control-label s-no-paddings" for="formGroupInputSmall">Number of Weeks Ago:</label>
																						<div class="col-sm-12 s-no-paddings">
																							<input type="text" class="form-control" id="input" placeholder="12">
																						</div>
																						<div class="clearfix"></div>
																					</div>
																				</div>
																			</form>
																			<!--- //Filter Criteria End --->

																			<br/><br/><br/>

																			<h4>Options</h4>

																			<!--- Filter Criteria Start --->
																			<form action="index.html" method="post">
																				<div class="s-filter-group-item">

																					<div class="s-options-group">
																						<div class="radio">
																							<input class="s-account-field-radio" type="radio" name="radio1" id="radio1" value="option1" checked>
																							<label for="radio1">
																									Use account field:
																							</label>
																							<div class="col-sm-12 s-no-paddings s-account-field-select">
																								<select class="form-control input-sm">
																									<option disabled="disabled" selected="selected"> Select From Account </option>
																									<option>First Name</option>
																									<option>Last Name</option>
																									<option>Company</option>
																									<option disabled="disabled">---</option>
																									<option>Primary E-Mail Address</option>
																									<option disabled="disabled">---</option>
																									<option>Addresses</option>
																								</select>
																							</div>
																							<div class="clearfix"></div>
																						</div>
																						<div class="radio">
																							<input type="radio" name="radio1" id="radio2" value="option2">
																							<label for="radio2">
																									Has account
																							</label>
																						</div>
																						<div class="radio">
																							<input type="radio" name="radio1" id="radio3" value="option3">
																							<label for="radio3">
																									Doesn't Has account
																							</label>
																						</div>
																					</div>

																				</div>
																			</form>
																			<!--- //Filter Criteria End --->

																			<br/><br/><br/>


																			<h4>Criteria</h4>

																			<!--- Filter Criteria Start --->
																			<form action="index.html" method="post">
																				<div class="s-filter-group-item">
																					<span>
																						<button class="btn btn-xs s-btn-ten24"> <button class="btn btn-xs s-btn-dgrey" id="j-edit-btn"><i class="fa fa-times"></i> Remove</button>
																					</span>
																					<div class="form-group form-group-sm">
																						<label class="col-sm-12 control-label s-no-paddings" for="formGroupInputSmall">Criteria Name:</label>
																						<div class="col-sm-12 s-no-paddings">
																							<input type="text" class="form-control" id="input" placeholder="12">
																						</div>
																						<div class="clearfix"></div>
																					</div>
																					<div class="form-group form-group-sm">
																						<label class="col-sm-12 control-label s-no-paddings" for="formGroupInputSmall">Condition:</label>
																						<div class="col-sm-12 s-no-paddings">
																							<select class="form-control input-sm">
																								<option value="-- Condition">- Condition --</option>
																								<option value="Equals">Equals</option>
																								<option value="Does Not Equal">Does Not Equal</option>
																								<option selected="selected" value="Contains">Contains</option>
																								<option value="Does Not Contain">Does Not Contain</option>
																								<option value="Starts With">Starts With</option>
																								<option value="Ends With">Ends With</option>
																								<option value="Like">Like</option>
																								<option value="Not Lke">Not Lke</option>
																								<option value="In">In</option>
																								<option value="Not In">Not In</option>
																							</select>
																						</div>
																						<div class="clearfix"></div>
																					</div>
																					<div class="form-group form-group-sm">
																						<label class="col-sm-12 control-label s-no-paddings" for="formGroupInputSmall">Criteria Value:</label>
																						<div class="col-sm-12 s-no-paddings">
																							<input type="text" class="form-control" id="input" placeholder="12">
																						</div>
																						<div class="clearfix"></div>
																					</div>
																				</div>
																				<div>
																					<div>
																						<button class="btn btn-xs btn-default">AND</button>
																						<button class="btn btn-xs btn-defualt active">OR</button>
																					</div>
																				</div>
																				<div>
																					<span>
																						<button class="btn btn-xs s-btn-ten24" style="display:none;"> <button class="btn btn-xs s-btn-dgrey" id="j-edit-btn"><i class="fa fa-times"></i> Remove</button>
																					</span>
																					<div class="form-group form-group-sm">
																						<label class="col-sm-12 control-label s-no-paddings" for="formGroupInputSmall">Criteria Name:</label>
																						<div class="col-sm-12 s-no-paddings">
																							<input type="text" class="form-control" id="input" placeholder="12">
																						</div>
																						<div class="clearfix"></div>
																					</div>
																					<div class="form-group form-group-sm">
																						<label class="col-sm-12 control-label s-no-paddings" for="formGroupInputSmall">Condition:</label>
																						<div class="col-sm-12 s-no-paddings">
																							<select class="form-control input-sm">
																								<option value="-- Condition">- Condition --</option>
																								<option selected="selected" value="Equals">Equals</option>
																								<option value="Does Not Equal">Does Not Equal</option>
																								<option value="Contains">Contains</option>
																								<option value="Does Not Contain">Does Not Contain</option>
																								<option value="Starts With">Starts With</option>
																								<option value="Ends With">Ends With</option>
																								<option value="Like">Like</option>
																								<option value="Not Lke">Not Lke</option>
																								<option value="In">In</option>
																								<option value="Not In">Not In</option>
																							</select>
																						</div>
																						<div class="clearfix"></div>
																					</div>
																					<div class="form-group form-group-sm">
																						<label class="col-sm-12 control-label s-no-paddings" for="formGroupInputSmall">Criteria Value:</label>
																						<div class="col-sm-12 s-no-paddings">
																							<input type="text" class="form-control" id="input" placeholder="12">
																						</div>
																						<div class="clearfix"></div>
																					</div>
																				</div>

																				<button class="btn btn-xs s-btn-ten24" data-toggle="collapse" data-target="#j-add-row-6">Add Display Field</button>
																				<div class="collapse" id="j-add-row-6">
																					<div class="s-filter-group-item">
																						<div class="form-group form-group-sm">
																							<label class="col-sm-12 control-label s-no-paddings" for="formGroupInputSmall">Criteria Name:</label>
																							<div class="col-sm-12 s-no-paddings">
																								<input type="text" class="form-control" id="input" placeholder="12">
																							</div>
																							<div class="clearfix"></div>
																						</div>
																						<div class="form-group form-group-sm">
																							<label class="col-sm-12 control-label s-no-paddings" for="formGroupInputSmall">Condition:</label>
																							<div class="col-sm-12 s-no-paddings">
																								<select class="form-control input-sm">
																									<option value="-- Condition">- Condition --</option>
																									<option value="Equals">Equals</option>
																									<option value="Does Not Equal">Does Not Equal</option>
																									<option selected="selected" value="Contains">Contains</option>
																									<option value="Does Not Contain">Does Not Contain</option>
																									<option value="Starts With">Starts With</option>
																									<option value="Ends With">Ends With</option>
																									<option value="Like">Like</option>
																									<option value="Not Lke">Not Lke</option>
																									<option value="In">In</option>
																									<option value="Not In">Not In</option>
																								</select>
																							</div>
																							<div class="clearfix"></div>
																						</div>
																						<div class="form-group form-group-sm">
																							<label class="col-sm-12 control-label s-no-paddings" for="formGroupInputSmall">Criteria Value:</label>
																							<div class="col-sm-12 s-no-paddings">
																								<input type="text" class="form-control" id="input" placeholder="12">
																							</div>
																							<div class="clearfix"></div>
																						</div>
																						<button name="button" class="btn s-btn-ten24 btn-xs"><i class="fa fa-plus"></i> Column</button>
																						<button class="btn btn-danger btn-xs"><i class="fa fa-times"></i> Remove</button>
																					</div>
																				</div>

																			</form>
																			<!--- //Filter Criteria End --->

																			<br/><br/><br/>

																			<h4>Criteria</h4>

																			<!--- Filter Criteria Start --->
																			<form action="index.html" method="post">
																				<div class="s-filter-group-item">

																					<!-- Define Filter List group -->
																					<ul class="list-group s-define-filter-group">

																						<!-- //Filter item -->
																						<li class="s-define-filter-item">
																							<span class="s-define-filter-number">1</span>
																							<span class="s-define-filter-title">
																								<span class="s-define-filter-title-edit"><input type="text" value="T-Shirt"><button class="btn btn-xs s-btn-ten24 s-save-btn">Save</button></span>
																								<a href="#" class="j-tool-tip-item" data-toggle="tooltip" data-placement="bottom" data-original-title="Edit">T-Shirts</a>

																							</span>
																							<span>
																								<select class="form-control input-sm">

																									<option value="-- Condition">- Condition --</option>
																									<option value="Equals">Equals</option>
																									<option value="Does Not Equal">Does Not Equal</option>
																									<option selected="selected" value="Contains">Contains</option>
																									<option value="Does Not Contain">Does Not Contain</option>
																									<option value="Starts With">Starts With</option>
																									<option value="Ends With">Ends With</option>
																									<option value="Like">Like</option>
																									<option value="Not Lke">Not Lke</option>
																									<option value="In">In</option>
																									<option value="Not In">Not In</option>

																								</select>
																							</span>
																							<span class="s-define-filter-compare">
																								<span class="s-define-filter-compare-edit"><input type="text" value="Coolness Shirt"><button class="btn btn-xs s-btn-ten24 s-save-btn">Save</button></span>
																								<a href="#" class="j-tool-tip-item" data-toggle="tooltip" data-placement="bottom" data-original-title="Edit">Coolness Shirt</a>
																							</span>
																							<span class="s-define-filter-remove"><a class="btn btn-default s-remove j-tool-tip-item" data-toggle="tooltip" data-placement="bottom" data-original-title="Remove"><i class="fa fa-times"></i></a></span>
																						</li>
																						<!-- //Filter item -->

																						<!-- //Filter item -->
																						<li class="s-define-filter-item">
																							<span class="s-define-filter-number">2</span>
																							<span class="s-define-filter-title">
																								<span class="s-define-filter-title-edit"><input type="text" value="T-Shirt"><button class="btn btn-xs s-btn-ten24 s-save-btn">Save</button></span>
																								<a href="#" class="j-tool-tip-item" data-toggle="tooltip" data-placement="bottom" data-original-title="Edit">T-Shirts</a>

																							</span>
																							<span>
																								<select class="form-control input-sm">

																									<option value="-- Condition">- Condition --</option>
																									<option value="Equals">Equals</option>
																									<option value="Does Not Equal">Does Not Equal</option>
																									<option value="Contains">Contains</option>
																									<option value="Does Not Contain">Does Not Contain</option>
																									<option selected="selected" value="Starts With">Starts With</option>
																									<option value="Ends With">Ends With</option>
																									<option value="Like">Like</option>
																									<option value="Not Lke">Not Lke</option>
																									<option value="In">In</option>
																									<option value="Not In">Not In</option>

																								</select>
																							</span>
																							<span class="s-define-filter-compare">
																								<span class="s-define-filter-compare-edit"><input type="text" value="Coolness Shirt"><button class="btn btn-xs s-btn-ten24 s-save-btn">Save</button></span>
																								<a href="#" class="j-tool-tip-item" data-toggle="tooltip" data-placement="bottom" data-original-title="Edit">Happy</a>
																							</span>
																							<span class="s-define-filter-remove"><a class="btn btn-default s-remove j-tool-tip-item" data-toggle="tooltip" data-placement="bottom" data-original-title="Remove"><i class="fa fa-times"></i></a></span>
																						</li>
																						<!-- //Filter item -->

																						<!-- //Filter item -->
																						<li class="s-define-filter-item">
																							<span class="s-define-filter-number">3</span>
																							<span class="s-define-filter-title">
																								<span class="s-define-filter-title-edit"><input type="text" value="T-Shirt"><button class="btn btn-xs s-btn-ten24 s-save-btn">Save</button></span>
																								<a href="#" class="j-tool-tip-item" data-toggle="tooltip" data-placement="bottom" data-original-title="Edit">T-Shirts</a>

																							</span>
																							<span>
																								<select class="form-control input-sm">
																									<option value="-- Condition">- Condition --</option>
																									<option selected="selected" value="Equals">Equals</option>
																									<option value="Does Not Equal">Does Not Equal</option>
																									<option value="Contains">Contains</option>
																									<option value="Does Not Contain">Does Not Contain</option>
																									<option value="Starts With">Starts With</option>
																									<option value="Ends With">Ends With</option>
																									<option value="Like">Like</option>
																									<option value="Not Lke">Not Lke</option>
																									<option value="In">In</option>
																									<option value="Not In">Not In</option>
																								</select>
																							</span>
																							<span class="s-define-filter-compare">
																								<span class="s-define-filter-compare-edit"><input type="text" value="Coolness Shirt"><button class="btn btn-xs s-btn-ten24 s-save-btn">Save</button></span>
																								<a href="#" class="j-tool-tip-item" data-toggle="tooltip" data-placement="bottom" data-original-title="Edit">Simple</a>
																							</span>
																							<span class="s-define-filter-remove"><a class="btn btn-default s-remove j-tool-tip-item" data-toggle="tooltip" data-placement="bottom" data-original-title="Remove"><i class="fa fa-times"></i></a></span>
																						</li>
																						<!-- //Filter item -->
																					</ul>

																					<!--- Message if no items --->
																					<div class="s-none-selected" style="display:none;">There are no fields selected</div>

																					<!--- Button to show create option --->
																					<button class="btn btn-xs s-btn-ten24" data-toggle="collapse" data-target="#j-add-row">Add Display Field</button>

																					<!--- Create option dropdown --->
																					<div class="row s-add-display-field collapse" id="j-add-row">
																						<div class="col-xs-12">
																							<form role="form">
																								<div class="form-group">
																									<label for="exampleInputEmail2">Criteria Name</label>
																									<input type="text" class="form-control">
																								</div>
																								<div class="form-group">
																									<label for="">Criteria</label>
																									<select class="form-control input-sm">
																										<option value="-- Condition">- Condition --</option>
																										<option selected="selected" value="Equals">Equals</option>
																										<option value="Does Not Equal">Does Not Equal</option>
																										<option value="Contains">Contains</option>
																										<option value="Does Not Contain">Does Not Contain</option>
																										<option value="Starts With">Starts With</option>
																										<option value="Ends With">Ends With</option>
																										<option value="Like">Like</option>
																										<option value="Not Lke">Not Lke</option>
																										<option value="In">In</option>
																										<option value="Not In">Not In</option>
																									</select>
																								</div>
																								<div class="form-group">
																									<label for="">Criteria Value</label>
																									<input type="text" class="form-control">
																								</div>
																								<button name="button" class="btn s-btn-ten24 btn-xs"><i class="fa fa-plus"></i> Column</button>
																								<button class="btn btn-danger btn-xs"><i class="fa fa-times"></i> Remove</button>
																							</form>
																						</div>
																					</div>
																				</div>
																			</form>
																			<!--- //Filter Criteria End --->

																		</div>
																		<div class="col-xs-3">
																			<div class="s-button-select-group">
																				<button type="button" class="btn btn-sm s-btn-ten24">Save & Add Another Button</button>
																				<div class="s-or-box">OR-</div>
																				<button type="button" class="btn btn-sm s-btn-ten24">Save & Finish</button>
																			</div>
																			<div class="form-group">
																				<div class="s-checkbox"><input type="checkbox" id="j-checkbox21"><label for="j-checkbox21"> Add To New Group</label></div>
																			</div>
																		</div>
																	</div>
																</div>
															</div>
														</div>
														<!--- //Edit Filter Box --->

													</li>

													<li class="s-filter-group" >

														<!--- Filter display --->
														<div class="s-filter-item">
															<div class="panel panel-default s-filter-group-style">
																<div class="panel-heading">Filter Group 1 <a href="##" class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="" data-original-title="Remove"><i class="fa fa-times"></i></a></div>
																<div data-toggle="collapse" data-target="#j-nested-filter-1" class="panel-body j-tool-tip-item" data-toggle="tooltip" data-placement="bottom" title="Click To Edit">
																	(3) Filters <a href="##"><i class="fa fa-inbox"></i></a>
																</div>
															</div>

														</div>
														<!--- //Filter display --->

														<!---Nested Filter Box --->
														<div class="col-xs-12 collapse" id="j-nested-filter-1">
															<div class="row">
																<ul class="col-xs-12 list-unstyled s-no-paddings">

																	<!--- Filter display --->
																	<li >

																		<!--- Nested Filter Display --->
																		<div class="s-filter-item">
																			<div class="panel panel-default">
																				<div class="panel-heading">Gender <a href="##" class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="" data-original-title="Remove"><i class="fa fa-times"></i></a></div>
																				<div data-toggle="collapse" data-target="#j-edit-filter-1-1" class="panel-body j-tool-tip-item" data-toggle="tooltip" data-placement="bottom" title="Click To Edit">
																					Male 2 <a href="##"><i class="fa fa-pencil-square-o"></i></a>
																				</div>
																			</div>
																			<div class="btn-group-vertical btn-toggle">
																				<button class="btn btn-xs btn-default">AND</button>
																				<button class="btn btn-xs btn-defualt active">OR</button>
																			</div>
																		</div>
																		<!--- //Nested Filter Display --->

																		<!--- Edit Filter Box --->
																		<div class="col-xs-12 collapse s-add-filter" id="j-edit-filter-1-1">
																			<div class="row">
																				<div class="col-xs-12">
																					<h4> Define Filters: <span>Orders</span><i class="fa fa-times" data-toggle="collapse" data-target="#j-add-filter3"></i></h4>
																					<div class="row">
																						<div class="col-xs-4">
																							Select From Orders
																							<div class="option-dropdown">
																								<select class="form-control input-sm">
																									<option disabled="disabled" selected="selected">Select From Orders </option>
																									<option value="one">One</option>
																									<option value="two">Two</option>
																									<option value="three">Three</option>
																									<option value="four">Four</option>
																									<option value="five">Five</option>
																								</select>
																							</div>
																						</div>
																						<div class="col-xs-4 s-criteria">
																							<h4>Criteria</h4>

																							<!--- Filter Criteria Start --->
																							<form action="index.html" method="post">
																								<div class="s-filter-group-item">

																									<div class="form-group form-group-sm">
																										<label class="col-sm-12 control-label s-no-paddings" for="formGroupInputSmall">Date Conditions:</label>
																										<div class="col-sm-12 s-no-paddings">
																											<select class="form-control input-sm">
																												<option>1 week</option>
																												<option>2 week</option>
																												<option>3 week</option>
																												<option>4 week</option>
																												<option>5 week</option>
																											</select>
																										</div>
																										<div class="clearfix"></div>
																									</div>
																									<div class="form-group form-group-sm">
																										<label class="col-sm-12 control-label s-no-paddings" for="formGroupInputSmall">Number of Weeks Ago:</label>
																										<div class="col-sm-12 s-no-paddings">
																											<input type="text" class="form-control" id="input" placeholder="12">
																										</div>
																										<div class="clearfix"></div>
																									</div>
																								</div>
																							</form>
																							<!--- //Filter Criteria End --->

																						</div>
																						<div class="col-xs-4">
																							<div class="s-button-select-group">
																								<button type="button" class="btn s-btn-ten24">Save & Add Another Button</button>
																								<div class="s-or-box">OR</div>
																								<button type="button" class="btn s-btn-ten24">Save & Finish</button>
																							</div>
																							<div class="form-group">
																								<div class="s-checkbox"><input type="checkbox" id="j-checkbox31"><label for="j-checkbox31"> Add To New Group</label></div>
																							</div>
																						</div>
																					</div>
																				</div>
																			</div>
																		</div>
																		<!--- //Edit Filter Box --->

																	</li>
																	<!--- //Filter display --->

																	<!--- Filter display --->
																	<li >

																		<!--- Nested Filter Display --->
																		<div class="s-filter-item">
																			<div class="panel panel-default s-filter-group-style">
																				<div class="panel-heading">Filter Group 2 <a href="##" class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="" data-original-title="Remove"><i class="fa fa-times"></i></a></div>
																				<div data-toggle="collapse" data-target="#j-nested-filter-1-1-1" class="panel-body j-tool-tip-item" data-toggle="tooltip" data-placement="bottom" title="Click To Edit">
																					(3) Filters <a href="##"><i class="fa fa-inbox"></i></a>
																				</div>
																			</div>

																		</div>
																		<!--- //Nested Filter Display --->

																		<!---Nested Filter Box --->
																		<div class="col-xs-12 collapse" id="j-nested-filter-1-1-1">
																			<div class="row">
																				<ul class="col-xs-12 list-unstyled s-no-paddings">

																					<!--- Filter display --->
																					<li >

																						<!--- Nested Filter Display --->
																						<div class="s-filter-item">
																							<div class="panel panel-default">
																								<div class="panel-heading">Gender <a href="##" class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="" data-original-title="Remove"><i class="fa fa-times"></i></a></div>
																								<div data-toggle="collapse" data-target="#j-edit-filter-1-1-1" class="panel-body j-tool-tip-item" data-toggle="tooltip" data-placement="bottom" title="Click To Edit">
																									Male 3 <a href="##"><i class="fa fa-pencil-square-o"></i></a>
																								</div>
																							</div>

																						</div>
																						<!--- //Nested Filter Display --->

																						<!--- Edit Filter Box --->
																						<div class="col-xs-12 collapse s-add-filter" id="j-edit-filter-1-1-1">
																							<div class="row">
																								<div class="col-xs-12">
																									<h4> Define Filter: <span>Orders</span><i class="fa fa-times" data-toggle="collapse" data-target="#j-add-filter3"></i></h4>
																									<div class="row">
																										<div class="col-xs-4">
																											Select From Orders
																											<div class="option-dropdown">
																												<select class="form-control input-sm">
																													<option disabled="disabled" selected="selected">Select From Orders </option>
																													<option value="one">One</option>
																													<option value="two">Two</option>
																													<option value="three">Three</option>
																													<option value="four">Four</option>
																													<option value="five">Five</option>
																												</select>
																											</div>
																										</div>
																										<div class="col-xs-4 s-criteria">
																											<h4>Criteria</h4>

																											<!--- Filter Criteria Start --->
																											<form action="index.html" method="post">
																												<div class="s-filter-group-item">

																													<div class="form-group form-group-sm">
																														<label class="col-sm-12 control-label s-no-paddings" for="formGroupInputSmall">Date Conditions:</label>
																														<div class="col-sm-12 s-no-paddings">
																															<select class="form-control input-sm">
																																<option>1 week</option>
																																<option>2 week</option>
																																<option>3 week</option>
																																<option>4 week</option>
																																<option>5 week</option>
																															</select>
																														</div>
																														<div class="clearfix"></div>
																													</div>
																													<div class="form-group form-group-sm">
																														<label class="col-sm-12 control-label s-no-paddings" for="formGroupInputSmall">Number of Weeks Ago:</label>
																														<div class="col-sm-12 s-no-paddings">
																															<input type="text" class="form-control" id="input" placeholder="12">
																														</div>
																														<div class="clearfix"></div>
																													</div>
																												</div>
																											</form>
																											<!--- //Filter Criteria End --->

																										</div>
																										<div class="col-xs-4">
																											<div class="s-button-select-group">
																												<button type="button" class="btn s-btn-ten24">Save & Add Another Button</button>
																												<div class="s-or-box">OR</div>
																												<button type="button" class="btn s-btn-ten24">Save & Finish</button>
																											</div>
																											<div class="form-group">
																												<div class="s-checkbox"><input type="checkbox" id="j-checkbox41"><label for="j-checkbox41"> Add To New Group</label></div>
																											</div>
																										</div>
																									</div>
																								</div>
																							</div>
																						</div>
																						<!--- //Edit Filter Box --->

																					</li>
																					<!--- //Filter display --->

																					<li class="s-new-filter">
																						<!--- New Filter Panel Buttons --->
																						<div class="s-filter-item">
																							<button type="button" class="btn btn-xs btn-default" data-toggle="collapse" data-target="#j-add-filter"><i class="fa fa-plus"></i> Filter</button>
																							<button type="button" class="btn btn-xs btn-default" data-toggle="collapse" data-target="#j-add-filter-group"><i class="fa fa-plus"></i> Filter Group</button>
																						</div>
																						<!--- //New Filter Panel Buttons --->
																					</li>

																				</ul>
																			</div>
																		</div>
																		<!---//Nested Filter Box --->

																	</li>
																	<!--- //Filter display --->

																	<li class="s-new-filter">
																		<!--- New Filter Panel Buttons --->
																		<div class="s-filter-item">
																			<button type="button" class="btn btn-xs btn-default" data-toggle="collapse" data-target="#j-add-filter"><i class="fa fa-plus"></i> Filter</button>
																			<button type="button" class="btn btn-xs btn-default" data-toggle="collapse" data-target="#j-add-filter-group"><i class="fa fa-plus"></i> Filter Group</button>
																		</div>
																		<!--- //New Filter Panel Buttons --->
																	</li>

																</ul>
															</div>
														</div>
														<!---//Nested Filter Box --->

													</li>

													<li class="s-new-filter">
														<!--- New Filter Panel Buttons --->
														<div class="s-filter-item">
															<button type="button" class="btn btn-xs btn-default" data-toggle="collapse" data-target="#j-add-filter"><i class="fa fa-plus"></i> Filter</button>
															<button type="button" class="btn btn-xs btn-default" data-toggle="collapse" data-target="#j-add-filter-group"><i class="fa fa-plus"></i> Filter Group</button>
														</div>
														<!--- //New Filter Panel Buttons --->
													</li>

												</ul>
											</div>

											<!--- New Filter Panel --->
											<div class="s-add-filter-box">
												<div class="row s-add-filter">
													<div class="col-xs-12 collapse j-add-filter" id="j-add-filter-group">
														<div class="row">
															<div class="col-xs-12">
																<h4> Define Filter: <span>Orders</span><i class="fa fa-times" data-toggle="collapse" data-target="#j-add-filter-group"></i></h4>
																<div class="row">
																	<div class="col-xs-4">
																		Select From Orders
																		<div class="option-dropdown">
																			<select class="form-control input-sm">
																				<option disabled="disabled" selected="selected">Select From Orders </option>
																				<option value="one">One</option>
																				<option value="two">Two</option>
																				<option value="three">Three</option>
																				<option value="four">Four</option>
																				<option value="five">Five</option>
																			</select>
																		</div>
																	</div>
																	<div class="col-xs-4 s-criteria">
																		<h4>Criteria</h4>

																		<!--- Filter Criteria Start --->
																		<form action="index.html" method="post">
																			<div class="s-filter-group-item">

																				<div class="form-group form-group-sm">
																					<label class="col-sm-12 control-label s-no-paddings" for="formGroupInputSmall">Date Conditions:</label>
																					<div class="col-sm-12 s-no-paddings">
																						<select class="form-control input-sm">
																							<option>1 week</option>
																							<option>2 week</option>
																							<option>3 week</option>
																							<option>4 week</option>
																							<option>5 week</option>
																						</select>
																					</div>
																					<div class="clearfix"></div>
																				</div>
																				<div class="form-group form-group-sm">
																					<label class="col-sm-12 control-label s-no-paddings" for="formGroupInputSmall">Number of Weeks Ago:</label>
																					<div class="col-sm-12 s-no-paddings">
																						<input type="text" class="form-control" id="input" placeholder="12">
																					</div>
																					<div class="clearfix"></div>
																				</div>
																			</div>
																		</form>
																		<!--- //Filter Criteria End --->

																	</div>
																	<div class="col-xs-4">
																		<div class="s-button-select-group">
																			<button type="button" class="btn s-btn-ten24">Save & Add Another Button</button>
																			<div class="s-or-box">OR</div>
																			<button type="button" class="btn s-btn-ten24">Save & Finish</button>
																		</div>
																		<div class="form-group">
																			<div class="s-checkbox"><input type="checkbox" id="j-checkbox51"><label for="j-checkbox51"> Add To New Group</label></div>
																		</div>
																	</div>
																</div>
															</div>
														</div>
													</div>
												</div><!--- //Row --->

												<div class="row s-add-filter-box">
													<div class="col-xs-12 collapse s-add-filter" id="j-add-filter">
														<div class="row">
															<div class="col-xs-12">
																<h4> Define Filter: <span>Orders</span><i class="fa fa-times" data-toggle="collapse" data-target="#j-add-filter"></i></h4>
																<div class="row">
																	<div class="col-xs-4">
																		Select From Orders
																		<div class="option-dropdown">
																			<select class="form-control input-sm">
																				<option disabled="disabled" selected="selected">Select From Orders </option>
																				<option value="one">One</option>
																				<option value="two">Two</option>
																				<option value="three">Three</option>
																				<option value="four">Four</option>
																				<option value="five">Five</option>
																			</select>
																		</div>
																	</div>
																	<div class="col-xs-4 s-criteria">
																		<h4>Criteria</h4>

																		<!--- Filter Criteria Start --->
																		<form action="index.html" method="post">
																			<div class="s-filter-group-item">

																				<div class="form-group form-group-sm">
																					<label class="col-sm-12 control-label s-no-paddings" for="formGroupInputSmall">Date Conditions:</label>
																					<div class="col-sm-12 s-no-paddings">
																						<select class="form-control input-sm">
																							<option>1 week</option>
																							<option>2 week</option>
																							<option>3 week</option>
																							<option>4 week</option>
																							<option>5 week</option>
																						</select>
																					</div>
																					<div class="clearfix"></div>
																				</div>
																				<div class="form-group form-group-sm">
																					<label class="col-sm-12 control-label s-no-paddings" for="formGroupInputSmall">Number of Weeks Ago:</label>
																					<div class="col-sm-12 s-no-paddings">
																						<input type="text" class="form-control" id="input" placeholder="12">
																					</div>
																					<div class="clearfix"></div>
																				</div>
																			</div>
																		</form>
																		<!--- //Filter Criteria End --->

																	</div>
																	<div class="col-xs-4">
																		<div class="s-button-select-group">
																			<button type="button" class="btn s-btn-ten24">Save & Add Another Button</button>
																			<div class="s-or-box">OR</div>
																			<button type="button" class="btn s-btn-ten24">Save & Finish</button>
																		</div>
																		<div class="form-group">
																			<div class="s-checkbox"><input type="checkbox" id="j-checkbox61"><label for="j-checkbox61"> Add To New Group</label></div>
																		</div>
																	</div>
																</div>
															</div>
														</div>
													</div>
												</div><!--- //Row --->

											</div>
											<!--- //New Filter Panel --->
										</div>
										<!--- //End Filter Group --->

									</div>
								</div>
							</div><!--- //Tab Pane --->

							<div class="tab-pane s-display-options" id="j-display-options">

								<!-- Dragable List group -->
								<ul class="list-group s-j-draggablePanelList">

									<li class="list-group-item">
										<div class="row">
											<div class="col-xs-5 s-pannel-name">
												<span>1</span>
												<i class="fa fa-arrows-v"></i>
												<a class="s-pannel-title j-tool-tip-item j-edit-item" data-toggle="tooltip" data-placement="right" data-original-title="Edit">ID</a>
												<span class="s-title-edit-menu"><input type="text" class="form-control" value="ID"><button class="btn btn-xs s-btn-ten24 s-save-btn">Save</button></span>
											</div>
											<div class="col-xs-7 s-pannel-body">

												<div class="btn-group">
													<span class="s-sort-num">
														<a class="s-pannel-title j-tool-tip-item j-edit-item" data-toggle="tooltip" data-placement="right" data-original-title="Edit">1</a>
														<span class="s-title-edit-menu">
															<select class="form-control">
																<option value="1">1</option>
																<option value="2">2</option>
																<option value="3">3</option>
															</select>
															<button class="btn btn-xs s-btn-ten24 s-save-btn">Save</button>
														</span>
													</span>
													<a class="btn btn-default s-sort j-tool-tip-item" data-toggle="tooltip" data-placement="bottom" data-original-title="Sort Order"><i class="fa fa-sort-amount-asc"></i></a>
													<a class="btn btn-default j-tool-tip-item" data-toggle="tooltip" data-placement="bottom" data-original-title="Visible"><i class="fa fa-eye"></i></a>
													<a class="btn btn-default j-tool-tip-item" data-toggle="tooltip" data-placement="bottom" data-original-title="Search"><i class="fa fa-search"></i></a>
													<a class="btn btn-default j-tool-tip-item" data-toggle="tooltip" data-placement="bottom" data-original-title="Export"><i class="fa fa-download"></i></a>
													<a class="btn btn-default s-remove j-tool-tip-item" data-toggle="tooltip" data-placement="bottom" data-original-title="Remove"><i class="fa fa-times"></i></a>
												</div>

											</div>
										</div>
									</li>

									<li class="list-group-item">
										<div class="row">
											<div class="col-xs-5 s-pannel-name">
												<span>2</span>
												<i class="fa fa-arrows-v"></i>
												<a class="s-pannel-title j-tool-tip-item j-edit-item" data-toggle="tooltip" data-placement="right" data-original-title="Edit">Brand</a>
												<span class="s-title-edit-menu"><input type="text" class="form-control" value="ID"><button class="btn btn-xs s-btn-ten24 s-save-btn">Save</button></span>
											</div>
											<div class="col-xs-7 s-pannel-body">

												<div class="btn-group">
													<span class="s-sort-num" style="display:none;">
														<a class="s-pannel-title j-tool-tip-item j-edit-item" data-toggle="tooltip" data-placement="right" data-original-title="Edit">3</a>
														<span class="s-title-edit-menu">
															<select class="form-control">
																<option value="1">1</option>
																<option value="2">2</option>
																<option value="3">3</option>
															</select>
															<button class="btn btn-xs s-btn-ten24 s-save-btn">Save</button>
														</span>
													</span>
													<a class="btn btn-default s-sort j-tool-tip-item" data-toggle="tooltip" data-placement="bottom" data-original-title="Sort Order"><i class="fa fa-sort-amount-asc s-not-active"></i></a>
													<a class="btn btn-default j-tool-tip-item" data-toggle="tooltip" data-placement="bottom" data-original-title="Visible"><i class="fa fa-eye"></i></a>
													<a class="btn btn-default j-tool-tip-item disabled" data-toggle="tooltip" data-placement="bottom" data-original-title="Search"><i class="fa fa-search"></i></a>
													<a class="btn btn-default j-tool-tip-item" data-toggle="tooltip" data-placement="bottom" data-original-title="Export"><i class="fa fa-download"></i></a>
													<a class="btn btn-default s-remove j-tool-tip-item" data-toggle="tooltip" data-placement="bottom" data-original-title="Remove"><i class="fa fa-times"></i></a>
												</div>

											</div>
										</div>
									</li>

									<li class="list-group-item">
										<div class="row">
											<div class="col-xs-5 s-pannel-name">
												<span>3</span>
												<i class="fa fa-arrows-v"></i>
												<a class="s-pannel-title j-tool-tip-item j-edit-item" data-toggle="tooltip" data-placement="right" data-original-title="Edit">Style</a>
												<span class="s-title-edit-menu"><input type="text" class="form-control" value="ID"><button class="btn btn-xs s-btn-ten24 s-save-btn">Save</button></span>
											</div>
											<div class="col-xs-7 s-pannel-body">

												<div class="btn-group">
													<span class="s-sort-num">
														<a class="s-pannel-title j-tool-tip-item j-edit-item" data-toggle="tooltip" data-placement="right" data-original-title="Edit">2</a>
														<span class="s-title-edit-menu">
															<select class="form-control">
																<option value="1">1</option>
																<option value="2">2</option>
																<option value="3">3</option>
															</select>
															<button class="btn btn-xs s-btn-ten24 s-save-btn">Save</button>
														</span>
													</span>
													<a class="btn btn-default s-sort j-tool-tip-item" data-toggle="tooltip" data-placement="bottom" data-original-title="Sort Order"><i class="fa fa-sort-amount-desc"></i></a>
													<a class="btn btn-default j-tool-tip-item" data-toggle="tooltip" data-placement="bottom" data-original-title="Visible"><i class="fa fa-eye"></i></a>
													<a class="btn btn-default j-tool-tip-item" data-toggle="tooltip" data-placement="bottom" data-original-title="Search"><i class="fa fa-search"></i></a>
													<a class="btn btn-default j-tool-tip-item" data-toggle="tooltip" data-placement="bottom" data-original-title="Export"><i class="fa fa-download"></i></a>
													<a class="btn btn-default s-remove j-tool-tip-item" data-toggle="tooltip" data-placement="bottom" data-original-title="Remove"><i class="fa fa-times"></i></a>
												</div>

											</div>
										</div>
									</li>

								</ul>

								<!--- Message if no items --->
								<div class="s-none-selected" style="display:none;">There are no fields selected</div>

								<!--- Button to show create option --->
								<button class="btn btn-xs s-btn-ten24" data-toggle="collapse" data-target="#j-add-display-field">Add Display Field</button>

								<!--- Create option dropdown --->
								<div class="col-xs-12 collapse s-add-filter" id="j-add-display-field">
									<div class="row">
										<h4> Define Filters: <span>Orders</span><i class="fa fa-times" data-toggle="collapse" data-target="#j-add-display-field"></i></h4>
										<div class="col-xs-12">

											<div class="row">
												<div class="col-xs-2">
													<div class="form-group form-group-sm">
														<label class="col-sm-12 control-label s-no-paddings" for="formGroupInputSmall">Select From Orders</label>
														<div class="col-sm-12 s-no-paddings">
															<select class="form-control input-sm">
																<option disabled="disabled" selected="selected">Select From Orders</option>
																<option value="one">One</option>
																<option value="two">Two</option>
																<option value="three">Three</option>
																<option value="four">Four</option>
																<option value="five">Five</option>
															</select>
														</div>
														<div class="clearfix"></div>
													</div>
												</div>
												<div class="col-xs-6 s-criteria">

													Middle

												</div>
												<div class="col-xs-3">
													<div class="s-button-select-group">
														<button type="button" class="btn btn-sm s-btn-ten24">Save & Add Another Button</button>
														<div class="s-or-box">OR-</div>
														<button type="button" class="btn btn-sm s-btn-ten24">Save & Finish</button>
													</div>
													<div class="form-group">
														<div class="s-checkbox"><input type="checkbox" id="j-checkbox21"><label for="j-checkbox21"> Add To New Group</label></div>
													</div>
												</div>
											</div>
										</div>
									</div>
									<div class="clearfix"></div>
								</div>
								<!--- //Create option dropdown --->

							</div><!--- //Tab Pane --->
						</div>

					</div><!--- //Row --->

					<!--- //Tab panes for menu options end--->
					<div class="row s-table-header-nav">
						<div class="col-xs-6">
							<ul class="list-inline list-unstyled">
								<li>
									<form role="search">
										<label for="name" class="control-label"><i class="fa fa-level-down"></i></label>
										<select size="1" name="" aria-controls="" class="form-control accordion-dropdown">
											<option value="15" selected="selected" disabled="disabled">Bulk Action</option>
											<option value="j-export-link" data-toggle="collapse">Export</option>
											<option value="j-delete-link" data-toggle="collapse">Delete</option>
										</select>
									</form>
								</li>
								<li>
									<form class="s-table-header-search">
										<div class="input-group">
											<input type="text" class="form-control input-sm" placeholder="Search" name="srch-term" id="j-srch-term">
											<div class="input-group-btn">
												<button class="btn btn-default btn-sm" type="submit"><i class="fa fa-search"></i></button>
											</div>
										</div>
									</form>
								</li>
							</ul>
						</div>
						<div class="col-xs-6 s-table-view-options">
							<ul class="list-inline list-unstyled">
								<li>
									<form class="form-horizontal">
										<label for="inputPassword" class="control-label">View</label>
										<select size="1" name="" aria-controls="" class="form-control">
											<option value="5" selected="selected">5</option>
											<option value="15">10</option>
											<option value="20">25</option>
											<option value="20">50</option>
											<option value="20">100</option>
											<option value="20">250</option>
											<option value="-1">Auto</option>
										</select>
									</form>
								</li>
								<li>
									<ul class="pagination pagination-sm">
										<li><a href="#">&laquo;</a></li>
										<li class="active"><a href="#">1</a></li>
										<li><a href="#">2</a></li>
										<li><a href="#">3</a></li>
										<li><a href="#">4</a></li>
										<li><a href="#">5</a></li>
										<li class="disabled"><a href="#">&raquo;</a></li>
									</ul>
								</li>
								<!--- <li>
									<div class="btn-group" class="navbar-left">
										<button type="button" class="btn btn-sm btn-default" data-toggle="collapse" data-target="#j-download-link"><i class="fa fa-download"></i></button>
									</div>
								</li> --->
								<li>
									<div class="btn-group navbar-left">
										<button type="button" class="btn btn-sm btn-default"><i class="fa fa-plus"></i></button>
									</div>
								</li>
							</ul>

						</div>
					</div>

					<!--//export batch action-->
					<div id="j-export-link" class="row collapse s-batch-options">
						<div class="col-md-12 s-add-filter">

							<!--- Edit Filter Box --->

								<h4> Export:<i class="fa fa-times" data-toggle="collapse" data-target="#j-export-link"></i></h4>
								<div class="col-xs-12">

									<div class="row">
										<div class="col-xs-2">
											<div class="form-group form-group-sm">
												<label class="col-sm-12 control-label s-no-paddings" for="formGroupInputSmall">Items To Export:</label>
												<div class="col-sm-12 s-no-paddings">

													<div class="radio">
														<input type="radio" name="radio1" id="radio7" value="option2" checked="checked">
														<label for="radio7">
																All
														</label>
													</div>
													<div class="radio">
														<input type="radio" name="radio1" id="radio7" value="option2">
														<label for="radio7">
																Visable
														</label>
													</div>
													<div class="radio">
														<input type="radio" name="radio1" id="radio7" value="option2">
														<label for="radio7">
																Selected
														</label>
													</div>
												</div>
												<div class="clearfix"></div>
											</div>
										</div>
										<div class="col-xs-7 s-criteria">

											<!--- Filter Criteria Start --->
											<form action="index.html" method="post">
												<div class="s-filter-group-item">

													<div class="s-options-group">

														<div class="form-group">
															<label class="col-xs-12">Export Format:</label>
															<select class="form-control input-sm">
																<option selected="selected">Excel</option>
																<option>Text (CSV,Tab,...)</option>
															</select>
														</div>

														<!--- <div class="radio">
															<input type="radio" name="radio1" id="radio7" value="option2">
															<label for="radio7">
																	Excel
															</label>
														</div> --->

														<div class="radio">
															<input type="radio" name="radio1" id="radio7" value="option2">
															<label for="radio7">
																	Tab Delimited
															</label>
														</div>
														<div class="radio">
															<input type="radio" name="radio1" id="radio9" value="option2">
															<label for="radio9">
																	Comma Delimited
															</label>
														</div>
														<div class="radio">
															<input type="radio" name="radio1" id="radio6" value="option3" checked>
															<label for="radio6">
																	Custom Delimiter
															</label>
															<input style="display:block;" type="text" name="some_name" value="">
														</div>
													</div>

												</div>
											</form>
											<!--- //Filter Criteria End --->

										</div>
										<div class="col-xs-2">
											<div class="s-button-select-group">
												<button type="button" class="btn btn-sm s-btn-ten24">Export</button>
											</div>
										</div>
									</div>
								</div>


							<!--- //Edit Filter Box --->
						</div>
					</div>
					<!--//export batch action-->

					<!--delete batch action-->
					<div id="j-delete-link" class="row collapse s-batch-options">
						<div class="col-md-12 s-add-filter">

							<!--- Edit Filter Box --->

								<h4> Delete:<i class="fa fa-times" data-toggle="collapse" data-target="#j-delete-link"></i></h4>
								<div class="col-xs-12">

									<div class="row">
										<div class="col-xs-2">
											<div class="form-group form-group-sm">
												<label class="col-sm-12 control-label s-no-padding" for="formGroupInputSmall">Items To Delete:</label>
												<div class="col-sm-12 s-no-paddings">

													<div class="radio">
														<input type="radio" name="radio1" id="radio7" value="option2" checked="checked">
														<label for="radio7">
																All
														</label>
													</div>
													<div class="radio">
														<input type="radio" name="radio1" id="radio7" value="option2">
														<label for="radio7">
																Visable
														</label>
													</div>
													<div class="radio">
														<input type="radio" name="radio1" id="radio7" value="option2">
														<label for="radio7">
																Selected
														</label>
													</div>
												</div>
												<div class="clearfix"></div>
											</div>
										</div>
										<div class="col-xs-7 s-criteria">

											<div class="alert alert-danger" role="alert">
												<div class="input-group">
													<label>Confirm action by typing "DELETE" below.</label>
													<input type="text" class="form-control j-delete-text" placeholder="">

												</div>
											</div>

										</div>
										<div class="col-xs-2">
											<div class="s-button-select-group">
												<button type="button" class="btn btn-sm s-btn-ten24 j-delete-btn" disabled="disabled">Delete</button>
											</div>
										</div>
									</div>
								</div>

							<!--- //Edit Filter Box --->
						</div>
					</div>
					<!--//delete batch action-->

					<div class="table-responsive s-filter-table-box">
						<table class="table table-bordered table-striped">
							<thead>
								<tr>
									<th>Row</span></th>
									<th class="s-sortable">ID</th>
									<th class="s-sortable">Brand</th>
									<th class="s-sortable">Style</th>
									<th class="s-sortable">Color</th>
									<th class="s-sortable">Gender</th>
									<th class="s-sortable">Material</th>
									<th class="s-sortable">Purchase Date</th>
									<th class="s-sortable">Price</th>
									<th></th>
								</tr>
							</thead>
							<tbody>

								<!---TR 1--->
								<tr class="even-tr">
									<td><div class="s-checkbox"><input type="checkbox" id="j-checkbox"><label for="j-checkbox"></label></div></td>
									<td>2691402</td>
									<td>Ario</td>
									<td>Square Toe</td>
									<td>Black</td>
									<td>Male</td>
									<td>Leather</td>
									<td>July 06, 2014 05:36 PM</td>
									<td>$130.99</td>
									<td class="s-edit-elements">
										<ul>
											<li><span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="View"><a href="##"><i class="fa fa-eye"></i></a></span></li>
											<li><span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="Edit"><a href="##"><i class="fa fa-pencil"></i></a></span></li>
										</ul>
									</td>
								</tr>

								<!---TR 2--->
								<tr class="even-tr">
									<td><div class="s-checkbox"><input type="checkbox" id="j-checkbox2"><label for="j-checkbox2"></label></div></td>
									<td>2691402</td>
									<td>Ario</td>
									<td>Square Toe</td>
									<td>Black</td>
									<td>Male</td>
									<td>Leather</td>
									<td>July 06, 2014 05:36 PM</td>
									<td>$130.99</td>
									<td class="s-edit-elements">
										<ul>
											<li><span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="View"><a href="##"><i class="fa fa-eye"></i></a></span></li>
											<li><span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="Edit"><a href="##"><i class="fa fa-pencil"></i></a></span></li>
										</ul>
									</td>
								</tr>

								<!---TR 3--->
								<tr class="even-tr">
									<td><div class="s-checkbox"><input type="checkbox" id="j-checkbox3"><label for="j-checkbox3"></label></div></td>
									<td>2691402</td>
									<td>Ario</td>
									<td>Square Toe</td>
									<td>Black</td>
									<td>Male</td>
									<td>Leather</td>
									<td>July 06, 2014 05:36 PM</td>
									<td>$130.99</td>
									<td class="s-edit-elements">
										<ul>
											<li><span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="View"><a href="##"><i class="fa fa-eye"></i></a></span></li>
											<li><span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="Edit"><a href="##"><i class="fa fa-pencil"></i></a></span></li>
										</ul>
									</td>
								</tr>

								<!---TR 4--->
								<tr class="even-tr">
									<td><div class="s-checkbox"><input type="checkbox" id="j-checkbox4"><label for="j-checkbox4"></label></div></td>
									<td>2691402</td>
									<td>Ario</td>
									<td>Square Toe</td>
									<td>Black</td>
									<td>Male</td>
									<td>Leather</td>
									<td>July 06, 2014 05:36 PM</td>
									<td>$130.99</td>
									<td class="s-edit-elements">
										<ul>
											<li><span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="View"><a href="##"><i class="fa fa-eye"></i></a></span></li>
											<li><span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="Edit"><a href="##"><i class="fa fa-pencil"></i></a></span></li>
										</ul>
									</td>
								</tr>

								<!---TR 11--->
								<tr class="even-tr">
									<td><div class="s-checkbox"><input type="checkbox" id="j-checkbox11"><label for="j-checkbox11"></label></div></td>
									<td>2691402</td>
									<td>Ario</td>
									<td>Square Toe</td>
									<td>Black</td>
									<td>Male</td>
									<td>Leather</td>
									<td>July 06, 2014 05:36 PM</td>
									<td>$130.99</td>
									<td class="s-edit-elements">
										<ul>
											<li><span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="View"><a href="##"><i class="fa fa-eye"></i></a></span></li>
											<li><span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="Edit"><a href="##"><i class="fa fa-pencil"></i></a></span></li>
										</ul>
									</td>
								</tr>

								<!---TR 12--->
								<tr class="even-tr">
									<td><div class="s-checkbox"><input type="checkbox" id="j-checkbox12"><label for="j-checkbox12"></label></div></td>
									<td>2691402</td>
									<td>Ario</td>
									<td>Square Toe</td>
									<td>Black</td>
									<td>Male</td>
									<td>Leather</td>
									<td>July 06, 2014 05:36 PM</td>
									<td>$130.99</td>
									<td class="s-edit-elements">
										<ul>
											<li><span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="View"><a href="##"><i class="fa fa-eye"></i></a></span></li>
											<li><span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="Edit"><a href="##"><i class="fa fa-pencil"></i></a></span></li>
										</ul>
									</td>
								</tr>

								<!---TR 13--->
								<tr class="even-tr">
									<td><div class="s-checkbox"><input type="checkbox" id="j-checkbox13"><label for="j-checkbox13"></label></div></td>
									<td>2691402</td>
									<td>Ario</td>
									<td>Square Toe</td>
									<td>Black</td>
									<td>Male</td>
									<td>Leather</td>
									<td>July 06, 2014 05:36 PM</td>
									<td>$130.99</td>
									<td class="s-edit-elements">
										<ul>
											<li><span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="View"><a href="##"><i class="fa fa-eye"></i></a></span></li>
											<li><span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="Edit"><a href="##"><i class="fa fa-pencil"></i></a></span></li>
										</ul>
									</td>
								</tr>

								<!---TR 14--->
								<tr class="even-tr">
									<td><div class="s-checkbox"><input type="checkbox" id="j-checkbox14"><label for="j-checkbox14"></label></div></td>
									<td>2691402</td>
									<td>Ario</td>
									<td>Square Toe</td>
									<td>Black</td>
									<td>Male</td>
									<td>Leather</td>
									<td>July 06, 2014 05:36 PM</td>
									<td>$130.99</td>
									<td class="s-edit-elements">
										<ul>
											<li><span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="View"><a href="##"><i class="fa fa-eye"></i></a></span></li>
											<li><span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="Edit"><a href="##"><i class="fa fa-pencil"></i></a></span></li>
										</ul>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="row">
						<div class="col-md-12">
							<div class="dataTables_info" id="example3_info">Showing <b>1 to 10</b> of 57 entries</div>
						</div>
					</div>

				</div>

			</div>
		</div>
	</div>
	<div class="panel panel-default">
		<a data-toggle="collapse"  href="#collapseFive">
			<div class="panel-heading">
				<h4 class="panel-title">
					<span>Product Description</span>
					<i class="fa fa-caret-left"></i>
				</h4>
			</div>
		</a>
		<div id="collapseFive" class="panel-collapse collapse">
			<div class="panel-body">
				Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. 3 wolf moon officia aute, non cupidatat skateboard dolor brunch. Food truck quinoa nesciunt laborum eiusmod. Brunch 3 wolf moon tempor, sunt aliqua put a bird on it squid single-origin coffee nulla assumenda shoreditch et. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident. Ad vegan excepteur butcher vice lomo. Leggings occaecat craft beer farm-to-table, raw denim aesthetic synth nesciunt you probably haven't heard of them accusamus labore sustainable VHS.
			</div>
		</div>
	</div>
	<div class="panel panel-default">
		<a data-toggle="collapse"  href="#collapseSix">
			<div class="panel-heading">
				<h4 class="panel-title">
					<span>Listing Pages</span>
					<i class="fa fa-caret-left"></i>
				</h4>
			</div>
		</a>
		<div id="collapseSix" class="panel-collapse collapse">
			<div class="panel-body">
				Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. 3 wolf moon officia aute, non cupidatat skateboard dolor brunch. Food truck quinoa nesciunt laborum eiusmod. Brunch 3 wolf moon tempor, sunt aliqua put a bird on it squid single-origin coffee nulla assumenda shoreditch et. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident. Ad vegan excepteur butcher vice lomo. Leggings occaecat craft beer farm-to-table, raw denim aesthetic synth nesciunt you probably haven't heard of them accusamus labore sustainable VHS.
			</div>
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
