<div class="s-create-window">
  <header>
    <div class="navbar navbar-s-navbar-ten24 navbar-fixed-top">
      <span class="navbar-brand" href="#">Create Bundle</span>
      <ul class="nav navbar-nav pull-right">
        <li class="active"><a href="#"><i class="fa fa-times"></i></a></li>
      </ul>
    </div>
  </header>

  <section class="col-xs-12">

    <div class="row s-bundle-header">

      <form class="form-horizontal" role="form">
        <div class="col-xs-6">
          <div class="form-group">
            <label for="" class="col-sm-3 control-label">Bundle Name: <span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="The bundle name"> <i class="fa fa-question-circle"></i></span></label>
            <div class="col-sm-9">
              <input type="text" class="form-control" value="Custom T-Shirt" placeholder="">
            </div>
          </div>
          <div class="form-group">
            <label for="" class="col-sm-3 control-label">Bundle Code: <span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="The bundle code"> <i class="fa fa-question-circle"></i></span></label>
            <div class="col-sm-9">
              <input type="text" class="form-control" value="283746" placeholder="">
            </div>
          </div>
          <div class="form-group">
            <label for="" class="col-sm-3 control-label">Bundle Base Price: <span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="The starting price of the bundle"> <i class="fa fa-question-circle"></i></span></label>
            <div class="col-sm-9">
              <input type="text" class="form-control"value="$19.99" placeholder="">
            </div>
          </div>
        </div>

        <div class="col-xs-6">
          <div class="form-group">
            <label for="" class="col-sm-3 control-label">Type: <span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="Select a type"> <i class="fa fa-question-circle"></i></span></label>
            <div class="col-sm-9">
              <select class="form-control">
                <option value="one">One</option>
                <option value="two">Two</option>
                <option value="three">Three</option>
                <option value="four">Four</option>
                <option value="five">Five</option>
              </select>
            </div>
          </div>
          <div class="form-group">
            <label for="" class="col-sm-3 control-label">Brand: <span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="Select a brand"> <i class="fa fa-question-circle"></i></span></label>
            <div class="col-sm-9">
              <select class="form-control">
                <option value="one">One</option>
                <option value="two">Two</option>
                <option value="three">Three</option>
                <option value="four">Four</option>
                <option value="five">Five</option>
              </select>
            </div>
          </div>
        </div>
      </form>

    </div><!-- //bundle head -->
    <div class="s-bundle-group-section">

      <ul class="list-unstyled s-bundle-group">
        <li class="s-bundle-group-item">
          <div class="row">
            <div class="col-xs-5 s-bundle-group-title">
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
            <div class="col-xs-7">
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
                      <div class="s-bundle-group-items-list">
                        <ul class="list-unstyled" >
                          <li class="s-bundle-add-obj">
                            <ul class="list-unstyled list-inline">
                              <li class="col-xs-3 j-tool-tip-item s-bundle-details">Howling Wolf T-Shirt</li>
                              <li class="col-xs-1 j-tool-tip-item s-bundle-details">WOLF-01</li>
                              <li class="col-xs-2 j-tool-tip-item s-bundle-details">Size XL (TShirtHowl-XL)</li>
                              <li class="col-xs-4 j-tool-tip-item s-bundle-details">A classic howling Wolf t-shirt design...</li>
                              <li class="col-xs-1 j-tool-tip-item s-bundle-details">$9.99</li>
                              <li class="col-xs-1 j-tool-tip-item s-bundle-details-remove"><a class="btn s-btn-ten24"><i class="fa fa-times"></i></a></li>
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
                            <h4 id="j-temp-class">There are no items selected</h4>
                            <ul class="list-unstyled">
                              <li class="s-bundle-add-obj">
                                <ul class="list-unstyled list-inline">
                                  <li class="col-xs-3 j-tool-tip-item s-bundle-details">Howling Wolf T-Shirt</li>
                                  <li class="col-xs-1 j-tool-tip-item s-bundle-details">WOLF-01</li>
                                  <li class="col-xs-2 j-tool-tip-item s-bundle-details">Size XL (TShirtHowl-XL)</li>
                                  <li class="col-xs-4 j-tool-tip-item s-bundle-details">A classic howling Wolf t-shirt design...</li>
                                  <li class="col-xs-1 j-tool-tip-item s-bundle-details">$9.99</li>
                                  <li class="col-xs-1 j-tool-tip-item s-bundle-details-add"><a class="btn s-btn-ten24"><i class="fa fa-plus"></i></a></li>
                                </ul>
                                <div class="clearfix"></div>
                              </li>

                              <li class="s-bundle-add-obj">
                                <ul class="list-unstyled list-inline">
                                  <li class="col-xs-3 j-tool-tip-item s-bundle-details">Howling Wolf T-Shirt</li>
                                  <li class="col-xs-1 j-tool-tip-item s-bundle-details">WOLF-01</li>
                                  <li class="col-xs-2 j-tool-tip-item s-bundle-details">Size XL (TShirtHowl-XL)</li>
                                  <li class="col-xs-4 j-tool-tip-item s-bundle-details">A classic howling Wolf t-shirt design...</li>
                                  <li class="col-xs-1 j-tool-tip-item s-bundle-details">$9.99</li>
                                  <li class="col-xs-1 j-tool-tip-item s-bundle-details-add"><a class="btn s-btn-ten24"><i class="fa fa-plus"></i></a></li>
                                </ul>
                                <div class="clearfix"></div>
                              </li>

                              <li class="s-bundle-add-obj">
                                <ul class="list-unstyled list-inline">
                                  <li class="col-xs-3 j-tool-tip-item s-bundle-details">Howling Wolf T-Shirt</li>
                                  <li class="col-xs-1 j-tool-tip-item s-bundle-details">WOLF-01</li>
                                  <li class="col-xs-2 j-tool-tip-item s-bundle-details">Size XL (TShirtHowl-XL)</li>
                                  <li class="col-xs-4 j-tool-tip-item s-bundle-details">A classic howling Wolf t-shirt design...</li>
                                  <li class="col-xs-1 j-tool-tip-item s-bundle-details">$9.99</li>
                                  <li class="col-xs-1 j-tool-tip-item s-bundle-details-add"><a class="btn s-btn-ten24"><i class="fa fa-plus"></i></a></li>
                                </ul>
                                <div class="clearfix"></div>
                              </li>

                              <li class="s-bundle-add-obj">
                                <ul class="list-unstyled list-inline">
                                  <li class="col-xs-3 j-tool-tip-item s-bundle-details">Howling Wolf T-Shirt</li>
                                  <li class="col-xs-1 j-tool-tip-item s-bundle-details">WOLF-01</li>
                                  <li class="col-xs-2 j-tool-tip-item s-bundle-details">Size XL (TShirtHowl-XL)</li>
                                  <li class="col-xs-4 j-tool-tip-item s-bundle-details">A classic howling Wolf t-shirt design...</li>
                                  <li class="col-xs-1 j-tool-tip-item s-bundle-details">$9.99</li>
                                  <li class="col-xs-1 j-tool-tip-item s-bundle-details-add"><a class="btn s-btn-ten24"><i class="fa fa-plus"></i></a></li>
                                </ul>
                                <div class="clearfix"></div>
                              </li>

                            </ul>
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
            <div class="col-xs-5 s-bundle-group-title">
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
            <div class="col-xs-7">
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
                      <div class="s-bundle-group-items-list">
                        <ul class="list-unstyled" >
                          <li class="s-bundle-add-obj">
                            <ul class="list-unstyled list-inline">
                              <li class="col-xs-3 j-tool-tip-item s-bundle-details">Howling Wolf T-Shirt</li>
                              <li class="col-xs-1 j-tool-tip-item s-bundle-details">WOLF-01</li>
                              <li class="col-xs-2 j-tool-tip-item s-bundle-details">Size XL (TShirtHowl-XL)</li>
                              <li class="col-xs-4 j-tool-tip-item s-bundle-details">A classic howling Wolf t-shirt design...</li>
                              <li class="col-xs-1 j-tool-tip-item s-bundle-details">$9.99</li>
                              <li class="col-xs-1 j-tool-tip-item s-bundle-details-remove"><a class="btn s-btn-ten24"><i class="fa fa-times"></i></a></li>
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
                            <h4 id="j-temp-class">There are no items selected</h4>
                            <ul class="list-unstyled">
                              <li class="s-bundle-add-obj">
                                <ul class="list-unstyled list-inline">
                                  <li class="col-xs-3 j-tool-tip-item s-bundle-details">Howling Wolf T-Shirt</li>
                                  <li class="col-xs-1 j-tool-tip-item s-bundle-details">WOLF-01</li>
                                  <li class="col-xs-2 j-tool-tip-item s-bundle-details">Size XL (TShirtHowl-XL)</li>
                                  <li class="col-xs-4 j-tool-tip-item s-bundle-details">A classic howling Wolf t-shirt design...</li>
                                  <li class="col-xs-1 j-tool-tip-item s-bundle-details">$9.99</li>
                                  <li class="col-xs-1 j-tool-tip-item s-bundle-details-add"><a class="btn s-btn-ten24"><i class="fa fa-plus"></i></a></li>
                                </ul>
                                <div class="clearfix"></div>
                              </li>

                              <li class="s-bundle-add-obj">
                                <ul class="list-unstyled list-inline">
                                  <li class="col-xs-3 j-tool-tip-item s-bundle-details">Howling Wolf T-Shirt</li>
                                  <li class="col-xs-1 j-tool-tip-item s-bundle-details">WOLF-01</li>
                                  <li class="col-xs-2 j-tool-tip-item s-bundle-details">Size XL (TShirtHowl-XL)</li>
                                  <li class="col-xs-4 j-tool-tip-item s-bundle-details">A classic howling Wolf t-shirt design...</li>
                                  <li class="col-xs-1 j-tool-tip-item s-bundle-details">$9.99</li>
                                  <li class="col-xs-1 j-tool-tip-item s-bundle-details-add"><a class="btn s-btn-ten24"><i class="fa fa-plus"></i></a></li>
                                </ul>
                                <div class="clearfix"></div>
                              </li>

                              <li class="s-bundle-add-obj">
                                <ul class="list-unstyled list-inline">
                                  <li class="col-xs-3 j-tool-tip-item s-bundle-details">Howling Wolf T-Shirt</li>
                                  <li class="col-xs-1 j-tool-tip-item s-bundle-details">WOLF-01</li>
                                  <li class="col-xs-2 j-tool-tip-item s-bundle-details">Size XL (TShirtHowl-XL)</li>
                                  <li class="col-xs-4 j-tool-tip-item s-bundle-details">A classic howling Wolf t-shirt design...</li>
                                  <li class="col-xs-1 j-tool-tip-item s-bundle-details">$9.99</li>
                                  <li class="col-xs-1 j-tool-tip-item s-bundle-details-add"><a class="btn s-btn-ten24"><i class="fa fa-plus"></i></a></li>
                                </ul>
                                <div class="clearfix"></div>
                              </li>

                              <li class="s-bundle-add-obj">
                                <ul class="list-unstyled list-inline">
                                  <li class="col-xs-3 j-tool-tip-item s-bundle-details">Howling Wolf T-Shirt</li>
                                  <li class="col-xs-1 j-tool-tip-item s-bundle-details">WOLF-01</li>
                                  <li class="col-xs-2 j-tool-tip-item s-bundle-details">Size XL (TShirtHowl-XL)</li>
                                  <li class="col-xs-4 j-tool-tip-item s-bundle-details">A classic howling Wolf t-shirt design...</li>
                                  <li class="col-xs-1 j-tool-tip-item s-bundle-details">$9.99</li>
                                  <li class="col-xs-1 j-tool-tip-item s-bundle-details-add"><a class="btn s-btn-ten24"><i class="fa fa-plus"></i></a></li>
                                </ul>
                                <div class="clearfix"></div>
                              </li>

                            </ul>
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
            <div class="col-xs-5 s-bundle-group-title">
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
            <div class="col-xs-7">
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
                      <div class="s-bundle-group-items-list">
                        <ul class="list-unstyled" >
                          <li class="s-bundle-add-obj">
                            <ul class="list-unstyled list-inline">
                              <li class="col-xs-3 j-tool-tip-item s-bundle-details">Howling Wolf T-Shirt</li>
                              <li class="col-xs-1 j-tool-tip-item s-bundle-details">WOLF-01</li>
                              <li class="col-xs-2 j-tool-tip-item s-bundle-details">Size XL (TShirtHowl-XL)</li>
                              <li class="col-xs-4 j-tool-tip-item s-bundle-details">A classic howling Wolf t-shirt design...</li>
                              <li class="col-xs-1 j-tool-tip-item s-bundle-details">$9.99</li>
                              <li class="col-xs-1 j-tool-tip-item s-bundle-details-remove"><a class="btn s-btn-ten24"><i class="fa fa-times"></i></a></li>
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
                            <h4 id="j-temp-class">There are no items selected</h4>
                            <ul class="list-unstyled">
                              <li class="s-bundle-add-obj">
                                <ul class="list-unstyled list-inline">
                                  <li class="col-xs-3 j-tool-tip-item s-bundle-details">Howling Wolf T-Shirt</li>
                                  <li class="col-xs-1 j-tool-tip-item s-bundle-details">WOLF-01</li>
                                  <li class="col-xs-2 j-tool-tip-item s-bundle-details">Size XL (TShirtHowl-XL)</li>
                                  <li class="col-xs-4 j-tool-tip-item s-bundle-details">A classic howling Wolf t-shirt design...</li>
                                  <li class="col-xs-1 j-tool-tip-item s-bundle-details">$9.99</li>
                                  <li class="col-xs-1 j-tool-tip-item s-bundle-details-add"><a class="btn s-btn-ten24"><i class="fa fa-plus"></i></a></li>
                                </ul>
                                <div class="clearfix"></div>
                              </li>

                              <li class="s-bundle-add-obj">
                                <ul class="list-unstyled list-inline">
                                  <li class="col-xs-3 j-tool-tip-item s-bundle-details">Howling Wolf T-Shirt</li>
                                  <li class="col-xs-1 j-tool-tip-item s-bundle-details">WOLF-01</li>
                                  <li class="col-xs-2 j-tool-tip-item s-bundle-details">Size XL (TShirtHowl-XL)</li>
                                  <li class="col-xs-4 j-tool-tip-item s-bundle-details">A classic howling Wolf t-shirt design...</li>
                                  <li class="col-xs-1 j-tool-tip-item s-bundle-details">$9.99</li>
                                  <li class="col-xs-1 j-tool-tip-item s-bundle-details-add"><a class="btn s-btn-ten24"><i class="fa fa-plus"></i></a></li>
                                </ul>
                                <div class="clearfix"></div>
                              </li>

                              <li class="s-bundle-add-obj">
                                <ul class="list-unstyled list-inline">
                                  <li class="col-xs-3 j-tool-tip-item s-bundle-details">Howling Wolf T-Shirt</li>
                                  <li class="col-xs-1 j-tool-tip-item s-bundle-details">WOLF-01</li>
                                  <li class="col-xs-2 j-tool-tip-item s-bundle-details">Size XL (TShirtHowl-XL)</li>
                                  <li class="col-xs-4 j-tool-tip-item s-bundle-details">A classic howling Wolf t-shirt design...</li>
                                  <li class="col-xs-1 j-tool-tip-item s-bundle-details">$9.99</li>
                                  <li class="col-xs-1 j-tool-tip-item s-bundle-details-add"><a class="btn s-btn-ten24"><i class="fa fa-plus"></i></a></li>
                                </ul>
                                <div class="clearfix"></div>
                              </li>

                              <li class="s-bundle-add-obj">
                                <ul class="list-unstyled list-inline">
                                  <li class="col-xs-3 j-tool-tip-item s-bundle-details">Howling Wolf T-Shirt</li>
                                  <li class="col-xs-1 j-tool-tip-item s-bundle-details">WOLF-01</li>
                                  <li class="col-xs-2 j-tool-tip-item s-bundle-details">Size XL (TShirtHowl-XL)</li>
                                  <li class="col-xs-4 j-tool-tip-item s-bundle-details">A classic howling Wolf t-shirt design...</li>
                                  <li class="col-xs-1 j-tool-tip-item s-bundle-details">$9.99</li>
                                  <li class="col-xs-1 j-tool-tip-item s-bundle-details-add"><a class="btn s-btn-ten24"><i class="fa fa-plus"></i></a></li>
                                </ul>
                                <div class="clearfix"></div>
                              </li>

                            </ul>
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

    <button class="btn btn-xs s-btn-grey s-create-bundle-btn" data-toggle="collapse" data-target="#j-edit-filter-1"><i class="fa fa-plus"></i> Bundle Group</button>

    <!--- Edit Filter Box --->
    <div class="col-xs-12 collapse s-add-filter s-bundle-group-dropdown s-create-bundle-item" id="j-edit-filter-1">
      <div class="row">
        <h4> Define Bundle Group<i class="fa fa-times" data-toggle="collapse" data-target="#j-edit-filter-1"></i></h4>

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
                      <div class="btn-group s-search-filter">
                        <span class="s-search-input" ng-controller="TypeaheadCtrl">
                          <input type="text" ng-model="selected" placeholder="Search" typeahead="state for state in states | filter:$viewValue | limitTo:8" class="form-control">
                          <div class="s-add-bundle-type">
                            <button type="button" class="btn s-btn-dgrey" data-toggle="collapse" data-target="#j-toggle-add-bundle-type"><i class="fa fa-plus"></i> Add "This should be the name"</button>
                            <div id="j-toggle-add-bundle-type" class="collapse">
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
                        </span>
                      </div>
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
                  <div class="s-bundle-group-items-list">
                    <ul class="list-unstyled" >
                      <li class="s-bundle-add-obj">
                        <ul class="list-unstyled list-inline">
                          <li class="col-xs-3 j-tool-tip-item s-bundle-details">Howling Wolf T-Shirt</li>
                          <li class="col-xs-1 j-tool-tip-item s-bundle-details">WOLF-01</li>
                          <li class="col-xs-2 j-tool-tip-item s-bundle-details">Size XL (TShirtHowl-XL)</li>
                          <li class="col-xs-4 j-tool-tip-item s-bundle-details">A classic howling Wolf t-shirt design...</li>
                          <li class="col-xs-1 j-tool-tip-item s-bundle-details">$9.99</li>
                          <li class="col-xs-1 j-tool-tip-item s-bundle-details-remove"><a class="btn s-btn-ten24"><i class="fa fa-times"></i></a></li>
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
                        <h4 id="j-temp-class">There are no items selected</h4>
                        <ul class="list-unstyled">
                          <li class="s-bundle-add-obj">
                            <ul class="list-unstyled list-inline">
                              <li class="col-xs-3 j-tool-tip-item s-bundle-details">Howling Wolf T-Shirt</li>
                              <li class="col-xs-1 j-tool-tip-item s-bundle-details">WOLF-01</li>
                              <li class="col-xs-2 j-tool-tip-item s-bundle-details">Size XL (TShirtHowl-XL)</li>
                              <li class="col-xs-4 j-tool-tip-item s-bundle-details">A classic howling Wolf t-shirt design...</li>
                              <li class="col-xs-1 j-tool-tip-item s-bundle-details">$9.99</li>
                              <li class="col-xs-1 j-tool-tip-item s-bundle-details-add"><a class="btn s-btn-ten24"><i class="fa fa-plus"></i></a></li>
                            </ul>
                            <div class="clearfix"></div>
                          </li>

                          <li class="s-bundle-add-obj">
                            <ul class="list-unstyled list-inline">
                              <li class="col-xs-3 j-tool-tip-item s-bundle-details">Howling Wolf T-Shirt</li>
                              <li class="col-xs-1 j-tool-tip-item s-bundle-details">WOLF-01</li>
                              <li class="col-xs-2 j-tool-tip-item s-bundle-details">Size XL (TShirtHowl-XL)</li>
                              <li class="col-xs-4 j-tool-tip-item s-bundle-details">A classic howling Wolf t-shirt design...</li>
                              <li class="col-xs-1 j-tool-tip-item s-bundle-details">$9.99</li>
                              <li class="col-xs-1 j-tool-tip-item s-bundle-details-add"><a class="btn s-btn-ten24"><i class="fa fa-plus"></i></a></li>
                            </ul>
                            <div class="clearfix"></div>
                          </li>

                          <li class="s-bundle-add-obj">
                            <ul class="list-unstyled list-inline">
                              <li class="col-xs-3 j-tool-tip-item s-bundle-details">Howling Wolf T-Shirt</li>
                              <li class="col-xs-1 j-tool-tip-item s-bundle-details">WOLF-01</li>
                              <li class="col-xs-2 j-tool-tip-item s-bundle-details">Size XL (TShirtHowl-XL)</li>
                              <li class="col-xs-4 j-tool-tip-item s-bundle-details">A classic howling Wolf t-shirt design...</li>
                              <li class="col-xs-1 j-tool-tip-item s-bundle-details">$9.99</li>
                              <li class="col-xs-1 j-tool-tip-item s-bundle-details-add"><a class="btn s-btn-ten24"><i class="fa fa-plus"></i></a></li>
                            </ul>
                            <div class="clearfix"></div>
                          </li>

                          <li class="s-bundle-add-obj">
                            <ul class="list-unstyled list-inline">
                              <li class="col-xs-3 j-tool-tip-item s-bundle-details">Howling Wolf T-Shirt</li>
                              <li class="col-xs-1 j-tool-tip-item s-bundle-details">WOLF-01</li>
                              <li class="col-xs-2 j-tool-tip-item s-bundle-details">Size XL (TShirtHowl-XL)</li>
                              <li class="col-xs-4 j-tool-tip-item s-bundle-details">A classic howling Wolf t-shirt design...</li>
                              <li class="col-xs-1 j-tool-tip-item s-bundle-details">$9.99</li>
                              <li class="col-xs-1 j-tool-tip-item s-bundle-details-add"><a class="btn s-btn-ten24"><i class="fa fa-plus"></i></a></li>
                            </ul>
                            <div class="clearfix"></div>
                          </li>

                        </ul>
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

  </section>

  <footer>
    <div class="navbar navbar-s-navbar-ten24 navbar-fixed-bottom">
      <ul class="nav navbar-nav pull-right">
        <li class="active"><a href="#" style="padding: 9px 12px;font-size: 16px;">Save & New</a></li>
        <li class="active"><a href="#" style="padding: 9px 12px;font-size: 16px;">Save & Finish</a></li>
      </ul>
    </div>
  </footer>

</div><!--//wrapper end-->


<button type="button" class="btn btn-default j-test-button" style="margin-top:80px;width:100%;">
  CLICK ME
</button>


<script charset="utf-8">
  //search drop down effect
  $(function(){
    $('.s-search-filter .s-search-input input').keyup(function(){
      var myLength = $(this).val().length;
      if (myLength > 0) {
        $('.s-add-bundle-type').show();
      }else{
        $('.s-add-bundle-type').hide();
      }
    });
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
      return false;
  });
</script>

<script charset="utf-8">
  //Make panels dragable
  jQuery(function($) {
    var panelList = $('.s-j-draggablePanelList');

    panelList.sortable({
      // Only make the .panel-heading child elements support dragging.
      // Omit this to make then entire <li>...</li> draggable.
      handle: '.s-pannel-name',
      update: function() {
        $('.s-pannel-name', panelList).each(function(index, elem) {
          var $listItem = $(elem),
            newIndex = $listItem.index();

          // Persist the new indices.
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
  $('.j-test-button').click(function(){
    $('.s-create-window').show();
  });
  $('.navbar-nav .fa-times').click(function(){
    $('.s-create-window').hide();
  });
</script>


<script charset="utf-8">
  angular.module('filterSelect', ['ui.bootstrap']);
  function TypeaheadCtrl($scope, $http) {

    $scope.selected = undefined;
    $scope.states = ['Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California', 'Colorado', 'Connecticut', 'Delaware', 'Florida', 'Georgia', 'Hawaii', 'Idaho', 'Illinois', 'Indiana', 'Iowa', 'Kansas', 'Kentucky', 'Louisiana', 'Maine', 'Maryland', 'Massachusetts', 'Michigan', 'Minnesota', 'Mississippi', 'Missouri', 'Montana', 'Nebraska', 'Nevada', 'New Hampshire', 'New Jersey', 'New Mexico', 'New York', 'North Dakota', 'North Carolina', 'Ohio', 'Oklahoma', 'Oregon', 'Pennsylvania', 'Rhode Island', 'South Carolina', 'South Dakota', 'Tennessee', 'Texas', 'Utah', 'Vermont', 'Virginia', 'Washington', 'West Virginia', 'Wisconsin', 'Wyoming'];

  }
</script>
