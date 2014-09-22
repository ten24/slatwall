<style media="screen">
	body {background-color:#eee;}
	.s-remove:hover {background-color:#DA5757 !important;color:#ffffff !important;border:1px solid #DA5757 !important;}
</style>
<div class="row s-body-nav">
	<nav class="navbar navbar-default" role="navigation">
		<div class="col-md-4">
			<h1>Order #2635</h1>
		</div>
		<div class="col-md-8">
			<div class="btn-toolbar">

				<div class="btn-group btn-group-sm">
					<button type="button" class="btn s-btn-grey"><i class="fa fa-reply"></i> Products</button>

					<div class="btn-group btn-group-sm">
						<button type="button" class="btn s-btn-grey dropdown-toggle" data-toggle="dropdown">
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
					<button type="button" class="btn s-btn-grey s-remove">Delete</button>
					<button type="button" class="btn s-btn-grey">Cancel</button>
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
					<span>Configuration</span>
					<i class="fa fa-caret-left"></i>
				</h4>
			</div>
		</a>

		<div id="collapseTwo" class="panel-collapse collapse in">
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

					<tr class="s-item">
						<td class="s-image"><img src="http://placehold.it/50x50"></td>
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

				</table>
			</div>

			<hr/class="s-dotted">

			<!-- Search for product -->
			<div class="s-bundle-group-items">
				<div class="col-xs-12">
					<div class="input-group">
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
						<input id="j-temp-class-search" type="text" class="form-control s-search-input" name="x" placeholder="Search product or sku">
						<span class="input-group-btn">
							<button class="btn btn-default s-search-button" type="button"><span class="glyphicon glyphicon-search"></span></button>
						</span>
					</div>
				</div>

				<div class="col-xs-12 s-bundle-add-items">
					<div class="col-xs-12 s-bundle-add-items-inner">
						<h4 id="j-temp-class">There are no items selected</h4>
						<ul class="list-unstyled s-order-item-options">

							<li class="s-bundle-add-obj">
								<ul class="list-unstyled list-inline">
									<li class="s-item-type">Product</li>
									<li class="j-tool-tip-item s-bundle-details">Howling Wolf T-Shirt <span>WOLF-01</span></li>
									<li class="j-tool-tip-item s-bundle-details">Qty: <span>4</span></li>
									<li class="j-tool-tip-item s-bundle-details">Location: <span>Boston</span></li>
									<li class="col-xs-1 j-tool-tip-item s-bundle-details-add"><a class="btn s-btn-ten24"><i class="fa fa-plus"></i></a></li>
								</ul>
								<div class="clearfix"></div>
							</li>

							<li class="s-bundle-add-obj">
								<ul class="list-unstyled list-inline">
									<li class="s-item-type">Sku</li>
									<li class="j-tool-tip-item s-bundle-details">Mano Mano T-Shirt Large <span>02/T3r5</span></li>
									<li class="j-tool-tip-item s-bundle-details">Qty: <span>4</span></li>
									<li class="j-tool-tip-item s-bundle-details">Location: <span>Boston</span></li>
									<li class="col-xs-1 j-tool-tip-item s-bundle-details-add"><a class="btn s-btn-ten24"><i class="fa fa-plus"></i></a></li>
								</ul>
								<div class="clearfix"></div>
							</li>

							<li class="s-bundle-add-obj">
								<ul class="list-unstyled list-inline">
									<li class="s-item-type">Product</li>
									<li class="j-tool-tip-item s-bundle-details">Cool Guy T-Shirt <span>WOLF-07</span></li>
									<li class="j-tool-tip-item s-bundle-details">Qty: <span>4</span></li>
									<li class="j-tool-tip-item s-bundle-details">Location: <span>Boston</span></li>
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
