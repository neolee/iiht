$('#formUser').submit(function(event) {
  $('#alert').show().text('Saving...');

  $.ajax({
    type: $('#formUser').attr('method'),
    url: $('#formUser').attr('action'),
    data: $('#formUser').serialize(),
    success: function(data) {
      $('#alert').removeClass('alert alert-error').addClass('alert alert-success');
      $('#alert').text('Saved').fadeOut('slow');
    },
    error: function(data) {
      $('#alert').removeClass('alert alert-success').addClass('alert alert-error');
      $('#alert').text('Failed');
    },
  });

  return false;
});