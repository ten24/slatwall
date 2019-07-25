$(document).ready(function() {
    
    var elems = [];
   $('.orderItem').each(function(i, elem) {
       console.log($(elem).children('.returnQuantity'));
       $(elem).find('.returnQuantity').change(function(e) {
           updateOrderItem(elem);
       });
       $(elem).find('.refundUnitPrice').change(function() {
           updateOrderItem(elem);
       });
   })
   
   function updateOrderItem(elem) {
       var returnQuantity = $(elem).find('.returnQuantity').val();
       var refundUnitPrice = $(elem).find('.refundUnitPrice').val();
       
       if (returnQuantity == null || returnQuantity == undefined) {
           returnQuantity = 0;
       }
       
       if (refundUnitPrice == null || refundUnitPrice == undefined) {
           refundUnitPrice = 0;
       }
       
       var refundTotal = '$' + parseFloat(returnQuantity * refundUnitPrice, 10).toFixed(2);
       $(elem).find('.refundTotal').html(refundTotal);
       
       
       //console.log(returnQuantity);
       //console.log(refundUnitPrice);
       //console.log($(elem).children('.refundTotal'));
   }
});