$("#formComment").validate({
    rules: {
        comment: "required",
    }
});

$('#formComment').submit(function(event) {
    if($('#formComment').valid() == false) return false;
    
    $('#alert').removeClass('alert-success alert-error').addClass('alert-info');
    $('#alert').show().text('Commenting...');

    $.ajax({
        type: $('#formComment').attr('method'),
        url: $('#formComment').attr('action'),
        data: $('#formComment').serialize(),
        success: function(data) {
            errorMsg = 'Submitted.'
            $('#comments').append(data);
            $('#alert').removeClass('alert-info').addClass('alert-success');
            $('#alert').text(errorMsg).fadeOut('slow');
        },
        error: function(data) {
            switch(data.status)
            {
                case 401:
                errorMsg = 'You are not authorized to do this.'
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
