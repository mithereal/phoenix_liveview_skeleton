// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/user.scss"
// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"
import {Socket} from "phoenix"

import NProgress from "nprogress"
import {LiveSocket} from "phoenix_live_view"

 if ('serviceWorker' in navigator) {
   window.addEventListener('load', () => {
     navigator.serviceWorker.register('/js/service-worker.js');
   });
 }


const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
const liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}})

window.addEventListener("phx:page-loading-start", info => NProgress.start())
window.addEventListener("phx:page-loading-stop", info => NProgress.done())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket
