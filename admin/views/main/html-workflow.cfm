<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<div class="row s-body-nav">
	<nav class="navbar navbar-default" role="navigation">
		<div class="col-md-4 s-header-info">
			<ul class="list-unstyled list-inline">

			</ul>
			<h1>Creat Workflow</h1>
		</div>

		<div class="col-md-8">
			<div class="btn-toolbar">

				<div class="btn-group btn-group-sm">
					<button type="button" class="btn btn-default"><i class="glyphicon glyphicon-arrow-left"></i> Workflows</button>
				</div>

				<div class="btn-group btn-group-sm">
					<button type="button" class="btn btn-default s-remove">Cancel</button>
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
		<a data-toggle="collapse"  href="#collapseBasic">
			<div class="panel-heading">
				<h4 class="panel-title">
					<span>Basic</span>
					<i class="fa fa-caret-left"></i>
				</h4>
			</div>
		</a>
		
		<div id="collapseBasic" class="panel-collapse collapse in">
			<content class="s-body-box s-panel-header-info">
				<!---TODO:convert to directive as basic workflow viewlet --->
				<div class="col-md-6 s-header-left">
					<div class="s-header-detail">
						<dl class="dl-horizontal">
							<dt class="title">Workflow Name: <i class="fa fa-question-circle" ></i></dt>
							<dd class="value">
								<input type="text" name="some_name" class="form-control" value="Order Status">
							</dd>
							<dt class="title">Object: <i class="fa fa-question-circle" ></i></dt>
							<dd class="value">
								<select class="form-control" name="">
									<option value="1">Product</option>
									<option value="2">Order</option>
									<option value="3">Acount</option>
								</select>
							</dd>
							<dt class="title">Active: <i class="fa fa-question-circle"></i></dt>
							<dd class="value">Yes</dd>
						</dl>
					</div>
				</div>
				<div class="col-md-6 s-header-right">

				</div>

			</content>
		</div>
	</div>

	<div class="panel panel-default">
		<a data-toggle="collapse"  href="#collapseTrigger">
			<div class="panel-heading">
				<h4 class="panel-title">
					<span>Trigger</span>
					<i class="fa fa-caret-left"></i>
				</h4>
			</div>
		</a>

		<div id="collapseTrigger" class="panel-collapse collapse">
			<content class="s-body-box">
				<!---TODO: convert to triggers directives containing triggers  --->
				<div class="s-bundle-add-items s-workflow-objs">
					<ul class="list-unstyled s-order-item-options s-negative-obj">
						<!---TODO: convert to trigger directive --->
						<li class="s-bundle-add-obj">
							<ul class="list-unstyled list-inline">
								<li class="s-item-type s-tooltip" data-toggle="tooltip" data-placement="right" title="Event"><i class="fa fa-flag"></i></li>
							</ul>
							<ul class="list-unstyled list-inline s-middle">
								<li class="j-tool-tip-item s-bundle-details">Order - Save Order Success</li>
							</ul>
							<ul class="list-unstyled list-inline s-last">
								<li class="col-xs-1 j-tool-tip-item s-bundle-details-add"><a class="btn s-btn-dgrey s-remove"><i class="fa fa-trash"></i></a></li>
							</ul>
							<div class="clearfix"></div>
						</li>

						<li class="s-bundle-add-obj">
							<ul class="list-unstyled list-inline">
								<li class="s-item-type s-tooltip" data-toggle="tooltip" data-placement="right" title="Schedule"><i class="fa fa-calendar"></i></li>
							</ul>
							<ul class="list-unstyled list-inline s-middle">
								<li class="j-tool-tip-item s-bundle-details">Order - Save Order Success</li>
							</ul>
							<ul class="list-unstyled list-inline s-last">
								<li class="col-xs-1 j-tool-tip-item s-bundle-details-add"><a class="btn s-btn-dgrey s-remove"><i class="fa fa-trash"></i></a></li>
							</ul>
							<div class="clearfix"></div>
						</li>

						<li class="s-bundle-add-obj s-no-edit">
							<ul class="list-unstyled list-inline">
								<li class="s-item-type s-tooltip" data-toggle="tooltip" data-placement="right" title="Reference">R</li>
							</ul>
							<ul class="list-unstyled list-inline s-middle">
								<li class="j-tool-tip-item s-bundle-details">Order Update Workflow</li>
							</ul>
							<ul class="list-unstyled list-inline s-last">
								<li class="col-xs-1 j-tool-tip-item s-bundle-details-add"><a class="btn s-btn-dgrey"><i class="fa fa-pencil"></i></a></li>
							</ul>
							<div class="clearfix"></div>
						</li>

					</ul>

					<button class="btn btn-xs s-btn-ten24" data-toggle="collapse" data-target="#j-create-new-trigger"><i class="fa fa-plus"></i> Add Trigger</button>

					<!--- Edit Filter Box --->
					<div class="col-xs-12 collapse s-add-filter" id="j-create-new-trigger">
						<div class="row">
							<h4> New Trigger <i class="fa fa-times" data-toggle="collapse" data-target="#j-create-new-trigger"></i></h4>
							<div class="col-xs-12">

								<div class="row s-flex-col">
									<div class="col-xs-3">

										<div class="s-create-obj-window">
											<h4>Trigger Type:</h4>
											<div class="form-group">
												<div class="radio">
													<input type="radio" name="radio3" id="radio2" value="option2" checked="checked">
													<label for="radio2">
														Event
													</label>
												</div>
												<div class="radio">
													<input type="radio" name="radio3" id="radio3" value="option3">
													<label for="radio3">
														Schedule
													</label>
												</div>
											</div>
										</div>

									</div>
									<div class="col-xs-6 s-criteria">

										<h4>Select Trigger Event:</h4>
										<!--- Filter Criteria Start --->
										<form action="index.html" method="post">

											<div class="s-filter-group-item">

												<div class="form-group form-group-sm">
													<label class="col-sm-12 control-label s-no-paddings" for="formGroupInputSmall">Order Items:</label>
													<div class="col-sm-12 s-no-paddings">

														<!--- search --->
														<div class="s-search-filter">
															<div class="input-group">
																<input type="text" class="form-control input-sm j-search-input" placeholder="Search&hellip;">
																<ul class="dropdown-menu s-search-options">
																	<!--- <li><button type="button" class="btn s-btn-dgrey" data-toggle="collapse" data-target="#j-toggle-add-bundle-type"><i class="fa fa-plus"></i> Add "This should be the name"</button></li> --->
																	<li><a>On Order Item Save</a></li>
																	<li><a>On Order Item Update</a></li>
																	<li><a>On Order Item Cancel</a></li>
																	<li><a>On Order Item Delete</a></li>
																	<!--- <li><hr/></li> --->
																	<li id="j-placeholder-trigger"><a>On Order Item Event</a></li>
																	<li><a>On Order Fulfillment Event</a></li>
																</ul>
																<div class="input-group-btn">
																	<button type="button" class="btn btn-sm btn-default j-dropdown-options"><span class="caret"></span></button>
																</div>
															</div>

															<div class="s-add-content collapse" id="j-toggle-add-bundle-type">
																<form id="form_id" action="index.html" method="post" >
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

													</div>
													<div class="clearfix"></div>
												</div>

												<div class="form-group form-group-sm" id="j-placeholder-trigger-select" style="display:none;">
													<label class="col-sm-12 control-label s-no-paddings" for="formGroupInputSmall">On Order Item Event:</label>
													<div class="col-sm-12 s-no-paddings">

														<!--- search --->
														<div class="s-search-filter">
															<div class="input-group">
																<input type="text" class="form-control input-sm j-search-input" placeholder="Search&hellip;">
																<ul class="dropdown-menu s-search-options">
																	<li><button type="button" class="btn s-btn-dgrey" data-toggle="collapse" data-target="#j-toggle-add-bundle-type"><i class="fa fa-plus"></i> Add "This should be the name"</button></li>
																	<li><a>On Order Item Save</a></li>
																	<li><a>On Order Item Update</a></li>
																	<li><a>On Order Item Cancel</a></li>
																	<li><a>On Order Item Delete</a></li>
																	<li><hr/></li>
																	<li id="j-placeholder-trigger"><a>On Order Item Event</a></li>
																	<li><a>On Order Fulfillment Event</a></li>
																</ul>
																<div class="input-group-btn">
																	<button type="button" class="btn btn-sm btn-default j-dropdown-options"><span class="caret"></span></button>
																</div>
															</div>

															<div class="s-add-content collapse" id="j-toggle-add-bundle-type">
																<form id="form_id" action="index.html" method="post" >
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

													</div>
													<div class="clearfix"></div>
												</div>

											</div>

										</form>
										<!--- //Filter Criteria End --->

										<h4>Select Trigger Schedule:</h4>

										<!--- Filter Criteria Start --->
										<form action="index.html" method="post">

											<div class="s-filter-group-item">

												<div class="form-group form-group-sm">
													<label class="col-sm-12 control-label s-no-paddings" for="formGroupInputSmall">Order Collection:</label>
													<div class="col-sm-12 s-no-paddings">

														<!--- search --->
														<div class="s-search-filter">
															<div class="input-group">
																<input type="text" class="form-control input-sm j-search-input" placeholder="Search&hellip;">
																<ul class="dropdown-menu s-search-options">
																	<li><button type="button" class="btn s-btn-dgrey" data-toggle="collapse" data-target="#j-toggle-add-bundle-type"><i class="fa fa-plus"></i> Add "This should be the name"</button></li>
																	<li><a>Unassigned Orders</a></li>
																	<li><a>Todays Orders</a></li>
																</ul>
																<div class="input-group-btn">
																	<button type="button" class="btn btn-sm btn-default j-dropdown-options"><span class="caret"></span></button>
																</div>
															</div>

															<div class="s-add-content collapse" id="j-toggle-add-bundle-type">
																<form id="form_id" action="index.html" method="post" >
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

													</div>
													<div class="clearfix"></div>
												</div>

												<div class="form-group form-group-sm">
													<label class="col-sm-12 control-label s-no-paddings" for="formGroupInputSmall">Schedule Frequency:</label>
													<div class="col-sm-12 s-no-paddings">

														<!--- search --->
														<div class="s-search-filter">
															<div class="input-group">
																<input type="text" class="form-control input-sm j-search-input" placeholder="Search&hellip;">
																<ul class="dropdown-menu s-search-options">
																	<li><button type="button" class="btn s-btn-dgrey" data-toggle="collapse" data-target="#j-toggle-add-bundle-type3"><i class="fa fa-plus"></i> Add "This should be the name"</button></li>
																	<li><a>Every Monday</a></li>
																	<li><a>Bob's Daily Schedule</a></li>
																</ul>
																<div class="input-group-btn">
																	<button type="button" class="btn btn-sm btn-default j-dropdown-options"><span class="caret"></span></button>
																</div>
															</div>

															<div class="s-add-content collapse" id="j-toggle-add-bundle-type3">
																<form id="form_id" action="index.html" method="post">
																	<div class="form-group form-group-sm">
																		<label class="col-sm-12 control-label s-no-paddings" for="formGroupInputSmall">Schedule Name:</label>
																		<div class="col-sm-12 s-no-paddings">
																			<input type="text" class="form-control" id="input">
																		</div>
																		<div class="clearfix"></div>
																	</div>

																	<div class="form-group">
																		<label class="col-sm-12 control-label s-no-paddings" for="formGroupInputSmall">Schedule Type:</label>
																		<select class="form-control input-sm">
																			<option value="-- Select">--Select--</option>
																			<option selected="" value="Daily">Daily</option>
																			<option value="Days of the Week">Days of the Week</option>
																			<option value="Days of the Month">Days of the Month</option>
																		</select>
																	</div>

																	<div class="row">
																		<div class="form-group form-group-sm col-sm-6">
																			<label class="col-sm-12 control-label s-no-paddings" for="formGroupInputSmall">Start Time:</label>
																			<div class="col-sm-12 s-no-paddings">
																				<input type="text" class="form-control" id="input">
																			</div>
																			<div class="clearfix"></div>
																		</div>

																		<div class="form-group form-group-sm col-sm-6">
																			<label class="col-sm-12 control-label s-no-paddings" for="formGroupInputSmall">End Time:</label>
																			<div class="col-sm-12 s-no-paddings">
																				<input type="text" class="form-control" id="input">
																			</div>
																			<div class="clearfix"></div>
																		</div>
																	</div>

																	<hr/>

																	<div class="form-group s-workflow-checkbox">

																		<label class="col-sm-12 s-no-paddings" for="formGroupInputSmall">End Time:</label>
																		<div class="controls col-sm-6 s-checkbox">
																			<input type="checkbox" id="j-checkbox1" checked="checked" ><label for="j-checkbox1"> Sunday</label>
																			<input type="checkbox" id="j-checkbox2" checked="checked" ><label for="j-checkbox2"> Monday</label>
																			<input type="checkbox" id="j-checkbox3" checked="checked" ><label for="j-checkbox3"> Tuesday</label>
																			<input type="checkbox" id="j-checkbox4" checked="checked" ><label for="j-checkbox4"> Wednesday</label>
																		</div>

																		<div class="controls col-sm-6 s-checkbox">
																			<input type="checkbox" id="j-checkbox4" checked="checked" ><label for="j-checkbox4"> Thursday</label>
																			<input type="checkbox" id="j-checkbox4" checked="checked" ><label for="j-checkbox5"> Friday</label>
																			<input type="checkbox" id="j-checkbox6" checked="checked" ><label for="j-checkbox6"> Saturday</label>
																		</div>

																	</div>

																	<button name="button" class="btn s-btn-ten24 btn-xs s-width-100"> Save Schedule</button>
																</form>
															</div>

														</div>
														<!--- // search --->

													</div>
													<div class="clearfix"></div>
												</div>

											</div>

										</form>
										<!--- //Filter Criteria End --->

									</div>
									<div class="col-xs-3">

										<div class="s-default-list">
											<h4>Schedule:</h4>

											<div class="agenda">
										        <div class="table-responsive">
										            <table class="table table-condensed table-bordered">
										                <!--- <thead>
										                    <tr>
										                        <th>Date</th>
										                        <th>Time</th>
										                    </tr>
										                </thead> --->
										                <tbody>

										                    <!-- Multiple events in a single day (note the rowspan) -->
										                    <tr>
										                        <td class="agenda-date active" rowspan="2">
										                            <div class="dayofmonth">26</div>
										                            <div class="shortdate">July, 2014</div>
										                            <div class="dayofweek text-muted">Monday</div>
										                        </td>
										                        <td class="agenda-time">
										                            9:00 AM
										                        </td>
										                    </tr>
										                    <tr>
										                        <td class="agenda-time">
										                            5:00 PM
										                        </td>
										                    </tr>
										                    <!-- //Multiple events in a single day -->

										                    <!-- Multiple events in a single day (note the rowspan) -->
										                    <tr>
										                        <td class="agenda-date active" rowspan="2">
										                            <div class="dayofmonth">27</div>
										                            <div class="shortdate">July, 2014</div>
										                            <div class="dayofweek text-muted">Tuesday</div>
										                        </td>
										                        <td class="agenda-time">
										                            9:00 AM
										                        </td>
										                    </tr>
										                    <tr>
										                        <td class="agenda-time">
										                            5:00 PM
										                        </td>
										                    </tr>
										                    <!-- //Multiple events in a single day -->

                                                            <!-- Single events (note the rowspan) -->
															<tr>
																<td class="agenda-date active" rowspan="1">
																	<div class="dayofmonth">28</div>
																	<div class="shortdate">July, 2014</div>
																	<div class="dayofweek text-muted">Wednesday</div>
																</td>
																<td class="agenda-time">
																	9:00 AM
																</td>
															</tr>
                                                            <!-- //Single events -->

										                </tbody>
										            </table>
										            <button class="btn btn-xs btn-default">Show More <i class="fa fa-refresh fa-spin"></i></button>
										        </div>
										    </div>

										</div>

										<div class="s-button-select-group">
											<button type="button" class="btn btn-sm s-btn-ten24 s-width-100">Save Trigger</button>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<!--- //Edit Filter Box --->

					<div class="clearfix"></div>

				</div>

			</content>
		</div>
	</div>

	<div class="panel panel-default">
		<a data-toggle="collapse"  href="#collapseTasks">
			<div class="panel-heading">
				<h4 class="panel-title">
					<span>Tasks</span>
					<i class="fa fa-caret-left"></i>
				</h4>
			</div>
		</a>
		<div id="collapseTasks" class="panel-collapse collapse">
			<div class="s-body-box">

				<div class="s-bundle-add-items s-workflow-objs">
					<ul class="list-unstyled s-order-item-options s-negative-obj">

						<li class="s-bundle-add-obj s-no-edit">
							<ul class="list-unstyled list-inline">
								<li class="s-item-type s-tooltip">1</li>
							</ul>
							<ul class="list-unstyled list-inline s-middle">
								<li class="j-tool-tip-item s-bundle-details">Update Order Status</li>
								<li class="j-tool-tip-item s-bundle-details">Active: <span>No</span></li>
							</ul>
							<ul class="list-unstyled list-inline s-last">
								<li class="col-xs-1 j-tool-tip-item s-bundle-details-add"><a class="btn s-btn-dgrey s-edit" data-toggle="collapse" data-target="#s-add-obj-1"><i class="fa fa-pencil"></i></a></li>
								<li class="col-xs-1 j-tool-tip-item s-bundle-details-add"><a class="btn s-btn-dgrey s-remove" data-toggle="collapse" data-target="#s-add-obj-1"><i class="fa fa-trash"></i></a></li>
							</ul>
							<div class="clearfix"></div>
						</li>
						<div class="s-bundle-edit-obj collapse" id="s-add-obj-1">

							<div class="s-body-box">

								<div class="col-xs-12 s-filter-content">

									<!--- Header nav with title starts --->
									<div class="row s-header-bar">
										<div class="col-md-12 s-header-nav">
											<ul class="nav nav-tabs" role="tablist">
												<li class="active"><a href="##j-basic-2" role="tab" data-toggle="tab">Basic</a></li>
												<li><a href="##j-conditions-2" role="tab" data-toggle="tab">Conditions</a></li>
												<li><a href="##j-actions-2" role="tab" data-toggle="tab">Actions</a></li>
											</ul>
										</div>
									</div>
									<!--- //Header nav with title end --->

									<!--- Tab panes for menu options start--->
									<div class="row s-options s-task-actions">
										<div class="tab-content" id="j-property-box">

											<div class="tab-pane active" id="j-basic-2">

												<div class="row">
													<div class="col-xs-4">

														<div class="s-create-obj-window">

															<div class="form-group">
																<label>Task Name:</label>
																<input type="text" class="form-control" placeholder="">
															</div>

															<div class="form-group">
																<label>Active:</label>

																<div class="radio">
																	<input type="radio" name="radio1" id="radio2" value="option2" checked="checked">
																	<label for="radio2">
																			Yes
																	</label>
																</div>
																<div class="radio">
																	<input type="radio" name="radio1" id="radio3" value="option3">
																	<label for="radio3">
																			No
																	</label>
																</div>
															</div>
														</div>

													</div>
												</div>

											</div>

											<div class="tab-pane" id="j-conditions-2">
												<div class="s-setting-options">
													<div class="row s-setting-options-body">

														<!--- Start Filter Group --->
														<div class="col-xs-12 s-filters-selected">
															<div class="row">
																<ul class="col-xs-12 list-unstyled">

																	<li>

																		<!--- Filter display --->
																		<div class="s-filter-item">
																			<!--- <div class="btn-group-vertical">
																				<button class="btn btn-xs btn-default">OR</button>
																				<button class="btn btn-xs btn-default active">AND</button>
																			</div> --->
																			<div class="panel panel-default">
																				<div class="panel-heading">Filter 1 <a href="##" class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="" data-original-title="Remove"><i class="fa fa-times"></i></a></div>
																				<div data-toggle="collapse" data-target="#j-edit-filter-z" class="panel-body j-tool-tip-item" data-toggle="tooltip" data-placement="bottom" title="Click To Edit">
																					Example 1 <a href="##"><i class="fa fa-pencil-square-o"></i></a>
																				</div>
																			</div>
																		</div>
																		<!--- //Filter display --->

																		<!--- Edit Filter Box --->
																		<div class="col-xs-12 collapse s-add-filter" id="j-edit-filter-z">
																			<div class="row">
																				<h4> Define Filters: <span>Orders</span><i class="fa fa-times" data-toggle="collapse" data-target="#j-edit-filter-z"></i></h4>
																				<div class="col-xs-12">

																					<div class="row s-flex-col">
																						<div class="col-xs-3">
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
																										<button class="btn btn-xs s-btn-dgrey" id="j-edit-btn"><i class="fa fa-times"></i> Remove</button>
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
																										<button class="btn btn-xs s-btn-dgrey" id="j-edit-btn"><i class="fa fa-times"></i> Remove</button>
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
																			<div class="btn-group-vertical">
																				<button class="btn btn-xs btn-default">OR</button>
																				<button class="btn btn-xs btn-default active">AND</button>
																			</div>
																			<div class="panel panel-default s-filter-group-style">
																				<div class="panel-heading">Example Group 1 <a href="##" class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="" data-original-title="Remove"><i class="fa fa-times"></i></a></div>
																				<div data-toggle="collapse" data-target="#j-nested-filter-f" class="panel-body j-tool-tip-item" data-toggle="tooltip" data-placement="bottom" title="Click To Edit">
																					(3) Filters <a href="##"><i class="fa fa-inbox"></i></a>
																				</div>
																			</div>
																		</div>
																		<!--- //Filter display --->

																		<!---Nested Filter Box --->
																		<div class="col-xs-12 collapse" id="j-nested-filter-f">
																			<div class="row">
																				<ul class="col-xs-12 list-unstyled s-no-paddings">

																					<!--- Filter display --->
																					<li >

																						<!--- Nested Filter Display --->
																						<div class="s-filter-item">
																							<!--- <div class="btn-group-vertical btn-toggle">
																								<button class="btn btn-xs btn-default">AND</button>
																								<button class="btn btn-xs btn-defualt active">OR</button>adsf
																							</div> --->
																							<div class="panel panel-default">
																								<div class="panel-heading">Gender <a href="##" class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="" data-original-title="Remove"><i class="fa fa-times"></i></a></div>
																								<div data-toggle="collapse" data-target="#j-edit-filter-j" class="panel-body j-tool-tip-item" data-toggle="tooltip" data-placement="bottom" title="Click To Edit">
																									Male 2 <a href="##"><i class="fa fa-pencil-square-o"></i></a>
																								</div>
																							</div>
																						</div>
																						<!--- //Nested Filter Display --->

																						<!--- Edit Filter Box --->
																						<div class="col-xs-12 collapse s-add-filter" id="j-edit-filter-j">
																							<div class="row">
																								<div class="col-xs-12">
																									<h4> Define Filters: <span>Orders</span><i class="fa fa-times" data-toggle="collapse" data-target="#j-edit-filter-j"></i></h4>
																									<div class="row">
																										<div class="col-xs-3">
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
																										<div class="col-xs-6 s-criteria">
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
																										<div class="col-xs-3">
																											<div class="s-button-select-group">
																												<button type="button" class="btn s-btn-ten24">Save & Add Another Button</button>
																												<div class="s-or-box">OR</div>
																												<button type="button" class="btn s-btn-ten24">Save & Finish</button>
																											</div>
																											<!--- <div class="form-group">
																												<div class="s-checkbox"><input type="checkbox" id="j-checkbox31"><label for="j-checkbox31"> Add To New Group</label></div>
																											</div> --->
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
																							<button type="button" class="btn btn-xs btn-default" data-toggle="collapse" data-target="#j-add-filter"><i class="fa fa-plus"></i> Save & Add Another</button>
																							<button type="button" class="btn btn-xs btn-default" data-toggle="collapse" data-target="#j-add-filter-group"><i class="fa fa-plus"></i> Save & Finish</button>
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
																			<button type="button" class="btn btn-xs btn-default" data-toggle="collapse" data-target="#j-add-5"><i class="fa fa-plus"></i> Add</button>
																			<button type="button" class="btn btn-xs btn-default" data-toggle="collapse" data-target="#j-add-another-5"><i class="fa fa-plus"></i> Add a New Group</button>
																		</div>
																		<!--- //New Filter Panel Buttons --->
																	</li>

																</ul>
															</div>

															<!--- New Filter Panel --->
															<div class="s-add-filter-box">

																<!--- Edit Filter Box --->
																<div class="col-xs-12 collapse s-add-filter" id="j-add-5">
																	<div class="row">
																		<h4> Define Condition: <span>Orders</span> <i class="fa fa-times" data-toggle="collapse" data-target="#j-add-5"></i></h4>
																		<div class="col-xs-12">

																			<div class="rown s-flex-col">
																				<div class="col-xs-3">

																					<div>
																						<div class="form-group">
																							<label class="s-width-100">Type:</label>

																							<select class="form-control input-sm">
																								<option value="Order">Order</option>
																								<option value="- Order ID">- Order ID</option>
																								<option value="- Order Date">- Order Date</option>
																								<option selected="" value="- Order Total">- Order Total</option>
																								<option value="-------------------">-------------------</option>
																								<option value="ACCOUNT">ACCOUNT</option>
																								<option value="SESSION">SESSION</option>
																								<option value="TRIGGER">TRIGGER</option>
																							</select>

																						</div>
																					</div>

																				</div>
																				<div class="col-xs-6 s-criteria">

																					<h4>Criteria</h4>
																					<!--- Filter Criteria Start --->
																					<form action="index.html" method="post">

																						<div class="form-group form-group-sm">
																							<div class="col-sm-3 s-no-paddings">

																								<select class="form-control input-sm">
																									<option selected="" value="=">=</option>
																									<option value=">">&gt;</option>
																									<option value=">">&gt;</option>
																									<option value="<">&lt;</option>
																									<option value=">=">&gt;=</option>
																									<option value="<=">&lt;=</option>
																									<option value="<>">&lt;&gt;</option>
																									<option value="NULL">NULL</option>
																									<option value="Changed">Changed</option>
																								</select>

																							</div>
																							<div class="col-sm-6">
																								<input class="form-control" type="text" name="some_name" value="">
																							</div>
																							<div class="clearfix"></div>
																						</div>
																						<div class="controls s-checkbox">
																							<input type="checkbox" id="j-checkbox7" checked="checked" ><label for="j-checkbox7"> Apply to pre-event data</label>
																						</div>

																					</form>
																					<!--- //Filter Criteria End --->

																				</div>
																				<div class="col-xs-3">
																					<div class="s-button-select-group">
																						<button type="button" class="btn btn-sm s-btn-ten24">Save & Add Another</button>
																						<div class="s-or-box">-OR-</div>
																						<button type="button" class="btn btn-sm s-btn-ten24">Save & Finish</button>
																					</div>
																				</div>
																			</div>
																		</div>
																	</div>
																</div>
																<!--- //Edit Filter Box --->

																<!--- Edit Filter Box --->
																<div class="col-xs-12 collapse s-add-filter" id="j-add-another-5">
																	<div class="row">
																		<h4> Define Condition: <span>Orders</span> <i class="fa fa-times" data-toggle="collapse" data-target="#j-add-another-5"></i></h4>
																		<div class="col-xs-12">

																			<div class="row s-flex-col">
																				<div class="col-xs-3">

																					<div>
																						<div class="form-group">
																							<label class="s-width-100">Type:</label>

																							<select class="form-control input-sm">
																								<option value="Order">Order</option>
																								<option value="- Order ID">- Order ID</option>
																								<option value="- Order Date">- Order Date</option>
																								<option selected="" value="- Order Total">- Order Total</option>
																								<option value="-------------------">-------------------</option>
																								<option value="ACCOUNT">ACCOUNT</option>
																								<option value="SESSION">SESSION</option>
																								<option value="TRIGGER">TRIGGER</option>
																							</select>

																						</div>
																					</div>

																				</div>
																				<div class="col-xs-6 s-criteria">

																					<h4>Criteria</h4>
																					<!--- Filter Criteria Start --->
																					<form action="index.html" method="post">

																						<div class="form-group form-group-sm">
																							<div class="col-sm-3 s-no-paddings">

																								<select class="form-control input-sm">
																									<option selected="" value="=">=</option>
																									<option value=">">&gt;</option>
																									<option value=">">&gt;</option>
																									<option value="<">&lt;</option>
																									<option value=">=">&gt;=</option>
																									<option value="<=">&lt;=</option>
																									<option value="<>">&lt;&gt;</option>
																									<option value="NULL">NULL</option>
																									<option value="Changed">Changed</option>
																								</select>

																							</div>
																							<div class="col-sm-6">
																								<input class="form-control" type="text" name="some_name" value="">
																							</div>
																							<div class="clearfix"></div>
																						</div>
																						<div class="controls s-checkbox">
																							<input type="checkbox" id="j-checkbox8" checked="checked" ><label for="j-checkbox8"> Apply to pre-event data</label>
																						</div>

																					</form>
																					<!--- //Filter Criteria End --->

																				</div>
																				<div class="col-xs-3">
																					<div class="s-button-select-group">
																						<button type="button" class="btn btn-sm s-btn-ten24">Save & Add Another</button>
																						<div class="s-or-box">-OR-</div>
																						<button type="button" class="btn btn-sm s-btn-ten24">Save & Finish</button>
																					</div>
																				</div>
																			</div>
																		</div>
																	</div>
																</div>
																<!--- //Edit Filter Box --->

															</div>
															<!--- //New Filter Panel --->
														</div>
														<!--- //End Filter Group --->

													</div>
												</div>
											</div>

											<div class="tab-pane" id="j-actions-2">
												<div class="s-bundle-add-items s-workflow-objs s-sortable">
													<ul class="list-unstyled s-order-item-options">

														<li class="s-bundle-add-obj">
															<ul class="list-unstyled list-inline">
																<li class="s-item-type">1</li>
																<li class="s-item-type"><i class="fa fa-arrows-v"></i></li>
															</ul>
															<ul class="list-unstyled list-inline s-middle">
																<li class="j-tool-tip-item s-bundle-details">Type: <span>E-Mail</span></li>
																<li class="j-tool-tip-item s-bundle-details">Object: <span>Order</span></li>
																<li class="j-tool-tip-item s-bundle-details">Detail: <span>Order Feedback Template</span></li>
															</ul>
															<ul class="list-unstyled list-inline s-last">
																<li class="col-xs-1 j-tool-tip-item s-bundle-details-add"><a class="btn s-btn-dgrey s-remove"><i class="fa fa-trash"></i></a></li>
															</ul>
															<div class="clearfix"></div>
														</li>

														<li class="s-bundle-add-obj">
															<ul class="list-unstyled list-inline">
																<li class="s-item-type">2</li>
																<li class="s-item-type"><i class="fa fa-arrows-v"></i></li>
															</ul>
															<ul class="list-unstyled list-inline s-middle">
																<li class="j-tool-tip-item s-bundle-details">Type: <span>E-Mail</span></li>
																<li class="j-tool-tip-item s-bundle-details">Object: <span>Order</span></li>
																<li class="j-tool-tip-item s-bundle-details">Detail: <span>Order Feedback Template</span></li>
															</ul>
															<ul class="list-unstyled list-inline s-last">
																<li class="col-xs-1 j-tool-tip-item s-bundle-details-add"><a class="btn s-btn-dgrey s-remove"><i class="fa fa-trash"></i></a></li>
															</ul>
															<div class="clearfix"></div>
														</li>

													</ul>
												</div>

												<div class="form-group">

													<button class="btn btn-xs s-btn-ten24" data-toggle="collapse" data-target="#j-add-action-b"><i class="fa fa-plus"></i> Add Action</button>

												</div>

												<!--- Edit Filter Box --->
												<div class="col-xs-12 collapse s-add-filter" id="j-add-action-b">
													<div class="row">
														<h4> Add Action <i class="fa fa-times" data-toggle="collapse" data-target="#j-add-action-b"></i></h4>
														<div class="col-xs-12">

															<div class="row s-flex-col">
																<div class="col-xs-3">

																	<div class="form-group form-group-sm">
																		<label for="" class="s-width-100">Select Action Type:</label>
																		<select class="form-control input-sm">
																			<option>Print</option>
																			<option>Email</option>
																			<option>Update</option>
																			<option>Process</option>
																			<option>Import</option>
																			<option>Export</option>
																			<option>Delete</option>
																		</select>
																	</div>

																	<div class="form-group form-group-sm">
																		<label for="" class="s-width-100">Select Object:</label>
																		<select class="form-control input-sm">
																			<option>Orders</option>
																			<option>Related Objects</option>
																			<option>Account</option>
																			<option>Order Item</option>
																		</select>
																	</div>

																</div>
																<div class="col-xs-6 s-criteria">

																	<!--- Filter Criteria Start --->
																	<div class="s-filter-group-item">

																		<h4>Print Template</h4>
																		<div class="form-group form-group-sm">

																			<!--- search --->
																			<div class="s-search-filter">
																				<div class="input-group">
																					<input type="text" class="form-control input-sm j-search-input" placeholder="Search&hellip;">
																					<ul class="dropdown-menu s-search-options">
																						<li><button type="button" class="btn s-btn-dgrey" data-toggle="collapse" data-target="#j-toggle-add-bundle-type"><i class="fa fa-plus"></i> Add "This should be the name"</button></li>
																						<li><a>Order Confirmation Template</a></li>
																						<li><a>Order Gift Thank You</a></li>
																						<li><a>Order Feedback</a></li>
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

																		</div>

																		<div class="form-group form-group-sm">
																			<label for="" class="col-sm-12 s-no-paddings">On Success</label>
																			<select class="form-control input-sm">
																				<option value="Proceed to Next Action / Task">Proceed to Next Action / Task</option>
																				<option selected="" value="Select Next Action">Select Next Action</option>
																				<option value="Select Next Task">Select Next Task</option>
																				<option value="Skip to Next Task">Skip to Next Task</option>
																				<option value="Exit Workflow">Exit Workflow</option>
																			</select>
																		</div>
																		<div class="form-group form-group-sm">
																			<select class="form-control input-sm">
																				<option value="- Select Action">- Select Action</option>
																			</select>
																		</div>

																		<div class="form-group form-group-sm">
																			<label for="" class="col-sm-12 s-no-paddings">On Failure</label>
																			<select class="form-control input-sm">
																				<option value="Proceed to Next Action / Task">Proceed to Next Action / Task</option>
																				<option value="Select Next Action">Select Next Action</option>
																				<option value="Select Next Task">Select Next Task</option>
																				<option value="Skip to Next Task">Skip to Next Task</option>
																				<option selected="" value="Exit Workflow">Exit Workflow</option>
																			</select>
																		</div>

																	</div>
																	<!--- //Filter Criteria End --->

/===================================================/


																	<!--- Filter Criteria Start --->
																	<div class="s-filter-group-item">

																		<h4>Update Data</h4>
																		<div class="form-group form-group-sm">
																			<input type="text" class="form-control" placeholder="Ready To Capture">
																			<!--- <p class="help-block">Help text here.</p> --->
																		</div>

																		<div class="form-group form-group-sm">
																			<label for="" class="col-sm-12 s-no-paddings">On Success</label>
																			<select class="form-control input-sm">
																				<option value="Proceed to Next Action / Task">Proceed to Next Action / Task</option>
																				<option selected="" value="Select Next Action">Select Next Action</option>
																				<option value="Select Next Task">Select Next Task</option>
																				<option value="Skip to Next Task">Skip to Next Task</option>
																				<option value="Exit Workflow">Exit Workflow</option>
																			</select>
																		</div>

																		<div class="form-group form-group-sm">
																			<label for="" class="col-sm-12 s-no-paddings"></label>
																			<select class="form-control input-sm">
																				<option value="- Select Action">- Select Action</option>
																			</select>
																		</div>

																		<div class="form-group form-group-sm">
																			<label for="" class="col-sm-12 s-no-paddings">On Failure</label>
																			<select class="form-control input-sm">
																				<option value="Proceed to Next Action / Task">Proceed to Next Action / Task</option>
																				<option value="Select Next Action">Select Next Action</option>
																				<option value="Select Next Task">Select Next Task</option>
																				<option value="Skip to Next Task">Skip to Next Task</option>
																				<option selected="" value="Exit Workflow">Exit Workflow</option>
																			</select>
																		</div>

																	</div>
																	<!--- //Filter Criteria End --->

/===================================================/

																	<!--- Filter Criteria Start --->
																	<div class="s-filter-group-item">

																		<h4>Dynamic Numeric</h4>
																		<div class="row">
																			<div class="col-md-6 form-group form-group-sm">
																				<select class="form-control input-sm">
																					<option value="1">Dynamic Numeric Value</option>
																					<option value="2">Add 'N'</option>
																					<option value="3">Set value to '0'</option>
																					<option value="4">Subtract 'N'</option>
																				</select>
																			</div>
																			<div class="col-md-6 form-group form-group-sm">
																				<input type="number" class="form-control" placeholder="" value="4">
																				<!--- <p class="help-block">Help text here.</p> --->
																			</div>
																		</div>

																	</div>
																	<!--- //Filter Criteria End --->

/===================================================/

																	<!--- Filter Criteria Start --->
																	<div class="s-filter-group-item">
																		<h4>Delete</h4>
																		<div class="form-group form-group-sm s-checkbox">
																			<input type="checkbox" id="j-delete-confirm" checked="checked"><label for="j-delete-confirm"> Confirm "Orders" object will be deleted</label>
																		</div>
																	</div>
																	<!--- //Filter Criteria End --->

																</div>
																<div class="col-xs-3">
																	<div class="s-button-select-group">
																		<button type="button" class="btn btn-sm s-btn-ten24">Save & Add Another</button>
																		<div class="s-or-box">OR-</div>
																		<button type="button" class="btn btn-sm s-btn-ten24">Save & Finish</button>
																	</div>
																</div>
															</div>
														</div>
													</div>
												</div>
												<!--- //Edit Filter Box --->
												<div class="clearfix"></div>
											</div>

										</div>
									</div>
								</div>

							</div>

						</div>

						<li class="s-bundle-add-obj">
							<ul class="list-unstyled list-inline">
								<li class="s-item-type s-tooltip">2</li>
							</ul>
							<ul class="list-unstyled list-inline s-middle">
								<li class="j-tool-tip-item s-bundle-details">Update Order Status</li>
								<li class="j-tool-tip-item s-bundle-details">Active: <span>Yes</span></li>
							</ul>
							<ul class="list-unstyled list-inline s-last">
								<li class="col-xs-1 j-tool-tip-item s-bundle-details-add"><a class="btn s-btn-dgrey s-edit" data-toggle="collapse" data-target="#s-add-obj-2"><i class="fa fa-pencil"></i></a></li>
								<li class="col-xs-1 j-tool-tip-item s-bundle-details-add"><a class="btn s-btn-dgrey s-remove" data-toggle="collapse" data-target="#s-add-obj-2"><i class="fa fa-trash"></i></a></li>
							</ul>
							<div class="clearfix"></div>
						</li>
						<div class="s-bundle-edit-obj collapse" id="s-add-obj-2">

							<div class="s-body-box">

								<div class="col-xs-12 s-filter-content">

									<!--- Header nav with title starts --->
									<div class="row s-header-bar">
										<div class="col-md-12 s-header-nav">
											<ul class="nav nav-tabs" role="tablist">
												<li class="active"><a href="##j-basic-8" role="tab" data-toggle="tab">Basic</a></li>
												<li><a href="##j-conditions-8" role="tab" data-toggle="tab">Conditions</a></li>
												<li><a href="##j-actions-8" role="tab" data-toggle="tab">Actions</a></li>
											</ul>
										</div>
									</div>
									<!--- //Header nav with title end --->

									<!--- Tab panes for menu options start--->
									<div class="row s-options s-task-actions">
										<div class="tab-content" id="j-property-box">

											<div class="tab-pane active" id="j-basic-8">

												<div class="row">
													<div class="col-xs-4">

														<div class="s-create-obj-window">

															<div class="form-group">
																<label>Task Name:</label>
																<input type="text" class="form-control" placeholder="">
															</div>

															<div class="form-group">
																<label>Active:</label>

																<div class="radio">
																	<input type="radio" name="radio1" id="radio2" value="option2" checked="checked">
																	<label for="radio2">
																			Yes
																	</label>
																</div>
																<div class="radio">
																	<input type="radio" name="radio1" id="radio3" value="option3">
																	<label for="radio3">
																			No
																	</label>
																</div>
															</div>

														</div>

													</div>
												</div>

											</div>

											<div class="tab-pane" id="j-conditions-8">
												<div class="s-setting-options">
													<div class="row s-setting-options-body">

														<!--- Start Filter Group --->
														<div class="col-xs-12 s-filters-selected">
															<div class="row">
																<ul class="col-xs-12 list-unstyled">

																	<li>

																		<!--- Filter display --->
																		<div class="s-filter-item">
																			<!--- <div class="btn-group-vertical">
																				<button class="btn btn-xs btn-default">OR</button>
																				<button class="btn btn-xs btn-default active">AND</button>
																			</div> --->
																			<div class="panel panel-default">
																				<div class="panel-heading">Filter 1 <a href="##" class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="" data-original-title="Remove"><i class="fa fa-times"></i></a></div>
																				<div data-toggle="collapse" data-target="#j-edit-filter-b" class="panel-body j-tool-tip-item" data-toggle="tooltip" data-placement="bottom" title="Click To Edit">
																					Example 1 <a href="##"><i class="fa fa-pencil-square-o"></i></a>
																				</div>
																			</div>
																		</div>
																		<!--- //Filter display --->

																		<!--- Edit Filter Box --->
																		<div class="col-xs-12 collapse s-add-filter" id="j-edit-filter-b">
																			<div class="row">
																				<h4> Define Filters: <span>Orders</span><i class="fa fa-times" data-toggle="collapse" data-target="#j-edit-filter-b"></i></h4>
																				<div class="col-xs-12">

																					<div class="row s-flex-col">
																						<div class="col-xs-3">
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
																										<button class="btn btn-xs s-btn-dgrey" id="j-edit-btn"><i class="fa fa-times"></i> Remove</button>
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
																										<button class="btn btn-xs s-btn-dgrey" id="j-edit-btn"><i class="fa fa-times"></i> Remove</button>
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

																						</div>
																						<div class="col-xs-3">
																							<div class="s-button-select-group">
																								<button type="button" class="btn btn-sm s-btn-ten24">Save & Add Another Button</button>
																								<div class="s-or-box">OR-</div>
																								<button type="button" class="btn btn-sm s-btn-ten24">Save & Finish</button>
																							</div>
																							<!--- <div class="form-group">
																								<div class="s-checkbox"><input type="checkbox" id="j-checkbox21"><label for="j-checkbox21"> Add To New Group</label></div>
																							</div> --->
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
																			<div class="btn-group-vertical">
																				<button class="btn btn-xs btn-default">OR</button>
																				<button class="btn btn-xs btn-default active">AND</button>
																			</div>
																			<div class="panel panel-default s-filter-group-style">
																				<div class="panel-heading">Example Group 1 <a href="##" class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="" data-original-title="Remove"><i class="fa fa-times"></i></a></div>
																				<div data-toggle="collapse" data-target="#j-nested-filter-b" class="panel-body j-tool-tip-item" data-toggle="tooltip" data-placement="bottom" title="Click To Edit">
																					(3) Filters <a href="##"><i class="fa fa-inbox"></i></a>
																				</div>
																			</div>
																		</div>
																		<!--- //Filter display --->

																		<!---Nested Filter Box --->
																		<div class="col-xs-12 collapse" id="j-nested-filter-b">
																			<div class="row">
																				<ul class="col-xs-12 list-unstyled s-no-paddings">

																					<!--- Filter display --->
																					<li >

																						<!--- Nested Filter Display --->
																						<div class="s-filter-item">
																							<!--- <div class="btn-group-vertical btn-toggle">
																								<button class="btn btn-xs btn-default">AND</button>
																								<button class="btn btn-xs btn-defualt active">OR</button>adsf
																							</div> --->
																							<div class="panel panel-default">
																								<div class="panel-heading">Gender <a href="##" class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="" data-original-title="Remove"><i class="fa fa-times"></i></a></div>
																								<div data-toggle="collapse" data-target="#j-edit-filter-1-1" class="panel-body j-tool-tip-item" data-toggle="tooltip" data-placement="bottom" title="Click To Edit">
																									Male 2 <a href="##"><i class="fa fa-pencil-square-o"></i></a>
																								</div>
																							</div>
																						</div>
																						<!--- //Nested Filter Display --->

																						<!--- Edit Filter Box --->
																						<div class="col-xs-12 collapse s-add-filter" id="j-edit-filter-1-1">
																							<div class="row">
																								<div class="col-xs-12">
																									<h4> Define Filters: <span>Orders</span><i class="fa fa-times" data-toggle="collapse" data-target="#j-nested-filter-b"></i></h4>
																									<div class="row s-flex-col">
																										<div class="col-xs-3">
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
																										<div class="col-xs-6 s-criteria">
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
																										<div class="col-xs-3">
																											<div class="s-button-select-group">
																												<button type="button" class="btn s-btn-ten24">Save & Add Another Button</button>
																												<div class="s-or-box">OR</div>
																												<button type="button" class="btn s-btn-ten24">Save & Finish</button>
																											</div>
																											<!--- <div class="form-group">
																												<div class="s-checkbox"><input type="checkbox" id="j-checkbox31"><label for="j-checkbox31"> Add To New Group</label></div>
																											</div> --->
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
																							<button type="button" class="btn btn-xs btn-default" data-toggle="collapse" data-target="#j-add-filter"><i class="fa fa-plus"></i> Save & Add Another</button>
																							<button type="button" class="btn btn-xs btn-default" data-toggle="collapse" data-target="#j-add-filter-group"><i class="fa fa-plus"></i> Save & Finish</button>
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
																			<button type="button" class="btn btn-xs btn-default" data-toggle="collapse" data-target="#j-add-2"><i class="fa fa-plus"></i> Add</button>
																			<button type="button" class="btn btn-xs btn-default" data-toggle="collapse" data-target="#j-add-another-2"><i class="fa fa-plus"></i> Add a New Group</button>
																		</div>
																		<!--- //New Filter Panel Buttons --->
																	</li>

																</ul>
															</div>

															<!--- New Filter Panel --->
															<div class="s-add-filter-box">

																<!--- Edit Filter Box --->
																<div class="col-xs-12 collapse s-add-filter" id="j-add-2">
																	<div class="row">
																		<h4> Define Condition: <span>Orders</span> <i class="fa fa-times" data-toggle="collapse" data-target="#j-add-2"></i></h4>
																		<div class="col-xs-12">

																			<div class="row s-flex-col">
																				<div class="col-xs-3">

																					<div>
																						<div class="form-group">
																							<label class="s-width-100">Type:</label>

																							<select class="form-control input-sm">
																								<option value="Order">Order</option>
																								<option value="- Order ID">- Order ID</option>
																								<option value="- Order Date">- Order Date</option>
																								<option selected="" value="- Order Total">- Order Total</option>
																								<option value="-------------------">-------------------</option>
																								<option value="ACCOUNT">ACCOUNT</option>
																								<option value="SESSION">SESSION</option>
																								<option value="TRIGGER">TRIGGER</option>
																							</select>

																						</div>
																					</div>

																				</div>
																				<div class="col-xs-6 s-criteria">

																					<h4>Criteria</h4>
																					<!--- Filter Criteria Start --->
																					<form action="index.html" method="post">

																						<div class="form-group form-group-sm">
																							<div class="col-sm-3 s-no-paddings">

																								<select class="form-control input-sm">
																									<option selected="" value="=">=</option>
																									<option value=">">&gt;</option>
																									<option value=">">&gt;</option>
																									<option value="<">&lt;</option>
																									<option value=">=">&gt;=</option>
																									<option value="<=">&lt;=</option>
																									<option value="<>">&lt;&gt;</option>
																									<option value="NULL">NULL</option>
																									<option value="Changed">Changed</option>
																								</select>

																							</div>
																							<div class="col-sm-6">
																								<input class="form-control" type="text" name="some_name" value="">
																							</div>
																							<div class="clearfix"></div>
																						</div>
																						<div class="controls s-checkbox">
																							<input type="checkbox" id="j-checkbox7" checked="checked" ><label for="j-checkbox7"> Apply to pre-event data</label>
																						</div>

																					</form>
																					<!--- //Filter Criteria End --->

																				</div>
																				<div class="col-xs-3">
																					<div class="s-button-select-group">
																						<button type="button" class="btn btn-sm s-btn-ten24">Save & Add Another</button>
																						<div class="s-or-box">-OR-</div>
																						<button type="button" class="btn btn-sm s-btn-ten24">Save & Finish</button>
																					</div>
																				</div>
																			</div>
																		</div>
																	</div>
																</div>
																<!--- //Edit Filter Box --->

																<!--- Edit Filter Box --->
																<div class="col-xs-12 collapse s-add-filter" id="j-add-another-2">
																	<div class="row">
																		<h4> Define Condition: <span>Orders</span> <i class="fa fa-times" data-toggle="collapse" data-target="#j-add-another-2"></i></h4>
																		<div class="col-xs-12">

																			<div class="row s-flex-col">
																				<div class="col-xs-3">

																					<div>
																						<div class="form-group">
																							<label class="s-width-100">Type:</label>

																							<select class="form-control input-sm">
																								<option value="Order">Order</option>
																								<option value="- Order ID">- Order ID</option>
																								<option value="- Order Date">- Order Date</option>
																								<option selected="" value="- Order Total">- Order Total</option>
																								<option value="-------------------">-------------------</option>
																								<option value="ACCOUNT">ACCOUNT</option>
																								<option value="SESSION">SESSION</option>
																								<option value="TRIGGER">TRIGGER</option>
																							</select>

																						</div>
																					</div>

																				</div>
																				<div class="col-xs-6 s-criteria">

																					<h4>Criteria</h4>
																					<!--- Filter Criteria Start --->
																					<form action="index.html" method="post">

																						<div class="form-group form-group-sm">
																							<div class="col-sm-3 s-no-paddings">

																								<select class="form-control input-sm">
																									<option selected="" value="=">=</option>
																									<option value=">">&gt;</option>
																									<option value=">">&gt;</option>
																									<option value="<">&lt;</option>
																									<option value=">=">&gt;=</option>
																									<option value="<=">&lt;=</option>
																									<option value="<>">&lt;&gt;</option>
																									<option value="NULL">NULL</option>
																									<option value="Changed">Changed</option>
																								</select>

																							</div>
																							<div class="col-sm-6">
																								<input class="form-control" type="text" name="some_name" value="">
																							</div>
																							<div class="clearfix"></div>
																						</div>
																						<div class="controls s-checkbox">
																							<input type="checkbox" id="j-checkbox8" checked="checked" ><label for="j-checkbox8"> Apply to pre-event data</label>
																						</div>

																					</form>
																					<!--- //Filter Criteria End --->

																				</div>
																				<div class="col-xs-3">
																					<div class="s-button-select-group">
																						<button type="button" class="btn btn-sm s-btn-ten24">Save & Add Another</button>
																						<div class="s-or-box">-OR-</div>
																						<button type="button" class="btn btn-sm s-btn-ten24">Save & Finish</button>
																					</div>
																				</div>
																			</div>
																		</div>
																	</div>
																</div>
																<!--- //Edit Filter Box --->

															</div>
															<!--- //New Filter Panel --->
														</div>
														<!--- //End Filter Group --->

													</div>
												</div>
											</div>

											<div class="tab-pane" id="j-actions-8">
												<div class="s-bundle-add-items s-workflow-objs s-sortable">
													<ul class="list-unstyled s-order-item-options">

														<li class="s-bundle-add-obj">
															<ul class="list-unstyled list-inline">
																<li class="s-item-type">1</li>
																<li class="s-item-type"><i class="fa fa-arrows-v"></i></li>
															</ul>
															<ul class="list-unstyled list-inline s-middle">
																<li class="j-tool-tip-item s-bundle-details">Type: <span>E-Mail</span></li>
																<li class="j-tool-tip-item s-bundle-details">Object: <span>Order</span></li>
																<li class="j-tool-tip-item s-bundle-details">Detail: <span>Order Feedback Template</span></li>
															</ul>
															<ul class="list-unstyled list-inline s-last">
																<li class="col-xs-1 j-tool-tip-item s-bundle-details-add"><a class="btn s-btn-dgrey s-remove"><i class="fa fa-trash"></i></a></li>
															</ul>
															<div class="clearfix"></div>
														</li>

														<li class="s-bundle-add-obj">
															<ul class="list-unstyled list-inline">
																<li class="s-item-type">2</li>
																<li class="s-item-type"><i class="fa fa-arrows-v"></i></li>
															</ul>
															<ul class="list-unstyled list-inline s-middle">
																<li class="j-tool-tip-item s-bundle-details">Type: <span>E-Mail</span></li>
																<li class="j-tool-tip-item s-bundle-details">Object: <span>Order</span></li>
																<li class="j-tool-tip-item s-bundle-details">Detail: <span>Order Feedback Template</span></li>
															</ul>
															<ul class="list-unstyled list-inline s-last">
																<li class="col-xs-1 j-tool-tip-item s-bundle-details-add"><a class="btn s-btn-dgrey s-remove"><i class="fa fa-trash"></i></a></li>
															</ul>
															<div class="clearfix"></div>
														</li>

													</ul>
												</div>

												<div class="form-group">

													<button class="btn btn-xs s-btn-ten24" data-toggle="collapse" data-target="#j-add-action-b"><i class="fa fa-plus"></i> Add Action</button>

												</div>

												<!--- Edit Filter Box --->
												<div class="col-xs-12 collapse s-add-filter" id="j-add-action-b">
													<div class="row">
														<h4> Add Action <i class="fa fa-times" data-toggle="collapse" data-target="#j-add-action-b"></i></h4>
														<div class="col-xs-12">

															<div class="row s-flex-col">
																<div class="col-xs-3">

																	<div class="form-group form-group-sm">
																		<label for="" class="s-width-100">Select Action Type:</label>
																		<select class="form-control input-sm">
																			<option>Print</option>
																			<option>Email</option>
																			<option>Update</option>
																			<option>Process</option>
																			<option>Import</option>
																			<option>Export</option>
																			<option>Delete</option>
																		</select>
																	</div>

																	<div class="form-group form-group-sm">
																		<label for="" class="s-width-100">Select Object:</label>
																		<select class="form-control input-sm">
																			<option>Orders</option>
																			<option>Related Objects</option>
																			<option>Account</option>
																			<option>Order Item</option>
																		</select>
																	</div>

																</div>
																<div class="col-xs-6 s-criteria">

																	<!--- Filter Criteria Start --->
																	<div class="s-filter-group-item">

																		<h4>Print Template</h4>
																		<div class="form-group form-group-sm">

																			<!--- search --->
																			<div class="s-search-filter">
																				<div class="input-group">
																					<input type="text" class="form-control input-sm j-search-input" placeholder="Search&hellip;">
																					<ul class="dropdown-menu s-search-options">
																						<li><button type="button" class="btn s-btn-dgrey" data-toggle="collapse" data-target="#j-toggle-add-bundle-type"><i class="fa fa-plus"></i> Add "This should be the name"</button></li>
																						<li><a>Order Confirmation Template</a></li>
																						<li><a>Order Gift Thank You</a></li>
																						<li><a>Order Feedback</a></li>
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

																		</div>

																		<div class="form-group form-group-sm">
																			<label for="" class="col-sm-12 s-no-paddings">On Success</label>
																			<select class="form-control input-sm">
																				<option value="Proceed to Next Action / Task">Proceed to Next Action / Task</option>
																				<option selected="" value="Select Next Action">Select Next Action</option>
																				<option value="Select Next Task">Select Next Task</option>
																				<option value="Skip to Next Task">Skip to Next Task</option>
																				<option value="Exit Workflow">Exit Workflow</option>
																			</select>
																		</div>
																		<div class="form-group form-group-sm">
																			<select class="form-control input-sm">
																				<option value="- Select Action">- Select Action</option>
																			</select>
																		</div>

																		<div class="form-group form-group-sm">
																			<label for="" class="col-sm-12 s-no-paddings">On Failure</label>
																			<select class="form-control input-sm">
																				<option value="Proceed to Next Action / Task">Proceed to Next Action / Task</option>
																				<option value="Select Next Action">Select Next Action</option>
																				<option value="Select Next Task">Select Next Task</option>
																				<option value="Skip to Next Task">Skip to Next Task</option>
																				<option selected="" value="Exit Workflow">Exit Workflow</option>
																			</select>
																		</div>

																	</div>
																	<!--- //Filter Criteria End --->

/===================================================/


																	<!--- Filter Criteria Start --->
																	<div class="s-filter-group-item">

																		<h4>Update Data</h4>
																		<div class="form-group form-group-sm">
																			<input type="text" class="form-control" placeholder="Ready To Capture">
																			<!--- <p class="help-block">Help text here.</p> --->
																		</div>

																		<div class="form-group form-group-sm">
																			<label for="" class="col-sm-12 s-no-paddings">On Success</label>
																			<select class="form-control input-sm">
																				<option value="Proceed to Next Action / Task">Proceed to Next Action / Task</option>
																				<option selected="" value="Select Next Action">Select Next Action</option>
																				<option value="Select Next Task">Select Next Task</option>
																				<option value="Skip to Next Task">Skip to Next Task</option>
																				<option value="Exit Workflow">Exit Workflow</option>
																			</select>
																		</div>

																		<div class="form-group form-group-sm">
																			<label for="" class="col-sm-12 s-no-paddings"></label>
																			<select class="form-control input-sm">
																				<option value="- Select Action">- Select Action</option>
																			</select>
																		</div>

																		<div class="form-group form-group-sm">
																			<label for="" class="col-sm-12 s-no-paddings">On Failure</label>
																			<select class="form-control input-sm">
																				<option value="Proceed to Next Action / Task">Proceed to Next Action / Task</option>
																				<option value="Select Next Action">Select Next Action</option>
																				<option value="Select Next Task">Select Next Task</option>
																				<option value="Skip to Next Task">Skip to Next Task</option>
																				<option selected="" value="Exit Workflow">Exit Workflow</option>
																			</select>
																		</div>

																	</div>
																	<!--- //Filter Criteria End --->

/===================================================/

																	<!--- Filter Criteria Start --->
																	<div class="s-filter-group-item">

																		<h4>Dynamic Numeric</h4>
																		<div class="row">
																			<div class="col-md-6 form-group form-group-sm">
																				<select class="form-control input-sm">
																					<option value="1">Dynamic Numeric Value</option>
																					<option value="2">Add 'N'</option>
																					<option value="3">Set value to '0'</option>
																					<option value="4">Subtract 'N'</option>
																				</select>
																			</div>
																			<div class="col-md-6 form-group form-group-sm">
																				<input type="number" class="form-control" placeholder="" value="4">
																				<!--- <p class="help-block">Help text here.</p> --->
																			</div>
																		</div>

																	</div>
																	<!--- //Filter Criteria End --->

/===================================================/

																	<!--- Filter Criteria Start --->
																	<div class="s-filter-group-item">
																		<h4>Delete</h4>
																		<div class="form-group form-group-sm s-checkbox">
																			<input type="checkbox" id="j-delete-confirm" checked="checked"><label for="j-delete-confirm"> Confirm "Orders" object will be deleted</label>
																		</div>
																	</div>
																	<!--- //Filter Criteria End --->

																</div>
																<div class="col-xs-3">
																	<div class="s-button-select-group">
																		<button type="button" class="btn btn-sm s-btn-ten24">Save & Add Another</button>
																		<div class="s-or-box">OR-</div>
																		<button type="button" class="btn btn-sm s-btn-ten24">Save & Finish</button>
																	</div>
																</div>
															</div>
														</div>
													</div>
												</div>
												<!--- //Edit Filter Box --->
												<div class="clearfix"></div>
											</div>

										</div>
									</div>
								</div>

							</div>

						</div>

					</ul>
				</div>

				<button class="btn btn-xs s-btn-ten24" data-toggle="collapse" data-target="#j-create-new-task"><i class="fa fa-plus"></i> Create New Task</button>

				<!--- Edit Filter Box --->
				<div class="col-xs-12 collapse s-add-filter s-tab-layout" id="j-create-new-task">
					<div class="row">
						<h4> Create New Task <i class="fa fa-times" data-toggle="collapse" data-target="#j-create-new-task"></i></h4>
						<div class="s-body-box">

								<div class="col-xs-12 s-filter-content">

									<!--- Header nav with title starts --->
									<div class="row s-header-bar">
										<div class="col-md-12 s-header-nav">
											<ul class="nav nav-tabs" role="tablist">
												<li class="active"><a href="##j-basic-3" role="tab" data-toggle="tab">Basic</a></li>
												<li><a href="##j-conditions-3" role="tab" data-toggle="tab">Conditions</a></li>
												<li><a href="##j-actions-3" role="tab" data-toggle="tab">Actions</a></li>
											</ul>
										</div>
									</div>
									<!--- //Header nav with title end --->

									<!--- Tab panes for menu options start--->
									<div class="row s-options s-task-actions">
										<div class="tab-content" id="j-property-box">

											<div class="tab-pane active" id="j-basic-3">

												<div class="row s-flex-col">
													<div class="col-xs-3">

														<div class="s-create-obj-window">

															<div class="form-group">
																<label>Task Name:</label>
																<input type="text" class="form-control" placeholder="">
															</div>

															<div class="form-group">
																<label>Active:</label>

																<div class="radio">
																	<input type="radio" name="radio1" id="radio2" value="option2" checked="checked">
																	<label for="radio2">
																			Yes
																	</label>
																</div>
																<div class="radio">
																	<input type="radio" name="radio1" id="radio3" value="option3">
																	<label for="radio3">
																			No
																	</label>
																</div>
															</div>
															<div class="form-group">
																<button class="btn btn-xs s-btn-ten24">Save & Continue</button>
															</div>
														</div>

													</div>
												</div>

											</div>

											<div class="tab-pane" id="j-conditions-3">
												<div class="s-setting-options">
													<div class="row s-setting-options-body">

														<!--- Start Filter Group --->
														<div class="col-xs-12 s-filters-selected">
															<div class="row">
																<ul class="col-xs-12 list-unstyled">

																	<li>

																		<!--- Filter display --->
																		<div class="s-filter-item">
																			<!--- <div class="btn-group-vertical">
																				<button class="btn btn-xs btn-default">OR</button>
																				<button class="btn btn-xs btn-default active">AND</button>
																			</div> --->
																			<div class="panel panel-default">
																				<div class="panel-heading">Filter 1 <a href="##" class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="" data-original-title="Remove"><i class="fa fa-times"></i></a></div>
																				<div data-toggle="collapse" data-target="#j-edit-filter-d" class="panel-body j-tool-tip-item" data-toggle="tooltip" data-placement="bottom" title="Click To Edit">
																					Example 1 <a href="##"><i class="fa fa-pencil-square-o"></i></a>
																				</div>
																			</div>
																		</div>
																		<!--- //Filter display --->

																		<!--- Edit Filter Box --->
																		<div class="col-xs-12 collapse s-add-filter" id="j-edit-filter-d">
																			<div class="row">
																				<h4> Define Filters: <span>Orders</span><i class="fa fa-times" data-toggle="collapse" data-target="#j-edit-filter-d"></i></h4>
																				<div class="col-xs-12">

																					<div class="row s-flex-col">
																						<div class="col-xs-3">
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
																										<button class="btn btn-xs s-btn-dgrey" id="j-edit-btn"><i class="fa fa-times"></i> Remove</button>
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
																										<button class="btn btn-xs s-btn-dgrey" id="j-edit-btn"><i class="fa fa-times"></i> Remove</button>
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

																							</form>
																							<!--- //Filter Criteria End --->

																						</div>
																						<div class="col-xs-3">
																							<div class="s-button-select-group">
																								<button type="button" class="btn btn-sm s-btn-ten24">Save & Add Another Button</button>
																								<div class="s-or-box">OR-</div>
																								<button type="button" class="btn btn-sm s-btn-ten24">Save & Finish</button>
																							</div>
																							<!--- <div class="form-group">
																								<div class="s-checkbox"><input type="checkbox" id="j-checkbox21"><label for="j-checkbox21"> Add To New Group</label></div>
																							</div> --->
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
																			<div class="btn-group-vertical">
																				<button class="btn btn-xs btn-default">OR</button>
																				<button class="btn btn-xs btn-default active">AND</button>
																			</div>
																			<div class="panel panel-default s-filter-group-style">
																				<div class="panel-heading">Example Group 1 <a href="##" class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="" data-original-title="Remove"><i class="fa fa-times"></i></a></div>
																				<div data-toggle="collapse" data-target="#j-nested-filter-c" class="panel-body j-tool-tip-item" data-toggle="tooltip" data-placement="bottom" title="Click To Edit">
																					(3) Filters <a href="##"><i class="fa fa-inbox"></i></a>
																				</div>
																			</div>
																		</div>
																		<!--- //Filter display --->

																		<!---Nested Filter Box --->
																		<div class="col-xs-12 collapse" id="j-nested-filter-c">
																			<div class="row">
																				<ul class="col-xs-12 list-unstyled s-no-paddings">

																					<!--- Filter display --->
																					<li >

																						<!--- Nested Filter Display --->
																						<div class="s-filter-item">
																							<!--- <div class="btn-group-vertical btn-toggle">
																								<button class="btn btn-xs btn-default">AND</button>
																								<button class="btn btn-xs btn-defualt active">OR</button>adsf
																							</div> --->
																							<div class="panel panel-default">
																								<div class="panel-heading">Gender <a href="##" class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="" data-original-title="Remove"><i class="fa fa-times"></i></a></div>
																								<div data-toggle="collapse" data-target="#j-edit-filter-2" class="panel-body j-tool-tip-item" data-toggle="tooltip" data-placement="bottom" title="Click To Edit">
																									Male 2 <a href="##"><i class="fa fa-pencil-square-o"></i></a>
																								</div>
																							</div>
																						</div>
																						<!--- //Nested Filter Display --->

																						<!--- Edit Filter Box --->
																						<div class="col-xs-12 collapse s-add-filter" id="j-edit-filter-2">
																							<div class="row">
																								<div class="col-xs-12">
																									<h4> Define Filters: <span>Orders</span><i class="fa fa-times" data-toggle="collapse" data-target="#j-edit-filter-2"></i></h4>
																									<div class="row s-flex-col">
																										<div class="col-xs-3">
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
																										<div class="col-xs-6 s-criteria">
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
																										<div class="col-xs-3">
																											<div class="s-button-select-group">
																												<button type="button" class="btn s-btn-ten24">Save & Add Another Button</button>
																												<div class="s-or-box">OR</div>
																												<button type="button" class="btn s-btn-ten24">Save & Finish</button>
																											</div>
																											<!--- <div class="form-group">
																												<div class="s-checkbox"><input type="checkbox" id="j-checkbox31"><label for="j-checkbox31"> Add To New Group</label></div>
																											</div> --->
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
																							<button type="button" class="btn btn-xs btn-default" data-toggle="collapse" data-target="#j-add-filter"><i class="fa fa-plus"></i> Save & Add Another</button>
																							<button type="button" class="btn btn-xs btn-default" data-toggle="collapse" data-target="#j-add-filter-group"><i class="fa fa-plus"></i> Save & Finish</button>
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
																			<button type="button" class="btn btn-xs btn-default" data-toggle="collapse" data-target="#j-add-4"><i class="fa fa-plus"></i> Add</button>
																			<button type="button" class="btn btn-xs btn-default" data-toggle="collapse" data-target="#j-add-another-4"><i class="fa fa-plus"></i> Add a New Group</button>
																		</div>
																		<!--- //New Filter Panel Buttons --->
																	</li>

																</ul>
															</div>

															<!--- New Filter Panel --->
															<div class="s-add-filter-box">

																<!--- Edit Filter Box --->
																<div class="col-xs-12 collapse s-add-filter" id="j-add-4">
																	<div class="row">
																		<h4> Define Condition: <span>Orders</span> <i class="fa fa-times" data-toggle="collapse" data-target="#j-add-2"></i></h4>
																		<div class="col-xs-12">

																			<div class="row s-flex-col">
																				<div class="col-xs-3">

																					<div>
																						<div class="form-group">
																							<label class="s-width-100">Type:</label>

																							<select class="form-control input-sm">
																								<option value="Order">Order</option>
																								<option value="- Order ID">- Order ID</option>
																								<option value="- Order Date">- Order Date</option>
																								<option selected="" value="- Order Total">- Order Total</option>
																								<option value="-------------------">-------------------</option>
																								<option value="ACCOUNT">ACCOUNT</option>
																								<option value="SESSION">SESSION</option>
																								<option value="TRIGGER">TRIGGER</option>
																							</select>

																						</div>
																					</div>

																				</div>
																				<div class="col-xs-6 s-criteria">

																					<h4>Criteria</h4>
																					<!--- Filter Criteria Start --->
																					<form action="index.html" method="post">

																						<div class="form-group form-group-sm">
																							<div class="col-sm-3 s-no-paddings">

																								<select class="form-control input-sm">
																									<option selected="" value="=">=</option>
																									<option value=">">&gt;</option>
																									<option value=">">&gt;</option>
																									<option value="<">&lt;</option>
																									<option value=">=">&gt;=</option>
																									<option value="<=">&lt;=</option>
																									<option value="<>">&lt;&gt;</option>
																									<option value="NULL">NULL</option>
																									<option value="Changed">Changed</option>
																								</select>

																							</div>
																							<div class="col-sm-6">
																								<input class="form-control" type="text" name="some_name" value="">
																							</div>
																							<div class="clearfix"></div>
																						</div>
																						<div class="controls s-checkbox">
																							<input type="checkbox" id="j-checkbox7" checked="checked" ><label for="j-checkbox7"> Apply to pre-event data</label>
																						</div>

																					</form>
																					<!--- //Filter Criteria End --->

																				</div>
																				<div class="col-xs-3">
																					<div class="s-button-select-group">
																						<button type="button" class="btn btn-sm s-btn-ten24">Save & Add Another</button>
																						<div class="s-or-box">-OR-</div>
																						<button type="button" class="btn btn-sm s-btn-ten24">Save & Finish</button>
																					</div>
																				</div>
																			</div>
																		</div>
																	</div>
																</div>
																<!--- //Edit Filter Box --->

																<!--- Edit Filter Box --->
																<div class="col-xs-12 collapse s-add-filter" id="j-add-another-4">
																	<div class="row">
																		<h4> Define Condition: <span>Orders</span> <i class="fa fa-times" data-toggle="collapse" data-target="#j-add-another-2"></i></h4>
																		<div class="col-xs-12">

																			<div class="row s-flex-col">
																				<div class="col-xs-3">

																					<div>
																						<div class="form-group">
																							<label class="s-width-100">Type:</label>

																							<select class="form-control input-sm">
																								<option value="Order">Order</option>
																								<option value="- Order ID">- Order ID</option>
																								<option value="- Order Date">- Order Date</option>
																								<option selected="" value="- Order Total">- Order Total</option>
																								<option value="-------------------">-------------------</option>
																								<option value="ACCOUNT">ACCOUNT</option>
																								<option value="SESSION">SESSION</option>
																								<option value="TRIGGER">TRIGGER</option>
																							</select>

																						</div>
																					</div>

																				</div>
																				<div class="col-xs-6 s-criteria">

																					<h4>Criteria</h4>
																					<!--- Filter Criteria Start --->
																					<form action="index.html" method="post">

																						<div class="form-group form-group-sm">
																							<div class="col-sm-3 s-no-paddings">

																								<select class="form-control input-sm">
																									<option selected="" value="=">=</option>
																									<option value=">">&gt;</option>
																									<option value=">">&gt;</option>
																									<option value="<">&lt;</option>
																									<option value=">=">&gt;=</option>
																									<option value="<=">&lt;=</option>
																									<option value="<>">&lt;&gt;</option>
																									<option value="NULL">NULL</option>
																									<option value="Changed">Changed</option>
																								</select>

																							</div>
																							<div class="col-sm-6">
																								<input class="form-control" type="text" name="some_name" value="">
																							</div>
																							<div class="clearfix"></div>
																						</div>
																						<div class="controls s-checkbox">
																							<input type="checkbox" id="j-checkbox8" checked="checked" ><label for="j-checkbox8"> Apply to pre-event data</label>
																						</div>

																					</form>
																					<!--- //Filter Criteria End --->

																				</div>
																				<div class="col-xs-3">
																					<div class="s-button-select-group">
																						<button type="button" class="btn btn-sm s-btn-ten24">Save & Add Another</button>
																						<div class="s-or-box">-OR-</div>
																						<button type="button" class="btn btn-sm s-btn-ten24">Save & Finish</button>
																					</div>
																				</div>
																			</div>
																		</div>
																	</div>
																</div>
																<!--- //Edit Filter Box --->

															</div>
															<!--- //New Filter Panel --->
														</div>
														<!--- //End Filter Group --->

													</div>
												</div>
											</div>

											<div class="tab-pane" id="j-actions-3">
												<div class="s-bundle-add-items s-workflow-objs s-sortable">
													<ul class="list-unstyled s-order-item-options">

														<li class="s-bundle-add-obj">
															<ul class="list-unstyled list-inline">
																<li class="s-item-type">1</li>
																<li class="s-item-type"><i class="fa fa-arrows-v"></i></li>
															</ul>
															<ul class="list-unstyled list-inline s-middle">
																<li class="j-tool-tip-item s-bundle-details">Type: <span>E-Mail</span></li>
																<li class="j-tool-tip-item s-bundle-details">Object: <span>Order</span></li>
																<li class="j-tool-tip-item s-bundle-details">Detail: <span>Order Feedback Template</span></li>
															</ul>
															<ul class="list-unstyled list-inline s-last">
																<li class="col-xs-1 j-tool-tip-item s-bundle-details-add"><a class="btn s-btn-dgrey s-remove"><i class="fa fa-trash"></i></a></li>
															</ul>
															<div class="clearfix"></div>
														</li>

														<li class="s-bundle-add-obj">
															<ul class="list-unstyled list-inline">
																<li class="s-item-type">2</li>
																<li class="s-item-type"><i class="fa fa-arrows-v"></i></li>
															</ul>
															<ul class="list-unstyled list-inline s-middle">
																<li class="j-tool-tip-item s-bundle-details">Type: <span>E-Mail</span></li>
																<li class="j-tool-tip-item s-bundle-details">Object: <span>Order</span></li>
																<li class="j-tool-tip-item s-bundle-details">Detail: <span>Order Feedback Template</span></li>
															</ul>
															<ul class="list-unstyled list-inline s-last">
																<li class="col-xs-1 j-tool-tip-item s-bundle-details-add"><a class="btn s-btn-dgrey s-remove"><i class="fa fa-trash"></i></a></li>
															</ul>
															<div class="clearfix"></div>
														</li>

													</ul>
												</div>

												<div class="form-group">

													<button class="btn btn-xs s-btn-ten24" data-toggle="collapse" data-target="#j-add-action-c"><i class="fa fa-plus"></i> Add Action</button>

												</div>

												<!--- Edit Filter Box --->
												<div class="col-xs-12 collapse s-add-filter" id="j-add-action-c">
													<div class="row">
														<h4> Add Action <i class="fa fa-times" data-toggle="collapse" data-target="#j-add-action-c"></i></h4>
														<div class="col-xs-12">

															<div class="row s-flex-col">
																<div class="col-xs-3">

																	<div class="form-group form-group-sm">
																		<label for="" class="s-width-100">Select Action Type:</label>
																		<select class="form-control input-sm">
																			<option>Print</option>
																			<option>Email</option>
																			<option>Update</option>
																			<option>Process</option>
																			<option>Import</option>
																			<option>Export</option>
																			<option>Delete</option>
																		</select>
																	</div>

																	<div class="form-group form-group-sm">
																		<label for="" class="s-width-100">Select Object:</label>
																		<select class="form-control input-sm">
																			<option>Orders</option>
																			<option>Related Objects</option>
																			<option>Account</option>
																			<option>Order Item</option>
																		</select>
																	</div>

																</div>
																<div class="col-xs-6 s-criteria">

																	<!--- Filter Criteria Start --->
																	<div class="s-filter-group-item">

																		<h4>Print Template</h4>
																		<div class="form-group form-group-sm">

																			<!--- search --->
																			<div class="s-search-filter">
																				<div class="input-group">
																					<input type="text" class="form-control input-sm j-search-input" placeholder="Search&hellip;">
																					<ul class="dropdown-menu s-search-options">
																						<li><button type="button" class="btn s-btn-dgrey" data-toggle="collapse" data-target="#j-toggle-add-bundle-type"><i class="fa fa-plus"></i> Add "This should be the name"</button></li>
																						<li><a>Order Confirmation Template</a></li>
																						<li><a>Order Gift Thank You</a></li>
																						<li><a>Order Feedback</a></li>
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

																		</div>

																		<div class="form-group form-group-sm">
																			<label for="" class="col-sm-12 s-no-paddings">On Success</label>
																			<select class="form-control input-sm">
																				<option value="Proceed to Next Action / Task">Proceed to Next Action / Task</option>
																				<option selected="" value="Select Next Action">Select Next Action</option>
																				<option value="Select Next Task">Select Next Task</option>
																				<option value="Skip to Next Task">Skip to Next Task</option>
																				<option value="Exit Workflow">Exit Workflow</option>
																			</select>
																		</div>
																		<div class="form-group form-group-sm">
																			<select class="form-control input-sm">
																				<option value="- Select Action">- Select Action</option>
																			</select>
																		</div>

																		<div class="form-group form-group-sm">
																			<label for="" class="col-sm-12 s-no-paddings">On Failure</label>
																			<select class="form-control input-sm">
																				<option value="Proceed to Next Action / Task">Proceed to Next Action / Task</option>
																				<option value="Select Next Action">Select Next Action</option>
																				<option value="Select Next Task">Select Next Task</option>
																				<option value="Skip to Next Task">Skip to Next Task</option>
																				<option selected="" value="Exit Workflow">Exit Workflow</option>
																			</select>
																		</div>

																	</div>
																	<!--- //Filter Criteria End --->

/===================================================/


																	<!--- Filter Criteria Start --->
																	<div class="s-filter-group-item">

																		<h4>Update Data</h4>
																		<div class="form-group form-group-sm">
																			<input type="text" class="form-control" placeholder="Ready To Capture">
																			<!--- <p class="help-block">Help text here.</p> --->
																		</div>

																		<div class="form-group form-group-sm">
																			<label for="" class="col-sm-12 s-no-paddings">On Success</label>
																			<select class="form-control input-sm">
																				<option value="Proceed to Next Action / Task">Proceed to Next Action / Task</option>
																				<option selected="" value="Select Next Action">Select Next Action</option>
																				<option value="Select Next Task">Select Next Task</option>
																				<option value="Skip to Next Task">Skip to Next Task</option>
																				<option value="Exit Workflow">Exit Workflow</option>
																			</select>
																		</div>

																		<div class="form-group form-group-sm">
																			<label for="" class="col-sm-12 s-no-paddings"></label>
																			<select class="form-control input-sm">
																				<option value="- Select Action">- Select Action</option>
																			</select>
																		</div>

																		<div class="form-group form-group-sm">
																			<label for="" class="col-sm-12 s-no-paddings">On Failure</label>
																			<select class="form-control input-sm">
																				<option value="Proceed to Next Action / Task">Proceed to Next Action / Task</option>
																				<option value="Select Next Action">Select Next Action</option>
																				<option value="Select Next Task">Select Next Task</option>
																				<option value="Skip to Next Task">Skip to Next Task</option>
																				<option selected="" value="Exit Workflow">Exit Workflow</option>
																			</select>
																		</div>

																	</div>
																	<!--- //Filter Criteria End --->

/===================================================/

																	<!--- Filter Criteria Start --->
																	<div class="s-filter-group-item">

																		<h4>Dynamic Numeric</h4>
																		<div class="row">
																			<div class="col-md-6 form-group form-group-sm">
																				<select class="form-control input-sm">
																					<option value="1">Dynamic Numeric Value</option>
																					<option value="2">Add 'N'</option>
																					<option value="3">Set value to '0'</option>
																					<option value="4">Subtract 'N'</option>
																				</select>
																			</div>
																			<div class="col-md-6 form-group form-group-sm">
																				<input type="number" class="form-control" placeholder="" value="4">
																				<!--- <p class="help-block">Help text here.</p> --->
																			</div>
																		</div>

																	</div>
																	<!--- //Filter Criteria End --->

/===================================================/

																	<!--- Filter Criteria Start --->
																	<div class="s-filter-group-item">
																		<h4>Delete</h4>
																		<div class="form-group form-group-sm s-checkbox">
																			<input type="checkbox" id="j-delete-confirm" checked="checked"><label for="j-delete-confirm"> Confirm "Orders" object will be deleted</label>
																		</div>
																	</div>
																	<!--- //Filter Criteria End --->

																</div>
																<div class="col-xs-3">
																	<div class="s-button-select-group">
																		<button type="button" class="btn btn-sm s-btn-ten24">Save & Add Another</button>
																		<div class="s-or-box">OR-</div>
																		<button type="button" class="btn btn-sm s-btn-ten24">Save & Finish</button>
																	</div>
																</div>
															</div>
														</div>
													</div>
												</div>
												<!--- //Edit Filter Box --->
												<div class="clearfix"></div>
											</div>

										</div>
									</div>
								</div>

							</div>
					</div>
				</div>
				<!--- //Edit Filter Box --->

				<div class="clearfix"></div>

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

<script charset="utf-8">
	//Hide and show the filter search content depending if search has text
	$('body').on('keyup','.s-search-bar',function() {
		if( $(this).find('.j-search-input').val().length > 0 ){
			$(this).parent().find('.s-bundle-add-items').removeClass('s-hide-trans');
		}else{
			$(this).parent().find('.s-bundle-add-items').addClass('s-hide-trans');
		};
	});
</script>

<script charset="utf-8">
	$('.j-search-input').keyup(function(){
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
	$('.j-dropdown-options').click(function(){
		$(this).parent().parent().parent().find('.s-search-options').toggle();
	});
</script>

<script charset="utf-8">
	$('#j-placeholder-trigger').click(function(){
		$('#j-placeholder-trigger-select').fadeIn( "slow");
		$('.s-search-options').hide();
	});
</script>
