var PAYMILL_PUBLIC_KEY = "176242150348ea30e5575947bd6c7d55";

$(document).ready(function ($) {

    var displayError = function(whatHappened){
      $('#messages').html("");
      $('#messages').append('<div id="error" class="alert alert-danger flash">' + whatHappened + '</div>');
    };

    function PaymillResponseHandler(error, result) {
        if (error) {
          displayError(error.apierror);
        } else {
            $(".payment-errors").css("display","none");
            $(".payment-errors").text("");

            var token = result.token;
            $('#paymill_card_token').val(token);
            $('#new_payment').submit();
        }
        $('.get-token').on('click', submitData);
    }

    var submitData = function (event) {
        if( $("#accept_terms").length && !$("#accept_terms").is(":checked")){
          displayError(you_must_accept_terms_and_conditions);
          return false;
        }

        $('#messages').html("");
        $('.get-token').off('click');

        if (false == paymill.validateCardNumber($('#card_number').val())) {
          displayError(invalid_card_number);
            $(".get-token").removeAttr("disabled");
            $('.get-token').on('click', submitData);
            return false;
        }
        if (false == paymill.validateExpiry($('#expiration_month').val(), $('#expiration_year').val())) {
          displayError(invalid_expiry_date);
            $('.get-token').on('click', submitData);
            return false;
        }

        if ($('#name').val() == '') {
            displayError(invalid_card_holder_name);
            $('.get-token').on('click', submitData);
            return false;
        }
        var params = {
            amount_int:     Math.round($("#total-price").val()),  // E.g. "15" for 0.15 Eur
            currency:       'EUR',    // ISO 4217 e.g. "EUR"
            number:         $('#card_number').val(),
            exp_month:      $('#expiration_month').val(),
            exp_year:       $('#expiration_year').val(),
            cvc:            $('#cvc').val(),
            cardholder:     $('#name').val()
        };

        paymill.createToken(params, PaymillResponseHandler);
        return false;
    };
    $(".get-token").on('click', submitData);
});
