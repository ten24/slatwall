<div class="row" ng-app="collections">
  <div class="col-xs-12">

    <!--- Header nav with title starts --->
    <div class="row s-header-bar">
      <div class="col-md-7"><h1>Best Selling Mens & Womens Boots From July 2014</h1></div>
      <div class="col-md-5 s-header-nav">
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
          <span class="s-edit-btn-group"><button class="btn btn-xs s-btn-ten24" id="j-save-btn" style="display:none;"><i class="fa fa-floppy-o"></i> Save</button> <button class="btn btn-xs s-btn-lgrey" id="j-edit-btn"><i class="fa fa-pencil"></i> Edit</button></span>
          <form class="form-horizontal s-properties" role="form">
            <div class="form-group">
              <label class="col-sm-2 control-label">Title:<span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="The collection title"> <i class="fa fa-question-circle"></i></span></label>
              <div class="col-sm-10">
                <input style="display:none" type="text" class="form-control" id="inputPassword" value="Best Selling Mens & Womens Boots From July 2014">
                <p class="form-control-static">Best Selling Mens & Womens Boots From July 2014</p>
              </div>
            </div>
            <div class="form-group">
              <label for="inputPassword" class="col-sm-2 control-label">Code: <span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="The collection code"> <i class="fa fa-question-circle"></i></span></label>
              <div class="col-sm-10">
                <input style="display:none" type="text" class="form-control" id="inputPassword" value="876567">
                <p class="form-control-static">876567</p>
              </div>
            </div>
            <div class="form-group">
              <label for="inputPassword" class="col-sm-2 control-label">Description: <span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="The collection description"> <i class="fa fa-question-circle"></i></span></label>
              <div class="col-sm-10">
                <input style="display:none" type="text" class="form-control" id="inputPassword" value="A selection for the best selling mens and womens boots from the month of july 2014. These will be used to display on the product listing pages for b15 marketing strategy plan.">
                <p class="form-control-static">A selection for the best selling mens and womens boots from the month of july 2014.</p>
              </div>
            </div>
            <div class="form-group">
              <label for="inputPassword" class="col-sm-2 control-label">Collection Type: <span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="The collection type"> <i class="fa fa-question-circle"></i></span></label>
              <div class="col-sm-10">
                <p class="form-control-static">876567</p>
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
                          <button type="button" class="btn btn-xs s-btn-white active">AND</button>
                          <button type="button" class="btn btn-xs s-btn-white">OR</button>
                        </div>
                      </div>
                      <!--- //Filter display --->

                      <!--- Edit Filter Box --->
                      <div class="col-xs-12 collapse s-add-filter" id="j-edit-filter-1">
                        <div class="row">
                          <div class="col-xs-12">
                            <h4> Define Filter: <span>Orders</span><i class="fa fa-minus-square-o" data-toggle="collapse" data-target="#j-add-filter3"></i></h4>
                            <div class="row">
                              <div class="col-xs-4">
                                Select From Orders:
                                <div class="option-dropdown">
                                  <select class="form-control input-sm">
                                    <option disabled="disabled" selected="selected">Select From Orders:</option>
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
                                  <div class="s-checkbox"><input type="checkbox" id="j-checkbox1"><label for="checkbox1"> Add To New Group</label></div>
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
                                <div class="btn-group-vertical">
                                  <button type="button" class="btn btn-xs s-btn-white active">AND</button>
                                  <button type="button" class="btn btn-xs s-btn-white">OR</button>
                                </div>
                              </div>
                              <!--- //Nested Filter Display --->

                              <!--- Edit Filter Box --->
                              <div class="col-xs-12 collapse s-add-filter" id="j-edit-filter-1-1">
                                <div class="row">
                                  <div class="col-xs-12">
                                    <h4> Define Filter: <span>Orders</span><i class="fa fa-minus-square-o" data-toggle="collapse" data-target="#j-add-filter3"></i></h4>
                                    <div class="row">
                                      <div class="col-xs-4">
                                        Select From Orders:
                                        <div class="option-dropdown">
                                          <select class="form-control input-sm">
                                            <option disabled="disabled" selected="selected">Select From Orders:</option>
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
                                          <div class="s-checkbox"><input type="checkbox" id="j-checkbox1"><label for="checkbox1"> Add To New Group</label></div>
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
                                            <h4> Define Filter: <span>Orders</span><i class="fa fa-minus-square-o" data-toggle="collapse" data-target="#j-add-filter3"></i></h4>
                                            <div class="row">
                                              <div class="col-xs-4">
                                                Select From Orders:
                                                <div class="option-dropdown">
                                                  <select class="form-control input-sm">
                                                    <option disabled="disabled" selected="selected">Select From Orders:</option>
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
                                                  <div class="s-checkbox"><input type="checkbox" id="j-checkbox1"><label for="checkbox1"> Add To New Group</label></div>
                                                </div>
                                              </div>
                                            </div>
                                          </div>
                                        </div>
                                      </div>
                                      <!--- //Edit Filter Box --->

                                    </li>
                                    <!--- //Filter display --->

                                  </ul>
                                </div>
                              </div>
                              <!---//Nested Filter Box --->

                            </li>
                            <!--- //Filter display --->

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
                          <h4> Define Filter: <span>Orders</span><i class="fa fa-minus-square-o" data-toggle="collapse" data-target="#j-add-filter-group"></i></h4>
                          <div class="row">
                            <div class="col-xs-4">
                              Select From Orders:
                              <div class="option-dropdown">
                                <select class="form-control input-sm">
                                  <option disabled="disabled" selected="selected">Select From Orders:</option>
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
                                <div class="s-checkbox"><input type="checkbox" id="j-checkbox1"><label for="checkbox1"> Add To New Group</label></div>
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
                          <h4> Define Filter: <span>Orders</span><i class="fa fa-minus-square-o" data-toggle="collapse" data-target="#j-add-filter"></i></h4>
                          <div class="row">
                            <div class="col-xs-4">
                              Select From Orders:
                              <div class="option-dropdown">
                                <select class="form-control input-sm">
                                  <option disabled="disabled" selected="selected">Select From Orders:</option>
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
                                <div class="s-checkbox"><input type="checkbox" id="j-checkbox1"><label for="checkbox1"> Add To New Group</label></div>
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
          <div class="s-none-selected">There are no fields selected</div>
          <button class="btn s-btn-ten24">Add Display Field</button>
        </div><!--- //Tab Pane --->
      </div>

    </div><!--- //Row --->
    <!--- //Tab panes for menu options end--->

    <div class="row s-table-content-nav">
      <div class="col-xs-12 s-align-left">

        <form class="navbar-form s-search-bar s-no-horiz-paddings" role="search">
          <div class="input-group">
            <input type="text" class="form-control input-sm" placeholder="Search" name="srch-term" id="j-srch-term">
            <div class="input-group-btn">
              <button class="btn btn-default btn-sm" type="submit"><i class="fa fa-search"></i></button>
            </div>
          </div>
        </form>
        <ul class="list-inline list-unstyled s-pagination-content">
          <li>

            <form class="form-horizontal" role="form">
              <div class="form-group">
                <label for="inputPassword" class="col-xs-8 control-label">View</label>
                <div class="col-xs-4 styleSelect">
                  <select size="1" name="" aria-controls="" class="form-control">
                    <option value="5" selected="selected">5</option>
                    <option value="15">15</option>
                    <option value="20">20</option>
                    <option value="-1">All</option>
                  </select>
                </div>
              </div>
            </form>

          </li>
          <li class="s-table-pagination">
            <ul class="pagination pagination-sm s-align-right">
              <li><a href="#">&laquo;</a></li>
              <li class="active"><a href="#">1</a></li>
              <li><a href="#">2</a></li>
              <li><a href="#">3</a></li>
              <li><a href="#">4</a></li>
              <li><a href="#">5</a></li>
              <li class="disabled"><a href="#">&raquo;</a></li>
            </ul>
          </li>
        </ul>
      </div>
    </div>
    <div class="table-responsive">
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

<!---Example success and warning alerts - These can be places anywhere and should always be in the footer area--->
<!--- <div class="alert alert-danger alert-dismissible s-alert-footer" role="alert">
  <button type="button" class="close" data-dismiss="alert"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
  <strong>Warning!</strong> Better check yourself, you're not looking too good.
</div> --->
<!--- <div class="alert alert-warning alert-dismissible s-alert-footer" role="alert">
  <button type="button" class="close" data-dismiss="alert"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
  <strong>Error!</strong> Collection code must be unique.
</div> --->
<!--- <div class="alert alert-success s-alert-footer" role="alert"><i class="fa fa-check"></i> Saved</div> --->

<style>

  /*Add font awesome css*/
  @font-face{font-family:'FontAwesome';src:url('../assets/fonts/fontawesome-webfont.eot?v=4.1.0');src:url('../assets/fonts/fontawesome-webfont.eot?#iefix&v=4.1.0') format('embedded-opentype'),url('../assets/fonts/fontawesome-webfont.woff?v=4.1.0') format('woff'),url('../assets/fonts/fontawesome-webfont.ttf?v=4.1.0') format('truetype'),url('../assets/fonts/fontawesome-webfont.svg?v=4.1.0#fontawesomeregular') format('svg');font-weight:normal;font-style:normal}.fa{display:inline-block;font-family:FontAwesome;font-style:normal;font-weight:normal;line-height:1;-webkit-font-smoothing:antialiased;-moz-osx-font-smoothing:grayscale}.fa-lg{font-size:1.33333333em;line-height:.75em;vertical-align:-15%}.fa-2x{font-size:2em}.fa-3x{font-size:3em}.fa-4x{font-size:4em}.fa-5x{font-size:5em}.fa-fw{width:1.28571429em;text-align:center}.fa-ul{padding-left:0;margin-left:2.14285714em;list-style-type:none}.fa-ul>li{position:relative}.fa-li{position:absolute;left:-2.14285714em;width:2.14285714em;top:.14285714em;text-align:center}.fa-li.fa-lg{left:-1.85714286em}.fa-border{padding:.2em .25em .15em;border:solid .08em #eee;border-radius:.1em}.pull-right{float:right}.pull-left{float:left}.fa.pull-left{margin-right:.3em}.fa.pull-right{margin-left:.3em}.fa-spin{-webkit-animation:spin 2s infinite linear;-moz-animation:spin 2s infinite linear;-o-animation:spin 2s infinite linear;animation:spin 2s infinite linear}@-moz-keyframes spin{0%{-moz-transform:rotate(0deg)}100%{-moz-transform:rotate(359deg)}}@-webkit-keyframes spin{0%{-webkit-transform:rotate(0deg)}100%{-webkit-transform:rotate(359deg)}}@-o-keyframes spin{0%{-o-transform:rotate(0deg)}100%{-o-transform:rotate(359deg)}}@keyframes spin{0%{-webkit-transform:rotate(0deg);transform:rotate(0deg)}100%{-webkit-transform:rotate(359deg);transform:rotate(359deg)}}.fa-rotate-90{filter:progid:DXImageTransform.Microsoft.BasicImage(rotation=1);-webkit-transform:rotate(90deg);-moz-transform:rotate(90deg);-ms-transform:rotate(90deg);-o-transform:rotate(90deg);transform:rotate(90deg)}.fa-rotate-180{filter:progid:DXImageTransform.Microsoft.BasicImage(rotation=2);-webkit-transform:rotate(180deg);-moz-transform:rotate(180deg);-ms-transform:rotate(180deg);-o-transform:rotate(180deg);transform:rotate(180deg)}.fa-rotate-270{filter:progid:DXImageTransform.Microsoft.BasicImage(rotation=3);-webkit-transform:rotate(270deg);-moz-transform:rotate(270deg);-ms-transform:rotate(270deg);-o-transform:rotate(270deg);transform:rotate(270deg)}.fa-flip-horizontal{filter:progid:DXImageTransform.Microsoft.BasicImage(rotation=0, mirror=1);-webkit-transform:scale(-1, 1);-moz-transform:scale(-1, 1);-ms-transform:scale(-1, 1);-o-transform:scale(-1, 1);transform:scale(-1, 1)}.fa-flip-vertical{filter:progid:DXImageTransform.Microsoft.BasicImage(rotation=2, mirror=1);-webkit-transform:scale(1, -1);-moz-transform:scale(1, -1);-ms-transform:scale(1, -1);-o-transform:scale(1, -1);transform:scale(1, -1)}.fa-stack{position:relative;display:inline-block;width:2em;height:2em;line-height:2em;vertical-align:middle}.fa-stack-1x,.fa-stack-2x{position:absolute;left:0;width:100%;text-align:center}.fa-stack-1x{line-height:inherit}.fa-stack-2x{font-size:2em}.fa-inverse{color:#fff}.fa-glass:before{content:"\f000"}.fa-music:before{content:"\f001"}.fa-search:before{content:"\f002"}.fa-envelope-o:before{content:"\f003"}.fa-heart:before{content:"\f004"}.fa-star:before{content:"\f005"}.fa-star-o:before{content:"\f006"}.fa-user:before{content:"\f007"}.fa-film:before{content:"\f008"}.fa-th-large:before{content:"\f009"}.fa-th:before{content:"\f00a"}.fa-th-list:before{content:"\f00b"}.fa-check:before{content:"\f00c"}.fa-times:before{content:"\f00d"}.fa-search-plus:before{content:"\f00e"}.fa-search-minus:before{content:"\f010"}.fa-power-off:before{content:"\f011"}.fa-signal:before{content:"\f012"}.fa-gear:before,.fa-cog:before{content:"\f013"}.fa-trash-o:before{content:"\f014"}.fa-home:before{content:"\f015"}.fa-file-o:before{content:"\f016"}.fa-clock-o:before{content:"\f017"}.fa-road:before{content:"\f018"}.fa-download:before{content:"\f019"}.fa-arrow-circle-o-down:before{content:"\f01a"}.fa-arrow-circle-o-up:before{content:"\f01b"}.fa-inbox:before{content:"\f01c"}.fa-play-circle-o:before{content:"\f01d"}.fa-rotate-right:before,.fa-repeat:before{content:"\f01e"}.fa-refresh:before{content:"\f021"}.fa-list-alt:before{content:"\f022"}.fa-lock:before{content:"\f023"}.fa-flag:before{content:"\f024"}.fa-headphones:before{content:"\f025"}.fa-volume-off:before{content:"\f026"}.fa-volume-down:before{content:"\f027"}.fa-volume-up:before{content:"\f028"}.fa-qrcode:before{content:"\f029"}.fa-barcode:before{content:"\f02a"}.fa-tag:before{content:"\f02b"}.fa-tags:before{content:"\f02c"}.fa-book:before{content:"\f02d"}.fa-bookmark:before{content:"\f02e"}.fa-print:before{content:"\f02f"}.fa-camera:before{content:"\f030"}.fa-font:before{content:"\f031"}.fa-bold:before{content:"\f032"}.fa-italic:before{content:"\f033"}.fa-text-height:before{content:"\f034"}.fa-text-width:before{content:"\f035"}.fa-s-align-left:before{content:"\f036"}.fa-align-center:before{content:"\f037"}.fa-s-align-right:before{content:"\f038"}.fa-align-justify:before{content:"\f039"}.fa-list:before{content:"\f03a"}.fa-dedent:before,.fa-outdent:before{content:"\f03b"}.fa-indent:before{content:"\f03c"}.fa-video-camera:before{content:"\f03d"}.fa-photo:before,.fa-image:before,.fa-picture-o:before{content:"\f03e"}.fa-pencil:before{content:"\f040"}.fa-map-marker:before{content:"\f041"}.fa-adjust:before{content:"\f042"}.fa-tint:before{content:"\f043"}.fa-edit:before,.fa-pencil-square-o:before{content:"\f044"}.fa-share-square-o:before{content:"\f045"}.fa-check-square-o:before{content:"\f046"}.fa-arrows:before{content:"\f047"}.fa-step-backward:before{content:"\f048"}.fa-fast-backward:before{content:"\f049"}.fa-backward:before{content:"\f04a"}.fa-play:before{content:"\f04b"}.fa-pause:before{content:"\f04c"}.fa-stop:before{content:"\f04d"}.fa-forward:before{content:"\f04e"}.fa-fast-forward:before{content:"\f050"}.fa-step-forward:before{content:"\f051"}.fa-eject:before{content:"\f052"}.fa-chevron-left:before{content:"\f053"}.fa-chevron-right:before{content:"\f054"}.fa-plus-circle:before{content:"\f055"}.fa-minus-circle:before{content:"\f056"}.fa-times-circle:before{content:"\f057"}.fa-check-circle:before{content:"\f058"}.fa-question-circle:before{content:"\f059"}.fa-info-circle:before{content:"\f05a"}.fa-crosshairs:before{content:"\f05b"}.fa-times-circle-o:before{content:"\f05c"}.fa-check-circle-o:before{content:"\f05d"}.fa-ban:before{content:"\f05e"}.fa-arrow-left:before{content:"\f060"}.fa-arrow-right:before{content:"\f061"}.fa-arrow-up:before{content:"\f062"}.fa-arrow-down:before{content:"\f063"}.fa-mail-forward:before,.fa-share:before{content:"\f064"}.fa-expand:before{content:"\f065"}.fa-compress:before{content:"\f066"}.fa-plus:before{content:"\f067"}.fa-minus:before{content:"\f068"}.fa-asterisk:before{content:"\f069"}.fa-exclamation-circle:before{content:"\f06a"}.fa-gift:before{content:"\f06b"}.fa-leaf:before{content:"\f06c"}.fa-fire:before{content:"\f06d"}.fa-eye:before{content:"\f06e"}.fa-eye-slash:before{content:"\f070"}.fa-warning:before,.fa-exclamation-triangle:before{content:"\f071"}.fa-plane:before{content:"\f072"}.fa-calendar:before{content:"\f073"}.fa-random:before{content:"\f074"}.fa-comment:before{content:"\f075"}.fa-magnet:before{content:"\f076"}.fa-chevron-up:before{content:"\f077"}.fa-chevron-down:before{content:"\f078"}.fa-retweet:before{content:"\f079"}.fa-shopping-cart:before{content:"\f07a"}.fa-folder:before{content:"\f07b"}.fa-folder-open:before{content:"\f07c"}.fa-arrows-v:before{content:"\f07d"}.fa-arrows-h:before{content:"\f07e"}.fa-bar-chart-o:before{content:"\f080"}.fa-twitter-square:before{content:"\f081"}.fa-facebook-square:before{content:"\f082"}.fa-camera-retro:before{content:"\f083"}.fa-key:before{content:"\f084"}.fa-gears:before,.fa-cogs:before{content:"\f085"}.fa-comments:before{content:"\f086"}.fa-thumbs-o-up:before{content:"\f087"}.fa-thumbs-o-down:before{content:"\f088"}.fa-star-half:before{content:"\f089"}.fa-heart-o:before{content:"\f08a"}.fa-sign-out:before{content:"\f08b"}.fa-linkedin-square:before{content:"\f08c"}.fa-thumb-tack:before{content:"\f08d"}.fa-external-link:before{content:"\f08e"}.fa-sign-in:before{content:"\f090"}.fa-trophy:before{content:"\f091"}.fa-github-square:before{content:"\f092"}.fa-upload:before{content:"\f093"}.fa-lemon-o:before{content:"\f094"}.fa-phone:before{content:"\f095"}.fa-square-o:before{content:"\f096"}.fa-bookmark-o:before{content:"\f097"}.fa-phone-square:before{content:"\f098"}.fa-twitter:before{content:"\f099"}.fa-facebook:before{content:"\f09a"}.fa-github:before{content:"\f09b"}.fa-unlock:before{content:"\f09c"}.fa-credit-card:before{content:"\f09d"}.fa-rss:before{content:"\f09e"}.fa-hdd-o:before{content:"\f0a0"}.fa-bullhorn:before{content:"\f0a1"}.fa-bell:before{content:"\f0f3"}.fa-certificate:before{content:"\f0a3"}.fa-hand-o-right:before{content:"\f0a4"}.fa-hand-o-left:before{content:"\f0a5"}.fa-hand-o-up:before{content:"\f0a6"}.fa-hand-o-down:before{content:"\f0a7"}.fa-arrow-circle-left:before{content:"\f0a8"}.fa-arrow-circle-right:before{content:"\f0a9"}.fa-arrow-circle-up:before{content:"\f0aa"}.fa-arrow-circle-down:before{content:"\f0ab"}.fa-globe:before{content:"\f0ac"}.fa-wrench:before{content:"\f0ad"}.fa-tasks:before{content:"\f0ae"}.fa-filter:before{content:"\f0b0"}.fa-briefcase:before{content:"\f0b1"}.fa-arrows-alt:before{content:"\f0b2"}.fa-group:before,.fa-users:before{content:"\f0c0"}.fa-chain:before,.fa-link:before{content:"\f0c1"}.fa-cloud:before{content:"\f0c2"}.fa-flask:before{content:"\f0c3"}.fa-cut:before,.fa-scissors:before{content:"\f0c4"}.fa-copy:before,.fa-files-o:before{content:"\f0c5"}.fa-paperclip:before{content:"\f0c6"}.fa-save:before,.fa-floppy-o:before{content:"\f0c7"}.fa-square:before{content:"\f0c8"}.fa-navicon:before,.fa-reorder:before,.fa-bars:before{content:"\f0c9"}.fa-list-ul:before{content:"\f0ca"}.fa-list-ol:before{content:"\f0cb"}.fa-strikethrough:before{content:"\f0cc"}.fa-underline:before{content:"\f0cd"}.fa-table:before{content:"\f0ce"}.fa-magic:before{content:"\f0d0"}.fa-truck:before{content:"\f0d1"}.fa-pinterest:before{content:"\f0d2"}.fa-pinterest-square:before{content:"\f0d3"}.fa-google-plus-square:before{content:"\f0d4"}.fa-google-plus:before{content:"\f0d5"}.fa-money:before{content:"\f0d6"}.fa-caret-down:before{content:"\f0d7"}.fa-caret-up:before{content:"\f0d8"}.fa-caret-left:before{content:"\f0d9"}.fa-caret-right:before{content:"\f0da"}.fa-columns:before{content:"\f0db"}.fa-unsorted:before,.fa-sort:before{content:"\f0dc"}.fa-sort-down:before,.fa-sort-desc:before{content:"\f0dd"}.fa-sort-up:before,.fa-sort-asc:before{content:"\f0de"}.fa-envelope:before{content:"\f0e0"}.fa-linkedin:before{content:"\f0e1"}.fa-rotate-left:before,.fa-undo:before{content:"\f0e2"}.fa-legal:before,.fa-gavel:before{content:"\f0e3"}.fa-dashboard:before,.fa-tachometer:before{content:"\f0e4"}.fa-comment-o:before{content:"\f0e5"}.fa-comments-o:before{content:"\f0e6"}.fa-flash:before,.fa-bolt:before{content:"\f0e7"}.fa-sitemap:before{content:"\f0e8"}.fa-umbrella:before{content:"\f0e9"}.fa-paste:before,.fa-clipboard:before{content:"\f0ea"}.fa-lightbulb-o:before{content:"\f0eb"}.fa-exchange:before{content:"\f0ec"}.fa-cloud-download:before{content:"\f0ed"}.fa-cloud-upload:before{content:"\f0ee"}.fa-user-md:before{content:"\f0f0"}.fa-stethoscope:before{content:"\f0f1"}.fa-suitcase:before{content:"\f0f2"}.fa-bell-o:before{content:"\f0a2"}.fa-coffee:before{content:"\f0f4"}.fa-cutlery:before{content:"\f0f5"}.fa-file-text-o:before{content:"\f0f6"}.fa-building-o:before{content:"\f0f7"}.fa-hospital-o:before{content:"\f0f8"}.fa-ambulance:before{content:"\f0f9"}.fa-medkit:before{content:"\f0fa"}.fa-fighter-jet:before{content:"\f0fb"}.fa-beer:before{content:"\f0fc"}.fa-h-square:before{content:"\f0fd"}.fa-plus-square:before{content:"\f0fe"}.fa-angle-double-left:before{content:"\f100"}.fa-angle-double-right:before{content:"\f101"}.fa-angle-double-up:before{content:"\f102"}.fa-angle-double-down:before{content:"\f103"}.fa-angle-left:before{content:"\f104"}.fa-angle-right:before{content:"\f105"}.fa-angle-up:before{content:"\f106"}.fa-angle-down:before{content:"\f107"}.fa-desktop:before{content:"\f108"}.fa-laptop:before{content:"\f109"}.fa-tablet:before{content:"\f10a"}.fa-mobile-phone:before,.fa-mobile:before{content:"\f10b"}.fa-circle-o:before{content:"\f10c"}.fa-quote-left:before{content:"\f10d"}.fa-quote-right:before{content:"\f10e"}.fa-spinner:before{content:"\f110"}.fa-circle:before{content:"\f111"}.fa-mail-reply:before,.fa-reply:before{content:"\f112"}.fa-github-alt:before{content:"\f113"}.fa-folder-o:before{content:"\f114"}.fa-folder-open-o:before{content:"\f115"}.fa-smile-o:before{content:"\f118"}.fa-frown-o:before{content:"\f119"}.fa-meh-o:before{content:"\f11a"}.fa-gamepad:before{content:"\f11b"}.fa-keyboard-o:before{content:"\f11c"}.fa-flag-o:before{content:"\f11d"}.fa-flag-checkered:before{content:"\f11e"}.fa-terminal:before{content:"\f120"}.fa-code:before{content:"\f121"}.fa-mail-reply-all:before,.fa-reply-all:before{content:"\f122"}.fa-star-half-empty:before,.fa-star-half-full:before,.fa-star-half-o:before{content:"\f123"}.fa-location-arrow:before{content:"\f124"}.fa-crop:before{content:"\f125"}.fa-code-fork:before{content:"\f126"}.fa-unlink:before,.fa-chain-broken:before{content:"\f127"}.fa-question:before{content:"\f128"}.fa-info:before{content:"\f129"}.fa-exclamation:before{content:"\f12a"}.fa-superscript:before{content:"\f12b"}.fa-subscript:before{content:"\f12c"}.fa-eraser:before{content:"\f12d"}.fa-puzzle-piece:before{content:"\f12e"}.fa-microphone:before{content:"\f130"}.fa-microphone-slash:before{content:"\f131"}.fa-shield:before{content:"\f132"}.fa-calendar-o:before{content:"\f133"}.fa-fire-extinguisher:before{content:"\f134"}.fa-rocket:before{content:"\f135"}.fa-maxcdn:before{content:"\f136"}.fa-chevron-circle-left:before{content:"\f137"}.fa-chevron-circle-right:before{content:"\f138"}.fa-chevron-circle-up:before{content:"\f139"}.fa-chevron-circle-down:before{content:"\f13a"}.fa-html5:before{content:"\f13b"}.fa-css3:before{content:"\f13c"}.fa-anchor:before{content:"\f13d"}.fa-unlock-alt:before{content:"\f13e"}.fa-bullseye:before{content:"\f140"}.fa-ellipsis-h:before{content:"\f141"}.fa-ellipsis-v:before{content:"\f142"}.fa-rss-square:before{content:"\f143"}.fa-play-circle:before{content:"\f144"}.fa-ticket:before{content:"\f145"}.fa-minus-square:before{content:"\f146"}.fa-minus-square-o:before{content:"\f147"}.fa-level-up:before{content:"\f148"}.fa-level-down:before{content:"\f149"}.fa-check-square:before{content:"\f14a"}.fa-pencil-square:before{content:"\f14b"}.fa-external-link-square:before{content:"\f14c"}.fa-share-square:before{content:"\f14d"}.fa-compass:before{content:"\f14e"}.fa-toggle-down:before,.fa-caret-square-o-down:before{content:"\f150"}.fa-toggle-up:before,.fa-caret-square-o-up:before{content:"\f151"}.fa-toggle-right:before,.fa-caret-square-o-right:before{content:"\f152"}.fa-euro:before,.fa-eur:before{content:"\f153"}.fa-gbp:before{content:"\f154"}.fa-dollar:before,.fa-usd:before{content:"\f155"}.fa-rupee:before,.fa-inr:before{content:"\f156"}.fa-cny:before,.fa-rmb:before,.fa-yen:before,.fa-jpy:before{content:"\f157"}.fa-ruble:before,.fa-rouble:before,.fa-rub:before{content:"\f158"}.fa-won:before,.fa-krw:before{content:"\f159"}.fa-bitcoin:before,.fa-btc:before{content:"\f15a"}.fa-file:before{content:"\f15b"}.fa-file-text:before{content:"\f15c"}.fa-sort-alpha-asc:before{content:"\f15d"}.fa-sort-alpha-desc:before{content:"\f15e"}.fa-sort-amount-asc:before{content:"\f160"}.fa-sort-amount-desc:before{content:"\f161"}.fa-sort-numeric-asc:before{content:"\f162"}.fa-sort-numeric-desc:before{content:"\f163"}.fa-thumbs-up:before{content:"\f164"}.fa-thumbs-down:before{content:"\f165"}.fa-youtube-square:before{content:"\f166"}.fa-youtube:before{content:"\f167"}.fa-xing:before{content:"\f168"}.fa-xing-square:before{content:"\f169"}.fa-youtube-play:before{content:"\f16a"}.fa-dropbox:before{content:"\f16b"}.fa-stack-overflow:before{content:"\f16c"}.fa-instagram:before{content:"\f16d"}.fa-flickr:before{content:"\f16e"}.fa-adn:before{content:"\f170"}.fa-bitbucket:before{content:"\f171"}.fa-bitbucket-square:before{content:"\f172"}.fa-tumblr:before{content:"\f173"}.fa-tumblr-square:before{content:"\f174"}.fa-long-arrow-down:before{content:"\f175"}.fa-long-arrow-up:before{content:"\f176"}.fa-long-arrow-left:before{content:"\f177"}.fa-long-arrow-right:before{content:"\f178"}.fa-apple:before{content:"\f179"}.fa-windows:before{content:"\f17a"}.fa-android:before{content:"\f17b"}.fa-linux:before{content:"\f17c"}.fa-dribbble:before{content:"\f17d"}.fa-skype:before{content:"\f17e"}.fa-foursquare:before{content:"\f180"}.fa-trello:before{content:"\f181"}.fa-female:before{content:"\f182"}.fa-male:before{content:"\f183"}.fa-gittip:before{content:"\f184"}.fa-sun-o:before{content:"\f185"}.fa-moon-o:before{content:"\f186"}.fa-archive:before{content:"\f187"}.fa-bug:before{content:"\f188"}.fa-vk:before{content:"\f189"}.fa-weibo:before{content:"\f18a"}.fa-renren:before{content:"\f18b"}.fa-pagelines:before{content:"\f18c"}.fa-stack-exchange:before{content:"\f18d"}.fa-arrow-circle-o-right:before{content:"\f18e"}.fa-arrow-circle-o-left:before{content:"\f190"}.fa-toggle-left:before,.fa-caret-square-o-left:before{content:"\f191"}.fa-dot-circle-o:before{content:"\f192"}.fa-wheelchair:before{content:"\f193"}.fa-vimeo-square:before{content:"\f194"}.fa-turkish-lira:before,.fa-try:before{content:"\f195"}.fa-plus-square-o:before{content:"\f196"}.fa-space-shuttle:before{content:"\f197"}.fa-slack:before{content:"\f198"}.fa-envelope-square:before{content:"\f199"}.fa-wordpress:before{content:"\f19a"}.fa-openid:before{content:"\f19b"}.fa-institution:before,.fa-bank:before,.fa-university:before{content:"\f19c"}.fa-mortar-board:before,.fa-graduation-cap:before{content:"\f19d"}.fa-yahoo:before{content:"\f19e"}.fa-google:before{content:"\f1a0"}.fa-reddit:before{content:"\f1a1"}.fa-reddit-square:before{content:"\f1a2"}.fa-stumbleupon-circle:before{content:"\f1a3"}.fa-stumbleupon:before{content:"\f1a4"}.fa-delicious:before{content:"\f1a5"}.fa-digg:before{content:"\f1a6"}.fa-pied-piper-square:before,.fa-pied-piper:before{content:"\f1a7"}.fa-pied-piper-alt:before{content:"\f1a8"}.fa-drupal:before{content:"\f1a9"}.fa-joomla:before{content:"\f1aa"}.fa-language:before{content:"\f1ab"}.fa-fax:before{content:"\f1ac"}.fa-building:before{content:"\f1ad"}.fa-child:before{content:"\f1ae"}.fa-paw:before{content:"\f1b0"}.fa-spoon:before{content:"\f1b1"}.fa-cube:before{content:"\f1b2"}.fa-cubes:before{content:"\f1b3"}.fa-behance:before{content:"\f1b4"}.fa-behance-square:before{content:"\f1b5"}.fa-steam:before{content:"\f1b6"}.fa-steam-square:before{content:"\f1b7"}.fa-recycle:before{content:"\f1b8"}.fa-automobile:before,.fa-car:before{content:"\f1b9"}.fa-cab:before,.fa-taxi:before{content:"\f1ba"}.fa-tree:before{content:"\f1bb"}.fa-spotify:before{content:"\f1bc"}.fa-deviantart:before{content:"\f1bd"}.fa-soundcloud:before{content:"\f1be"}.fa-database:before{content:"\f1c0"}.fa-file-pdf-o:before{content:"\f1c1"}.fa-file-word-o:before{content:"\f1c2"}.fa-file-excel-o:before{content:"\f1c3"}.fa-file-powerpoint-o:before{content:"\f1c4"}.fa-file-photo-o:before,.fa-file-picture-o:before,.fa-file-image-o:before{content:"\f1c5"}.fa-file-zip-o:before,.fa-file-archive-o:before{content:"\f1c6"}.fa-file-sound-o:before,.fa-file-audio-o:before{content:"\f1c7"}.fa-file-movie-o:before,.fa-file-video-o:before{content:"\f1c8"}.fa-file-code-o:before{content:"\f1c9"}.fa-vine:before{content:"\f1ca"}.fa-codepen:before{content:"\f1cb"}.fa-jsfiddle:before{content:"\f1cc"}.fa-life-bouy:before,.fa-life-saver:before,.fa-support:before,.fa-life-ring:before{content:"\f1cd"}.fa-circle-o-notch:before{content:"\f1ce"}.fa-ra:before,.fa-rebel:before{content:"\f1d0"}.fa-ge:before,.fa-empire:before{content:"\f1d1"}.fa-git-square:before{content:"\f1d2"}.fa-git:before{content:"\f1d3"}.fa-hacker-news:before{content:"\f1d4"}.fa-tencent-weibo:before{content:"\f1d5"}.fa-qq:before{content:"\f1d6"}.fa-wechat:before,.fa-weixin:before{content:"\f1d7"}.fa-send:before,.fa-paper-plane:before{content:"\f1d8"}.fa-send-o:before,.fa-paper-plane-o:before{content:"\f1d9"}.fa-history:before{content:"\f1da"}.fa-circle-thin:before{content:"\f1db"}.fa-header:before{content:"\f1dc"}.fa-paragraph:before{content:"\f1dd"}.fa-sliders:before{content:"\f1de"}.fa-share-alt:before{content:"\f1e0"}.fa-share-alt-square:before{content:"\f1e1"}.fa-bomb:before{content:"\f1e2"}

  /*Basic style overwrite*/
  body {font-family: 'Open Sans', sans-serif;color:#666666;padding-top:21px;}
  th {font-weight:600;}
  a {color:#F58620;}
  a:hover, a:focus {color: #F9AC68;text-decoration: underline; }

  /*Bootstrap overwrite*/
  .navbar-inverse .navbar-nav>li>a {color:#b0b0b0;}
  .navbar-inverse .navbar-nav>.open>a, .navbar-inverse .navbar-nav>.open>a:hover, .navbar-inverse .navbar-nav>.open>a:focus {background-color: #1B1E24}
  .pagination>.active>a, .pagination>.active>span, .pagination>.active>a:hover, .pagination>.active>span:hover, .pagination>.active>a:focus, .pagination>.active>span:focus {background-color:#F58620;border-color:#F58620;}
  .pagination>.disabled>span, .pagination>.disabled>span:hover, .pagination>.disabled>span:focus, .pagination>.disabled>a, .pagination>.disabled>a:hover, .pagination>.disabled>a:focus {color: #CCC;}
  .pagination>li>a:hover, .pagination>li>span:hover, .pagination>li>a:focus, .pagination>li>span:focus {background-color:#f58620;color:#ffffff;border-color:#f58620;}
  .btn:focus {outline: none;}
  .panel, .panel-group .panel {border-radius:0px;}
  .panel-default>.panel-heading {background-color:#606060;color:#ffffff;}
  .panel-group .panel-heading+.panel-collapse>.panel-body {border-top: none;}
  .panel-heading {border-top-left-radius: 0px;border-top-right-radius: 0px}
  .table th {white-space: nowrap;}
  .table>thead>tr>th, .table>tbody>tr>th, .table>tfoot>tr>th, .table>thead>tr>td, .table>tbody>tr>td, .table>tfoot>tr>td {padding: 8px 8px 5px 8px;}
  .table-bordered>thead>tr>th, .table-bordered>thead>tr>td {border-bottom-width:1px;}
  .btn-default {color:#767676;}
  .s-table-content-nav .dropdown-menu {left:auto;right:0;top:88%;border-radius:0px;}
  .s-table-content-nav .dropdown-menu {background-color:#F9F9F9;}
  .dropdown-menu li.active > a:hover, .dropdown-menu li > a:hover {background-color: #FC770D;background-image: -moz-linear-gradient(top, #f58620, #f58620);background-image: -ms-linear-gradient(top, #f58620, #f58620);background-image: -webkit-gradient(linear, 0 0, 0 100%, from(#f58620), to(#f58620));background-image: -webkit-linear-gradient(top, #f58620, #f58620);background-image: -o-linear-gradient(top, #f58620, #f58620);background-image: linear-gradient(top, #f58620, #f58620);color: #FFF !important;}
  .btn-default:hover, .btn-default:focus, .btn-default:active, .btn-default.active, .open>.dropdown-toggle.btn-default {background-color:#F58620;color:#ffffff;border-color: #F58620;}
  .nav-tabs {padding:0px 15px;}
  .tab-content .tab-pane {background-color: #eeeeee;padding:0px 15px;-moz-box-shadow: inset 0 0 2px #999999;-webkit-box-shadow: inset 0 0 2px #999999;box-shadow:inset 0 0 2px #999999;padding:20px 15px}
  .nav-tabs>li.active>a, .nav-tabs>li.active>a:hover, .nav-tabs>li.active>a:focus {color: #555;cursor: default;background: none;border: none;border-bottom-color: none;border-bottom:4px solid #F58620}
  .nav-tabs>li>a {border:none;color:#999999;}
  .nav-tabs>li>a:hover {background:none;border:none;color:#555;}
  .s-properties label {text-align:left !important;width: 170px;}
  select.form-control {border-color: #DDD;color: #767676;height: 29px;cursor:pointer;box-shadow:none;}

  /*Custom CSS*/
  .s-btn-ten24 {background-color: #F58620;border-color: #f1790b;color: #ffffff;}
  .s-btn-ten24:hover,.s-btn-ten24:focus,.s-btn-ten24:active,.s-btn-ten24.active {background-color: #f1790b;border-color: #f1790b;color:#ffffff;}
  .s-btn-ten24.disabled:hover,.s-btn-ten24.disabled:focus,.s-btn-ten24.disabled:active,.s-btn-ten24.disabled.active,.s-btn-ten24[disabled]:hover,.s-btn-ten24[disabled]:focus,.s-btn-ten24[disabled]:active,.s-btn-ten24[disabled].active,fieldset[disabled] .s-btn-ten24:hover,fieldset[disabled] .s-btn-ten24:focus,fieldset[disabled] .s-btn-ten24:active,fieldset[disabled] .s-btn-ten24.active {background-color: #F58620;}

  .s-btn-white {background-color: #FFF;border-color: #AAA;color: #888;}
  .s-btn-white:hover,.s-btn-white:focus,.s-btn-white:active,.s-btn-white.active {background-color: #9d9d9d;border-color: #919191;color:#fff;}
  .s-btn-white.disabled:hover,.s-btn-white.disabled:focus,.s-btn-white.disabled:active,.s-btn-white.disabled.active,.s-btn-white[disabled]:hover,.s-btn-white[disabled]:focus,.s-btn-white[disabled]:active,.s-btn-white[disabled].active,fieldset[disabled] .s-btn-white:hover,fieldset[disabled] .s-btn-white:focus,fieldset[disabled] .s-btn-white:active,fieldset[disabled] .s-btn-white.active {background-color: #aaa;border-color: #aaa;color:#fff;}


  .s-btn-grey {background-color: #eaeaea;border-color: #eaeaea;color:#5E5E5E;}
  .s-btn-grey:hover,.s-btn-grey:focus,.s-btn-grey:active,.s-btn-grey.active {background-color: #dddddd;border-color: #d1d1d1;color:#5E5E5E;}
  .s-btn-grey.disabled:hover,.s-btn-grey.disabled:focus,.s-btn-grey.disabled:active,.s-btn-grey.disabled.active,.s-btn-grey[disabled]:hover,.s-btn-grey[disabled]:focus,.s-btn-grey[disabled]:active,.s-btn-grey[disabled].active,fieldset[disabled] .s-btn-grey:hover,fieldset[disabled] .s-btn-grey:focus,fieldset[disabled] .s-btn-grey:active,fieldset[disabled] .s-btn-grey.active {background-color: #eaeaea;border-color: #eaeaea;color:#5E5E5E;}

  .s-btn-dgrey {background-color: #606060;border-color: #606060;color:#ffffff;}
  .s-btn-dgrey:hover,.s-btn-dgrey:focus,.s-btn-dgrey:active,.s-btn-dgrey.active {background-color: #535353;border-color: #474747;color:#ffffff;}
  .s-btn-dgrey.disabled:hover,.s-btn-dgrey.disabled:focus,.s-btn-dgrey.disabled:active,.s-btn-dgrey.disabled.active,.s-btn-dgrey[disabled]:hover,.s-btn-dgrey[disabled]:focus,.s-btn-dgrey[disabled]:active,.s-btn-dgrey[disabled].active,fieldset[disabled] .s-btn-dgrey:hover,fieldset[disabled] .s-btn-dgrey:focus,fieldset[disabled] .s-btn-dgrey:active,fieldset[disabled] .s-btn-dgrey.active {background-color: #606060;border-color: #606060;color:#ffffff;}

  .s-btn-lgrey {background-color: #cccccc;border-color: #cccccc;color:#888888;}
  .s-btn-lgrey:hover,.s-btn-lgrey:focus,.s-btn-lgrey:active,.s-btn-lgrey.active {background-color: #bfbfbf;border-color: #b3b3b3;color:#888888;}
  .s-btn-lgrey.disabled:hover,.s-btn-lgrey.disabled:focus,.s-btn-lgrey.disabled:active,.s-btn-lgrey.disabled.active,.s-btn-lgrey[disabled]:hover,.s-btn-lgrey[disabled]:focus,.s-btn-lgrey[disabled]:active,.s-btn-lgrey[disabled].active,fieldset[disabled] .s-btn-lgrey:hover,fieldset[disabled] .s-btn-lgrey:focus,fieldset[disabled] .s-btn-lgrey:active,fieldset[disabled] .s-btn-lgrey.active {background-color: #cccccc;border-color: #cccccc;color:#888888;}

  .s-display-options .s-none-selected {width:100%;text-align:center;font-weight:bold;}
  .s-header-bar h1{font-size:16px;margin-bottom:0;margin-top:9px;font-weight:600;}
  .s-header-bar .s-header-nav{text-align:right;}
  .s-header-bar .nav-tabs{display:inline-block;border-bottom:0;vertical-align:bottom;}
  .s-header-bar .nav-tabs ul li span{font-size:10px;top:-1px;position:relative;}
  .s-edit-btn-group {position: absolute;right: 10px;margin-top: -9px;}
  .s-options .tab-pane{padding:20px;}
  .s-options .tab-pane .dl-horizontal{text-align:left;}
  .s-filters-selected .s-new-filter .s-filter-item {margin-top:30px !important;}
  .s-filters-selected .s-filter-item .panel .panel-header a i{float:right;color:#AAA;margin-top:3px;}
  .s-setting-options-body .panel-heading a{color:#aaa;float:right;}
  .s-setting-options li {display:inline;}
  .s-filters-selected .s-filter-item .panel .panel-body{cursor:pointer;}
  .s-filters-selected .s-filter-item .panel .panel-body a{float:right;color:#ccc;}
  .s-filters-selected .s-filter-item .btn-group-vertical{float:right;margin-top:20px;margin-right:21px;}
  .s-filters-selected .s-filter-item .btn-group-vertical .btn{font-size:10px;}
  .s-filters-selected .s-and-or-box .btn-group{background-color:#eee;position:relative;top:-4px;}
  .s-filters-selected .s-define-box {text-align: center;border-top: 3px dotted #DDD;margin-top: 23px;padding-top: 20px;}
  .s-options .tab-content,.s-options .tab-pane dl dd.s-value{margin-bottom:15px;}
  .s-options .tab-pane label span i,.s-filters-selected .s-filter-item .panel .panel-body i{color:#ccc;}

  .s-edit-elements {width:60px;}
  .s-edit-elements ul {margin:0px;padding:0px;}
  .s-edit-elements ul li {text-align:center;cursor:pointer;-webkit-touch-callout: none;-webkit-user-select: none;-khtml-user-select: none;-moz-user-select: none;-ms-user-select: none;user-select: none;display:inline-block;text-decoration:none;margin-right:5px;}
  .s-edit-elements ul li:hover {color:#f58620;}
  .s-edit-elements ul li a {color:#666;}
  .s-edit-elements ul li a:hover {color:#F58620;}

  .s-no-paddings {padding:0px !important;}
  .s-no-horiz-paddings {padding-left:0px !important; padding-right:0px !important;}
  .s-align-right {text-align:right;}
  .s-align-left {text-align:left;}
  .s-table-content-nav-button {display:inline-block;}
  .s-table-content-nav button.s-table-content-nav-button {margin-top:8px;margin-bottom:8px;}
  .s-search-bar {display:inline-block;}
  .hiddenRow {padding: 0 !important;}
  .s-alert-footer {border-radius: 0px;position: fixed;left: 0;right: 0;bottom: 0;margin: 0;z-index:3000;text-align:center;}
  .s-disabled {pointer-events: none;opacity: 0.5;}
  .s-focus {box-shadow: 0px 0px 10px 0px #aaa;}
  .s-filter-group-style.s-focus {background-color: white;-webkit-box-shadow:1px 1px   0 rgba(0,   0,   0,   0.100),3px 3px   0 rgba(255, 255, 255, 1.0),4px 4px   0 rgba(0,   0,   0,   0.125),6px 6px   0 rgba(255, 255, 255, 1.0),4px 7px 7px   0 #aaaaaa;-moz-box-shadow:1px 1px   0 rgba(0,   0,   0,   0.100),3px 3px   0 rgba(255, 255, 255, 1.0),4px 4px   0 rgba(0,   0,   0,   0.125),6px 6px   0 rgba(255, 255, 255, 1.0),4px 7px 7px   0 #aaaaaa;box-shadow:1px 1px   0 rgba(0,   0,   0,   0.100),3px 3px   0 rgba(255, 255, 255, 1.0),4px 4px   0 rgba(0,   0,   0,   0.125),6px 6px   0 rgba(255, 255, 255, 1.0),4px 7px 7px   0 #aaaaaa;}
  .s-focus .panel-heading {background-color:#F58620 !important;}
  .s-focus .panel-heading .fa {color:#ffffff !important;}
  .s-filter-group-style {background-color: white;-webkit-box-shadow:1px 1px   0 rgba(0,   0,   0,   0.100),3px 3px   0 rgba(255, 255, 255, 1.0),4px 4px   0 rgba(0,   0,   0,   0.125),6px 6px   0 rgba(255, 255, 255, 1.0),7px 7px   0 rgba(0,   0,   0,   0.1);-moz-box-shadow:1px 1px   0 rgba(0,   0,   0,   0.100),3px 3px   0 rgba(255, 255, 255, 1.0),4px 4px   0 rgba(0,   0,   0,   0.125),6px 6px   0 rgba(255, 255, 255, 1.0),7px 7px   0 rgba(0,   0,   0,   0.1);box-shadow:1px 1px   0 rgba(0,   0,   0,   0.100),3px 3px   0 rgba(255, 255, 255, 1.0),4px 4px   0 rgba(0,   0,   0,   0.125),6px 6px   0 rgba(255, 255, 255, 1.0),7px 7px   0 rgba(0,   0,   0,   0.1);margin-right:6px;}
  .s-filter-group-style + .btn-group-vertical {margin-right:19px !important;}


  .s-checkbox {text-align:center;-webkit-touch-callout: none;-webkit-user-select: none;-khtml-user-select: none;-moz-user-select: none;-ms-user-select: none;user-select: none;}
  .s-checkbox {margin:0px;}
  .s-checkbox label {padding-left: 0px;margin-top:2px; cursor:pointer;}
  .s-checkbox label{display:inline-block;position:relative;}
  .s-checkbox label:before{content:"";display:inline-block;width:15px;height:15px;border:1px solid #cccccc;border-radius:3px;background-color:#fff;-webkit-transition:border 0.15s ease-in-out, color 0.15s ease-in-out;transition:border 0.15s ease-in-out, color 0.15s ease-in-out;vertical-align:text-top;}
  .s-checkbox label:after{display:inline-block;position:absolute;width:16px;height:16px;left:0;top:0;padding-right:1px;padding-top:2px;font-size:9px;color:#555555;vertical-align:text-top;}
  @-moz-document url-prefix() {.s-checkbox label:after {padding-top:3px;}}
  .s-checkbox input[type=checkbox]{display:none;}
  .s-checkbox input[type=checkbox]:checked + label:after{font-family:'Glyphicons Halflings';content:"\e013";}
  .s-checkbox input[type=checkbox]:disabled + label{opacity:0.65;}
  .s-checkbox input[type=checkbox]:disabled + label:before{background-color:#eeeeee;cursor:not-allowed;}

  table tr th.s-sortable:after {font-family:'FontAwesome';content: "\f0dc";float:right;font-size:10px;margin-top:3px;cursor: pointer;color:#ccc;}
  table tr th .glyphicon {vertical-align:text-top;}


  .pagination {margin:0px;}
  .pagination>li>a, .pagination>li>span {color:#767676;}

  .s-setting-options-body .s-filter-item {vertical-align:top;margin-bottom: 16px;display: inline-block;width: 270px;margin-left: 3px;margin-top:2px;}
  .s-setting-options-body .s-filter-item span.s-or-icon {position: relative;top: -10px;left: 22px;}
  .s-setting-options-body .s-filter-item span.s-or-icon:after {content: "or";color: #ccc;}
  .s-setting-options-body .s-filter-item span.s-and-icon {position: relative;top: -10px;left: 18px;}
  .s-setting-options-body .s-filter-item span.s-and-icon:after {content: "and";color: #ccc;}
  .s-setting-options-body .s-filter-item:first-child {margin-left:0px;}
  .s-setting-options-body .filter-group {display: inline-block;background-color:#fcfcfc;padding-left: 15px;padding-top: 8px;margin-left: 15px;padding-right: 35px;margin-bottom: 10px;-moz-box-shadow: inset 0 0 1px #ccc;-webkit-box-shadow: inset 0 0 1px #ccc;box-shadow:inset 0 0 1px #ccc;}

  .s-setting-options-body .filter-group .s-filter-item:first-child {margin-left:0px;}
  .s-setting-options-body .filter-group .s-filter-item:last-child {margin-right:0px;}

  .s-setting-options-body .s-add-filter-button-box {border-bottom:1px solid}

  .s-setting-options-body .panel {display:inline-block;width:190px;margin-bottom:5px;border:none;}
  .s-setting-options-body .panel-heading {padding: 5px 15px;background-color:#606060;color:#ffffff;border-bottom:none;}
  .s-setting-options-body .panel-body {padding: 10px 15px;}

  .s-setting-options-body .s-setting-and-or {width: 100%;padding: 10px 0px 16px 0px;display: block;font-weight: 700;}
  .s-setting-options-body .s-setting-and-or .btn {min-width:52px;text-align:center;}

  .s-setting-options-body .s-add-filter {background:#eaeaea;-moz-box-shadow: inset 0 0 2px #CCCCCC;-webkit-box-shadow: inset 0 0 2px #CCCCCC;box-shadow: inset 0 0 2px #CCCCCC;margin-top:15px;}
  .s-setting-options-body .s-add-filter .row:first-child {padding-top: 15px; padding-bottom:30px; }
  .s-setting-options-body .s-add-filter h4 i {float:right;cursor:pointer;}
  .s-setting-options-body .s-add-filter h4 {border-bottom: 1px solid #dddddd;margin-bottom:15px;}
  .s-setting-options-body .s-add-filter label {font-weight:normal;}
  .s-add-filter-box .s-and-or-box {margin-top: 20px;margin-bottom: 8px;}
  .s-and-or-box {text-align:center;height:40px;}
  .s-and-or-box hr {border: 0;border-top: 3px dotted #DDDDDD;position: relative;top: -36px;z-index: 0;}
  .s-and-or-box .btn-group {z-index: 10;padding: 0px 10px;}
  .s-criteria .s-and-or-box .btn-group {background-color:#EAEAEA;}
  .s-setting-options-body .s-add-filter button.s-remove {float:right;}
  .s-setting-options-body .s-add-filter .s-button-select-group {text-align:center;border-bottom:3px dotted #DDDDDD;margin-bottom:15px;}
  .s-setting-options-body .s-add-filter .s-button-select-group .btn {margin-bottom:15px;margin-top:15px;}
  .s-setting-options-body .s-add-filter .s-filter-group-item {background: #F2F2F2;border-radius: 4px;padding: 15px;margin-bottom:10px;}

  .s-table-content-nav .s-pagination-content {margin: 8px 0px 8px 0px;vertical-align: bottom;float: right;}
  .s-table-content-nav .s-pagination-content li {vertical-align:middle;padding:0px;}
  .s-table-content-nav .s-pagination-content li .form-group {margin-bottom:0px;width:200px;}
  .s-table-content-nav .s-pagination-content li label {padding-top: 4px;font-weight: normal;padding-right: 0px;text-align: right;}
  .s-table-content-nav .s-pagination-content li .form-group>div {padding-left:5px;}
  .s-table-content-nav .s-pagination-content li ul {vertical-align:middle;}
  .s-table-content-nav .s-pagination-content .s-table-pagination {vertical-align:middle;padding:0px;}

</style>

<script charset="utf-8">
  //activate tooltips
  $(function(){
    $('.j-tool-tip-item').tooltip();
  })();
</script>

<script charset="utf-8">
  //This was created for example only to toggle the edit save icons
  $(function(){
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
  })();
</script>





<script charset="utf-8">
  $('.s-filter-item .panel-body').click(function(){
    $(this).parent().parent().parent().siblings('li').toggleClass('s-disabled');
    $(this).parent().toggleClass('s-focus');
  });
</script>




<!--- Add new default font --->
<link href='http://fonts.googleapis.com/css?family=Open+Sans:400,600,800,700' rel='stylesheet' type='text/css'>


<!--- /////////////////Below is the unchanged code ryan was working on /////////////////--->

<!--- <br />
<br />

<br />
<br />

<div class="panel panel-default"<!--- ng-app="collections"---> ng-controller="collections">
  <div class="panel-heading">
    <!---populate with listing name --->
    <h3 class="panel-title" ng-bind-template="{{collection.collectionName}} Listing"><!---CollectionName Listing---></h3>
  </div>
  <div class="panel-body">

    <div class="row s-table-content-nav">
      <div class="col-md-12 align-right">
    <!---most likely using angular filter searching here --->
        <form class="navbar-form search-bar no-padding" role="search">
          <div class="input-group">
            <input type="text" class="form-control input-sm" placeholder="Search" name="srch-term" id="srch-term">
            <div class="input-group-btn">
              <button class="btn btn-default btn-xs" type="submit"><i class="fa fa-search"></i></button>
            </div>
          </div>
        </form>

        <button type="button" class="btn btn-grey btn-xs s-table-content-nav-button" data-toggle="collapse" data-target="#option-select"><i class="fa fa-cogs"></i></button>
        <button type="button" class="btn btn-ten24 btn-xs s-table-content-nav-button"><i class="fa fa-plus"></i></button>

        <div id="option-select" class="collapse align-left">

          <div class="panel-group" id="accordion">
            <div class="panel panel-default">
              <div class="panel-heading" data-toggle="collapse" data-parent="#accordion" href="#collapseOne">
                <h4 class="panel-title">
                    Properties
                </h4>
              </div>
              <div id="collapseOne" class="panel-collapse collapse in">
                <div class="panel-body">
                  Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. 3 wolf moon officia aute, non cupidatat skateboard dolor brunch. Food truck quinoa nesciunt laborum eiusmod. Brunch 3 wolf moon tempor, sunt aliqua put a bird on it squid single-origin coffee nulla assumenda shoreditch et. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident. Ad vegan excepteur butcher vice lomo. Leggings occaecat craft beer farm-to-table, raw denim aesthetic synth nesciunt you probably haven't heard of them accusamus labore sustainable VHS.
                </div>
              </div>
            </div>
            <div class="panel panel-default">
              <div class="panel-heading" data-toggle="collapse" data-parent="#accordion" href="#collapseTwo">
                <h4 class="panel-title">
                    Filters
                </h4>
              </div>
              <div id="collapseTwo" class="panel-collapse collapse setting-options">
                <div class="panel-body">

                  <div class="row setting-options-header">
                    <div class="col-xs-3">
                      <button type="button" class="btn btn-grey btn-xs"><i class="fa fa-pencil-square-o"></i> Edit Filters</button>
                    </div>
                    <div class="col-xs-9 option-row">

                      <div class="option-dropdown">
                        <select class="form-control input-sm" ng-change="setSelectedExistingCollection(selectedExistingCollection)" ng-model="selectedExistingCollection" ng-options="existingCollection.collectionName for existingCollection in existingCollections">
              <!---populate with existing collections --->
                            <option value="">Copy From Existing Collection</option>
                        </select>
                      </div>

                      <div class="option-buttons">
                        <button ng-click="copyExistingCollection()" type="button" class="btn btn-grey btn-xs"><i class="fa fa-files-o"></i> Copy</button>
                        <button ng-click="saveExistingCollection()" type="button" class="btn btn-ten24 btn-xs"><i class="fa fa-floppy-o"></i> Save</button>
                      </div>

                    </div>
                  </div>

                  <div class="row setting-options-body">
                    <div class="col-xs-12 filters-selected">
                      <div class="row">
                        <div class="filter-item">
                          <div class="panel panel-default">
                            <div class="dropdown">
                              <div class="panel-heading dropdown-toggle" id="filter-option-drop" data-toggle="dropdown">Order Total</div>
                              <ul class="dropdown-menu" role="menu" aria-labelledby="filter-option-drop">
                                <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Edit</a></li>
                                <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Remove</a></li>
                              </ul>
                            </div>
                            <div class="panel-body">
                              $20.99 - $200.00
                            </div>
                          </div>
                          <span class="and-icon"></span>
                        </div><!--- Filter Item End --->

                        <div class="filter-item">
                          <div class="panel panel-default">
                            <div class="dropdown">
                              <div class="panel-heading dropdown-toggle" id="filter-option-drop" data-toggle="dropdown">Order Total</div>
                              <ul class="dropdown-menu" role="menu" aria-labelledby="filter-option-drop">
                                <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Edit</a></li>
                                <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Remove</a></li>
                              </ul>
                            </div>
                            <div class="panel-body">
                              $20.99 - $200.00
                            </div>
                          </div>
                          <span class="or-icon"></span>
                        </div><!--- Filter Item End --->

                        <!--- <div class="filter-group">
                          <div class="filter-item">
                            <div class="panel panel-default">
                              <div class="dropdown">
                                <div class="panel-heading dropdown-toggle" id="filter-option-drop" data-toggle="dropdown">Order Total</div>
                                <ul class="dropdown-menu" role="menu" aria-labelledby="filter-option-drop">
                                  <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Edit</a></li>
                                  <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Remove</a></li>
                                </ul>
                              </div>
                              <div class="panel-body">
                                $20.99 - $200.00
                              </div>
                            </div>
                            <span class="or-icon"></span>
                          </div>

                          <div class="filter-item">
                            <div class="panel panel-default">
                              <div class="dropdown">
                                <div class="panel-heading dropdown-toggle" id="filter-option-drop" data-toggle="dropdown">Order Total</div>
                                <ul class="dropdown-menu" role="menu" aria-labelledby="filter-option-drop">
                                  <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Edit</a></li>
                                  <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Remove</a></li>
                                </ul>
                              </div>
                              <div class="panel-body">
                                $20.99 - $200.00
                              </div>
                            </div>
                            <span class="and-icon"></span>
                          </div>
                        </div> --->

                        <div class="filter-item">
                          <div class="panel panel-default">
                            <div class="dropdown">
                              <div class="panel-heading dropdown-toggle" id="filter-option-drop" data-toggle="dropdown">Order Total</div>
                              <ul class="dropdown-menu" role="menu" aria-labelledby="filter-option-drop">
                                <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Edit</a></li>
                                <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Remove</a></li>
                              </ul>
                            </div>
                            <div class="panel-body">
                              $20.99 - $200.00
                            </div>
                          </div>
                        </div><!--- Filter Item End --->

                      </div>

                      <!--- Add another filter to filter set --->
                      <div class="row add-filter-box">
                        <div class="col-xs-12">
                          <button type="button" class="btn btn-ten24 btn-xs" data-toggle="collapse" data-target="#add-filter"><i class="fa fa-plus"></i> ADD</button>
                        </div>
                        <div class="col-xs-12 collapse add-filter" id="add-filter">
                          <div class="row">
                            <div class="col-xs-12">

                              <h4> Define Filter: <span ng-bind="collectionConfig.baseEntityAlias"></span><i class="fa fa-minus-square-o" data-toggle="collapse" data-target="#add-filter"></i></h4>

                              <div class="row">
                                <div class="col-xs-4">
                                  Select From <span  ng-bind="collectionConfig.baseEntityAlias">Orders</span>:
                                  <div class="option-dropdown">
                                    <select class="form-control input-sm"
                                        ng-change="setSelectedFilterProperty(selectedFilterProperty)"
                                        ng-model="selectedFilterProperty"
                                        ng-options="filterProperty.NAME for filterProperty in filterProperties.DATA"
                                        >
                                        <option value="" ng-bind-template="Select From {{filterProperties.ENTITYNAME}}:" selected="selected"></option>
                                    </select>
                                  </div>

                                </div>

                                <div class="col-xs-4">
                                  <h4>Criteria</h4>

                                  <form id="form_id" action="index.html" method="post">
                                    <div class="filter-group-item">
                                      <button class="btn btn-xs btn-grey remove"><i class="fa fa-times"></i> remove</button>
                                      <div class="form-group form-group-sm">
                                        <label class="col-sm-12 control-label no-padding" for="formGroupInputSmall">Date Conditions:</label>
                                        <div class="col-sm-12 no-padding">
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
                                        <label class="col-sm-12 control-label no-padding" for="formGroupInputSmall">Number of Weeks Ago:</label>
                                        <div class="col-sm-12 no-padding">
                                          <input type="text" class="form-control" id="input" placeholder="12">
                                        </div>
                                        <div class="clearfix"></div>
                                      </div>
                                    </div>
                                    <div class="and-or-box">
                                      <div class="btn-group">
                                        <button type="button" class="btn btn-default btn-xs">AND</button>
                                        <button type="button" class="btn btn-default btn-xs active">OR</button>
                                      </div>
                                      <hr/>
                                    </div>
                                  </form>

                                  <form id="form_id" action="index.html" method="post">
                                    <div class="filter-group-item">
                                      <button class="btn btn-xs btn-grey remove"><i class="fa fa-times"></i> remove</button>
                                      <div class="form-group form-group-sm">
                                        <label class="col-sm-12 control-label no-padding" for="formGroupInputSmall">Date Conditions:</label>
                                        <div class="col-sm-12 no-padding">
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
                                        <label class="col-sm-12 control-label no-padding" for="formGroupInputSmall">Number of Weeks Ago:</label>
                                        <div class="col-sm-12 no-padding">
                                          <input type="text" class="form-control" id="input" placeholder="12">
                                        </div>
                                        <div class="clearfix"></div>
                                      </div>
                                    </div>
                                    <div class="and-or-box">
                                      <div class="btn-group">
                                        <button type="button" class="btn btn-default btn-xs"><i class="fa fa-plus"></i> Define Additional Criteria</button>
                                        <button type="button" class="btn btn-default btn-xs"><i class="fa fa-plus"></i> Define Additional Group</button>
                                      </div>
                                      <hr/>
                                    </div>
                                  </form>

                                </div>

                                <div class="col-xs-4">
                                  <div class="button-select-group">
                                    <button type="button" class="btn btn-ten24">Save & Add Another Button</button>
                                    <div class="or-box">OR</div>
                                    <button type="button" class="btn btn-ten24">Save & Finish</button>
                                  </div>
                                  <div class="form-group">
                                    <div class="checkbox"><input type="checkbox" id="checkbox1"><label for="checkbox1"> Add To New Group</label></div>
                                  </div>
                                </div>
                              </div>

                            </div>
                          </div>
                        </div>
                      </div><!--- Row --->

                    </div>



                    <!--- Add and/or filter set --->
                    <div class="col-xs-12">

                      <!--- Add another filter to filter set --->
                      <div class="row add-filter-box">
                        <div class="col-xs-12">
                          <button type="button" class="btn btn-ten24" data-toggle="collapse" data-target="#add-filter-set"><i class="fa fa-plus"></i> Add Filter To New Group</button>
                        </div>
                        <div class="col-xs-12 collapse add-filter" id="add-filter-set">
                          <div class="row">
                            <div class="col-xs-12">

                              <h4> Define Filter: <span>Orders</span><i class="fa fa-minus-square-o" data-toggle="collapse" data-target="#add-filter-set"></i></h4>

                              <div class="row">
                                <div class="col-xs-4">
                                  Select From Orders:
                                  <div class="option-dropdown">
                                    <select class="form-control input-sm">
                                      <option disabled="disabled" selected="selected">Select From Orders:</option>
                                      <option value="one">One</option>
                                      <option value="two">Two</option>
                                      <option value="three">Three</option>
                                      <option value="four">Four</option>
                                      <option value="five">Five</option>
                                    </select>
                                  </div>

                                </div>

                                <div class="col-xs-4">
                                  <h4>Criteria</h4>

                                  <form id="form_id" action="index.html" method="post">
                                    <div class="filter-group-item">
                                      <button class="btn btn-xs btn-grey remove"><i class="fa fa-times"></i> remove</button>
                                      <div class="form-group form-group-sm">
                                        <label class="col-sm-12 control-label no-padding" for="formGroupInputSmall">Date Conditions:</label>
                                        <div class="col-sm-12 no-padding">
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
                                        <label class="col-sm-12 control-label no-padding" for="formGroupInputSmall">Number of Weeks Ago:</label>
                                        <div class="col-sm-12 no-padding">
                                          <input type="text" class="form-control" id="input" placeholder="12">
                                        </div>
                                        <div class="clearfix"></div>
                                      </div>
                                    </div>
                                    <div class="and-or-box">
                                      <div class="btn-group">
                                        <button type="button" class="btn btn-default btn-xs">AND</button>
                                        <button type="button" class="btn btn-default btn-xs active">OR</button>
                                      </div>
                                      <hr/>
                                    </div>
                                  </form>


                                  <form id="form_id" action="index.html" method="post">
                                    <div class="filter-group-item">
                                      <button class="btn btn-xs btn-grey remove"><i class="fa fa-times"></i> remove</button>
                                      <div class="form-group form-group-sm">
                                        <label class="col-sm-12 control-label no-padding" for="formGroupInputSmall">Date Conditions:</label>
                                        <div class="col-sm-12 no-padding">
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
                                        <label class="col-sm-12 control-label no-padding" for="formGroupInputSmall">Number of Weeks Ago:</label>
                                        <div class="col-sm-12 no-padding">
                                          <input type="text" class="form-control" id="input" placeholder="12">
                                        </div>
                                        <div class="clearfix"></div>
                                      </div>
                                    </div>
                                    <div class="and-or-box">
                                      <div class="btn-group">
                                        <button type="button" class="btn btn-default btn-xs"><i class="fa fa-plus"></i> Define Additional Criteria</button>
                                        <button type="button" class="btn btn-default btn-xs"><i class="fa fa-plus"></i> Define Additional Group</button>
                                      </div>
                                      <hr/>
                                    </div>
                                  </form>

                                </div>
                                <div class="col-xs-4">
                                  <div class="button-select-group">
                                    <button type="button" class="btn btn-ten24">Save & Add Another Button</button>
                                    <div class="or-box">OR</div>
                                    <button type="button" class="btn btn-ten24">Save & Finish</button>
                                  </div>
                                  <div class="form-group">
                                    <div class="checkbox"><input type="checkbox" id="checkbox1"><label for="checkbox1"> Add To New Group</label></div>
                                  </div>
                                </div>
                              </div>

                            </div>
                          </div>
                        </div>
                      </div><!--- Row --->

                    </div><!--- Col --->

                  </div>

                </div>
              </div>
            </div>

            <div class="panel panel-default">
              <div class="panel-heading" data-toggle="collapse" data-parent="#accordion" href="#collapseThree">
                <h4 class="panel-title">
                    Display Options
                </h4>
              </div>
              <div id="collapseThree" class="panel-collapse collapse">
                <div class="panel-body">
                  Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. 3 wolf moon officia aute, non cupidatat skateboard dolor brunch. Food truck quinoa nesciunt laborum eiusmod. Brunch 3 wolf moon tempor, sunt aliqua put a bird on it squid single-origin coffee nulla assumenda shoreditch et. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident. Ad vegan excepteur butcher vice lomo. Leggings occaecat craft beer farm-to-table, raw denim aesthetic synth nesciunt you probably haven't heard of them accusamus labore sustainable VHS.
                </div>
              </div>
            </div>
            <hr/>
          </div>
        </div>

        <!--- Drop down option you can delete if you don't need--->
        <!--- <div class="btn-group">
          <button type="button" class="btn btn-ten24 btn-xs dropdown-toggle s-table-content-nav-button" data-toggle="dropdown">
            <span class="glyphicon glyphicon-cog"></span>
          </button>
          <ul class="dropdown-menu" role="menu">
            <li><a href="#">Properties</a></li>
            <li><a href="#">Filters</a></li>
            <li><a href="#">Display Options</a></li>
          </ul>
        </div> --->

      </div>
    </div>

    <table class="table table-bordered table-striped">
        <thead>
          <!---column headers go here --->
          <tr>
            <th>Row</span></th>
            <th ng-repeat="(key,value) in collection.pageRecords[0]" class="sortable" ng-bind="key"></th>
            <th>View</th>
          </tr>
        </thead>
        <tbody>
      <tr class="even-tr" ng-repeat="pageRecord in collection.pageRecords">
              <td><div class="checkbox"><input type="checkbox" id="checkbox1"><label for="checkbox1"></label></div></td>
              <td ng-repeat="(key,value) in pageRecord" ng-bind="value"></td>
              <td class="view-element"></td>
          </tr>
          <!---TR 1--->
           <!---row data goes here --->
          <!---<tr class="even-tr">
            <td><div class="checkbox"><input type="checkbox" id="checkbox1"><label for="checkbox1"></label></div></td>
            <td>2691402</td>
            <td>Ten24</td>
            <td>James</td>
            <td>Earl</td>
            <td>Sales Order</td>
            <td>New</td>
            <td>West</td>
            <td>Jun 06, 2014 05:36 PM</td>
            <td>Jun 06, 2014 05:43 PM</td>
            <td>$183.90</td>
            <td class="view-element"></td>
          </tr>--->

        </tbody>
    </table>

    <div class="row">
      <div class="col-md-12 align-right">
        <ul class="pagination pagination-sm" sw-pagination-bar collection="collection">

        </ul>
        <!---<ul class="pagination pagination-sm">
          <li><a href="#">&laquo;</a></li>
          <li ng-repeat="pageNo in totalPages"><a href="#" ng-bind="$index+1"></a></li>
          <!---<li><a href="#">1</a></li>
          <li><a href="#">2</a></li>
          <li><a href="#">3</a></li>
          <li><a href="#">4</a></li>
          <li><a href="#">5</a></li>--->
          <li><a href="#">&raquo;</a></li>
        </ul>--->
      </div>
    </div>

  </div>
</div>

<style>

/*!
 *  Font Awesome 4.1.0 by @davegandy - http://fontawesome.io - @fontawesome
 *  License - http://fontawesome.io/license (Font: SIL OFL 1.1, CSS: MIT License)
 */@font-face{font-family:'FontAwesome';src:url('../assets/fonts/fontawesome-webfont.eot?v=4.1.0');src:url('../assets/fonts/fontawesome-webfont.eot?#iefix&v=4.1.0') format('embedded-opentype'),url('../assets/fonts/fontawesome-webfont.woff?v=4.1.0') format('woff'),url('../assets/fonts/fontawesome-webfont.ttf?v=4.1.0') format('truetype'),url('../assets/fonts/fontawesome-webfont.svg?v=4.1.0#fontawesomeregular') format('svg');font-weight:normal;font-style:normal}.fa{display:inline-block;font-family:FontAwesome;font-style:normal;font-weight:normal;line-height:1;-webkit-font-smoothing:antialiased;-moz-osx-font-smoothing:grayscale}.fa-lg{font-size:1.33333333em;line-height:.75em;vertical-align:-15%}.fa-2x{font-size:2em}.fa-3x{font-size:3em}.fa-4x{font-size:4em}.fa-5x{font-size:5em}.fa-fw{width:1.28571429em;text-align:center}.fa-ul{padding-left:0;margin-left:2.14285714em;list-style-type:none}.fa-ul>li{position:relative}.fa-li{position:absolute;left:-2.14285714em;width:2.14285714em;top:.14285714em;text-align:center}.fa-li.fa-lg{left:-1.85714286em}.fa-border{padding:.2em .25em .15em;border:solid .08em #eee;border-radius:.1em}.pull-right{float:right}.pull-left{float:left}.fa.pull-left{margin-right:.3em}.fa.pull-right{margin-left:.3em}.fa-spin{-webkit-animation:spin 2s infinite linear;-moz-animation:spin 2s infinite linear;-o-animation:spin 2s infinite linear;animation:spin 2s infinite linear}@-moz-keyframes spin{0%{-moz-transform:rotate(0deg)}100%{-moz-transform:rotate(359deg)}}@-webkit-keyframes spin{0%{-webkit-transform:rotate(0deg)}100%{-webkit-transform:rotate(359deg)}}@-o-keyframes spin{0%{-o-transform:rotate(0deg)}100%{-o-transform:rotate(359deg)}}@keyframes spin{0%{-webkit-transform:rotate(0deg);transform:rotate(0deg)}100%{-webkit-transform:rotate(359deg);transform:rotate(359deg)}}.fa-rotate-90{filter:progid:DXImageTransform.Microsoft.BasicImage(rotation=1);-webkit-transform:rotate(90deg);-moz-transform:rotate(90deg);-ms-transform:rotate(90deg);-o-transform:rotate(90deg);transform:rotate(90deg)}.fa-rotate-180{filter:progid:DXImageTransform.Microsoft.BasicImage(rotation=2);-webkit-transform:rotate(180deg);-moz-transform:rotate(180deg);-ms-transform:rotate(180deg);-o-transform:rotate(180deg);transform:rotate(180deg)}.fa-rotate-270{filter:progid:DXImageTransform.Microsoft.BasicImage(rotation=3);-webkit-transform:rotate(270deg);-moz-transform:rotate(270deg);-ms-transform:rotate(270deg);-o-transform:rotate(270deg);transform:rotate(270deg)}.fa-flip-horizontal{filter:progid:DXImageTransform.Microsoft.BasicImage(rotation=0, mirror=1);-webkit-transform:scale(-1, 1);-moz-transform:scale(-1, 1);-ms-transform:scale(-1, 1);-o-transform:scale(-1, 1);transform:scale(-1, 1)}.fa-flip-vertical{filter:progid:DXImageTransform.Microsoft.BasicImage(rotation=2, mirror=1);-webkit-transform:scale(1, -1);-moz-transform:scale(1, -1);-ms-transform:scale(1, -1);-o-transform:scale(1, -1);transform:scale(1, -1)}.fa-stack{position:relative;display:inline-block;width:2em;height:2em;line-height:2em;vertical-align:middle}.fa-stack-1x,.fa-stack-2x{position:absolute;left:0;width:100%;text-align:center}.fa-stack-1x{line-height:inherit}.fa-stack-2x{font-size:2em}.fa-inverse{color:#fff}.fa-glass:before{content:"\f000"}.fa-music:before{content:"\f001"}.fa-search:before{content:"\f002"}.fa-envelope-o:before{content:"\f003"}.fa-heart:before{content:"\f004"}.fa-star:before{content:"\f005"}.fa-star-o:before{content:"\f006"}.fa-user:before{content:"\f007"}.fa-film:before{content:"\f008"}.fa-th-large:before{content:"\f009"}.fa-th:before{content:"\f00a"}.fa-th-list:before{content:"\f00b"}.fa-check:before{content:"\f00c"}.fa-times:before{content:"\f00d"}.fa-search-plus:before{content:"\f00e"}.fa-search-minus:before{content:"\f010"}.fa-power-off:before{content:"\f011"}.fa-signal:before{content:"\f012"}.fa-gear:before,.fa-cog:before{content:"\f013"}.fa-trash-o:before{content:"\f014"}.fa-home:before{content:"\f015"}.fa-file-o:before{content:"\f016"}.fa-clock-o:before{content:"\f017"}.fa-road:before{content:"\f018"}.fa-download:before{content:"\f019"}.fa-arrow-circle-o-down:before{content:"\f01a"}.fa-arrow-circle-o-up:before{content:"\f01b"}.fa-inbox:before{content:"\f01c"}.fa-play-circle-o:before{content:"\f01d"}.fa-rotate-right:before,.fa-repeat:before{content:"\f01e"}.fa-refresh:before{content:"\f021"}.fa-list-alt:before{content:"\f022"}.fa-lock:before{content:"\f023"}.fa-flag:before{content:"\f024"}.fa-headphones:before{content:"\f025"}.fa-volume-off:before{content:"\f026"}.fa-volume-down:before{content:"\f027"}.fa-volume-up:before{content:"\f028"}.fa-qrcode:before{content:"\f029"}.fa-barcode:before{content:"\f02a"}.fa-tag:before{content:"\f02b"}.fa-tags:before{content:"\f02c"}.fa-book:before{content:"\f02d"}.fa-bookmark:before{content:"\f02e"}.fa-print:before{content:"\f02f"}.fa-camera:before{content:"\f030"}.fa-font:before{content:"\f031"}.fa-bold:before{content:"\f032"}.fa-italic:before{content:"\f033"}.fa-text-height:before{content:"\f034"}.fa-text-width:before{content:"\f035"}.fa-align-left:before{content:"\f036"}.fa-align-center:before{content:"\f037"}.fa-align-right:before{content:"\f038"}.fa-align-justify:before{content:"\f039"}.fa-list:before{content:"\f03a"}.fa-dedent:before,.fa-outdent:before{content:"\f03b"}.fa-indent:before{content:"\f03c"}.fa-video-camera:before{content:"\f03d"}.fa-photo:before,.fa-image:before,.fa-picture-o:before{content:"\f03e"}.fa-pencil:before{content:"\f040"}.fa-map-marker:before{content:"\f041"}.fa-adjust:before{content:"\f042"}.fa-tint:before{content:"\f043"}.fa-edit:before,.fa-pencil-square-o:before{content:"\f044"}.fa-share-square-o:before{content:"\f045"}.fa-check-square-o:before{content:"\f046"}.fa-arrows:before{content:"\f047"}.fa-step-backward:before{content:"\f048"}.fa-fast-backward:before{content:"\f049"}.fa-backward:before{content:"\f04a"}.fa-play:before{content:"\f04b"}.fa-pause:before{content:"\f04c"}.fa-stop:before{content:"\f04d"}.fa-forward:before{content:"\f04e"}.fa-fast-forward:before{content:"\f050"}.fa-step-forward:before{content:"\f051"}.fa-eject:before{content:"\f052"}.fa-chevron-left:before{content:"\f053"}.fa-chevron-right:before{content:"\f054"}.fa-plus-circle:before{content:"\f055"}.fa-minus-circle:before{content:"\f056"}.fa-times-circle:before{content:"\f057"}.fa-check-circle:before{content:"\f058"}.fa-question-circle:before{content:"\f059"}.fa-info-circle:before{content:"\f05a"}.fa-crosshairs:before{content:"\f05b"}.fa-times-circle-o:before{content:"\f05c"}.fa-check-circle-o:before{content:"\f05d"}.fa-ban:before{content:"\f05e"}.fa-arrow-left:before{content:"\f060"}.fa-arrow-right:before{content:"\f061"}.fa-arrow-up:before{content:"\f062"}.fa-arrow-down:before{content:"\f063"}.fa-mail-forward:before,.fa-share:before{content:"\f064"}.fa-expand:before{content:"\f065"}.fa-compress:before{content:"\f066"}.fa-plus:before{content:"\f067"}.fa-minus:before{content:"\f068"}.fa-asterisk:before{content:"\f069"}.fa-exclamation-circle:before{content:"\f06a"}.fa-gift:before{content:"\f06b"}.fa-leaf:before{content:"\f06c"}.fa-fire:before{content:"\f06d"}.fa-eye:before{content:"\f06e"}.fa-eye-slash:before{content:"\f070"}.fa-warning:before,.fa-exclamation-triangle:before{content:"\f071"}.fa-plane:before{content:"\f072"}.fa-calendar:before{content:"\f073"}.fa-random:before{content:"\f074"}.fa-comment:before{content:"\f075"}.fa-magnet:before{content:"\f076"}.fa-chevron-up:before{content:"\f077"}.fa-chevron-down:before{content:"\f078"}.fa-retweet:before{content:"\f079"}.fa-shopping-cart:before{content:"\f07a"}.fa-folder:before{content:"\f07b"}.fa-folder-open:before{content:"\f07c"}.fa-arrows-v:before{content:"\f07d"}.fa-arrows-h:before{content:"\f07e"}.fa-bar-chart-o:before{content:"\f080"}.fa-twitter-square:before{content:"\f081"}.fa-facebook-square:before{content:"\f082"}.fa-camera-retro:before{content:"\f083"}.fa-key:before{content:"\f084"}.fa-gears:before,.fa-cogs:before{content:"\f085"}.fa-comments:before{content:"\f086"}.fa-thumbs-o-up:before{content:"\f087"}.fa-thumbs-o-down:before{content:"\f088"}.fa-star-half:before{content:"\f089"}.fa-heart-o:before{content:"\f08a"}.fa-sign-out:before{content:"\f08b"}.fa-linkedin-square:before{content:"\f08c"}.fa-thumb-tack:before{content:"\f08d"}.fa-external-link:before{content:"\f08e"}.fa-sign-in:before{content:"\f090"}.fa-trophy:before{content:"\f091"}.fa-github-square:before{content:"\f092"}.fa-upload:before{content:"\f093"}.fa-lemon-o:before{content:"\f094"}.fa-phone:before{content:"\f095"}.fa-square-o:before{content:"\f096"}.fa-bookmark-o:before{content:"\f097"}.fa-phone-square:before{content:"\f098"}.fa-twitter:before{content:"\f099"}.fa-facebook:before{content:"\f09a"}.fa-github:before{content:"\f09b"}.fa-unlock:before{content:"\f09c"}.fa-credit-card:before{content:"\f09d"}.fa-rss:before{content:"\f09e"}.fa-hdd-o:before{content:"\f0a0"}.fa-bullhorn:before{content:"\f0a1"}.fa-bell:before{content:"\f0f3"}.fa-certificate:before{content:"\f0a3"}.fa-hand-o-right:before{content:"\f0a4"}.fa-hand-o-left:before{content:"\f0a5"}.fa-hand-o-up:before{content:"\f0a6"}.fa-hand-o-down:before{content:"\f0a7"}.fa-arrow-circle-left:before{content:"\f0a8"}.fa-arrow-circle-right:before{content:"\f0a9"}.fa-arrow-circle-up:before{content:"\f0aa"}.fa-arrow-circle-down:before{content:"\f0ab"}.fa-globe:before{content:"\f0ac"}.fa-wrench:before{content:"\f0ad"}.fa-tasks:before{content:"\f0ae"}.fa-filter:before{content:"\f0b0"}.fa-briefcase:before{content:"\f0b1"}.fa-arrows-alt:before{content:"\f0b2"}.fa-group:before,.fa-users:before{content:"\f0c0"}.fa-chain:before,.fa-link:before{content:"\f0c1"}.fa-cloud:before{content:"\f0c2"}.fa-flask:before{content:"\f0c3"}.fa-cut:before,.fa-scissors:before{content:"\f0c4"}.fa-copy:before,.fa-files-o:before{content:"\f0c5"}.fa-paperclip:before{content:"\f0c6"}.fa-save:before,.fa-floppy-o:before{content:"\f0c7"}.fa-square:before{content:"\f0c8"}.fa-navicon:before,.fa-reorder:before,.fa-bars:before{content:"\f0c9"}.fa-list-ul:before{content:"\f0ca"}.fa-list-ol:before{content:"\f0cb"}.fa-strikethrough:before{content:"\f0cc"}.fa-underline:before{content:"\f0cd"}.fa-table:before{content:"\f0ce"}.fa-magic:before{content:"\f0d0"}.fa-truck:before{content:"\f0d1"}.fa-pinterest:before{content:"\f0d2"}.fa-pinterest-square:before{content:"\f0d3"}.fa-google-plus-square:before{content:"\f0d4"}.fa-google-plus:before{content:"\f0d5"}.fa-money:before{content:"\f0d6"}.fa-caret-down:before{content:"\f0d7"}.fa-caret-up:before{content:"\f0d8"}.fa-caret-left:before{content:"\f0d9"}.fa-caret-right:before{content:"\f0da"}.fa-columns:before{content:"\f0db"}.fa-unsorted:before,.fa-sort:before{content:"\f0dc"}.fa-sort-down:before,.fa-sort-desc:before{content:"\f0dd"}.fa-sort-up:before,.fa-sort-asc:before{content:"\f0de"}.fa-envelope:before{content:"\f0e0"}.fa-linkedin:before{content:"\f0e1"}.fa-rotate-left:before,.fa-undo:before{content:"\f0e2"}.fa-legal:before,.fa-gavel:before{content:"\f0e3"}.fa-dashboard:before,.fa-tachometer:before{content:"\f0e4"}.fa-comment-o:before{content:"\f0e5"}.fa-comments-o:before{content:"\f0e6"}.fa-flash:before,.fa-bolt:before{content:"\f0e7"}.fa-sitemap:before{content:"\f0e8"}.fa-umbrella:before{content:"\f0e9"}.fa-paste:before,.fa-clipboard:before{content:"\f0ea"}.fa-lightbulb-o:before{content:"\f0eb"}.fa-exchange:before{content:"\f0ec"}.fa-cloud-download:before{content:"\f0ed"}.fa-cloud-upload:before{content:"\f0ee"}.fa-user-md:before{content:"\f0f0"}.fa-stethoscope:before{content:"\f0f1"}.fa-suitcase:before{content:"\f0f2"}.fa-bell-o:before{content:"\f0a2"}.fa-coffee:before{content:"\f0f4"}.fa-cutlery:before{content:"\f0f5"}.fa-file-text-o:before{content:"\f0f6"}.fa-building-o:before{content:"\f0f7"}.fa-hospital-o:before{content:"\f0f8"}.fa-ambulance:before{content:"\f0f9"}.fa-medkit:before{content:"\f0fa"}.fa-fighter-jet:before{content:"\f0fb"}.fa-beer:before{content:"\f0fc"}.fa-h-square:before{content:"\f0fd"}.fa-plus-square:before{content:"\f0fe"}.fa-angle-double-left:before{content:"\f100"}.fa-angle-double-right:before{content:"\f101"}.fa-angle-double-up:before{content:"\f102"}.fa-angle-double-down:before{content:"\f103"}.fa-angle-left:before{content:"\f104"}.fa-angle-right:before{content:"\f105"}.fa-angle-up:before{content:"\f106"}.fa-angle-down:before{content:"\f107"}.fa-desktop:before{content:"\f108"}.fa-laptop:before{content:"\f109"}.fa-tablet:before{content:"\f10a"}.fa-mobile-phone:before,.fa-mobile:before{content:"\f10b"}.fa-circle-o:before{content:"\f10c"}.fa-quote-left:before{content:"\f10d"}.fa-quote-right:before{content:"\f10e"}.fa-spinner:before{content:"\f110"}.fa-circle:before{content:"\f111"}.fa-mail-reply:before,.fa-reply:before{content:"\f112"}.fa-github-alt:before{content:"\f113"}.fa-folder-o:before{content:"\f114"}.fa-folder-open-o:before{content:"\f115"}.fa-smile-o:before{content:"\f118"}.fa-frown-o:before{content:"\f119"}.fa-meh-o:before{content:"\f11a"}.fa-gamepad:before{content:"\f11b"}.fa-keyboard-o:before{content:"\f11c"}.fa-flag-o:before{content:"\f11d"}.fa-flag-checkered:before{content:"\f11e"}.fa-terminal:before{content:"\f120"}.fa-code:before{content:"\f121"}.fa-mail-reply-all:before,.fa-reply-all:before{content:"\f122"}.fa-star-half-empty:before,.fa-star-half-full:before,.fa-star-half-o:before{content:"\f123"}.fa-location-arrow:before{content:"\f124"}.fa-crop:before{content:"\f125"}.fa-code-fork:before{content:"\f126"}.fa-unlink:before,.fa-chain-broken:before{content:"\f127"}.fa-question:before{content:"\f128"}.fa-info:before{content:"\f129"}.fa-exclamation:before{content:"\f12a"}.fa-superscript:before{content:"\f12b"}.fa-subscript:before{content:"\f12c"}.fa-eraser:before{content:"\f12d"}.fa-puzzle-piece:before{content:"\f12e"}.fa-microphone:before{content:"\f130"}.fa-microphone-slash:before{content:"\f131"}.fa-shield:before{content:"\f132"}.fa-calendar-o:before{content:"\f133"}.fa-fire-extinguisher:before{content:"\f134"}.fa-rocket:before{content:"\f135"}.fa-maxcdn:before{content:"\f136"}.fa-chevron-circle-left:before{content:"\f137"}.fa-chevron-circle-right:before{content:"\f138"}.fa-chevron-circle-up:before{content:"\f139"}.fa-chevron-circle-down:before{content:"\f13a"}.fa-html5:before{content:"\f13b"}.fa-css3:before{content:"\f13c"}.fa-anchor:before{content:"\f13d"}.fa-unlock-alt:before{content:"\f13e"}.fa-bullseye:before{content:"\f140"}.fa-ellipsis-h:before{content:"\f141"}.fa-ellipsis-v:before{content:"\f142"}.fa-rss-square:before{content:"\f143"}.fa-play-circle:before{content:"\f144"}.fa-ticket:before{content:"\f145"}.fa-minus-square:before{content:"\f146"}.fa-minus-square-o:before{content:"\f147"}.fa-level-up:before{content:"\f148"}.fa-level-down:before{content:"\f149"}.fa-check-square:before{content:"\f14a"}.fa-pencil-square:before{content:"\f14b"}.fa-external-link-square:before{content:"\f14c"}.fa-share-square:before{content:"\f14d"}.fa-compass:before{content:"\f14e"}.fa-toggle-down:before,.fa-caret-square-o-down:before{content:"\f150"}.fa-toggle-up:before,.fa-caret-square-o-up:before{content:"\f151"}.fa-toggle-right:before,.fa-caret-square-o-right:before{content:"\f152"}.fa-euro:before,.fa-eur:before{content:"\f153"}.fa-gbp:before{content:"\f154"}.fa-dollar:before,.fa-usd:before{content:"\f155"}.fa-rupee:before,.fa-inr:before{content:"\f156"}.fa-cny:before,.fa-rmb:before,.fa-yen:before,.fa-jpy:before{content:"\f157"}.fa-ruble:before,.fa-rouble:before,.fa-rub:before{content:"\f158"}.fa-won:before,.fa-krw:before{content:"\f159"}.fa-bitcoin:before,.fa-btc:before{content:"\f15a"}.fa-file:before{content:"\f15b"}.fa-file-text:before{content:"\f15c"}.fa-sort-alpha-asc:before{content:"\f15d"}.fa-sort-alpha-desc:before{content:"\f15e"}.fa-sort-amount-asc:before{content:"\f160"}.fa-sort-amount-desc:before{content:"\f161"}.fa-sort-numeric-asc:before{content:"\f162"}.fa-sort-numeric-desc:before{content:"\f163"}.fa-thumbs-up:before{content:"\f164"}.fa-thumbs-down:before{content:"\f165"}.fa-youtube-square:before{content:"\f166"}.fa-youtube:before{content:"\f167"}.fa-xing:before{content:"\f168"}.fa-xing-square:before{content:"\f169"}.fa-youtube-play:before{content:"\f16a"}.fa-dropbox:before{content:"\f16b"}.fa-stack-overflow:before{content:"\f16c"}.fa-instagram:before{content:"\f16d"}.fa-flickr:before{content:"\f16e"}.fa-adn:before{content:"\f170"}.fa-bitbucket:before{content:"\f171"}.fa-bitbucket-square:before{content:"\f172"}.fa-tumblr:before{content:"\f173"}.fa-tumblr-square:before{content:"\f174"}.fa-long-arrow-down:before{content:"\f175"}.fa-long-arrow-up:before{content:"\f176"}.fa-long-arrow-left:before{content:"\f177"}.fa-long-arrow-right:before{content:"\f178"}.fa-apple:before{content:"\f179"}.fa-windows:before{content:"\f17a"}.fa-android:before{content:"\f17b"}.fa-linux:before{content:"\f17c"}.fa-dribbble:before{content:"\f17d"}.fa-skype:before{content:"\f17e"}.fa-foursquare:before{content:"\f180"}.fa-trello:before{content:"\f181"}.fa-female:before{content:"\f182"}.fa-male:before{content:"\f183"}.fa-gittip:before{content:"\f184"}.fa-sun-o:before{content:"\f185"}.fa-moon-o:before{content:"\f186"}.fa-archive:before{content:"\f187"}.fa-bug:before{content:"\f188"}.fa-vk:before{content:"\f189"}.fa-weibo:before{content:"\f18a"}.fa-renren:before{content:"\f18b"}.fa-pagelines:before{content:"\f18c"}.fa-stack-exchange:before{content:"\f18d"}.fa-arrow-circle-o-right:before{content:"\f18e"}.fa-arrow-circle-o-left:before{content:"\f190"}.fa-toggle-left:before,.fa-caret-square-o-left:before{content:"\f191"}.fa-dot-circle-o:before{content:"\f192"}.fa-wheelchair:before{content:"\f193"}.fa-vimeo-square:before{content:"\f194"}.fa-turkish-lira:before,.fa-try:before{content:"\f195"}.fa-plus-square-o:before{content:"\f196"}.fa-space-shuttle:before{content:"\f197"}.fa-slack:before{content:"\f198"}.fa-envelope-square:before{content:"\f199"}.fa-wordpress:before{content:"\f19a"}.fa-openid:before{content:"\f19b"}.fa-institution:before,.fa-bank:before,.fa-university:before{content:"\f19c"}.fa-mortar-board:before,.fa-graduation-cap:before{content:"\f19d"}.fa-yahoo:before{content:"\f19e"}.fa-google:before{content:"\f1a0"}.fa-reddit:before{content:"\f1a1"}.fa-reddit-square:before{content:"\f1a2"}.fa-stumbleupon-circle:before{content:"\f1a3"}.fa-stumbleupon:before{content:"\f1a4"}.fa-delicious:before{content:"\f1a5"}.fa-digg:before{content:"\f1a6"}.fa-pied-piper-square:before,.fa-pied-piper:before{content:"\f1a7"}.fa-pied-piper-alt:before{content:"\f1a8"}.fa-drupal:before{content:"\f1a9"}.fa-joomla:before{content:"\f1aa"}.fa-language:before{content:"\f1ab"}.fa-fax:before{content:"\f1ac"}.fa-building:before{content:"\f1ad"}.fa-child:before{content:"\f1ae"}.fa-paw:before{content:"\f1b0"}.fa-spoon:before{content:"\f1b1"}.fa-cube:before{content:"\f1b2"}.fa-cubes:before{content:"\f1b3"}.fa-behance:before{content:"\f1b4"}.fa-behance-square:before{content:"\f1b5"}.fa-steam:before{content:"\f1b6"}.fa-steam-square:before{content:"\f1b7"}.fa-recycle:before{content:"\f1b8"}.fa-automobile:before,.fa-car:before{content:"\f1b9"}.fa-cab:before,.fa-taxi:before{content:"\f1ba"}.fa-tree:before{content:"\f1bb"}.fa-spotify:before{content:"\f1bc"}.fa-deviantart:before{content:"\f1bd"}.fa-soundcloud:before{content:"\f1be"}.fa-database:before{content:"\f1c0"}.fa-file-pdf-o:before{content:"\f1c1"}.fa-file-word-o:before{content:"\f1c2"}.fa-file-excel-o:before{content:"\f1c3"}.fa-file-powerpoint-o:before{content:"\f1c4"}.fa-file-photo-o:before,.fa-file-picture-o:before,.fa-file-image-o:before{content:"\f1c5"}.fa-file-zip-o:before,.fa-file-archive-o:before{content:"\f1c6"}.fa-file-sound-o:before,.fa-file-audio-o:before{content:"\f1c7"}.fa-file-movie-o:before,.fa-file-video-o:before{content:"\f1c8"}.fa-file-code-o:before{content:"\f1c9"}.fa-vine:before{content:"\f1ca"}.fa-codepen:before{content:"\f1cb"}.fa-jsfiddle:before{content:"\f1cc"}.fa-life-bouy:before,.fa-life-saver:before,.fa-support:before,.fa-life-ring:before{content:"\f1cd"}.fa-circle-o-notch:before{content:"\f1ce"}.fa-ra:before,.fa-rebel:before{content:"\f1d0"}.fa-ge:before,.fa-empire:before{content:"\f1d1"}.fa-git-square:before{content:"\f1d2"}.fa-git:before{content:"\f1d3"}.fa-hacker-news:before{content:"\f1d4"}.fa-tencent-weibo:before{content:"\f1d5"}.fa-qq:before{content:"\f1d6"}.fa-wechat:before,.fa-weixin:before{content:"\f1d7"}.fa-send:before,.fa-paper-plane:before{content:"\f1d8"}.fa-send-o:before,.fa-paper-plane-o:before{content:"\f1d9"}.fa-history:before{content:"\f1da"}.fa-circle-thin:before{content:"\f1db"}.fa-header:before{content:"\f1dc"}.fa-paragraph:before{content:"\f1dd"}.fa-sliders:before{content:"\f1de"}.fa-share-alt:before{content:"\f1e0"}.fa-share-alt-square:before{content:"\f1e1"}.fa-bomb:before{content:"\f1e2"}

  body {font-family: 'Open Sans', sans-serif;color:#666666;}
  th {font-weight:600;}

  .view-element {text-align:center;cursor:pointer;-webkit-touch-callout: none;-webkit-user-select: none;-khtml-user-select: none;-moz-user-select: none;-ms-user-select: none;user-select: none;}
  .view-element:hover {background-color:#f58620 !important;border-color:#f58620 !important;color:#fff;}
  .view-element:after{font-family:'FontAwesome';content:"\f06e";}

  .no-padding {padding:0px !important;}
  .align-right {text-align:right;}
  .align-left {text-align:left;}
  .s-table-content-nav-button {display:inline-block;}
  .s-table-content-nav button.s-table-content-nav-button {margin-top:8px;margin-bottom:8px;}
  .search-bar {display:inline-block;}
  .hiddenRow {padding: 0 !important;}


  /*CHECK BOX STYLES START*/
  .checkbox {text-align:center;-webkit-touch-callout: none;-webkit-user-select: none;-khtml-user-select: none;-moz-user-select: none;-ms-user-select: none;user-select: none;}
  .checkbox {margin:0px;}
  .checkbox label {padding-left: 0px;margin-top:2px;}
  .checkbox label{display:inline-block;position:relative;}
  .checkbox label:before{content:"";display:inline-block;width:15px;height:15px;border:1px solid #cccccc;border-radius:3px;background-color:#fff;-webkit-transition:border 0.15s ease-in-out, color 0.15s ease-in-out;transition:border 0.15s ease-in-out, color 0.15s ease-in-out;vertical-align:text-top;}
  .checkbox label:after{display:inline-block;position:absolute;width:16px;height:16px;left:0;top:0;padding-right:1px;padding-top:2px;font-size:9px;color:#555555;vertical-align:text-top;}
  @-moz-document url-prefix() {.checkbox label:after {padding-top:3px;}}
  .checkbox input[type=checkbox]{display:none;}
  .checkbox input[type=checkbox]:checked + label:after{font-family:'Glyphicons Halflings';content:"\e013";}
  .checkbox input[type=checkbox]:disabled + label{opacity:0.65;}
  .checkbox input[type=checkbox]:disabled + label:before{background-color:#eeeeee;cursor:not-allowed;}
  /*CHECK BOX STYLES END*/

  /*Bootstrap overwrite*/
  .navbar-inverse .navbar-nav>li>a {color:#b0b0b0;}
  .navbar-inverse .navbar-nav>.open>a, .navbar-inverse .navbar-nav>.open>a:hover, .navbar-inverse .navbar-nav>.open>a:focus {background-color: #1B1E24}

  .btn:focus {outline: none;}
  .panel, .panel-group .panel {border-radius:0px;}
  .panel-default>.panel-heading {background-color:#606060;color:#ffffff;}
  #accordion .panel-default>.panel-heading {cursor: pointer;}
  /*#accordion .panel-default>.panel-heading:before {font-family: 'FontAwesome';content: "\f067";float: left;margin-right: 6px;margin-top: -1px;}*/
  .panel-group .panel-heading+.panel-collapse>.panel-body {border-top: none;}
  .panel-heading {border-top-left-radius: 0px;border-top-right-radius: 0px}
  .table>thead>tr>th, .table>tbody>tr>th, .table>tfoot>tr>th, .table>thead>tr>td, .table>tbody>tr>td, .table>tfoot>tr>td {padding: 8px 8px 5px 8px;}
  .table-bordered>thead>tr>th, .table-bordered>thead>tr>td {border-bottom-width:1px;}
  .btn-default {color:#767676;}
  .s-table-content-nav .dropdown-menu {left:auto;right:0;top:88%;border-radius:0px;}
  .s-table-content-nav .dropdown-menu {background-color:#F9F9F9;}
  .dropdown-menu li.active > a:hover, .dropdown-menu li > a:hover {background-color: #FC770D;background-image: -moz-linear-gradient(top, #f58620, #f58620);background-image: -ms-linear-gradient(top, #f58620, #f58620);background-image: -webkit-gradient(linear, 0 0, 0 100%, from(#f58620), to(#f58620));background-image: -webkit-linear-gradient(top, #f58620, #f58620);background-image: -o-linear-gradient(top, #f58620, #f58620);background-image: linear-gradient(top, #f58620, #f58620);color: #FFF !important;}
  .pagination>li>a:hover, .pagination>li>span:hover, .pagination>li>a:focus, .pagination>li>span:focus {background-color:#f58620;color:#ffffff;border-color:#f58620;}
  .btn-default:hover, .btn-default:focus, .btn-default:active, .btn-default.active, .open>.dropdown-toggle.btn-default {background-color:#F58620;color:#ffffff;border-color: #F58620;}

  .btn-ten24 {background-color: #f58620;border-color: #f1790b;color: #ffffff;}
  .btn-ten24:hover,.btn-ten24:focus,.btn-ten24:active,.btn-ten24.active {background-color: #f1790b;border-color: #f1790b;color:#ffffff;}
  .btn-ten24.disabled:hover,.btn-ten24.disabled:focus,.btn-ten24.disabled:active,.btn-ten24.disabled.active,.btn-ten24[disabled]:hover,.btn-ten24[disabled]:focus,.btn-ten24[disabled]:active,.btn-ten24[disabled].active,fieldset[disabled] .btn-ten24:hover,fieldset[disabled] .btn-ten24:focus,fieldset[disabled] .btn-ten24:active,fieldset[disabled] .btn-ten24.active {background-color: #f58620;}

  .btn-grey {background-color: #eaeaea;border-color: #eaeaea;color:#5E5E5E;}
  .btn-grey:hover,.btn-grey:focus,.btn-grey:active,.btn-grey.active {background-color: #dddddd;border-color: #d1d1d1;color:#5E5E5E;}
  .btn-grey.disabled:hover,.btn-grey.disabled:focus,.btn-grey.disabled:active,.btn-grey.disabled.active,.btn-grey[disabled]:hover,.btn-grey[disabled]:focus,.btn-grey[disabled]:active,.btn-grey[disabled].active,fieldset[disabled] .btn-grey:hover,fieldset[disabled] .btn-grey:focus,fieldset[disabled] .btn-grey:active,fieldset[disabled] .btn-grey.active {background-color: #eaeaea;border-color: #eaeaea;color:#5E5E5E;}

  .btn-green {background-color: #0aa699;border-color: #0aa699;color:#ffffff;}
  .btn-green:hover,.btn-green:focus,.btn-green:active,.btn-green.active {background-color: #098e83;border-color: #07766d;color:#ffffff;}
  .btn-green.disabled:hover,.btn-green.disabled:focus,.btn-green.disabled:active,.btn-green.disabled.active,.btn-green[disabled]:hover,.btn-green[disabled]:focus,.btn-green[disabled]:active,.btn-green[disabled].active,fieldset[disabled] .btn-green:hover,fieldset[disabled] .btn-green:focus,fieldset[disabled] .btn-green:active,fieldset[disabled] .btn-green.active {background-color: #0aa699;border-color: #0aa699;color:#ffffff;}

  .btn-blue {background-color: #0090d9;border-color: #0090d9;color:#ffffff;}
  .btn-blue:hover,.btn-blue:focus,.btn-blue:active,.btn-blue.active {background-color: #007fc0;border-color: #006ea6;color:#ffffff;}
  .btn-blue.disabled:hover,.btn-blue.disabled:focus,.btn-blue.disabled:active,.btn-blue.disabled.active,.btn-blue[disabled]:hover,.btn-blue[disabled]:focus,.btn-blue[disabled]:active,.btn-blue[disabled].active,fieldset[disabled] .btn-blue:hover,fieldset[disabled] .btn-blue:focus,fieldset[disabled] .btn-blue:active,fieldset[disabled] .btn-blue.active {background-color: #0090d9;border-color: #0090d9;color:#ffffff;}

  .btn-dblue {background-color: #1B314A;border-color: #1B314A;color:#ffffff;}
  .btn-dblue:hover,.btn-dblue:focus,.btn-dblue:active,.btn-dblue.active {background-color: #142537;border-color: #0d1825;color:#ffffff;}
  .btn-dblue.disabled:hover,.btn-dblue.disabled:focus,.btn-dblue.disabled:active,.btn-dblue.disabled.active,.btn-dblue[disabled]:hover,.btn-dblue[disabled]:focus,.btn-dblue[disabled]:active,.btn-dblue[disabled].active,fieldset[disabled] .btn-dblue:hover,fieldset[disabled] .btn-dblue:focus,fieldset[disabled] .btn-dblue:active,fieldset[disabled] .btn-dblue.active {background-color: #1B314A;border-color: #1B314A;color:#ffffff;}

  .btn-red {background-color: #F14D4D;border-color: #F14D4D;color:#ffffff;}
  .btn-red:hover,.btn-red:focus,.btn-red:active,.btn-red.active {background-color: #ef3535;border-color: #ed1e1e;color:#ffffff;}
  .btn-red.disabled:hover,.btn-red.disabled:focus,.btn-red.disabled:active,.btn-red.disabled.active,.btn-red[disabled]:hover,.btn-red[disabled]:focus,.btn-red[disabled]:active,.btn-red[disabled].active,fieldset[disabled] .btn-red:hover,fieldset[disabled] .btn-red:focus,fieldset[disabled] .btn-red:active,fieldset[disabled] .btn-red.active {background-color: #F14D4D;border-color: #F14D4D;color:#ffffff;}

  .btn-dgrey {background-color: #606060;border-color: #606060;color:#ffffff;}
  .btn-dgrey:hover,.btn-dgrey:focus,.btn-dgrey:active,.btn-dgrey.active {background-color: #535353;border-color: #474747;color:#ffffff;}
  .btn-dgrey.disabled:hover,.btn-dgrey.disabled:focus,.btn-dgrey.disabled:active,.btn-dgrey.disabled.active,.btn-dgrey[disabled]:hover,.btn-dgrey[disabled]:focus,.btn-dgrey[disabled]:active,.btn-dgrey[disabled].active,fieldset[disabled] .btn-dgrey:hover,fieldset[disabled] .btn-dgrey:focus,fieldset[disabled] .btn-dgrey:active,fieldset[disabled] .btn-dgrey.active {background-color: #606060;border-color: #606060;color:#ffffff;}

  .btn-lgrey {background-color: #cccccc;border-color: #cccccc;color:#888888;}
  .btn-lgrey:hover,.btn-lgrey:focus,.btn-lgrey:active,.btn-lgrey.active {background-color: #bfbfbf;border-color: #b3b3b3;color:#888888;}
  .btn-lgrey.disabled:hover,.btn-lgrey.disabled:focus,.btn-lgrey.disabled:active,.btn-lgrey.disabled.active,.btn-lgrey[disabled]:hover,.btn-lgrey[disabled]:focus,.btn-lgrey[disabled]:active,.btn-lgrey[disabled].active,fieldset[disabled] .btn-lgrey:hover,fieldset[disabled] .btn-lgrey:focus,fieldset[disabled] .btn-lgrey:active,fieldset[disabled] .btn-lgrey.active {background-color: #cccccc;border-color: #cccccc;color:#888888;}


  table tr th.sortable:after {font-family:'FontAwesome';content: "\f0dc";float:right;font-size:10px;margin-top:3px;cursor: pointer;color:#ccc;}
  table tr th .glyphicon {vertical-align:text-top;}

  .setting-options-header {border-bottom: 1px solid #F5F5F5;padding-bottom: 14px;margin-bottom:15px;}
  .setting-options-header h4 {font-size:13px;}
  .setting-options-header .option-row {text-align:right;}
  .setting-options-header .option-row .option-dropdown {display:inline-block;width:230px;}
  .setting-options-header .option-row .option-buttons {display:inline-block;vertical-align: top;}

  .pagination {margin:0px;}
  .pagination>li>a, .pagination>li>span {color:#767676;}

  .setting-options-body .filter-item {margin-bottom: 10px;display: inline-block;width: 200px;margin-left: 15px;margin-right: 15px;margin-top:2px;}
  .setting-options-body .filter-item span.or-icon {position: relative;top: -10px;left: 22px;}
  .setting-options-body .filter-item span.or-icon:after {content: "or";color: #ccc;}
  .setting-options-body .filter-item span.and-icon {position: relative;top: -10px;left: 18px;}
  .setting-options-body .filter-item span.and-icon:after {content: "and";color: #ccc;}
  .setting-options-body .filter-group {display: inline-block;background-color:#fcfcfc;padding-left: 15px;padding-top: 8px;margin-left: 15px;padding-right: 35px;margin-bottom: 10px;-moz-box-shadow: inset 0 0 1px #ccc;-webkit-box-shadow: inset 0 0 1px #ccc;box-shadow:inset 0 0 1px #ccc;}
  .setting-options-body .filter-group .filter-item {}
  .setting-options-body .filter-group .filter-item:first-child {margin-left:0px;}
  .setting-options-body .filter-group .filter-item:last-child {margin-right:0px;}

  .setting-options-body .add-filter-button-box {border-bottom:1px solid}

  .setting-options-body .panel {display:inline-block;width:84%;}
  .setting-options-body .panel-heading {padding: 5px 15px;background-color:#606060;color:#ffffff;cursor:pointer;}
  .setting-options-body .panel-heading:after {font-family: 'FontAwesome';content: "\f0c9";float:right;color: #aaaaaa;}
  .setting-options-body .panel-body {padding: 10px 15px;}

  .setting-options-body .setting-and-or {width: 100%;padding: 10px 0px 16px 0px;display: block;font-weight: 700;}
  .setting-options-body .setting-and-or .btn {min-width:52px;text-align:center;}
  .setting-options-body .filters-selected .add-filter-box {border-bottom: 1px solid #EEE;padding-bottom: 15px;margin-bottom: 8px;}

  .setting-options-body .add-filter {background:#eaeaea;-moz-box-shadow: inset 0 0 2px #CCCCCC;-webkit-box-shadow: inset 0 0 2px #CCCCCC;box-shadow: inset 0 0 2px #CCCCCC;margin-top:15px;}
  .setting-options-body .add-filter .row:first-child {padding-top: 15px; padding-bottom:30px; }
  .setting-options-body .add-filter h4 i {float:right;cursor:pointer;}
  .setting-options-body .add-filter h4 {border-bottom: 1px solid #dddddd;margin-bottom:15px;}
  .setting-options-body .add-filter label {font-weight:normal;}
  .setting-options-body .add-filter .and-or-box {text-align:center;height:40px;}
  .setting-options-body .add-filter .and-or-box hr {border: 0;border-top: 3px dotted #DDDDDD;position: relative;top: -36px;z-index: 0;}
  .setting-options-body .add-filter .and-or-box .btn-group {z-index: 10;background: #e5e9ec;padding: 0px 10px;}
  .setting-options-body .add-filter button.remove {float:right;}
  .setting-options-body .add-filter .button-select-group {text-align:center;border-bottom:3px dotted #DDDDDD;margin-bottom:15px;}
  .setting-options-body .add-filter .button-select-group .btn {margin-bottom:15px;margin-top:15px;}
  .setting-options-body .add-filter .filter-group-item {background: #F2F2F2;border-radius: 4px;padding: 15px;margin-bottom:10px;}



  /*REMOVE*/
  #search-results {display:none;}

</style>

<link href='http://fonts.googleapis.com/css?family=Open+Sans:400,600,800,700' rel='stylesheet' type='text/css'> --->
