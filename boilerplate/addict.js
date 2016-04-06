// for phoenix_html support, including form and button helpers
// copy the following scripts into your javascript bundle:
// * https://raw.githubusercontent.com/phoenixframework/phoenix_html/v2.3.0/priv/static/phoenix_html.js

$(document).ready(function() {
  function navigateToRoot() {
    window.location.href = "/";
  }

  function addErrors(errors) {
    for (var i = errors.length - 1; i >= 0; i--) {
      $('.addict.errors').append("<p class='addict error-message'>"+errors[i].message+"</p>");
    }
  }

  $('#btn-register').click(function () {
    var name = $('#txt-name').val();
    var email = $('#txt-email').val();
    var password = $('#txt-password').val();
    var csrf_token = $('#csrf-token').val();
    var params = {
      name: name,
      email: email,
      password: password
    };
    $.ajax({
      type: 'POST',
      url: '/register',
      headers: {
        'x-csrf-token': csrf_token
      },
      data: params
    })
    .done(navigateToRoot);
  });

  $('#btn-logout').click(function () {
    var csrf_token = $('#csrf-token').val();
    $.ajax({
      type: 'POST',
      url: '/logout',
      headers: {
        'x-csrf-token': csrf_token
      },
    }).done(navigateToRoot);
  });

  $('#btn-login').click(function () {
    var csrf_token = $('#csrf-token').val();
    var email = $('#txt-email').val();
    var password = $('#txt-password').val();
    var csrf_token = $('#csrf-token').val();
    $('.addict.errors').empty();
    var params = {
      email: email,
      password: password
    };

    $.ajax({
      type: 'POST',
      url: '/login',
      headers: {
        'x-csrf-token': csrf_token
      },
      data: params
    })
    .fail(function (res) {addErrors(res.responseJSON.errors); })
    .done(navigateToRoot);;
  });

  $('#btn-reset-password').click(function () {
    var csrf_token = $('#csrf-token').val();
    var password = $('#txt-password').val();
    var token = $('#token').val();
    var signature = $('#signature').val();
    $('.addict.errors').empty();
    var params = {
      password: password,
      token: token,
      signature: signature
    };

    $.ajax({
      type: 'POST',
      url: '/reset_password',
      headers: {
        'x-csrf-token': csrf_token
      },
      data: params
    })
    .fail(function (res) {addErrors(res.responseJSON.errors); })
    .done(navigateToRoot);;
  });


  $('#btn-send-reset-password-link').click(function () {
    var email = $('#txt-email').val();
    var csrf_token = $('#csrf-token').val();
    $('.addict.errors').empty();
    var params = {
      email: email,
    };

    $.ajax({
      type: 'POST',
      url: '/recover_password',
      headers: {
        'x-csrf-token': csrf_token
      },
      data: params
    })
    .fail(function() { addErrors([{message: "Whoops, something went wrong! Please try again later."}]) })
    .done(navigateToRoot);;
  });
});