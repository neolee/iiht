$('#formUser').submit(function(event) {
  $('#alert').removeClass('alert-success alert-error').addClass('alert-info');
  $('#alert').show().text('Saving...');

  $.ajax({
    type: $('#formUser').attr('method'),
    url: $('#formUser').attr('action'),
    data: $('#formUser').serialize(),
    success: function(data) {
      $('#alert').removeClass('alert-info').addClass('alert-success');
      $('#alert').text('Saved').fadeOut('slow');
    },
    error: function(data) {
      $('#alert').removeClass('alert-info').addClass('alert-error');
      $('#alert').text('Failed');
    },
  });

  return false;
});