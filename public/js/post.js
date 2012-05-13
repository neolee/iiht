$('#btnSave').click(function(event) {
  $('#alert').removeClass('alert-success alert-error').addClass('alert-info');
  $('#alert').show().text('Saving...');

  $.ajax({
    type: $('#formPost').attr('method'),
    url: $('#formPost').attr('action'),
    data: $('#formPost').serialize(),
    success: function(data) {
      $('#alert').removeClass('alert-info').addClass('alert-success');
      $('#alert').text('Saved').fadeOut('slow');
      location.reload();
    },
    error: function(data) {
      $('#alert').removeClass('alert-info').addClass('alert-error');
      $('#alert').text('Failed');
    },
  });

  return false;
});