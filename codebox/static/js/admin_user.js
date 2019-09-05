// Generated by CoffeeScript 2.4.1
(function() {
  $(document).ready(function() {
    $('[data-user-reset-password]').click(function(e) {
      var new_password, username;
      username = $(e.target).attr('data-user-reset-password');
      new_password = prompt('New password');
      if ((new_password == null) || new_password === "") {
        return;
      }
      return $.post('/admin/user/reset_password', {
        'username': username,
        'password': new_password
      }, function(data) {
        if (data.success != null) {
          alert(`${username}'s password was changed`);
        }
        return console.log(data);
      });
    });
    return $('[data-user-delete]').click(function(e) {
      var username;
      username = $(e.target).attr('data-user-delete');
      return $.post('/admin/user/delete', {
        'username': username
      }, function(data) {
        if (data.success != null) {
          alert(`${username} was deleted`);
        }
        return window.location.reload();
      });
    });
  });

}).call(this);

//# sourceMappingURL=admin_user.js.map
