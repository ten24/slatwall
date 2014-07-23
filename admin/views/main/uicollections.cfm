<div class="panel panel-default" ng-app="collections">
  <div class="panel-heading">
    <h3 class="panel-title">Order Listing</h3>
  </div>
  <div class="panel-body">

    <div class="row content-nav">
      <div class="col-md-12 align-right">

        <form class="navbar-form search-bar no-padding" role="search">
          <div class="input-group">
            <input type="text" class="form-control" placeholder="Search" name="srch-term" id="srch-term">
            <div class="input-group-btn">
              <button class="btn btn-default" type="submit"><span class="glyphicon glyphicon-search"></span></button>
            </div>
          </div>
        </form>
        <button type="button" class="btn btn-default content-nav-button"><span class="glyphicon glyphicon-plus"></span></button>
        <button type="button" class="btn btn-default content-nav-button"><span class="glyphicon glyphicon-cog"></span></button>
      </div>
    </div>

    <table class="table table-bordered table-striped">
        <thead>
            <tr>
                <th>Row</span></th>
                <th class="sortable">ID</th>
                <th class="sortable">Company</th>
                <th class="sortable">First Name</th>
                <th class="sortable">Last Name</th>
                <th class="sortable">Type</th>
                <th class="sortable">Status</th>
                <th class="sortable">Origin</th>
                <th class="sortable">Created</th>
                <th class="sortable">Date Placed</th>
                <th class="sortable">Total</th>
                <th>View</th>
            </tr>
        </thead>
        <tbody>
          <!---TR 1--->
            <tr>
                <td><div class="checkbox"><input type="checkbox" id="checkbox2"><label for="checkbox2"></label></div></td>
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
                <td class="view-element" ng-model="collapsed" ng-click="collapsed=!collapsed"></td>
            </tr>
            <tr ng-show="collapsed">
              <td class="details" colspan="12">
                <table cellpadding="5" cellspacing="0" border="0" style="padding-left:50px;">
                  <tbody>
                    <tr>
                      <td><p>Nulla vitae elit libero, a pharetra augue. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor. Sed posuere consectetur est at lobortis. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Aenean lacinia bibendum nulla sed consectetur. Integer posuere erat a ante venenatis dapibus posuere velit aliquet.</p></td>
                    </tr>
                  </tbody>
                </table>
              </td>
            </tr>
            <!---TR 2--->
            <tr>
                <td><div class="checkbox"><input type="checkbox" id="checkbox2"><label for="checkbox2"></label></div></td>
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
                <td class="view-element" ng-model="collapsed2" ng-click="collapsed2=!collapsed2"></td>
            </tr>
            <tr ng-show="collapsed2">
              <td class="details" colspan="12">
                <table cellpadding="5" cellspacing="0" border="0" style="padding-left:50px;">
                  <tbody>
                    <tr>
                      <td><p>Nulla vitae elit libero, a pharetra augue. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor. Sed posuere consectetur est at lobortis. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Aenean lacinia bibendum nulla sed consectetur. Integer posuere erat a ante venenatis dapibus posuere velit aliquet.</p></td>
                    </tr>
                  </tbody>
                </table>
              </td>
            </tr>
            <!---TR 3--->
            <tr>
                <td><div class="checkbox"><input type="checkbox" id="checkbox2"><label for="checkbox2"></label></div></td>
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
                <td class="view-element" ng-model="collapsed3" ng-click="collapsed3=!collapsed3"></td>
            </tr>
            <tr ng-show="collapsed3">
              <td class="details" colspan="12">
                <table cellpadding="5" cellspacing="0" border="0" style="padding-left:50px;">
                  <tbody>
                    <tr>
                      <td><p>Nulla vitae elit libero, a pharetra augue. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor. Sed posuere consectetur est at lobortis. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Aenean lacinia bibendum nulla sed consectetur. Integer posuere erat a ante venenatis dapibus posuere velit aliquet.</p></td>
                    </tr>
                  </tbody>
                </table>
              </td>
            </tr>
            <!---TR 4--->
            <tr>
                <td><div class="checkbox"><input type="checkbox" id="checkbox2"><label for="checkbox2"></label></div></td>
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
                <td class="view-element" ng-model="collapsed3" ng-click="collapsed4=!collapsed4"></td>
            </tr>
            <tr ng-show="collapsed4">
              <td class="details" colspan="12">
                <table cellpadding="5" cellspacing="0" border="0" style="padding-left:50px;">
                  <tbody>
                    <tr>
                      <td><p>Nulla vitae elit libero, a pharetra augue. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor. Sed posuere consectetur est at lobortis. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Aenean lacinia bibendum nulla sed consectetur. Integer posuere erat a ante venenatis dapibus posuere velit aliquet.</p></td>
                    </tr>
                  </tbody>
                </table>
              </td>
            </tr>
        </tbody>
    </table>

    <div class="row">
      <div class="col-md-12 align-right">
        <ul class="pagination pagination-sm">
          <li><a href="#">&laquo;</a></li>
          <li><a href="#">1</a></li>
          <li><a href="#">2</a></li>
          <li><a href="#">3</a></li>
          <li><a href="#">4</a></li>
          <li><a href="#">5</a></li>
          <li><a href="#">&raquo;</a></li>
        </ul>
      </div>
    </div>

  </div>
</div>

<style>

  body {font-family: 'Open Sans', sans-serif;}
  th {font-weight:600;}

  .view-element {text-align:center;cursor:pointer;}
  .view-element:after{font-family:'Glyphicons Halflings';content:"\e105";}

  .no-padding {padding:0px !important;}
  .align-right {text-align:right;}
  .align-left {text-align:left;}
  .content-nav-button {display:inline-block;}
  .content-nav button.content-nav-button {margin-top:8px;margin-bottom:8px;}
  .search-bar {display:inline-block;}
  .hiddenRow {padding: 0 !important;}


  /*CHECK BOX STYLES START*/
  .checkbox {text-align:center;}
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
  .panel {border-radius:0px;}
  .panel-heading {border-top-left-radius: 0px;border-top-right-radius: 0px}
  .panel-title {font-weight:700;}
  .table>thead>tr>th, .table>tbody>tr>th, .table>tfoot>tr>th, .table>thead>tr>td, .table>tbody>tr>td, .table>tfoot>tr>td {padding: 8px 8px 5px 8px;}

  table tr th.sortable:after {font-family:'Glyphicons Halflings';content: "\e119";float:right;font-size:10px;margin-top:3px;cursor: pointer;color:#ccc;}
  table tr th .glyphicon {vertical-align:text-top;}

</style>
<link href='http://fonts.googleapis.com/css?family=Open+Sans:400,600,800,700' rel='stylesheet' type='text/css'>
