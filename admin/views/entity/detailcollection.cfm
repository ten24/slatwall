<div class="row" ng-controller="collections" style="margin-top:12px;">
  
  <div class="col-xs-12">
    <!--- Header nav with title start --->
   <!--- <span ng-controller="collectionsTabController">--->
	<!---<span 	sw-header-with-tabs
			header-title="collection.collectionName"
			tab-array="[{tabTitle:'PROPERTIES',isActive:true,id:'properties'},
						{tabTitle:'FILTERS ('+filterCount+')',isActive:false,id:'filters'},
						{tabTitle:'DISPLAY OPTIONS',isActive:false,id:'display-options',directive:'sw-tab-display-options'}
			]"
	>
	</span>--->
	
    <!---</span>--->
    <div class="row s-header-bar">
      <div class="col-md-7"><h1 ng-bind="collection.collectionName"></h1></div>
      <div class="col-md-5 s-header-nav">
        <ul class="nav nav-tabs" role="tablist">
          <li class="active"><a href="##j-properties" role="tab" data-toggle="tab">PROPERTIES</a></li>
          <li><a href="##j-filters" role="tab" data-toggle="tab">FILTERS <span>(<span ng-bind="filterCount"></span>)</span></a></li>
          <li><a href="##j-display-options" role="tab" data-toggle="tab">DISPLAY OPTIONS</a></li>
        </ul>
      </div>
    </div>
    <!--- //Header nav with title end --->

    <!--- Tab panes for menu options start--->
    
    <div class="row s-options">
      <div class="tab-content" id="j-property-box">

        <div class="tab-pane active" id="j-properties">
          <span class="s-edit-btn-group"><button class="btn btn-xs s-btn-ten24" id="j-save-btn" ng-click="saveCollection()" style="display:none;"><i class="fa fa-floppy-o"></i> Save</button> <button class="btn btn-xs s-btn-lgrey" id="j-edit-btn"><i class="fa fa-pencil"></i> Edit</button></span>
          <form class="form-horizontal s-properties" role="form" name="collectionForm" ng-init="setCollectionFormScope(collectionForm)" >
            <input style="display:none" name="entityID" ng-model="collection.collectionID" type="hidden" value="">
            
           <!-- <span 	sw-property-display
            		object="collection"
            		property="collectionName",
					is-editable="true"
            ></span>-->
            <div class="form-group">
              <label class="col-sm-2 control-label">Title:<span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="The collection title"> <i class="fa fa-question-circle"></i></span></label>
              <div class="col-sm-10">
                <input style="display:none" ng-model="collection.collectionName" name="collectionName" type="text" class="form-control" id="inputPassword" value="" required>
                <p class="form-control-static" ng-bind="collection.collectionName"><!---collection Name ---></p>
              </div>
            </div>
            <div class="form-group">
              <label for="inputPassword" class="col-sm-2 control-label">Code: <span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="The collection code"> <i class="fa fa-question-circle"></i></span></label>
              <div class="col-sm-10">
                <input ng-model="collection.collectionCode" style="display:none" name="collectionCode" type="text" class="form-control" id="inputPassword" value="" required>
                <p class="form-control-static" ng-bind="collection.collectionCode"><!---collection Code ---></p>
              </div>
            </div>
            <div class="form-group">
              <label for="inputPassword" class="col-sm-2 control-label">Description: <span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="The collection description"> <i class="fa fa-question-circle"></i></span></label>
              <div class="col-sm-10">
                <input style="display:none" ng-model="collection.description" name="description" type="text" class="form-control" id="inputPassword" value="" >
                <p ng-bind="collection.description" class="form-control-static"><!---collection description ---></p>
              </div>
            </div>
            <div class="form-group">
              <label for="inputPassword" class="col-sm-2 control-label">Collection Type: <span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="The collection type"> <i class="fa fa-question-circle"></i></span></label>
              <div class="col-sm-10">
                <input disabled="disabled" style="display:none" ng-model="collectionConfig.baseEntityAlias" type="text" class="form-control" value="" >
                <p ng-bind="collectionConfig.baseEntityAlias" class="form-control-static"><!---collection base entity alias ---></p>
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
                	<!---filterGroups gets taken apart here --->
                	<ul class="col-xs-12 list-unstyled" 
                		sw-filter-groups 
                		data-increment-filter-count="incrementFilterCount(number)" 
                		data-filter-group-item="collectionConfig.filterGroups[0].filterGroup"
                		data-filter-properties-list="filterPropertiesList"
                		data-save-collection="saveCollection()"
                		>
                	</ul>
                </div>
                <!--- //New Filter Panel --->
              </div>
              <!--- //End Filter Group --->
            </div>
          </div>
        </div><!--- //Tab Pane --->
        <div class="tab-pane s-display-options" id="j-display-options">
			<span sw-display-options
				data-columns="collectionConfig.columns"
				data-properties-list="filterPropertiesList"
				data-save-collection="saveCollection()"
			>
				<span 	ng-repeat="column in collectionConfig.columns" 
						sw-column-item
						data-column="column"
						data-column-index="$index"
						data-save-collection="saveCollection()"
						
				></span>
			</span >
		</div><!--- //Tab Pane --->
      </div>

    </div><!--- //Row --->
    <!--- //Tab panes for menu options end--->
    <div class="s-table-options">
      <form class="navbar-form navbar-left form-horizontal" role="search">
        <div class="form-group">
          <label for="name" class="control-label"><i class="fa fa-level-down"></i></label>
          <select size="1" name="" aria-controls="" class="form-control">
            <option value="15" selected="selected" disabled="disabled">Bulk Action</option>
            <option value="20">Last Changed</option>
            <option value="20">Delete</option>
            <option value="20">Examples</option>
            <option value="20">Examples</option>
            <option value="-1">Examples</option>
          </select>
        </div>
      </form>
      <form class="navbar-form navbar-left s-table-header-search">
        <div class="input-group">
          <input type="text" class="form-control input-sm" placeholder="Search" name="srch-term" id="j-srch-term">
          <div class="input-group-btn">
            <button class="btn btn-default btn-sm" type="submit"><i class="fa fa-search"></i></button>
          </div>
        </div>
      </form>
      <div class="s-table-header-right">
        <form class="navbar-form form-horizontal navbar-left">
          <div class="form-group">
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
          </div>
        </form>
        <ul class="pagination pagination-sm navbar-left">
          <li><a href="#">&laquo;</a></li>
          <li class="active"><a href="#">1</a></li>
          <li><a href="#">2</a></li>
          <li><a href="#">3</a></li>
          <li><a href="#">4</a></li>
          <li><a href="#">5</a></li>
          <li class="disabled"><a href="#">&raquo;</a></li>
        </ul>
        <div class="btn-group" class="navbar-left">
          <button type="button" class="btn btn-sm s-btn-grey"><i class="fa fa-plus"></i></button>
        </div>
      </div>
    </div>
    <!---tab view end --->
   <!--- <div class="row s-table-content-nav">
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
                  <select 	ng-model="pageShowOptions.selected" 
                  			ng-change="pageShowOptionChanged(pageShowOptions.selected)"
                  			ng-options="pageShowOption.display for pageShowOption in pageShowOptions track by pageShowOption.value" 
                  			size="1" name="" aria-controls="" class="form-control" >
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
    </div>--->
	<!---TODO: make this list view section a directive that we pass a collection into --->
    <!---list view begin --->
    <div class="table-responsive">
	    <table class="table table-bordered table-striped">
	        <thead>
	            <tr>
	                <th>Row</span></th>
	                <th ng-repeat="(key,column) in collectionConfig.columns" class="s-sortable" ng-bind="column.title" ng-show="column.isVisible"></th>
	                <th></th>
	            </tr>
	        </thead>
	        <tbody>
				<tr class="even-tr" ng-repeat="pageRecord in collection.pageRecords">
		            <td> <div class="s-checkbox"><input type="checkbox" id="j-checkbox"><label for="j-checkbox"></label></div></td>
		            <td ng-repeat="(key,column) in collectionConfig.columns" ng-bind="pageRecord[column.propertyIdentifier.split('.').pop()]" ng-show="column.isVisible"></td>
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
	<!---list view end --->
    <div class="row">
      <div class="col-md-12">
        <div class="dataTables_info" id="example3_info">Showing <b><span ng-bind="collection.pageRecordsStart"><!--- record start ---></span> to <span ng-bind="collection.pageRecordsEnd"><!---records end ---><span></b> of <span ng-bind="collection.recordsCount"><!--- records Count ---></span> entries</div>
      </div>
    </div>
  </div>
</div>

<style>

  /*Add font awesome css*/
  @font-face{font-family:'FontAwesome';src:url('../assets/fonts/fontawesome-webfont.eot?v=4.1.0');src:url('../assets/fonts/fontawesome-webfont.eot?#iefix&v=4.1.0') format('embedded-opentype'),url('../assets/fonts/fontawesome-webfont.woff?v=4.1.0') format('woff'),url('../assets/fonts/fontawesome-webfont.ttf?v=4.1.0') format('truetype'),url('../assets/fonts/fontawesome-webfont.svg?v=4.1.0#fontawesomeregular') format('svg');font-weight:normal;font-style:normal}.fa{display:inline-block;font-family:FontAwesome;font-style:normal;font-weight:normal;line-height:1;-webkit-font-smoothing:antialiased;-moz-osx-font-smoothing:grayscale}.fa-lg{font-size:1.33333333em;line-height:.75em;vertical-align:-15%}.fa-2x{font-size:2em}.fa-3x{font-size:3em}.fa-4x{font-size:4em}.fa-5x{font-size:5em}.fa-fw{width:1.28571429em;text-align:center}.fa-ul{padding-left:0;margin-left:2.14285714em;list-style-type:none}.fa-ul>li{position:relative}.fa-li{position:absolute;left:-2.14285714em;width:2.14285714em;top:.14285714em;text-align:center}.fa-li.fa-lg{left:-1.85714286em}.fa-border{padding:.2em .25em .15em;border:solid .08em #eee;border-radius:.1em}.pull-right{float:right}.pull-left{float:left}.fa.pull-left{margin-right:.3em}.fa.pull-right{margin-left:.3em}.fa-spin{-webkit-animation:spin 2s infinite linear;-moz-animation:spin 2s infinite linear;-o-animation:spin 2s infinite linear;animation:spin 2s infinite linear}@-moz-keyframes spin{0%{-moz-transform:rotate(0deg)}100%{-moz-transform:rotate(359deg)}}@-webkit-keyframes spin{0%{-webkit-transform:rotate(0deg)}100%{-webkit-transform:rotate(359deg)}}@-o-keyframes spin{0%{-o-transform:rotate(0deg)}100%{-o-transform:rotate(359deg)}}@keyframes spin{0%{-webkit-transform:rotate(0deg);transform:rotate(0deg)}100%{-webkit-transform:rotate(359deg);transform:rotate(359deg)}}.fa-rotate-90{filter:progid:DXImageTransform.Microsoft.BasicImage(rotation=1);-webkit-transform:rotate(90deg);-moz-transform:rotate(90deg);-ms-transform:rotate(90deg);-o-transform:rotate(90deg);transform:rotate(90deg)}.fa-rotate-180{filter:progid:DXImageTransform.Microsoft.BasicImage(rotation=2);-webkit-transform:rotate(180deg);-moz-transform:rotate(180deg);-ms-transform:rotate(180deg);-o-transform:rotate(180deg);transform:rotate(180deg)}.fa-rotate-270{filter:progid:DXImageTransform.Microsoft.BasicImage(rotation=3);-webkit-transform:rotate(270deg);-moz-transform:rotate(270deg);-ms-transform:rotate(270deg);-o-transform:rotate(270deg);transform:rotate(270deg)}.fa-flip-horizontal{filter:progid:DXImageTransform.Microsoft.BasicImage(rotation=0, mirror=1);-webkit-transform:scale(-1, 1);-moz-transform:scale(-1, 1);-ms-transform:scale(-1, 1);-o-transform:scale(-1, 1);transform:scale(-1, 1)}.fa-flip-vertical{filter:progid:DXImageTransform.Microsoft.BasicImage(rotation=2, mirror=1);-webkit-transform:scale(1, -1);-moz-transform:scale(1, -1);-ms-transform:scale(1, -1);-o-transform:scale(1, -1);transform:scale(1, -1)}.fa-stack{position:relative;display:inline-block;width:2em;height:2em;line-height:2em;vertical-align:middle}.fa-stack-1x,.fa-stack-2x{position:absolute;left:0;width:100%;text-align:center}.fa-stack-1x{line-height:inherit}.fa-stack-2x{font-size:2em}.fa-inverse{color:#fff}.fa-glass:before{content:"\f000"}.fa-music:before{content:"\f001"}.fa-search:before{content:"\f002"}.fa-envelope-o:before{content:"\f003"}.fa-heart:before{content:"\f004"}.fa-star:before{content:"\f005"}.fa-star-o:before{content:"\f006"}.fa-user:before{content:"\f007"}.fa-film:before{content:"\f008"}.fa-th-large:before{content:"\f009"}.fa-th:before{content:"\f00a"}.fa-th-list:before{content:"\f00b"}.fa-check:before{content:"\f00c"}.fa-times:before{content:"\f00d"}.fa-search-plus:before{content:"\f00e"}.fa-search-minus:before{content:"\f010"}.fa-power-off:before{content:"\f011"}.fa-signal:before{content:"\f012"}.fa-gear:before,.fa-cog:before{content:"\f013"}.fa-trash-o:before{content:"\f014"}.fa-home:before{content:"\f015"}.fa-file-o:before{content:"\f016"}.fa-clock-o:before{content:"\f017"}.fa-road:before{content:"\f018"}.fa-download:before{content:"\f019"}.fa-arrow-circle-o-down:before{content:"\f01a"}.fa-arrow-circle-o-up:before{content:"\f01b"}.fa-inbox:before{content:"\f01c"}.fa-play-circle-o:before{content:"\f01d"}.fa-rotate-right:before,.fa-repeat:before{content:"\f01e"}.fa-refresh:before{content:"\f021"}.fa-list-alt:before{content:"\f022"}.fa-lock:before{content:"\f023"}.fa-flag:before{content:"\f024"}.fa-headphones:before{content:"\f025"}.fa-volume-off:before{content:"\f026"}.fa-volume-down:before{content:"\f027"}.fa-volume-up:before{content:"\f028"}.fa-qrcode:before{content:"\f029"}.fa-barcode:before{content:"\f02a"}.fa-tag:before{content:"\f02b"}.fa-tags:before{content:"\f02c"}.fa-book:before{content:"\f02d"}.fa-bookmark:before{content:"\f02e"}.fa-print:before{content:"\f02f"}.fa-camera:before{content:"\f030"}.fa-font:before{content:"\f031"}.fa-bold:before{content:"\f032"}.fa-italic:before{content:"\f033"}.fa-text-height:before{content:"\f034"}.fa-text-width:before{content:"\f035"}.fa-s-align-left:before{content:"\f036"}.fa-align-center:before{content:"\f037"}.fa-s-align-right:before{content:"\f038"}.fa-align-justify:before{content:"\f039"}.fa-list:before{content:"\f03a"}.fa-dedent:before,.fa-outdent:before{content:"\f03b"}.fa-indent:before{content:"\f03c"}.fa-video-camera:before{content:"\f03d"}.fa-photo:before,.fa-image:before,.fa-picture-o:before{content:"\f03e"}.fa-pencil:before{content:"\f040"}.fa-map-marker:before{content:"\f041"}.fa-adjust:before{content:"\f042"}.fa-tint:before{content:"\f043"}.fa-edit:before,.fa-pencil-square-o:before{content:"\f044"}.fa-share-square-o:before{content:"\f045"}.fa-check-square-o:before{content:"\f046"}.fa-arrows:before{content:"\f047"}.fa-step-backward:before{content:"\f048"}.fa-fast-backward:before{content:"\f049"}.fa-backward:before{content:"\f04a"}.fa-play:before{content:"\f04b"}.fa-pause:before{content:"\f04c"}.fa-stop:before{content:"\f04d"}.fa-forward:before{content:"\f04e"}.fa-fast-forward:before{content:"\f050"}.fa-step-forward:before{content:"\f051"}.fa-eject:before{content:"\f052"}.fa-chevron-left:before{content:"\f053"}.fa-chevron-right:before{content:"\f054"}.fa-plus-circle:before{content:"\f055"}.fa-minus-circle:before{content:"\f056"}.fa-times-circle:before{content:"\f057"}.fa-check-circle:before{content:"\f058"}.fa-question-circle:before{content:"\f059"}.fa-info-circle:before{content:"\f05a"}.fa-crosshairs:before{content:"\f05b"}.fa-times-circle-o:before{content:"\f05c"}.fa-check-circle-o:before{content:"\f05d"}.fa-ban:before{content:"\f05e"}.fa-arrow-left:before{content:"\f060"}.fa-arrow-right:before{content:"\f061"}.fa-arrow-up:before{content:"\f062"}.fa-arrow-down:before{content:"\f063"}.fa-mail-forward:before,.fa-share:before{content:"\f064"}.fa-expand:before{content:"\f065"}.fa-compress:before{content:"\f066"}.fa-plus:before{content:"\f067"}.fa-minus:before{content:"\f068"}.fa-asterisk:before{content:"\f069"}.fa-exclamation-circle:before{content:"\f06a"}.fa-gift:before{content:"\f06b"}.fa-leaf:before{content:"\f06c"}.fa-fire:before{content:"\f06d"}.fa-eye:before{content:"\f06e"}.fa-eye-slash:before{content:"\f070"}.fa-warning:before,.fa-exclamation-triangle:before{content:"\f071"}.fa-plane:before{content:"\f072"}.fa-calendar:before{content:"\f073"}.fa-random:before{content:"\f074"}.fa-comment:before{content:"\f075"}.fa-magnet:before{content:"\f076"}.fa-chevron-up:before{content:"\f077"}.fa-chevron-down:before{content:"\f078"}.fa-retweet:before{content:"\f079"}.fa-shopping-cart:before{content:"\f07a"}.fa-folder:before{content:"\f07b"}.fa-folder-open:before{content:"\f07c"}.fa-arrows-v:before{content:"\f07d"}.fa-arrows-h:before{content:"\f07e"}.fa-bar-chart-o:before{content:"\f080"}.fa-twitter-square:before{content:"\f081"}.fa-facebook-square:before{content:"\f082"}.fa-camera-retro:before{content:"\f083"}.fa-key:before{content:"\f084"}.fa-gears:before,.fa-cogs:before{content:"\f085"}.fa-comments:before{content:"\f086"}.fa-thumbs-o-up:before{content:"\f087"}.fa-thumbs-o-down:before{content:"\f088"}.fa-star-half:before{content:"\f089"}.fa-heart-o:before{content:"\f08a"}.fa-sign-out:before{content:"\f08b"}.fa-linkedin-square:before{content:"\f08c"}.fa-thumb-tack:before{content:"\f08d"}.fa-external-link:before{content:"\f08e"}.fa-sign-in:before{content:"\f090"}.fa-trophy:before{content:"\f091"}.fa-github-square:before{content:"\f092"}.fa-upload:before{content:"\f093"}.fa-lemon-o:before{content:"\f094"}.fa-phone:before{content:"\f095"}.fa-square-o:before{content:"\f096"}.fa-bookmark-o:before{content:"\f097"}.fa-phone-square:before{content:"\f098"}.fa-twitter:before{content:"\f099"}.fa-facebook:before{content:"\f09a"}.fa-github:before{content:"\f09b"}.fa-unlock:before{content:"\f09c"}.fa-credit-card:before{content:"\f09d"}.fa-rss:before{content:"\f09e"}.fa-hdd-o:before{content:"\f0a0"}.fa-bullhorn:before{content:"\f0a1"}.fa-bell:before{content:"\f0f3"}.fa-certificate:before{content:"\f0a3"}.fa-hand-o-right:before{content:"\f0a4"}.fa-hand-o-left:before{content:"\f0a5"}.fa-hand-o-up:before{content:"\f0a6"}.fa-hand-o-down:before{content:"\f0a7"}.fa-arrow-circle-left:before{content:"\f0a8"}.fa-arrow-circle-right:before{content:"\f0a9"}.fa-arrow-circle-up:before{content:"\f0aa"}.fa-arrow-circle-down:before{content:"\f0ab"}.fa-globe:before{content:"\f0ac"}.fa-wrench:before{content:"\f0ad"}.fa-tasks:before{content:"\f0ae"}.fa-filter:before{content:"\f0b0"}.fa-briefcase:before{content:"\f0b1"}.fa-arrows-alt:before{content:"\f0b2"}.fa-group:before,.fa-users:before{content:"\f0c0"}.fa-chain:before,.fa-link:before{content:"\f0c1"}.fa-cloud:before{content:"\f0c2"}.fa-flask:before{content:"\f0c3"}.fa-cut:before,.fa-scissors:before{content:"\f0c4"}.fa-copy:before,.fa-files-o:before{content:"\f0c5"}.fa-paperclip:before{content:"\f0c6"}.fa-save:before,.fa-floppy-o:before{content:"\f0c7"}.fa-square:before{content:"\f0c8"}.fa-navicon:before,.fa-reorder:before,.fa-bars:before{content:"\f0c9"}.fa-list-ul:before{content:"\f0ca"}.fa-list-ol:before{content:"\f0cb"}.fa-strikethrough:before{content:"\f0cc"}.fa-underline:before{content:"\f0cd"}.fa-table:before{content:"\f0ce"}.fa-magic:before{content:"\f0d0"}.fa-truck:before{content:"\f0d1"}.fa-pinterest:before{content:"\f0d2"}.fa-pinterest-square:before{content:"\f0d3"}.fa-google-plus-square:before{content:"\f0d4"}.fa-google-plus:before{content:"\f0d5"}.fa-money:before{content:"\f0d6"}.fa-caret-down:before{content:"\f0d7"}.fa-caret-up:before{content:"\f0d8"}.fa-caret-left:before{content:"\f0d9"}.fa-caret-right:before{content:"\f0da"}.fa-columns:before{content:"\f0db"}.fa-unsorted:before,.fa-sort:before{content:"\f0dc"}.fa-sort-down:before,.fa-sort-desc:before{content:"\f0dd"}.fa-sort-up:before,.fa-sort-asc:before{content:"\f0de"}.fa-envelope:before{content:"\f0e0"}.fa-linkedin:before{content:"\f0e1"}.fa-rotate-left:before,.fa-undo:before{content:"\f0e2"}.fa-legal:before,.fa-gavel:before{content:"\f0e3"}.fa-dashboard:before,.fa-tachometer:before{content:"\f0e4"}.fa-comment-o:before{content:"\f0e5"}.fa-comments-o:before{content:"\f0e6"}.fa-flash:before,.fa-bolt:before{content:"\f0e7"}.fa-sitemap:before{content:"\f0e8"}.fa-umbrella:before{content:"\f0e9"}.fa-paste:before,.fa-clipboard:before{content:"\f0ea"}.fa-lightbulb-o:before{content:"\f0eb"}.fa-exchange:before{content:"\f0ec"}.fa-cloud-download:before{content:"\f0ed"}.fa-cloud-upload:before{content:"\f0ee"}.fa-user-md:before{content:"\f0f0"}.fa-stethoscope:before{content:"\f0f1"}.fa-suitcase:before{content:"\f0f2"}.fa-bell-o:before{content:"\f0a2"}.fa-coffee:before{content:"\f0f4"}.fa-cutlery:before{content:"\f0f5"}.fa-file-text-o:before{content:"\f0f6"}.fa-building-o:before{content:"\f0f7"}.fa-hospital-o:before{content:"\f0f8"}.fa-ambulance:before{content:"\f0f9"}.fa-medkit:before{content:"\f0fa"}.fa-fighter-jet:before{content:"\f0fb"}.fa-beer:before{content:"\f0fc"}.fa-h-square:before{content:"\f0fd"}.fa-plus-square:before{content:"\f0fe"}.fa-angle-double-left:before{content:"\f100"}.fa-angle-double-right:before{content:"\f101"}.fa-angle-double-up:before{content:"\f102"}.fa-angle-double-down:before{content:"\f103"}.fa-angle-left:before{content:"\f104"}.fa-angle-right:before{content:"\f105"}.fa-angle-up:before{content:"\f106"}.fa-angle-down:before{content:"\f107"}.fa-desktop:before{content:"\f108"}.fa-laptop:before{content:"\f109"}.fa-tablet:before{content:"\f10a"}.fa-mobile-phone:before,.fa-mobile:before{content:"\f10b"}.fa-circle-o:before{content:"\f10c"}.fa-quote-left:before{content:"\f10d"}.fa-quote-right:before{content:"\f10e"}.fa-spinner:before{content:"\f110"}.fa-circle:before{content:"\f111"}.fa-mail-reply:before,.fa-reply:before{content:"\f112"}.fa-github-alt:before{content:"\f113"}.fa-folder-o:before{content:"\f114"}.fa-folder-open-o:before{content:"\f115"}.fa-smile-o:before{content:"\f118"}.fa-frown-o:before{content:"\f119"}.fa-meh-o:before{content:"\f11a"}.fa-gamepad:before{content:"\f11b"}.fa-keyboard-o:before{content:"\f11c"}.fa-flag-o:before{content:"\f11d"}.fa-flag-checkered:before{content:"\f11e"}.fa-terminal:before{content:"\f120"}.fa-code:before{content:"\f121"}.fa-mail-reply-all:before,.fa-reply-all:before{content:"\f122"}.fa-star-half-empty:before,.fa-star-half-full:before,.fa-star-half-o:before{content:"\f123"}.fa-location-arrow:before{content:"\f124"}.fa-crop:before{content:"\f125"}.fa-code-fork:before{content:"\f126"}.fa-unlink:before,.fa-chain-broken:before{content:"\f127"}.fa-question:before{content:"\f128"}.fa-info:before{content:"\f129"}.fa-exclamation:before{content:"\f12a"}.fa-superscript:before{content:"\f12b"}.fa-subscript:before{content:"\f12c"}.fa-eraser:before{content:"\f12d"}.fa-puzzle-piece:before{content:"\f12e"}.fa-microphone:before{content:"\f130"}.fa-microphone-slash:before{content:"\f131"}.fa-shield:before{content:"\f132"}.fa-calendar-o:before{content:"\f133"}.fa-fire-extinguisher:before{content:"\f134"}.fa-rocket:before{content:"\f135"}.fa-maxcdn:before{content:"\f136"}.fa-chevron-circle-left:before{content:"\f137"}.fa-chevron-circle-right:before{content:"\f138"}.fa-chevron-circle-up:before{content:"\f139"}.fa-chevron-circle-down:before{content:"\f13a"}.fa-html5:before{content:"\f13b"}.fa-css3:before{content:"\f13c"}.fa-anchor:before{content:"\f13d"}.fa-unlock-alt:before{content:"\f13e"}.fa-bullseye:before{content:"\f140"}.fa-ellipsis-h:before{content:"\f141"}.fa-ellipsis-v:before{content:"\f142"}.fa-rss-square:before{content:"\f143"}.fa-play-circle:before{content:"\f144"}.fa-ticket:before{content:"\f145"}.fa-minus-square:before{content:"\f146"}.fa-minus-square-o:before{content:"\f147"}.fa-level-up:before{content:"\f148"}.fa-level-down:before{content:"\f149"}.fa-check-square:before{content:"\f14a"}.fa-pencil-square:before{content:"\f14b"}.fa-external-link-square:before{content:"\f14c"}.fa-share-square:before{content:"\f14d"}.fa-compass:before{content:"\f14e"}.fa-toggle-down:before,.fa-caret-square-o-down:before{content:"\f150"}.fa-toggle-up:before,.fa-caret-square-o-up:before{content:"\f151"}.fa-toggle-right:before,.fa-caret-square-o-right:before{content:"\f152"}.fa-euro:before,.fa-eur:before{content:"\f153"}.fa-gbp:before{content:"\f154"}.fa-dollar:before,.fa-usd:before{content:"\f155"}.fa-rupee:before,.fa-inr:before{content:"\f156"}.fa-cny:before,.fa-rmb:before,.fa-yen:before,.fa-jpy:before{content:"\f157"}.fa-ruble:before,.fa-rouble:before,.fa-rub:before{content:"\f158"}.fa-won:before,.fa-krw:before{content:"\f159"}.fa-bitcoin:before,.fa-btc:before{content:"\f15a"}.fa-file:before{content:"\f15b"}.fa-file-text:before{content:"\f15c"}.fa-sort-alpha-asc:before{content:"\f15d"}.fa-sort-alpha-desc:before{content:"\f15e"}.fa-sort-amount-asc:before{content:"\f160"}.fa-sort-amount-desc:before{content:"\f161"}.fa-sort-numeric-asc:before{content:"\f162"}.fa-sort-numeric-desc:before{content:"\f163"}.fa-thumbs-up:before{content:"\f164"}.fa-thumbs-down:before{content:"\f165"}.fa-youtube-square:before{content:"\f166"}.fa-youtube:before{content:"\f167"}.fa-xing:before{content:"\f168"}.fa-xing-square:before{content:"\f169"}.fa-youtube-play:before{content:"\f16a"}.fa-dropbox:before{content:"\f16b"}.fa-stack-overflow:before{content:"\f16c"}.fa-instagram:before{content:"\f16d"}.fa-flickr:before{content:"\f16e"}.fa-adn:before{content:"\f170"}.fa-bitbucket:before{content:"\f171"}.fa-bitbucket-square:before{content:"\f172"}.fa-tumblr:before{content:"\f173"}.fa-tumblr-square:before{content:"\f174"}.fa-long-arrow-down:before{content:"\f175"}.fa-long-arrow-up:before{content:"\f176"}.fa-long-arrow-left:before{content:"\f177"}.fa-long-arrow-right:before{content:"\f178"}.fa-apple:before{content:"\f179"}.fa-windows:before{content:"\f17a"}.fa-android:before{content:"\f17b"}.fa-linux:before{content:"\f17c"}.fa-dribbble:before{content:"\f17d"}.fa-skype:before{content:"\f17e"}.fa-foursquare:before{content:"\f180"}.fa-trello:before{content:"\f181"}.fa-female:before{content:"\f182"}.fa-male:before{content:"\f183"}.fa-gittip:before{content:"\f184"}.fa-sun-o:before{content:"\f185"}.fa-moon-o:before{content:"\f186"}.fa-archive:before{content:"\f187"}.fa-bug:before{content:"\f188"}.fa-vk:before{content:"\f189"}.fa-weibo:before{content:"\f18a"}.fa-renren:before{content:"\f18b"}.fa-pagelines:before{content:"\f18c"}.fa-stack-exchange:before{content:"\f18d"}.fa-arrow-circle-o-right:before{content:"\f18e"}.fa-arrow-circle-o-left:before{content:"\f190"}.fa-toggle-left:before,.fa-caret-square-o-left:before{content:"\f191"}.fa-dot-circle-o:before{content:"\f192"}.fa-wheelchair:before{content:"\f193"}.fa-vimeo-square:before{content:"\f194"}.fa-turkish-lira:before,.fa-try:before{content:"\f195"}.fa-plus-square-o:before{content:"\f196"}.fa-space-shuttle:before{content:"\f197"}.fa-slack:before{content:"\f198"}.fa-envelope-square:before{content:"\f199"}.fa-wordpress:before{content:"\f19a"}.fa-openid:before{content:"\f19b"}.fa-institution:before,.fa-bank:before,.fa-university:before{content:"\f19c"}.fa-mortar-board:before,.fa-graduation-cap:before{content:"\f19d"}.fa-yahoo:before{content:"\f19e"}.fa-google:before{content:"\f1a0"}.fa-reddit:before{content:"\f1a1"}.fa-reddit-square:before{content:"\f1a2"}.fa-stumbleupon-circle:before{content:"\f1a3"}.fa-stumbleupon:before{content:"\f1a4"}.fa-delicious:before{content:"\f1a5"}.fa-digg:before{content:"\f1a6"}.fa-pied-piper-square:before,.fa-pied-piper:before{content:"\f1a7"}.fa-pied-piper-alt:before{content:"\f1a8"}.fa-drupal:before{content:"\f1a9"}.fa-joomla:before{content:"\f1aa"}.fa-language:before{content:"\f1ab"}.fa-fax:before{content:"\f1ac"}.fa-building:before{content:"\f1ad"}.fa-child:before{content:"\f1ae"}.fa-paw:before{content:"\f1b0"}.fa-spoon:before{content:"\f1b1"}.fa-cube:before{content:"\f1b2"}.fa-cubes:before{content:"\f1b3"}.fa-behance:before{content:"\f1b4"}.fa-behance-square:before{content:"\f1b5"}.fa-steam:before{content:"\f1b6"}.fa-steam-square:before{content:"\f1b7"}.fa-recycle:before{content:"\f1b8"}.fa-automobile:before,.fa-car:before{content:"\f1b9"}.fa-cab:before,.fa-taxi:before{content:"\f1ba"}.fa-tree:before{content:"\f1bb"}.fa-spotify:before{content:"\f1bc"}.fa-deviantart:before{content:"\f1bd"}.fa-soundcloud:before{content:"\f1be"}.fa-database:before{content:"\f1c0"}.fa-file-pdf-o:before{content:"\f1c1"}.fa-file-word-o:before{content:"\f1c2"}.fa-file-excel-o:before{content:"\f1c3"}.fa-file-powerpoint-o:before{content:"\f1c4"}.fa-file-photo-o:before,.fa-file-picture-o:before,.fa-file-image-o:before{content:"\f1c5"}.fa-file-zip-o:before,.fa-file-archive-o:before{content:"\f1c6"}.fa-file-sound-o:before,.fa-file-audio-o:before{content:"\f1c7"}.fa-file-movie-o:before,.fa-file-video-o:before{content:"\f1c8"}.fa-file-code-o:before{content:"\f1c9"}.fa-vine:before{content:"\f1ca"}.fa-codepen:before{content:"\f1cb"}.fa-jsfiddle:before{content:"\f1cc"}.fa-life-bouy:before,.fa-life-saver:before,.fa-support:before,.fa-life-ring:before{content:"\f1cd"}.fa-circle-o-notch:before{content:"\f1ce"}.fa-ra:before,.fa-rebel:before{content:"\f1d0"}.fa-ge:before,.fa-empire:before{content:"\f1d1"}.fa-git-square:before{content:"\f1d2"}.fa-git:before{content:"\f1d3"}.fa-hacker-news:before{content:"\f1d4"}.fa-tencent-weibo:before{content:"\f1d5"}.fa-qq:before{content:"\f1d6"}.fa-wechat:before,.fa-weixin:before{content:"\f1d7"}.fa-send:before,.fa-paper-plane:before{content:"\f1d8"}.fa-send-o:before,.fa-paper-plane-o:before{content:"\f1d9"}.fa-history:before{content:"\f1da"}.fa-circle-thin:before{content:"\f1db"}.fa-header:before{content:"\f1dc"}.fa-paragraph:before{content:"\f1dd"}.fa-sliders:before{content:"\f1de"}.fa-share-alt:before{content:"\f1e0"}.fa-share-alt-square:before{content:"\f1e1"}.fa-bomb:before{content:"\f1e2"}

  /*Basic style overwrite*/
  body {font-family: 'Open Sans', sans-serif;color:#666666;padding-top:21px;}
  th {font-weight:600;}
  a {color:#F58620;}
  a:hover, a:focus {color: #F9AC68;text-decoration: underline; }
  button::-moz-focus-inner {border: 0;}
  input::-moz-focus-inner { border: 0; }
  a, a:active, a:focus {outline: none;}

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
  .btn-default:hover, .btn-default:focus, .btn-default:active, .btn-default.active, .open>.dropdown-toggle.btn-default {background-color:#F58620;color:#ffffff;}
  .nav-tabs {padding:0px 15px;}
  .tab-content .tab-pane {background-color: #eeeeee;padding:0px 15px;-moz-box-shadow: inset 0 0 2px #999999;-webkit-box-shadow: inset 0 0 2px #999999;box-shadow:inset 0 0 2px #999999;padding:20px 15px}
  .nav-tabs>li.active>a, .nav-tabs>li.active>a:hover, .nav-tabs>li.active>a:focus {color: #555;cursor: default;background: none;border: none;border-bottom-color: none;border-bottom:4px solid #F58620}
  .nav-tabs>li>a {border:none;color:#999999;}
  .nav-tabs>li>a:hover {background:none;border:none;color:#555;}
  .s-properties label {text-align:left !important;width: 170px;}
  .form-control {border-color: #DDD !important;color: #767676;height: 30px;box-shadow:none;box-shadow:none;}

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
  .s-filters-selected .s-filter-item .btn-group-vertical{float:left;margin-top:20px;margin-right:21px;}
  .s-filters-selected .s-filter-item .btn-group-vertical .btn {font-size:10px;}
  .s-filters-selected .s-filter-item .btn-group-vertical .btn.active {box-shadow:none;}
  .s-filters-selected .s-and-or-box .btn-group{background-color:#eee;position:relative;top:-4px;}
  .s-filters-selected .s-define-box {text-align: center;border-top: 3px dotted #DDD;margin-top: 23px;padding-top: 20px;}
  .s-options .tab-content,.s-options .tab-pane dl dd.s-value{margin-bottom:15px;}
  .s-options .tab-pane label span i,.s-filters-selected .s-filter-item .panel .panel-body i{color:#ccc;}

  .s-add-display-field {background: #EAEAEA;-moz-box-shadow: inset 0 0 2px #CCCCCC;-webkit-box-shadow: inset 0 0 2px #CCC;box-shadow: inset 0 0 2px #CCC;margin-top: 15px;margin-right:0px;margin-left:0px;}
  .s-add-display-field > div {padding:15px;}
  .s-add-display-field > div > i.fa-plus {top: 4px;position: relative;margin-right: 5px;}
  .s-add-display-field > div button {margin-top: 4px;}

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
  @-moz-document url-prefix() {.s-checkbox label:after {padding-top:2px;}}
  .s-checkbox input[type=checkbox]{display:none;}
  .s-checkbox input[type=checkbox]:checked + label:after{font-family:'Glyphicons Halflings';content:"\e013";}
  .s-checkbox input[type=checkbox]:disabled + label{opacity:0.65;}
  .s-checkbox input[type=checkbox]:disabled + label:before{background-color:#eeeeee;cursor:not-allowed;}

  table tr th.s-sortable:after {font-family:'FontAwesome';content: "\f0dc";float:right;font-size:10px;margin-top:3px;cursor: pointer;color:#ccc;}
  table tr th .glyphicon {vertical-align:text-top;}
  .s-filter-table-box tr td:first-child {width:46px;}

  .pagination {margin: 8px 0;}
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

  .s-setting-options-body .s-add-filter-button-box {border-bottom:1px solid;}

  .s-setting-options-body .panel {display:inline-block;width:190px;margin-bottom:5px;border:none;}
  .s-setting-options-body .panel-heading {padding: 5px 15px;background-color:#606060;color:#ffffff;border-bottom:none;}
  .s-setting-options-body .panel-body {padding: 10px 15px;}

  .s-setting-options-body .s-setting-and-or {width: 100%;padding: 10px 0px 16px 0px;display: block;font-weight: 700;}
  .s-setting-options-body .s-setting-and-or .btn {min-width:52px;text-align:center;}

  .s-setting-options-body .s-add-filter {background:#eaeaea;-moz-box-shadow: inset 0 0 2px #CCCCCC;-webkit-box-shadow: inset 0 0 2px #CCCCCC;box-shadow: inset 0 0 2px #CCCCCC;margin-top:15px;}
  .s-setting-options-body .s-add-filter h4 i {float:right;cursor:pointer;padding-top:2px;}
  .s-setting-options-body .s-add-filter h4 {border-bottom: 1px solid #dddddd;margin-bottom:15px;}
  .s-setting-options-body .s-add-filter label {font-weight:normal;font-size:12px;}
  .s-add-filter-box .s-and-or-box {margin-top: 20px;margin-bottom: 8px;}
  .s-and-or-box {text-align:center;height:40px;}
  .s-and-or-box hr {border: 0;border-top: 3px dotted #DDDDDD;position: relative;top: -36px;z-index: 0;}
  .s-and-or-box .btn-group {z-index: 10;padding: 0px 10px;}
  .s-add-filter > .row > h4 {background-color: #FFF;margin-top: 0px;padding: 8px 15px;background-color: #606060;color: #DDD;}
  .s-add-filter > .row {padding-top:0px !important;}
  .s-add-filter .s-criteria {border: 3px dotted #DDD;border-bottom: none;border-top: none;margin-right: 20px;padding-right: 40px;padding-left: 40px;margin-left: 16px;margin-bottom: 15px;}
  .s-add-filter .s-button-select-group {text-align:center;}
  .s-add-filter .s-checkbox {margin-top:15px;}
  .s-add-filter .s-or-box {margin-bottom:10px;margin-top:10px;}

  /* Selectbox css used to style select menues for cross browser support */
  .selectboxit-container{position:relative;display:inline-block;vertical-align:top}
  .selectboxit-container *{font:12px Helvetica,Arial;-webkit-touch-callout:none;-webkit-user-select:none;-khtml-user-select:none;-moz-user-select:-moz-none;-ms-user-select:none;-o-user-select:none;user-select:none;outline:none;white-space:nowrap}
  .selectboxit-container .selectboxit{width:220px;cursor:pointer;margin:0;padding:0;border-radius:3px;overflow:hidden;display:block;position:relative}
  .selectboxit-container span,.selectboxit-container .selectboxit-options a{height:29px;line-height:29px;display:block;}
  .selectboxit-container .selectboxit:focus{outline:0}
  .selectboxit.selectboxit-disabled,.selectboxit-options .selectboxit-disabled{opacity:.65;filter:alpha(opacity=65);-webkit-box-shadow:none;-moz-box-shadow:none;box-shadow:none;cursor:default}
  .selectboxit-text{text-indent:5px;overflow:hidden;text-overflow:ellipsis;float:left}
  .selectboxit .selectboxit-option-icon-container{margin-left:5px}
  .selectboxit-container .selectboxit-options{-moz-box-sizing:border-box;box-sizing:border-box;min-width:100%;*width:100%;margin:0;padding:0;list-style:none;position:absolute;overflow-x:hidden;overflow-y:auto;cursor:pointer;display:none;z-index:9999999999999;text-align:left;-webkit-box-shadow:none;-moz-box-shadow:none;box-shadow:none}
  .selectboxit-option .selectboxit-option-anchor{padding:0 2px}
  .selectboxit-option .selectboxit-option-anchor:hover{text-decoration:none}
  .selectboxit-option,.selectboxit-optgroup-header{text-indent:5px;margin:0;list-style-type:none}
  .selectboxit-option-first{border-top-right-radius:6px;border-top-left-radius:6px}
  .selectboxit-optgroup-header + .selectboxit-option-first{border-top-right-radius:0;border-top-left-radius:0}
  .selectboxit-option-last{border-bottom-right-radius:6px;border-bottom-left-radius:6px}
  .selectboxit-optgroup-header{font-weight:700}
  .selectboxit-optgroup-header:hover{cursor:default}
  .selectboxit-arrow-container{width:30px;position:absolute;right:0;}
  .s-table-options .selectboxit-arrow-container{background-color:#eeeeee;}
  .selectboxit .selectboxit-arrow-container .selectboxit-arrow{margin:0 auto;position:absolute;top:44%;right:0;left:0}
  .selectboxit .selectboxit-arrow-container .selectboxit-arrow.ui-icon{top:30%}
  .selectboxit-option-icon-container{float:left}
  .selectboxit-container .selectboxit-option-icon{margin:0;padding:0;vertical-align:middle}
  .selectboxit-option-icon-url{width:18px;background-size:18px 18px;background-repeat:no-repeat;height:100%;background-position:center;float:left}
  .selectboxit-rendering{display:inline-block!important;*display:inline!important;zoom:1!important;visibility:visible!important;position:absolute!important;top:-9999px!important;left:-9999px!important}
  .jqueryui .ui-icon{background-color:inherit}
  .jqueryui .ui-icon-triangle-1-s{background-position:-64px -16px}
  .selectboxit-btn.selectboxit-enabled:hover,.selectboxit-btn.selectboxit-enabled:focus,.selectboxit-btn.selectboxit-enabled:active{color:#767676;background-color:#fff}
  .selectboxit-btn.selectboxit-enabled:hover,.selectboxit-btn.selectboxit-enabled:focus{color:#767676;text-decoration:none;background-position:0 -15px}
  .selectboxit-default-arrow{width:0;height:0;border-top:4px solid #767676;border-right:4px solid transparent;border-left:4px solid transparent;color:#767676 !important;}
  .selectboxit-list{background-color:#fff;border:1px solid #ccc;border:1px solid rgba(0,0,0,0.2);-webkit-box-shadow:0 5px 10px rgba(0,0,0,0.2);-moz-box-shadow:0 5px 10px rgba(0,0,0,0.2);box-shadow:0 5px 10px rgba(0,0,0,0.2)}
  .selectboxit-list .selectboxit-option-anchor{color:#767676}
  .selectboxit-list > .selectboxit-focus > .selectboxit-option-anchor{background-color:#F58620;color:#ffffff;}
  .selectboxit-list > .selectboxit-disabled > .selectboxit-option-anchor{color:#ccc}

  .s-table-options {display: inline-block;width: 100%;}
  .s-table-options .control-label {font-weight:normal;vertical-align:middle;padding-top: 4px;}
  .s-table-options .navbar-form {margin-right:15px;}
  .s-table-options .navbar-form:first-child {margin-left:17px;}
  .s-table-options .btn-group {margin-top:15px;margin-top: 8px;margin-bottom: 8px;margin-left:15px;}
  .s-table-options .s-table-header-search {padding-left:0px;}
  .s-table-options .s-table-header-search button {color:#5E5E5E;background-color:#eeeeee;}
  .s-table-options .s-table-header-right {float:right;}
  .s-table-options .fa-level-down {transform: scaleX(-1);-moz-transform: scaleX(-1);-webkit-transform: scaleX(-1);-ms-transform: scaleX(-1);display:inline-block;position: relative;top: 6px;}

  .s-j-draggablePanelList a {height: 40px;border-radius: 0px;border:0px !important;margin:0px !important;}

  .s-j-draggablePanelList a:hover {background-color:#eeeeee;color:#767676;border:0px !important;}
  .s-j-draggablePanelList a.active {border:0px;box-shadow:none;-moz-box-shadow:    inset  0  8px 8px -8px rgba(0, 0, 0, 0.125),inset  0 -8px 8px -8px rgba(0, 0, 0, 0.125);-webkit-box-shadow: inset  0  8px 8px -8px rgba(0, 0, 0, 0.125),inset  0 -8px 8px -8px rgba(0, 0, 0, 0.125);box-shadow: inset  0  8px 8px -8px rgba(0, 0, 0, 0.125),inset  0 -8px 8px -8px rgba(0, 0, 0, 0.125);border:0px;}
  .s-j-draggablePanelList a i {margin-top:50%;}
  .s-j-draggablePanelList a.active:hover {background-color:#F79C49;color:#ffffff;}
  .s-j-draggablePanelList a:last-child {border:0px;}
  .s-j-draggablePanelList .s-remove {background-color:#DA5757;color:#ffffff !important;}
  .s-j-draggablePanelList .s-remove:hover {background-color:#D66B6B !important;}
  .s-j-draggablePanelList .s-remove.active {background-color:#DA5757 !important;color:#ffffff !important;}
  .s-j-draggablePanelList .s-sort.active {background-color:#ffffff !important;color:#767676 !important;box-shadow:none;}
  .s-j-draggablePanelList .s-sort:hover {background-color:#eeeeee !important;color:#767676 !important;box-shadow:none;}
  .s-j-draggablePanelList .list-group-item {margin-bottom:2px;}
  .s-j-draggablePanelList .s-pannel-name {cursor: move;height:40px;}
  .s-j-draggablePanelList .s-pannel-name input {width: 164px;display:inline-block;margin-top:5px;margin-right:5px;}
  .s-j-draggablePanelList .s-pannel-name .s-pannel-title {cursor: pointer;color:#666666;background:none;}
  .s-j-draggablePanelList .s-pannel-name .s-pannel-title:hover {text-decoration:none;}
  .s-j-draggablePanelList .s-pannel-name .s-pannel-title:active {box-shadow:none !important;background:none !important;}
  .s-j-draggablePanelList .s-pannel-name i {color:#ccc;}
  .s-j-draggablePanelList .s-pannel-body {text-align:right;padding-right:0px;}
  .s-j-draggablePanelList .list-group-item {padding-top:0px;padding-bottom:0px;border-radius:0px;}
  .s-j-draggablePanelList .s-pannel-name > span:first-child {position:absolute;top:0px;left:0px;display:inline-block;width: 34px;text-align: center;height: 40px;background-color: #606060;box-shadow: inset -7px 0 2px -7px rgba(0, 0, 0, 0.8);color: #FFF;display: inline-block;padding-top: 11px;font-size: 12px;color: #DDD;}
  .s-j-draggablePanelList .s-pannel-name > i {margin-left: 30px;margin-top:14px;}
  .s-j-draggablePanelList .s-pannel-body .btn-group {float:right;}
  .s-pannel-name .s-title-edit-menu {-moz-box-shadow: inset 0 0 1px #999999;-webkit-box-shadow: inset 0 0 1px #999;box-shadow: inset 0 0 1px #999;position: absolute;left: 57px;top:0px;width: 230px;z-index: 3000;background-color: #EEE;height: 40px;padding-left: 10px;display:none;}


</style>

<script charset="utf-8">
  //activate tooltips
  $(function(){
    $('.j-tool-tip-item').tooltip();
  });
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
  });
</script>





<script charset="utf-8">
  $('.s-filter-item .panel-body').click(function(){
    $(this).parent().parent().parent().siblings('li').toggleClass('s-disabled');
    $(this).parent().toggleClass('s-focus');
  });
</script>

<script charset="utf-8">
  !function(a){"use strict";a(window.jQuery,window,document)}(function(a,b,c,d){"use strict";a.widget("selectBox.selectBoxIt",{VERSION:"3.8.1",options:{showEffect:"none",showEffectOptions:{},showEffectSpeed:"medium",hideEffect:"none",hideEffectOptions:{},hideEffectSpeed:"medium",showFirstOption:!0,defaultText:"",defaultIcon:"",downArrowIcon:"",theme:"default",keydownOpen:!0,isMobile:function(){var a=navigator.userAgent||navigator.vendor||b.opera;return/iPhone|iPod|iPad|Silk|Android|BlackBerry|Opera Mini|IEMobile/.test(a)},"native":!1,aggressiveChange:!1,selectWhenHidden:!0,viewport:a(b),similarSearch:!1,copyAttributes:["title","rel"],copyClasses:"button",nativeMousedown:!1,customShowHideEvent:!1,autoWidth:!0,html:!0,populate:"",dynamicPositioning:!0,hideCurrent:!1},getThemes:function(){var b=this,c=a(b.element).attr("data-theme")||"c";return{bootstrap:{focus:"active",hover:"",enabled:"enabled",disabled:"disabled",arrow:"caret",button:"btn",list:"dropdown-menu",container:"bootstrap",open:"open"},jqueryui:{focus:"ui-state-focus",hover:"ui-state-hover",enabled:"ui-state-enabled",disabled:"ui-state-disabled",arrow:"ui-icon ui-icon-triangle-1-s",button:"ui-widget ui-state-default",list:"ui-widget ui-widget-content",container:"jqueryui",open:"selectboxit-open"},jquerymobile:{focus:"ui-btn-down-"+c,hover:"ui-btn-hover-"+c,enabled:"ui-enabled",disabled:"ui-disabled",arrow:"ui-icon ui-icon-arrow-d ui-icon-shadow",button:"ui-btn ui-btn-icon-right ui-btn-corner-all ui-shadow ui-btn-up-"+c,list:"ui-btn ui-btn-icon-right ui-btn-corner-all ui-shadow ui-btn-up-"+c,container:"jquerymobile",open:"selectboxit-open"},"default":{focus:"selectboxit-focus",hover:"selectboxit-hover",enabled:"selectboxit-enabled",disabled:"selectboxit-disabled",arrow:"selectboxit-default-arrow",button:"selectboxit-btn",list:"selectboxit-list",container:"selectboxit-container",open:"selectboxit-open"}}},isDeferred:function(b){return a.isPlainObject(b)&&b.promise&&b.done},_create:function(b){var d=this,e=d.options.populate,f=d.options.theme;if(d.element.is("select"))return d.widgetProto=a.Widget.prototype,d.originalElem=d.element[0],d.selectBox=d.element,d.options.populate&&d.add&&!b&&d.add(e),d.selectItems=d.element.find("option"),d.firstSelectItem=d.selectItems.slice(0,1),d.documentHeight=a(c).height(),d.theme=a.isPlainObject(f)?a.extend({},d.getThemes()["default"],f):d.getThemes()[f]?d.getThemes()[f]:d.getThemes()["default"],d.currentFocus=0,d.blur=!0,d.textArray=[],d.currentIndex=0,d.currentText="",d.flipped=!1,b||(d.selectBoxStyles=d.selectBox.attr("style")),d._createDropdownButton()._createUnorderedList()._copyAttributes()._replaceSelectBox()._addClasses(d.theme)._eventHandlers(),d.originalElem.disabled&&d.disable&&d.disable(),d._ariaAccessibility&&d._ariaAccessibility(),d.isMobile=d.options.isMobile(),d._mobile&&d._mobile(),d.options["native"]&&this._applyNativeSelect(),d.triggerEvent("create"),d},_createDropdownButton:function(){var b=this,c=b.originalElemId=b.originalElem.id||"",d=b.originalElemValue=b.originalElem.value||"",e=b.originalElemName=b.originalElem.name||"",f=b.options.copyClasses,g=b.selectBox.attr("class")||"";return b.dropdownText=a("<span/>",{id:c&&c+"SelectBoxItText","class":"selectboxit-text",unselectable:"on",text:b.firstSelectItem.text()}).attr("data-val",d),b.dropdownImageContainer=a("<span/>",{"class":"selectboxit-option-icon-container"}),b.dropdownImage=a("<i/>",{id:c&&c+"SelectBoxItDefaultIcon","class":"selectboxit-default-icon",unselectable:"on"}),b.dropdown=a("<span/>",{id:c&&c+"SelectBoxIt","class":"selectboxit "+("button"===f?g:"")+" "+(b.selectBox.prop("disabled")?b.theme.disabled:b.theme.enabled),name:e,tabindex:b.selectBox.attr("tabindex")||"0",unselectable:"on"}).append(b.dropdownImageContainer.append(b.dropdownImage)).append(b.dropdownText),b.dropdownContainer=a("<span/>",{id:c&&c+"SelectBoxItContainer","class":"selectboxit-container "+b.theme.container+" "+("container"===f?g:"")}).append(b.dropdown),b},_createUnorderedList:function(){var b,c,d,e,f,g,h,i,j,k,l,m,n,o=this,p="",q=o.originalElemId||"",r=a("<ul/>",{id:q&&q+"SelectBoxItOptions","class":"selectboxit-options",tabindex:-1});if(o.options.showFirstOption||(o.selectItems.first().attr("disabled","disabled"),o.selectItems=o.selectBox.find("option").slice(1)),o.selectItems.each(function(q){m=a(this),c="",d="",b=m.prop("disabled"),e=m.attr("data-icon")||"",f=m.attr("data-iconurl")||"",g=f?"selectboxit-option-icon-url":"",h=f?"style=\"background-image:url('"+f+"');\"":"",i=m.attr("data-selectedtext"),j=m.attr("data-text"),l=j?j:m.text(),n=m.parent(),n.is("optgroup")&&(c="selectboxit-optgroup-option",0===m.index()&&(d='<span class="selectboxit-optgroup-header '+n.first().attr("class")+'"data-disabled="true">'+n.first().attr("label")+"</span>")),m.attr("value",this.value),p+=d+'<li data-id="'+q+'" data-val="'+this.value+'" data-disabled="'+b+'" class="'+c+" selectboxit-option "+(a(this).attr("class")||"")+'"><a class="selectboxit-option-anchor"><span class="selectboxit-option-icon-container"><i class="selectboxit-option-icon '+e+" "+(g||o.theme.container)+'"'+h+"></i></span>"+(o.options.html?l:o.htmlEscape(l))+"</a></li>",k=m.attr("data-search"),o.textArray[q]=b?"":k?k:l,this.selected&&(o._setText(o.dropdownText,i||l),o.currentFocus=q)}),o.options.defaultText||o.selectBox.attr("data-text")){var s=o.options.defaultText||o.selectBox.attr("data-text");o._setText(o.dropdownText,s),o.options.defaultText=s}return r.append(p),o.list=r,o.dropdownContainer.append(o.list),o.listItems=o.list.children("li"),o.listAnchors=o.list.find("a"),o.listItems.first().addClass("selectboxit-option-first"),o.listItems.last().addClass("selectboxit-option-last"),o.list.find("li[data-disabled='true']").not(".optgroupHeader").addClass(o.theme.disabled),o.dropdownImage.addClass(o.selectBox.attr("data-icon")||o.options.defaultIcon||o.listItems.eq(o.currentFocus).find("i").attr("class")),o.dropdownImage.attr("style",o.listItems.eq(o.currentFocus).find("i").attr("style")),o},_replaceSelectBox:function(){var b,c,e,f=this,g=f.originalElem.id||"",h=f.selectBox.attr("data-size"),i=f.listSize=h===d?"auto":"0"===h?"auto":+h;return f.selectBox.css("display","none").after(f.dropdownContainer),f.dropdownContainer.appendTo("body").addClass("selectboxit-rendering"),b=f.dropdown.height(),f.downArrow=a("<i/>",{id:g&&g+"SelectBoxItArrow","class":"selectboxit-arrow",unselectable:"on"}),f.downArrowContainer=a("<span/>",{id:g&&g+"SelectBoxItArrowContainer","class":"selectboxit-arrow-container",unselectable:"on"}).append(f.downArrow),f.dropdown.append(f.downArrowContainer),f.listItems.removeClass("selectboxit-selected").eq(f.currentFocus).addClass("selectboxit-selected"),c=f.downArrowContainer.outerWidth(!0),e=f.dropdownImage.outerWidth(!0),f.options.autoWidth&&(f.dropdown.css({width:"auto"}).css({width:f.list.outerWidth(!0)+c+e}),f.list.css({"min-width":f.dropdown.width()})),f.dropdownText.css({"max-width":f.dropdownContainer.outerWidth(!0)-(c+e)}),f.selectBox.after(f.dropdownContainer),f.dropdownContainer.removeClass("selectboxit-rendering"),"number"===a.type(i)&&(f.maxHeight=f.listAnchors.outerHeight(!0)*i),f},_scrollToView:function(a){var b=this,c=b.listItems.eq(b.currentFocus),d=b.list.scrollTop(),e=c.height(),f=c.position().top,g=Math.abs(f),h=b.list.height();return"search"===a?e>h-f?b.list.scrollTop(d+(f-(h-e))):-1>f&&b.list.scrollTop(f-e):"up"===a?-1>f&&b.list.scrollTop(d-g):"down"===a&&e>h-f&&b.list.scrollTop(d+(g-h+e)),b},_callbackSupport:function(b){var c=this;return a.isFunction(b)&&b.call(c,c.dropdown),c},_setText:function(a,b){var c=this;return c.options.html?a.html(b):a.text(b),c},open:function(a){var b=this,c=b.options.showEffect,d=b.options.showEffectSpeed,e=b.options.showEffectOptions,f=b.options["native"],g=b.isMobile;return!b.listItems.length||b.dropdown.hasClass(b.theme.disabled)?b:(f||g||this.list.is(":visible")||(b.triggerEvent("open"),b._dynamicPositioning&&b.options.dynamicPositioning&&b._dynamicPositioning(),"none"===c?b.list.show():"show"===c||"slideDown"===c||"fadeIn"===c?b.list[c](d):b.list.show(c,e,d),b.list.promise().done(function(){b._scrollToView("search"),b.triggerEvent("opened")})),b._callbackSupport(a),b)},close:function(a){var b=this,c=b.options.hideEffect,d=b.options.hideEffectSpeed,e=b.options.hideEffectOptions,f=b.options["native"],g=b.isMobile;return f||g||!b.list.is(":visible")||(b.triggerEvent("close"),"none"===c?b.list.hide():"hide"===c||"slideUp"===c||"fadeOut"===c?b.list[c](d):b.list.hide(c,e,d),b.list.promise().done(function(){b.triggerEvent("closed")})),b._callbackSupport(a),b},toggle:function(){var a=this,b=a.list.is(":visible");b?a.close():b||a.open()},_keyMappings:{38:"up",40:"down",13:"enter",8:"backspace",9:"tab",32:"space",27:"esc"},_keydownMethods:function(){var a=this,b=a.list.is(":visible")||!a.options.keydownOpen;return{down:function(){a.moveDown&&b&&a.moveDown()},up:function(){a.moveUp&&b&&a.moveUp()},enter:function(){var b=a.listItems.eq(a.currentFocus);a._update(b),"true"!==b.attr("data-preventclose")&&a.close(),a.triggerEvent("enter")},tab:function(){a.triggerEvent("tab-blur"),a.close()},backspace:function(){a.triggerEvent("backspace")},esc:function(){a.close()}}},_eventHandlers:function(){var b,c,d=this,e=d.options.nativeMousedown,f=d.options.customShowHideEvent,g=d.focusClass,h=d.hoverClass,i=d.openClass;return this.dropdown.on({"click.selectBoxIt":function(){d.dropdown.trigger("focus",!0),d.originalElem.disabled||(d.triggerEvent("click"),e||f||d.toggle())},"mousedown.selectBoxIt":function(){a(this).data("mdown",!0),d.triggerEvent("mousedown"),e&&!f&&d.toggle()},"mouseup.selectBoxIt":function(){d.triggerEvent("mouseup")},"blur.selectBoxIt":function(){d.blur&&(d.triggerEvent("blur"),d.close(),a(this).removeClass(g))},"focus.selectBoxIt":function(b,c){var e=a(this).data("mdown");a(this).removeData("mdown"),e||c||setTimeout(function(){d.triggerEvent("tab-focus")},0),c||(a(this).hasClass(d.theme.disabled)||a(this).addClass(g),d.triggerEvent("focus"))},"keydown.selectBoxIt":function(a){var b=d._keyMappings[a.keyCode],c=d._keydownMethods()[b];c&&(c(),!d.options.keydownOpen||"up"!==b&&"down"!==b||d.open()),c&&"tab"!==b&&a.preventDefault()},"keypress.selectBoxIt":function(a){var b=a.charCode||a.keyCode,c=d._keyMappings[a.charCode||a.keyCode],e=String.fromCharCode(b);d.search&&(!c||c&&"space"===c)&&d.search(e,!0,!0),"space"===c&&a.preventDefault()},"mouseenter.selectBoxIt":function(){d.triggerEvent("mouseenter")},"mouseleave.selectBoxIt":function(){d.triggerEvent("mouseleave")}}),d.list.on({"mouseover.selectBoxIt":function(){d.blur=!1},"mouseout.selectBoxIt":function(){d.blur=!0},"focusin.selectBoxIt":function(){d.dropdown.trigger("focus",!0)}}),d.list.on({"mousedown.selectBoxIt":function(){d._update(a(this)),d.triggerEvent("option-click"),"false"===a(this).attr("data-disabled")&&"true"!==a(this).attr("data-preventclose")&&d.close(),setTimeout(function(){d.dropdown.trigger("focus",!0)},0)},"focusin.selectBoxIt":function(){d.listItems.not(a(this)).removeAttr("data-active"),a(this).attr("data-active","");var b=d.list.is(":hidden");(d.options.searchWhenHidden&&b||d.options.aggressiveChange||b&&d.options.selectWhenHidden)&&d._update(a(this)),a(this).addClass(g)},"mouseup.selectBoxIt":function(){e&&!f&&(d._update(a(this)),d.triggerEvent("option-mouseup"),"false"===a(this).attr("data-disabled")&&"true"!==a(this).attr("data-preventclose")&&d.close())},"mouseenter.selectBoxIt":function(){"false"===a(this).attr("data-disabled")&&(d.listItems.removeAttr("data-active"),a(this).addClass(g).attr("data-active",""),d.listItems.not(a(this)).removeClass(g),a(this).addClass(g),d.currentFocus=+a(this).attr("data-id"))},"mouseleave.selectBoxIt":function(){"false"===a(this).attr("data-disabled")&&(d.listItems.not(a(this)).removeClass(g).removeAttr("data-active"),a(this).addClass(g),d.currentFocus=+a(this).attr("data-id"))},"blur.selectBoxIt":function(){a(this).removeClass(g)}},".selectboxit-option"),d.list.on({"click.selectBoxIt":function(a){a.preventDefault()}},"a"),d.selectBox.on({"change.selectBoxIt, internal-change.selectBoxIt":function(a,e){var f,g;e||(f=d.list.find('li[data-val="'+d.originalElem.value+'"]'),f.length&&(d.listItems.eq(d.currentFocus).removeClass(d.focusClass),d.currentFocus=+f.attr("data-id"))),f=d.listItems.eq(d.currentFocus),g=f.attr("data-selectedtext"),b=f.attr("data-text"),c=b?b:f.find("a").text(),d._setText(d.dropdownText,g||c),d.dropdownText.attr("data-val",d.originalElem.value),f.find("i").attr("class")&&(d.dropdownImage.attr("class",f.find("i").attr("class")).addClass("selectboxit-default-icon"),d.dropdownImage.attr("style",f.find("i").attr("style"))),d.triggerEvent("changed")},"disable.selectBoxIt":function(){d.dropdown.addClass(d.theme.disabled)},"enable.selectBoxIt":function(){d.dropdown.removeClass(d.theme.disabled)},"open.selectBoxIt":function(){var a,b=d.list.find("li[data-val='"+d.dropdownText.attr("data-val")+"']");b.length||(b=d.listItems.not("[data-disabled=true]").first()),d.currentFocus=+b.attr("data-id"),a=d.listItems.eq(d.currentFocus),d.dropdown.addClass(i).removeClass(h).addClass(g),d.listItems.removeClass(d.selectedClass).removeAttr("data-active").not(a).removeClass(g),a.addClass(d.selectedClass).addClass(g),d.options.hideCurrent&&(d.listItems.show(),a.hide())},"close.selectBoxIt":function(){d.dropdown.removeClass(i)},"blur.selectBoxIt":function(){d.dropdown.removeClass(g)},"mouseenter.selectBoxIt":function(){a(this).hasClass(d.theme.disabled)||d.dropdown.addClass(h)},"mouseleave.selectBoxIt":function(){d.dropdown.removeClass(h)},destroy:function(a){a.preventDefault(),a.stopPropagation()}}),d},_update:function(a){var b,c,d,e=this,f=e.options.defaultText||e.selectBox.attr("data-text"),g=e.listItems.eq(e.currentFocus);"false"===a.attr("data-disabled")&&(b=e.listItems.eq(e.currentFocus).attr("data-selectedtext"),c=g.attr("data-text"),d=c?c:g.text(),(f&&e.options.html?e.dropdownText.html()===f:e.dropdownText.text()===f)&&e.selectBox.val()===a.attr("data-val")?e.triggerEvent("change"):(e.selectBox.val(a.attr("data-val")),e.currentFocus=+a.attr("data-id"),e.originalElem.value!==e.dropdownText.attr("data-val")&&e.triggerEvent("change")))},_addClasses:function(a){var b=this,c=(b.focusClass=a.focus,b.hoverClass=a.hover,a.button),d=a.list,e=a.arrow,f=a.container;return b.openClass=a.open,b.selectedClass="selectboxit-selected",b.downArrow.addClass(b.selectBox.attr("data-downarrow")||b.options.downArrowIcon||e),b.dropdownContainer.addClass(f),b.dropdown.addClass(c),b.list.addClass(d),b},refresh:function(a,b){var c=this;return c._destroySelectBoxIt()._create(!0),b||c.triggerEvent("refresh"),c._callbackSupport(a),c},htmlEscape:function(a){return String(a).replace(/&/g,"&amp;").replace(/"/g,"&quot;").replace(/'/g,"&#39;").replace(/</g,"&lt;").replace(/>/g,"&gt;")},triggerEvent:function(a){var b=this,c=b.options.showFirstOption?b.currentFocus:b.currentFocus-1>=0?b.currentFocus:0;return b.selectBox.trigger(a,{selectbox:b.selectBox,selectboxOption:b.selectItems.eq(c),dropdown:b.dropdown,dropdownOption:b.listItems.eq(b.currentFocus)}),b},_copyAttributes:function(){var a=this;return a._addSelectBoxAttributes&&a._addSelectBoxAttributes(),a},_realOuterWidth:function(a){if(a.is(":visible"))return a.outerWidth(!0);var b,c=a.clone();return c.css({visibility:"hidden",display:"block",position:"absolute"}).appendTo("body"),b=c.outerWidth(!0),c.remove(),b}});var e=a.selectBox.selectBoxIt.prototype;e.add=function(b,c){this._populate(b,function(b){var d,e,f=this,g=a.type(b),h=0,i=[],j=f._isJSON(b),k=j&&f._parseJSON(b);if(b&&("array"===g||j&&k.data&&"array"===a.type(k.data))||"object"===g&&b.data&&"array"===a.type(b.data)){for(f._isJSON(b)&&(b=k),b.data&&(b=b.data),e=b.length;e-1>=h;h+=1)d=b[h],a.isPlainObject(d)?i.push(a("<option/>",d)):"string"===a.type(d)&&i.push(a("<option/>",{text:d,value:d}));f.selectBox.append(i)}else b&&"string"===g&&!f._isJSON(b)?f.selectBox.append(b):b&&"object"===g?f.selectBox.append(a("<option/>",b)):b&&f._isJSON(b)&&a.isPlainObject(f._parseJSON(b))&&f.selectBox.append(a("<option/>",f._parseJSON(b)));return f.dropdown?f.refresh(function(){f._callbackSupport(c)},!0):f._callbackSupport(c),f})},e._parseJSON=function(b){return JSON&&JSON.parse&&JSON.parse(b)||a.parseJSON(b)},e._isJSON=function(a){var b,c=this;try{return b=c._parseJSON(a),!0}catch(d){return!1}},e._populate=function(b,c){var d=this;return b=a.isFunction(b)?b.call():b,d.isDeferred(b)?b.done(function(a){c.call(d,a)}):c.call(d,b),d},e._ariaAccessibility=function(){var b=this,c=a("label[for='"+b.originalElem.id+"']");return b.dropdownContainer.attr({role:"combobox","aria-autocomplete":"list","aria-haspopup":"true","aria-expanded":"false","aria-owns":b.list[0].id}),b.dropdownText.attr({"aria-live":"polite"}),b.dropdown.on({"disable.selectBoxIt":function(){b.dropdownContainer.attr("aria-disabled","true")},"enable.selectBoxIt":function(){b.dropdownContainer.attr("aria-disabled","false")}}),c.length&&b.dropdownContainer.attr("aria-labelledby",c[0].id),b.list.attr({role:"listbox","aria-hidden":"true"}),b.listItems.attr({role:"option"}),b.selectBox.on({"open.selectBoxIt":function(){b.list.attr("aria-hidden","false"),b.dropdownContainer.attr("aria-expanded","true")},"close.selectBoxIt":function(){b.list.attr("aria-hidden","true"),b.dropdownContainer.attr("aria-expanded","false")}}),b},e._addSelectBoxAttributes=function(){var b=this;return b._addAttributes(b.selectBox.prop("attributes"),b.dropdown),b.selectItems.each(function(c){b._addAttributes(a(this).prop("attributes"),b.listItems.eq(c))}),b},e._addAttributes=function(b,c){var d=this,e=d.options.copyAttributes;return b.length&&a.each(b,function(b,d){var f=d.name.toLowerCase(),g=d.value;"null"===g||-1===a.inArray(f,e)&&-1===f.indexOf("data")||c.attr(f,g)}),d},e.destroy=function(a){var b=this;return b._destroySelectBoxIt(),b.widgetProto.destroy.call(b),b._callbackSupport(a),b},e._destroySelectBoxIt=function(){var b=this;return b.dropdown.off(".selectBoxIt"),a.contains(b.dropdownContainer[0],b.originalElem)&&b.dropdownContainer.before(b.selectBox),b.dropdownContainer.remove(),b.selectBox.removeAttr("style").attr("style",b.selectBoxStyles),b.triggerEvent("destroy"),b},e.disable=function(a){var b=this;return b.options.disabled||(b.close(),b.selectBox.attr("disabled","disabled"),b.dropdown.removeAttr("tabindex").removeClass(b.theme.enabled).addClass(b.theme.disabled),b.setOption("disabled",!0),b.triggerEvent("disable")),b._callbackSupport(a),b},e.disableOption=function(b,c){var d,e,f,g=this,h=a.type(b);return"number"===h&&(g.close(),d=g.selectBox.find("option").eq(b),g.triggerEvent("disable-option"),d.attr("disabled","disabled"),g.listItems.eq(b).attr("data-disabled","true").addClass(g.theme.disabled),g.currentFocus===b&&(e=g.listItems.eq(g.currentFocus).nextAll("li").not("[data-disabled='true']").first().length,f=g.listItems.eq(g.currentFocus).prevAll("li").not("[data-disabled='true']").first().length,e?g.moveDown():f?g.moveUp():g.disable())),g._callbackSupport(c),g},e._isDisabled=function(){var a=this;return a.originalElem.disabled&&a.disable(),a},e._dynamicPositioning=function(){var b=this;if("number"===a.type(b.listSize))b.list.css("max-height",b.maxHeight||"none");else{var c=b.dropdown.offset().top,d=b.list.data("max-height")||b.list.outerHeight(),e=b.dropdown.outerHeight(),f=b.options.viewport,g=f.height(),h=a.isWindow(f.get(0))?f.scrollTop():f.offset().top,i=g+h>=c+e+d,j=!i;if(b.list.data("max-height")||b.list.data("max-height",b.list.outerHeight()),j)if(b.dropdown.offset().top-h>=d)b.list.css("max-height",d),b.list.css("top",b.dropdown.position().top-b.list.outerHeight());else{var k=Math.abs(c+e+d-(g+h)),l=Math.abs(b.dropdown.offset().top-h-d);l>k?(b.list.css("max-height",d-k-e/2),b.list.css("top","auto")):(b.list.css("max-height",d-l-e/2),b.list.css("top",b.dropdown.position().top-b.list.outerHeight()))}else b.list.css("max-height",d),b.list.css("top","auto")}return b},e.enable=function(a){var b=this;return b.options.disabled&&(b.triggerEvent("enable"),b.selectBox.removeAttr("disabled"),b.dropdown.attr("tabindex",0).removeClass(b.theme.disabled).addClass(b.theme.enabled),b.setOption("disabled",!1),b._callbackSupport(a)),b},e.enableOption=function(b,c){var d,e=this,f=a.type(b);return"number"===f&&(d=e.selectBox.find("option").eq(b),e.triggerEvent("enable-option"),d.removeAttr("disabled"),e.listItems.eq(b).attr("data-disabled","false").removeClass(e.theme.disabled)),e._callbackSupport(c),e},e.moveDown=function(a){var b=this;b.currentFocus+=1;var c="true"===b.listItems.eq(b.currentFocus).attr("data-disabled")?!0:!1,d=b.listItems.eq(b.currentFocus).nextAll("li").not("[data-disabled='true']").first().length;if(b.currentFocus===b.listItems.length)b.currentFocus-=1;else{if(c&&d)return b.listItems.eq(b.currentFocus-1).blur(),b.moveDown(),void 0;c&&!d?b.currentFocus-=1:(b.listItems.eq(b.currentFocus-1).blur().end().eq(b.currentFocus).focusin(),b._scrollToView("down"),b.triggerEvent("moveDown"))}return b._callbackSupport(a),b},e.moveUp=function(a){var b=this;b.currentFocus-=1;var c="true"===b.listItems.eq(b.currentFocus).attr("data-disabled")?!0:!1,d=b.listItems.eq(b.currentFocus).prevAll("li").not("[data-disabled='true']").first().length;if(-1===b.currentFocus)b.currentFocus+=1;else{if(c&&d)return b.listItems.eq(b.currentFocus+1).blur(),b.moveUp(),void 0;c&&!d?b.currentFocus+=1:(b.listItems.eq(this.currentFocus+1).blur().end().eq(b.currentFocus).focusin(),b._scrollToView("up"),b.triggerEvent("moveUp"))}return b._callbackSupport(a),b},e._setCurrentSearchOption=function(a){var b=this;return(b.options.aggressiveChange||b.options.selectWhenHidden||b.listItems.eq(a).is(":visible"))&&b.listItems.eq(a).data("disabled")!==!0&&(b.listItems.eq(b.currentFocus).blur(),b.currentIndex=a,b.currentFocus=a,b.listItems.eq(b.currentFocus).focusin(),b._scrollToView("search"),b.triggerEvent("search")),b},e._searchAlgorithm=function(a,b){var c,d,e,f,g=this,h=!1,i=g.textArray,j=g.currentText;for(c=a,e=i.length;e>c;c+=1){for(f=i[c],d=0;e>d;d+=1)-1!==i[d].search(b)&&(h=!0,d=e);if(h||(g.currentText=g.currentText.charAt(g.currentText.length-1).replace(/[|()\[{.+*?$\\]/g,"\\$0"),j=g.currentText),b=new RegExp(j,"gi"),j.length<3){if(b=new RegExp(j.charAt(0),"gi"),-1!==f.charAt(0).search(b))return g._setCurrentSearchOption(c),(f.substring(0,j.length).toLowerCase()!==j.toLowerCase()||g.options.similarSearch)&&(g.currentIndex+=1),!1}else if(-1!==f.search(b))return g._setCurrentSearchOption(c),!1;if(f.toLowerCase()===g.currentText.toLowerCase())return g._setCurrentSearchOption(c),g.currentText="",!1}return!0},e.search=function(a,b,c){var d=this;c?d.currentText+=a.replace(/[|()\[{.+*?$\\]/g,"\\$0"):d.currentText=a.replace(/[|()\[{.+*?$\\]/g,"\\$0");var e=d._searchAlgorithm(d.currentIndex,new RegExp(d.currentText,"gi"));return e&&d._searchAlgorithm(0,d.currentText),d._callbackSupport(b),d},e._updateMobileText=function(){var a,b,c,d=this;a=d.selectBox.find("option").filter(":selected"),b=a.attr("data-text"),c=b?b:a.text(),d._setText(d.dropdownText,c),d.list.find('li[data-val="'+a.val()+'"]').find("i").attr("class")&&d.dropdownImage.attr("class",d.list.find('li[data-val="'+a.val()+'"]').find("i").attr("class")).addClass("selectboxit-default-icon")},e._applyNativeSelect=function(){var a=this;return a.dropdownContainer.append(a.selectBox),a.dropdown.attr("tabindex","-1"),a.selectBox.css({display:"block",visibility:"visible",width:a._realOuterWidth(a.dropdown),height:a.dropdown.outerHeight(),opacity:"0",position:"absolute",top:"0",left:"0",cursor:"pointer","z-index":"999999",margin:a.dropdown.css("margin"),padding:"0","-webkit-appearance":"menulist-button"}),a.originalElem.disabled&&a.triggerEvent("disable"),this},e._mobileEvents=function(){var a=this;a.selectBox.on({"changed.selectBoxIt":function(){a.hasChanged=!0,a._updateMobileText(),a.triggerEvent("option-click")},"mousedown.selectBoxIt":function(){a.hasChanged||!a.options.defaultText||a.originalElem.disabled||(a._updateMobileText(),a.triggerEvent("option-click"))},"enable.selectBoxIt":function(){a.selectBox.removeClass("selectboxit-rendering")},"disable.selectBoxIt":function(){a.selectBox.addClass("selectboxit-rendering")}})},e._mobile=function(){var a=this;return a.isMobile&&(a._applyNativeSelect(),a._mobileEvents()),this},e.remove=function(b,c){var d,e,f=this,g=a.type(b),h=0,i="";if("array"===g){for(e=b.length;e-1>=h;h+=1)d=b[h],"number"===a.type(d)&&(i+=i.length?", option:eq("+d+")":"option:eq("+d+")");f.selectBox.find(i).remove()}else"number"===g?f.selectBox.find("option").eq(b).remove():f.selectBox.find("option").remove();return f.dropdown?f.refresh(function(){f._callbackSupport(c)},!0):f._callbackSupport(c),f},e.selectOption=function(b,c){var d=this,e=a.type(b);return"number"===e?d.selectBox.val(d.selectItems.eq(b).val()).change():"string"===e&&d.selectBox.val(b).change(),d._callbackSupport(c),d},e.setOption=function(b,c,d){var e=this;return"string"===a.type(b)&&(e.options[b]=c),e.refresh(function(){e._callbackSupport(d)},!0),e},e.setOptions=function(b,c){var d=this;return a.isPlainObject(b)&&(d.options=a.extend({},d.options,b)),d.refresh(function(){d._callbackSupport(c)},!0),d},e.wait=function(a,b){var c=this;return c.widgetProto._delay.call(c,b,a),c}});
</script>

<script charset="utf-8">
  $("select").selectBoxIt();
</script>

<script charset="utf-8">

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


<!--- Add new default font --->
<link href='http://fonts.googleapis.com/css?family=Open+Sans:400,600,800,700' rel='stylesheet' type='text/css'>


<!---If you uncomment this content you will be able to drag table columns to sort them
<style media="screen">
  .dragtable-sortable { list-style-type: none; margin: 0; padding: 0; -moz-user-select: none;}
  .dragtable-sortable li {float: left; background: white;}
  .dragtable-sortable th, .dragtable-sortable td{border-left: 0px;}
  .dragtable-sortable li:first-child th, .dragtable-sortable li:first-child td {border-left: 1px solid #CCC;}
  .ui-sortable-helper {opacity: 0.7;filter: alpha(opacity=70);}
  .ui-sortable-placeholder {-moz-box-shadow: 4px 5px 4px #C6C6C6 inset;-webkit-box-shadow: 4px 5px 4px #C6C6C6 inset;box-shadow: 4px 5px 4px #C6C6C6 inset;border-bottom: 1px solid #CCCCCC;border-top: 1px solid #CCCCCC;visibility: visible !important;background: #EFEFEF !important;visibility: visible !important;}
  .ui-sortable-placeholder * {opacity: 0.0; visibility: hidden;}
</style>
<script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.2/jquery-ui.min.js"></script>
<script charset="utf-8">
  (function(e){function r(){var t=e('<style id="__dragtable_disable_text_selection__" type="text/css">body { -ms-user-select:none;-moz-user-select:-moz-none;-khtml-user-select:none;-webkit-user-select:none;user-select:none; }</style>');e(document.head).append(t);e(document.body).attr("onselectstart","return false;").attr("unselectable","on");if(window.getSelection){window.getSelection().removeAllRanges()}else{document.selection.empty()}}function i(){e("#__dragtable_disable_text_selection__").remove();if(t){e(document.body).attr("onselectstart",t)}else{e(document.body).removeAttr("onselectstart")}if(n){e(document.body).attr("unselectable",n)}else{e(document.body).removeAttr("unselectable")}}function s(e,t){var n=e.parentNode;var r=e.nextSibling===t?e:e.nextSibling;t.parentNode.insertBefore(e,t);n.insertBefore(t,r)}e.widget("akottr.dragtable",{options:{revert:false,dragHandle:".table-handle",maxMovingRows:40,excludeFooter:false,onlyHeaderThreshold:100,dragaccept:null,persistState:null,restoreState:null,exact:true,clickDelay:10,containment:null,cursor:"move",cursorAt:false,distance:0,tolerance:"pointer",axis:"x",beforeStart:e.noop,beforeMoving:e.noop,beforeReorganize:e.noop,beforeStop:e.noop},originalTable:{el:null,selectedHandle:null,sortOrder:null,startIndex:0,endIndex:0},sortableTable:{el:e(),selectedHandle:e(),movingRow:e()},persistState:function(){var t=this;this.originalTable.el.find("th").each(function(e){if(this.id!==""){t.originalTable.sortOrder[this.id]=e}});e.ajax({url:this.options.persistState,data:this.originalTable.sortOrder})},_restoreState:function(t){for(var n in t){this.originalTable.startIndex=e("#"+n).closest("th").prevAll().size()+1;this.originalTable.endIndex=parseInt(t[n]+1,10);this._bubbleCols()}},_bubbleCols:function(){var e,t,n,r;var i=this.originalTable.startIndex;var o=this.originalTable.endIndex;var u=this.originalTable.el.children();if(this.options.excludeFooter){u=u.not("tfoot")}if(i<o){for(e=i;e<o;e++){n=u.find("> tr > td:nth-child("+e+")").add(u.find("> tr > th:nth-child("+e+")"));r=u.find("> tr > td:nth-child("+(e+1)+")").add(u.find("> tr > th:nth-child("+(e+1)+")"));for(t=0;t<n.length;t++){s(n[t],r[t])}}}else{for(e=i;e>o;e--){n=u.find("> tr > td:nth-child("+e+")").add(u.find("> tr > th:nth-child("+e+")"));r=u.find("> tr > td:nth-child("+(e-1)+")").add(u.find("> tr > th:nth-child("+(e-1)+")"));for(t=0;t<n.length;t++){s(n[t],r[t])}}}},_rearrangeTableBackroundProcessing:function(){var t=this;return function(){t._bubbleCols();t.options.beforeStop(t.originalTable);t.sortableTable.el.remove();i();if(t.options.persistState!==null){e.isFunction(t.options.persistState)?t.options.persistState(t.originalTable):t.persistState()}}},_rearrangeTable:function(){var e=this;return function(){e.originalTable.selectedHandle.removeClass("dragtable-handle-selected");e.sortableTable.el.sortable("disable");e.sortableTable.el.addClass("dragtable-disabled");e.options.beforeReorganize(e.originalTable,e.sortableTable);e.originalTable.endIndex=e.sortableTable.movingRow.prevAll().size()+1;setTimeout(e._rearrangeTableBackroundProcessing(),50)}},_generateSortable:function(t){!t.cancelBubble&&(t.cancelBubble=true);var n=this;var i=this.originalTable.el[0].attributes;var s="";for(var o=0;o<i.length;o++){if(i[o].nodeValue&&i[o].nodeName!="id"&&i[o].nodeName!="width"){s+=i[o].nodeName+'="'+i[o].nodeValue+'" '}}var u=[];var a=[];this.originalTable.el.find("tr").slice(0,this.options.maxMovingRows).each(function(t,n){var r=this.attributes;var i="";for(var s=0;s<r.length;s++){if(r[s].nodeValue&&r[s].nodeName!="id"){i+=" "+r[s].nodeName+'="'+r[s].nodeValue+'"'}}u.push(i);a.push(e(this).height())});var f=[];var l=0;var c=n.originalTable.el.children();if(this.options.excludeFooter){c=c.not("tfoot")}c.find("> tr > th").each(function(t,n){var r=e(this).outerWidth();f.push(r);l+=r});if(n.options.exact){var h=l-n.originalTable.el.outerWidth();f[0]-=h}l+=2;var p='<ul class="dragtable-sortable" style="position:absolute; width:'+l+'px;">';c.find("> tr > th").each(function(t,r){p+="<li>";p+="<table "+s+">";var i=c.find("> tr > th:nth-child("+(t+1)+")");if(n.options.maxMovingRows>1){i=i.add(c.find("> tr > td:nth-child("+(t+1)+")").slice(0,n.options.maxMovingRows-1))}i.each(function(t){var n=e(this).clone().wrap("<div></div>").parent().html();if(n.toLowerCase().indexOf("<th")===0)p+="<thead>";p+="<tr "+u[t]+'" style="height:'+a[t]+'px;">';p+=n;if(n.toLowerCase().indexOf("<th")===0)p+="</thead>";p+="</tr>"});p+="</table>";p+="</li>"});p+="</ul>";this.sortableTable.el=this.originalTable.el.before(p).prev();this.sortableTable.el.find("> li > table").each(function(t,n){e(this).css("width",f[t]+"px")});this.sortableTable.selectedHandle=this.sortableTable.el.find("th .dragtable-handle-selected");var d=!this.options.dragaccept?"li":"li:has("+this.options.dragaccept+")";this.sortableTable.el.sortable({items:d,stop:this._rearrangeTable(),revert:this.options.revert,tolerance:this.options.tolerance,containment:this.options.containment,cursor:this.options.cursor,cursorAt:this.options.cursorAt,distance:this.options.distance,axis:this.options.axis});this.originalTable.startIndex=e(t.target).closest("th").prevAll().size()+1;this.options.beforeMoving(this.originalTable,this.sortableTable);this.sortableTable.movingRow=this.sortableTable.el.find("> li:nth-child("+this.originalTable.startIndex+")");r();this.sortableTable.movingRow.trigger(e.extend(e.Event(t.type),{which:1,clientX:t.clientX,clientY:t.clientY,pageX:t.pageX,pageY:t.pageY,screenX:t.screenX,screenY:t.screenY}));var v=this.sortableTable.el.find(".ui-sortable-placeholder");if(!v.height()<=0){v.css("height",this.sortableTable.el.find(".ui-sortable-helper").height())}v.html('<div class="outer" style="height:100%;"><div class="inner" style="height:100%;"></div></div>')},bindTo:{},_create:function(){this.originalTable={el:this.element,selectedHandle:e(),sortOrder:{},startIndex:0,endIndex:0};this.bindTo=this.originalTable.el.find("th");if(this.options.dragaccept){this.bindTo=this.bindTo.filter(this.options.dragaccept)}if(this.bindTo.find(this.options.dragHandle).size()>0){this.bindTo=this.bindTo.find(this.options.dragHandle)}if(this.options.restoreState!==null){e.isFunction(this.options.restoreState)?this.options.restoreState(this.originalTable):this._restoreState(this.options.restoreState)}var t=this;this.bindTo.mousedown(function(n){if(n.which!==1)return;if(t.options.beforeStart(t.originalTable)===false){return}clearTimeout(this.downTimer);this.downTimer=setTimeout(function(){t.originalTable.selectedHandle=e(this);t.originalTable.selectedHandle.addClass("dragtable-handle-selected");t._generateSortable(n)},t.options.clickDelay)}).mouseup(function(e){clearTimeout(this.downTimer)})},redraw:function(){this.destroy();this._create()},destroy:function(){this.bindTo.unbind("mousedown");e.Widget.prototype.destroy.apply(this,arguments)}});var t=e(document.body).attr("onselectstart"),n=e(document.body).attr("unselectable")})(jQuery)
</script>
<script charset="utf-8">
$(document).ready(function() {
  $('.table-striped').dragtable();
});
</script>--->
