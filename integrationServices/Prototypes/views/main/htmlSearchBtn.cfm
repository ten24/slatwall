<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
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
