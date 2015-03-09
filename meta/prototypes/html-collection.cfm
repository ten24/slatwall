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
            <h1>Best Selling Mens Boots</h1>
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
        <a data-toggle="collapse"  href="#basic">
            <div class="panel-heading">
                <h4 class="panel-title">
                    <span>Basic</span>
                    <i class="fa fa-caret-left"></i>
                </h4>
            </div>
        </a>
        <div id="basic" class="panel-collapse collapse in">
            <content class="s-body-box">
                <div class="tab-pane" id="tabbasic">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-horizontal  s-property-info">
                                <div class="form-group">
                                    <label class="control-label col-sm-4 title" style="text-align:left;">Title: <span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="The collection title"> <i class="fa fa-question-circle"></i></span></label>
                                    <div class="col-sm-8">
                                        <p class="form-control-static value">Best Selling Mens & Womens Boots From July 2014</p>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-sm-4 title" style="text-align:left;">Code: <span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="" data-original-title="The collection code"> <i class="fa fa-question-circle"></i></span></label>
                                    <div class="col-sm-8">
                                        <p class="form-control-static value">876567</p>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-sm-4 title" style="text-align:left;">Description: <span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="" data-original-title="The collection description"> <i class="fa fa-question-circle"></i></span></label>
                                    <div class="col-sm-8">
                                        <p class="form-control-static value">A selection for the best selling mens boots.</p>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-sm-4 title" style="text-align:left;">Collection Type: <span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="" data-original-title="The collection type"> <i class="fa fa-question-circle"></i></span></label>
                                    <div class="col-sm-8">
                                        <p class="form-control-static value">Type</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </content>
        </div>
    </div>
    
    <div class="panel panel-default">
        <a data-toggle="collapse"  href="#filterOptions">
            <div class="panel-heading">
                <h4 class="panel-title">
                    <span>Filter Options</span>
                    <i class="fa fa-caret-left"></i>
                </h4>
            </div>
        </a>

        <div id="filterOptions" class="panel-collapse collapse">
            <content class="s-body-box s-panel-header-info">

                <div class="col-xs-12 s-filter-content">

                	<!--- Header nav with title starts --->
                	<div class="row s-header-bar">
                		<div class="col-md-12 s-header-nav">
                			<ul class="nav nav-tabs" role="tablist" style="padding:0px;">
                				<li class="active"><a href="##j-filters" role="tab" data-toggle="tab">FILTERS <span>(6)</span></a></li>
                				<li><a href="##j-display-options" role="tab" data-toggle="tab">DISPLAY OPTIONS</a></li>
                			</ul>
                		</div>
                	</div>
                	<!--- //Header nav with title end --->

                	<!--- Tab panes for menu options start--->
                	<div class="row s-options">
                		<div class="tab-content" id="j-property-box">

                			<div class="tab-pane active" id="j-filters">
                				<div class="s-setting-options">
                					<div class="row s-setting-options-body">

                						<!--- Start Filter Group --->
                						<div class="col-xs-12 s-filters-selected">
                							<div class="row">
                								<ul class="col-xs-12 list-unstyled">

                									<li>
                                                        
                										<!--- Filter display --->
                										<div class="s-filter-item">
                											<div class="panel panel-default">
                												<div class="panel-heading">Gender <a href="##" class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="" data-original-title="Remove"><i class="fa fa-times"></i></a></div>
                												<div data-toggle="collapse" data-target="#j-edit-filter-1" class="panel-body j-tool-tip-item" data-toggle="tooltip" data-placement="bottom" title="Click To Edit">
                													Male <a href="##"><i class="fa fa-pencil-square-o"></i></a>
                												</div>
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

                														</div>
                														<div class="col-xs-3">
                															<div class="s-button-select-group">
                																<button type="button" class="btn btn-sm s-btn-ten24">Save & Add Another Button</button>
                																<div class="s-or-box">-OR-</div>
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
                										<span class="s-title-edit-menu" style="display:none;position: absolute;z-index: 3000;width: 150px;left: 0px;top:0px;background: #EEE;height: 40px;moz-box-shadow: inset 0 0 1px #999999;-webkit-box-shadow: inset 0 0 1px #999;box-shadow: inset 0 0 1px #999;text-align: left;">
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
                										<span class="s-title-edit-menu" style="display:none;position: absolute;z-index: 3000;width: 150px;left: 0px;top:0px;background: #EEE;height: 40px;moz-box-shadow: inset 0 0 1px #999999;-webkit-box-shadow: inset 0 0 1px #999;box-shadow: inset 0 0 1px #999;text-align: left;">
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
                										<span class="s-title-edit-menu" style="display:none;position: absolute;z-index: 3000;width: 150px;left: 0px;top:0px;background: #EEE;height: 40px;moz-box-shadow: inset 0 0 1px #999999;-webkit-box-shadow: inset 0 0 1px #999;box-shadow: inset 0 0 1px #999;text-align: left;">
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
                				<button class="btn btn-xs s-btn-ten24" data-toggle="collapse" data-target="#j-add-row">Add Display Field</button>

                				<!--- Create option dropdown --->
                				<div class="row s-add-display-field collapse" id="j-add-row">
                					<div class="col-xs-12">
                						<i class="fa fa-plus"></i>
                						<select class="form-control">
                							<option value="Select from Orders" disabled="disabled" selected="selected">Order Items</option>
                							<option value="Order Total">Order Total</option>
                							<option value="Order Item Total">Order Item Total</option>
                						</select>

                						<select class="form-control">
                							<option value="Select from Orders" disabled="disabled" selected="selected">Select From Account</option>
                							<option value="Order Total">First Name</option>
                							<option value="Order Item Total">Last Name</option>
                						</select>
                						<button name="button" class="btn s-btn-ten24 btn-xs"><i class="fa fa-plus"></i> Column</button>
                						<button class="btn btn-danger btn-xs"><i class="fa fa-times"></i> Remove</button>
                					</div>
                				</div>

                			</div><!--- //Tab Pane --->
                		</div>

                	</div><!--- //Row --->

                	<!--- //Tab panes for menu options end--->
                	<div class="s-table-header-nav">
                		<div class="col-xs-6 s-zero-left">
                			<ul class="list-inline list-unstyled">
                				<li>
                					<form role="filter" class="s-filter-options">
            							<select size="1" name="" aria-controls="" class="form-control accordion-dropdown">
            								<option value="15" selected="selected" disabled="disabled">Bulk Action</option>
            								<option value="j-export-link" data-toggle="collapse">Export</option>
            								<option value="j-delete-link" data-toggle="collapse">Delete</option>
            							</select>
                					</form>
                				</li>
                				<li style="width:200px;">
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
                		<div class="col-xs-6 s-zero-right" style="text-align:right;">
                			<ul class="list-inline list-unstyled">
                				<li>
                                    <style>
                                        .s-table-header-nav label, .s-table-header-nav .selectboxit-container {display:inline-block;}
                                    </style>
                					<form class="form-horizontal" style="width: 170px;">
                						<label for="inputPassword" class="control-label col-md-4">View</label>
                                        <div class="col-md-8">
                    						<select class="form-control">
                    							<option value="5" selected="selected">5</option>
                    							<option value="15">10</option>
                    							<option value="20">25</option>
                    							<option value="20">50</option>
                    							<option value="20">100</option>
                    							<option value="20">250</option>
                    							<option value="-1">Auto</option>
                    						</select>
                                        </div>
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
                								<button type="button" class="btn btn-sm s-btn-ten24" style="width:100%;">Export</button>
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

                				<h4> Filters:<i class="fa fa-times" data-toggle="collapse" data-target="#j-delete-link"></i></h4>
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
                								<button type="button" class="btn btn-sm s-btn-ten24 j-delete-btn" disabled="disabled" style="width:100%;">Delete</button>
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
                						<td>
                                            <a title="" class="adminentitydetailsku btn btn-default btn-xs" target="_self" href="?slatAction=entity.detailsku&amp;skuID=8a80808448f051db0149579b4370064c&amp;productID=8a80808448f051db0149579b4350064b" id="adminentitydetailsku_8a80808448f051db0149579b4370064c"><i class="glyphicon glyphicon-eye-open"></i> </a> 
                                            <a title="" class="adminentityeditsku btn btn-default btn-xs" target="_self" href="?slatAction=entity.editsku&amp;skuID=8a80808448f051db0149579b4370064c&amp;productID=8a80808448f051db0149579b4350064b" id="adminentityeditsku_8a80808448f051db0149579b4370064c"><i class="glyphicon glyphicon-pencil"></i> </a> 
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
                						<td>
                                            <a title="" class="adminentitydetailsku btn btn-default btn-xs" target="_self" href="?slatAction=entity.detailsku&amp;skuID=8a80808448f051db0149579b4370064c&amp;productID=8a80808448f051db0149579b4350064b" id="adminentitydetailsku_8a80808448f051db0149579b4370064c"><i class="glyphicon glyphicon-eye-open"></i> </a> 
                                            <a title="" class="adminentityeditsku btn btn-default btn-xs" target="_self" href="?slatAction=entity.editsku&amp;skuID=8a80808448f051db0149579b4370064c&amp;productID=8a80808448f051db0149579b4350064b" id="adminentityeditsku_8a80808448f051db0149579b4370064c"><i class="glyphicon glyphicon-pencil"></i> </a> 
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
                						<td>
                                            <a title="" class="adminentitydetailsku btn btn-default btn-xs" target="_self" href="?slatAction=entity.detailsku&amp;skuID=8a80808448f051db0149579b4370064c&amp;productID=8a80808448f051db0149579b4350064b" id="adminentitydetailsku_8a80808448f051db0149579b4370064c"><i class="glyphicon glyphicon-eye-open"></i> </a> 
                                            <a title="" class="adminentityeditsku btn btn-default btn-xs" target="_self" href="?slatAction=entity.editsku&amp;skuID=8a80808448f051db0149579b4370064c&amp;productID=8a80808448f051db0149579b4350064b" id="adminentityeditsku_8a80808448f051db0149579b4370064c"><i class="glyphicon glyphicon-pencil"></i> </a> 
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
                						<td>
                                            <a title="" class="adminentitydetailsku btn btn-default btn-xs" target="_self" href="?slatAction=entity.detailsku&amp;skuID=8a80808448f051db0149579b4370064c&amp;productID=8a80808448f051db0149579b4350064b" id="adminentitydetailsku_8a80808448f051db0149579b4370064c"><i class="glyphicon glyphicon-eye-open"></i> </a> 
                                            <a title="" class="adminentityeditsku btn btn-default btn-xs" target="_self" href="?slatAction=entity.editsku&amp;skuID=8a80808448f051db0149579b4370064c&amp;productID=8a80808448f051db0149579b4350064b" id="adminentityeditsku_8a80808448f051db0149579b4370064c"><i class="glyphicon glyphicon-pencil"></i> </a> 
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
                						<td>
                                            <a title="" class="adminentitydetailsku btn btn-default btn-xs" target="_self" href="?slatAction=entity.detailsku&amp;skuID=8a80808448f051db0149579b4370064c&amp;productID=8a80808448f051db0149579b4350064b" id="adminentitydetailsku_8a80808448f051db0149579b4370064c"><i class="glyphicon glyphicon-eye-open"></i> </a> 
                                            <a title="" class="adminentityeditsku btn btn-default btn-xs" target="_self" href="?slatAction=entity.editsku&amp;skuID=8a80808448f051db0149579b4370064c&amp;productID=8a80808448f051db0149579b4350064b" id="adminentityeditsku_8a80808448f051db0149579b4370064c"><i class="glyphicon glyphicon-pencil"></i> </a> 
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
                						<td>
                                            <a title="" class="adminentitydetailsku btn btn-default btn-xs" target="_self" href="?slatAction=entity.detailsku&amp;skuID=8a80808448f051db0149579b4370064c&amp;productID=8a80808448f051db0149579b4350064b" id="adminentitydetailsku_8a80808448f051db0149579b4370064c"><i class="glyphicon glyphicon-eye-open"></i> </a> 
                                            <a title="" class="adminentityeditsku btn btn-default btn-xs" target="_self" href="?slatAction=entity.editsku&amp;skuID=8a80808448f051db0149579b4370064c&amp;productID=8a80808448f051db0149579b4350064b" id="adminentityeditsku_8a80808448f051db0149579b4370064c"><i class="glyphicon glyphicon-pencil"></i> </a> 
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
                						<td>
                                            <a title="" class="adminentitydetailsku btn btn-default btn-xs" target="_self" href="?slatAction=entity.detailsku&amp;skuID=8a80808448f051db0149579b4370064c&amp;productID=8a80808448f051db0149579b4350064b" id="adminentitydetailsku_8a80808448f051db0149579b4370064c"><i class="glyphicon glyphicon-eye-open"></i> </a> 
                                            <a title="" class="adminentityeditsku btn btn-default btn-xs" target="_self" href="?slatAction=entity.editsku&amp;skuID=8a80808448f051db0149579b4370064c&amp;productID=8a80808448f051db0149579b4350064b" id="adminentityeditsku_8a80808448f051db0149579b4370064c"><i class="glyphicon glyphicon-pencil"></i> </a> 
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
                						<td>
                                            <a title="" class="adminentitydetailsku btn btn-default btn-xs" target="_self" href="?slatAction=entity.detailsku&amp;skuID=8a80808448f051db0149579b4370064c&amp;productID=8a80808448f051db0149579b4350064b" id="adminentitydetailsku_8a80808448f051db0149579b4370064c"><i class="glyphicon glyphicon-eye-open"></i> </a> 
                                            <a title="" class="adminentityeditsku btn btn-default btn-xs" target="_self" href="?slatAction=entity.editsku&amp;skuID=8a80808448f051db0149579b4370064c&amp;productID=8a80808448f051db0149579b4350064b" id="adminentityeditsku_8a80808448f051db0149579b4370064c"><i class="glyphicon glyphicon-pencil"></i> </a> 
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

            </content>
        </div>
    </div>

    <div class="panel panel-default">
        <a data-toggle="collapse"  href="#systemOptions">
            <div class="panel-heading">
                <h4 class="panel-title">
                    <span>System</span>
                    <i class="fa fa-caret-left"></i>
                </h4>
            </div>
        </a>
        <div id="systemOptions" class="panel-collapse collapse">
            <content class="s-body-box">
                This is test content
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
