// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).
import "../css/app.css"

// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"
import mapboxgl from "mapbox-gl"
import mapboxglSupported from "@mapbox/mapbox-gl-supported"


let Hooks = {}

Hooks.MainMap = {
  initMap() {
    // if (mapboxglSupported.supported()) {
    //   console.log("--------Yes")
    // } else {
    //   console.log("--------No")
    // }


    mapboxgl.accessToken = 'pk.eyJ1IjoiZW15cmsiLCJhIjoiY2wweW93ZnYzMGp0OTNvbzN5a2VvNWVldyJ9.QyM0MUn75YqHqMUvMlMaag';
    const map = new mapboxgl.Map({
      container: 'bike-map', // container id
      style: 'mapbox://styles/mapbox/streets-v11', // style URL
    })

    map.on('load', function () {
      map.resize();
      map.addLayer({
        'id': 'WaPo',
        'type': 'circle',
        'source': 'WaPo',
        'layout': {
          // make layer visible by default
          'visibility': 'visible'
        },
        'paint': {
          'circle-radius': 2,
          'circle-color': 'rgba(55,148,179,1)'
        },
        'source-layer': 'WaPo'
      });
    })
  },

  mounted() {
    this.initMap()
  }
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, { params: { _csrf_token: csrfToken }, hooks: Hooks })

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" })
window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

