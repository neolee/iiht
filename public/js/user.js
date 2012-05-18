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
            switch(data.status)
            {
                case 401:
                errorMsg = 'You are not authorized to do this.'
                break;
                case 403:
                errorMsg = 'Current password is not correct. No data change performed.'
                break;
                case 304:
                errorMsg = 'Nothing changed.'
                break;
                case 400:
                errorMsg = 'Cannot save changes [Error: ' + data.responseText + '].'
                break;
                default:
                errorMsg = 'Failed [Error code: ' + data.status + '].'
            }

            $('#alert').removeClass('alert-info').addClass('alert-error');
            $('#alert').text(errorMsg);
        },
    });

    return false;
});
