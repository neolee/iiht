$("##{form_id}").validate({
    rules: {
        title: "required",
    }
});

$('##{commit_id}').click(function(event) {
    if($('##{form_id}').valid() == false) return false;
  
    $('##{alert_id}').removeClass('alert-success alert-error').addClass('alert-info');
    $('##{alert_id}').show().text('Saving...');

    $.ajax({
        type: $('##{form_id}').attr('method'),
        url: $('##{form_id}').attr('action'),
        data: $('##{form_id}').serialize(),
        success: function(data) {
            $('#post').html(data);
            $('##{alert_id}').removeClass('alert-info').addClass('alert-success');
            $('##{alert_id}').text('Saved').fadeOut('slow');
            if ('#{locals[:mode]}' == 'new') {
                location = '/';
            }
            else {
                $('##{modal_id}').modal('hide');
            }
        },
        error: function(data) {
            switch(data.status)
            {
                case 401:
                errorMsg = 'You are not authorized to do this.'
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

            $('##{alert_id}').removeClass('alert-info').addClass('alert-error');
            $('##{alert_id}').text(errorMsg);
        },
    });

    return false;
});