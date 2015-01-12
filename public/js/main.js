// On an user's entrance
var enterRoom = function(user) {
    ws.send(user + " enter");
    $.Dialog.close();
};

// On an user's leave
var leaveRoom = function(user) {
    ws.send(user + " leave");
    $.Dialog.close();
};

/* Watch click */
$(document).click(function(e) {
    var id = $(e.target).attr("id");
    var alt = $(e.target).attr("alt");
    var src = $(e.target).attr("src");
    if ($('#'+id).attr('alt') != undefined) {
        console.log(id);
        $.Dialog({
            overlay: true,
            shadow: true,
            flat: true,
            draggable: true,
            icon: '<img src="' + src + '">',
            title: '',
            content: '',
            padding: 10,
            width: '30%',
            onShow: function(_dialog) {
                var enterButton = '<button class="button primary" type="button" onclick="enterRoom(\'' + id + '\')">出勤</button>&nbsp;';
                var leaveButton = '<button class="button warning" type="button" onclick="leaveRoom(\'' + id + '\')">退勤</button>&nbsp;';
                var content =
                    '<label>User</label>' +
                    '<div class="input-control text info-state">' +
                    '<input type="text" name="user" value="' + id + '" readonly>' +
                    //'<button class="btn-clear" onclick="clearUser()"></button>' +
                    '</div>' +
                    '<label></label>' +
                    '<div class="form-actions" align="right">' +
                    ((alt == "out") ? enterButton : leaveButton) +
                    '<button class="button" type="button" onclick="$.Dialog.close()">Cancel</button> ' +
                    '</div>';
                $.Dialog.title('Status update');
                $.Dialog.content(content);
            }
        });
    }
});

$(document).ready(function(e) {
    var ws_uri = location.href.replace(/^http/, 'ws');
    ws = new WebSocket(ws_uri);

    ws.onopen = function() {
        console.log('ws.onopen');
    }
    ws.onmessage = function(msg) {
        console.log('ws.onmessage: "' + msg.data + '" from server');
        var user = msg.data.split(':')[0];
        var action = msg.data.split(':')[1];
        var avatar = $('#' + user).attr('src');
        $('#' + user).parent().parent().addClass('animated fadeOut');
        $('#' + user).parent().parent().remove();
        if (action == 'enter') {
            var newImg = $("<img/>", {
                alt: "in",
                id: user,
                src: avatar
            });
            var newTileContent = $("<div/>", {
                "class": "tile-content"
            });
            newImg.appendTo(newTileContent);
            var newLabel = $("<div/>", {
                "class": "label fg-amber",
                text: user
            });
            var newBadge = $("<div/>", {
                "class": "badge available"
            });
            var newBrand = $("<div/>", {
                "class": "brand"
            });
            newLabel.appendTo(newBrand);
            newBadge.appendTo(newBrand);
            var newTile = $("<div/>", {
                "class": "tile animated fadeIn",
                "data-click": "transform"
            });
            newTileContent.appendTo(newTile);
            newBrand.appendTo(newTile);
            $('#in').append(newTile);
        } else {
            var newImg = $("<img/>", {
                alt: "out",
                id: user,
                src: avatar
            });
            var newDiv = $("<div/>", {
                "class": "tile-content"
            });
            newImg.appendTo(newDiv);
            var newA = $("<a/>", {
                "class": "tile half bg-dark animated fadeIn",
                "data-click": "transform"
            })
            newDiv.appendTo(newA);
            $('#out').append(newA);
        }
    }
    ws.onclose = function() {
        ws = new WebSocket(ws_uri);
    }

    /*
    var input = $('#input')
    input.change(function () {
      var msg = input.val();
      ws.send(msg);
      append_li('"' + msg + '" to server');
      input.val("");
    });
    */
});
