$(function(){
	$('.cmn_boxdetails .cmn_col:nth-child(2) .cmn_table').addClass('one');
	$('.cmn_boxdetails .cmn_col:nth-child(3) .cmn_table').addClass('two');
	$('.cmn_boxdetails .cmn_col:nth-child(4) .cmn_table').addClass('three');
	
	$('.value').click(function() {
		var showTable = $(this).attr('data-chart');
		$('#' + showTable).click();			
	});
	
	$('.cmn_boxdetails .details >a').click(function(e){
		e.preventDefault();
		curr = $(this).parents('.cmn_col').index();
    
    	if(curr ==1){
        	$('.cmn_boxdetails .details').removeClass('active');
            $(this).parents('.details').addClass('active');
        
        } else if(curr ==2){
		
			$('.cmn_boxdetails .details').removeClass('active');
        	$(this).parents('.cmn_col').prev('.cmn_col').find('.details').addClass('active');
            $(this).parents('.details').addClass('active');
        
        } else if(curr == 3){
       		
       		$('.cmn_boxdetails .details').addClass('active');
        
        } else {
        	
        	$('.cmn_boxdetails .details').removeClass('active');
        } 
		
		if($(window).width()>767){
			
			$('.btm_box').removeAttr('style');
			H = $(this.hash).outerHeight();
			$n = $(this).parents('.box_container').next('.btm_box');
			$('.cmn_table').fadeOut('fast');
			
			if($(this.hash).is(':visible')){
				$(this.hash).hide();
				$(this).parents('.details').removeClass('active');
				$('.cmn_boxdetails .details').removeClass('active');
				$('.btm_box').not($n).css('margin-top',29);
				$('.member_box').css('margin-top',64);
			} else {

				$(this.hash).show();
				$n.css('margin-top',19);
				$('.btm_box').not($n).css('margin-top',H+29);
				$('.member_box').css('margin-top',H+35);
			}
				
		} else {
			$('.cmn_table').slideUp()
			if($(this.hash).is(':visible')){
				$(this.hash).slideUp()
				$(this).parents('.details').removeClass('active');
			} else {
				$(this.hash).slideDown();
			}
		}
	});
	
})
