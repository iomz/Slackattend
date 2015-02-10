/* When an user action is fired */
var updateStatus = function(id, action_name) {
    var data = JSON.stringify({ user: id, action_name: action_name })
    ws.send(data);
    $.Dialog.close();
};

/* Update the screen when server side process successful */
var animateUpdate = function(id, action_name, avatar) {
    $('#' + id).parent().parent().addClass('animated fadeOut');
    $('#' + id).parent().parent().remove();

    if (action_name == in_action) {
        var newImg = $("<img/>", {
            alt: action_name,
            id: id,
            src: avatar
        });
        var newTileContent = $("<div/>", {
            "class": "tile-content"
        });
        newImg.appendTo(newTileContent);
        var newLabel = $("<div/>", {
            "class": "label fg-amber",
            text: id
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
            alt: out_action,
            id: id,
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
};

/* Watch click */
$(document).click(function(e) {
    var id = $(e.target).attr("id");
    var action_name = ($(e.target).attr("alt") == in_action) ? out_action : in_action;
    var src = $(e.target).attr("src");
    if ($('#'+id).attr('alt') != undefined) {
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
                var color = (action_name == in_action) ? 'primary' : 'warning';
                var updateButtons = '<button class="button ' + color + '" type="button" onclick="updateStatus(\'' + id + '\', \'' + action_name + '\')">' + action_name + '</button>&nbsp;';
                var content =
                    '<label>User</label>' +
                    '<div class="input-control text info-state">' +
                    '<input type="text" name="user" value="' + id + '" readonly>' +
                    '</div>' +
                    '<label></label>' +
                    '<div class="form-actions" align="right">' +
                    updateButtons +
                    '<button class="button" type="button" onclick="$.Dialog.close()">Cancel</button> ' +
                    '</div>';
                $.Dialog.title('Status update');
                $.Dialog.content(content);
            }
        });
    }
});

$(document).ready(function(e) {
    ws.onopen = function() {
        console.log(ws);
    }

    ws.onmessage = function(msg) {
        var data = JSON.parse(msg.data);
        if (data.id && data.action_name) {
            var id = data.id;
            var action_name = data.action_name;
            var avatar = $('#' + id).attr('src');
            animateUpdate(id, action_name, avatar);
        } else {
            console.log(data);
        }
    }

    ws.onclose = function() {
        console.log(ws);
        location.reload()
    }

});

var ws = new WebSocket(location.href.replace(/^http/, 'ws'));

