$.ajaxSetup({
    beforeSend: function() {
        $('#spinner').show();
    },
    complete: function(){
        $('#spinner').hide();
    },
    success: function() {}
});

$.validator.setDefaults({
    errorClass: 'error',
    validClass: 'success',
    errorElement: 'span',
    highlight: function(element, errorClass, validClass) {
        var $obj;
        $obj = element.type === 'radio' ? this.findByName(element.name) : $(element);
        return $obj.parents('div.control-group').removeClass(validClass).addClass(errorClass);
    },
    unhighlight: function(element, errorClass, validClass) {
        var $obj;
        $obj = element.type === 'radio' ? this.findByName(element.name) : $(element);
        $obj.next('span.help-inline.' + errorClass).remove();
        return $obj.parents('div.control-group').removeClass(errorClass).addClass(validClass);
    },
    errorPlacement: function(error, element) {
        if (element.siblings().length > 0) {
            error.insertAfter(element.siblings(':last'));
        } else {
            error.insertAfter(element);
        }
    }
});

$.validator.messages = ({
    required: " can't be blank",
    remote: ' needs to get fixed',
    email: ' is not a valid email address',
    url: ' is not a valid URL',
    date: ' is not a valid date',
    dateISO: ' is not a valid date (ISO)',
    number: ' is not a valid number',
    digits: ' needs to be digits',
    creditcard: ' is not a valid credit card number',
    equalTo: ' is not the same value again',
    accept: ' is not a value with a valid extension',
    maxlength: jQuery.validator.format(' needs to be no more than {0} characters'),
    minlength: jQuery.validator.format(' needs to be at least {0} characters'),
    rangelength: jQuery.validator.format(' needs to be a value between {0} and {1} characters long'),
    range: jQuery.validator.format(' needs to be a value between {0} and {1}'),
    max: jQuery.validator.format(' needs to be a value less than or equal to {0}'),
    min: jQuery.validator.format(' needs to be a value greater than or equal to {0}')
});
