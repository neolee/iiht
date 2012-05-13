$('#formUser').submit(function(event) {
  $('#msgSave').show().text('Saving...');

  $.ajax({
    type: $('#formUser').attr('method'),
    url: $('#formUser').attr('action'),
    data: $('#formUser').serialize(),
    success: function(data) {
      $('#msgSave').text('Saved').fadeOut('slow');
    },
    error: function(data) {
      $('#msgSave').text('Failed');
    },
  });

  return false;
});