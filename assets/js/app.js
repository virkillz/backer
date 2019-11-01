// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

import css from '../css/app.css';

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

window.__socket = require("phoenix").Socket;

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"
import { Socket } from "phoenix"
import LiveSocket from "phoenix_live_view"
import { Elm } from "../src/Backerzone.elm";

let liveSocket = new LiveSocket("/live", Socket)
liveSocket.connect()

const node = document.getElementById('backerzone');

if (node) {
    const avatar = node.getAttribute('data-avatar');
    const notifCount = node.getAttribute('data-notif-count');
    const isDonee = (node.getAttribute('data-is-donee') == "true");

    Elm.Backerzone.init({
        node: node,
        flags: [avatar, isDonee, notifCount]
    });
}
