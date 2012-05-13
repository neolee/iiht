$.ajaxSetup({
  beforeSend: function() {
    $('#spinner').show();
  },
  complete: function(){
    $('#spinner').hide();
  },
  success: function() {}
});

