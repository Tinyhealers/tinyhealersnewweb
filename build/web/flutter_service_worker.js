'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {".git/COMMIT_EDITMSG": "a8297d555dd34879e8e48e1cf12acefa",
".git/config": "810846837f08aef95143ded4752d5346",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/HEAD": "cf7dd3ce51958c5f13fece957cc417fb",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/fsmonitor-watchman.sample": "a0b2633a2c8e97501610bd3f73da66fc",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-commit.sample": "5029bfab85b1c39281aa9697379ea444",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/hooks/sendemail-validate.sample": "4d67df3a8d5c98cb8565c07e42be0b04",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/index": "81f7ab96ff83362b92bc3a4233f83d62",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "bbec8342e613eb1f96c3966bfc57309b",
".git/logs/refs/heads/main": "ef44450bcfdf9a9b34af42b90eaaea62",
".git/logs/refs/remotes/origin/main": "2a5c5700e3f62d37429665d905f66b89",
".git/objects/26/c09b862852130bf1c85ac7b30273434c2a3631": "f69e9dfbe649308aade6768fcfdfa597",
".git/objects/30/f6e4eed7fdb5f687ae40989ec1db41ec0ef051": "cd3efcf2396d68c8cc673a1313fbfd33",
".git/objects/87/104c2fe8d160d4c53c90acdfa3cc26a48170bc": "a10e4de337e4d267949faa7758dc07f4",
".git/objects/96/70470d679ae60fa2277f809a6cb39aa6740357": "ea46ba594bc8ede00c039a339a922477",
".git/objects/a3/bdb797437d2eeb82c0259c1b6b566099497bd9": "ca42c2180d845d5ff8233c9fed730db5",
".git/objects/d9/91836263c165e10d80d0213f706df584b04335": "691fad5b665c1e3bafd1d991a690797e",
".git/objects/ee/fcaf2a7dbc4e9acfcdeed73a897d512cc02a43": "ae218e326860897149431f41d9f51044",
".git/objects/f0/b229cf2a3f803178c9acb56a2d98fdc5eff8d1": "183ca87444038fbbf6d56ed304a4a45c",
".git/objects/fc/c89314fe68d6c81f5d219cbc13142d1d56cfc9": "85b0df0963a803dd94d765b133f7342c",
".git/refs/heads/main": "6fbf695d49ccea51b06aef0a0566f3d6",
".git/refs/remotes/origin/main": "6fbf695d49ccea51b06aef0a0566f3d6",
"assets/AssetManifest.bin": "b636ee3f6ab0109eff2dc170dffe1199",
"assets/AssetManifest.bin.json": "b83f6ccdfdd9894deddf33c0f0f41884",
"assets/AssetManifest.json": "ef48e6df3b44fc5f33ef72cc3ea85319",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "0a31eb8ede0e205aa7f221d725da9bd1",
"assets/lib/images/appicon.png": "2a9b41ff9e9eaaed06dd9ee67c279694",
"assets/NOTICES": "cde4194407d69bba0bb566022a3c4795",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/web/icons/Icon-192.png": "cfb7ead4abc60e87ef10645f206fdd89",
"assets/web/icons/Icon-512.png": "cfb7ead4abc60e87ef10645f206fdd89",
"assets/web/icons/Icon-maskable-192.png": "cfb7ead4abc60e87ef10645f206fdd89",
"assets/web/icons/Icon-maskable-512.png": "cfb7ead4abc60e87ef10645f206fdd89",
"assets/web/icons/loginpage.jpg": "1f439c51499b2133712fa1677f1b7ef6",
"canvaskit/canvaskit.js": "66177750aff65a66cb07bb44b8c6422b",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/chromium/canvaskit.js": "671c6b4f8fcc199dcc551c7bb125f239",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/skwasm.js": "694fda5704053957c2594de355805228",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"favicon.png": "2d9254a06de7aa36639738b05405a4a0",
"flutter.js": "f393d3c16b631f36852323de8e583132",
"flutter_bootstrap.js": "8cac02fc6d031185689a8eaa734cf475",
"icons/Icon-192.png": "cfb7ead4abc60e87ef10645f206fdd89",
"icons/Icon-512.png": "cfb7ead4abc60e87ef10645f206fdd89",
"icons/Icon-maskable-192.png": "cfb7ead4abc60e87ef10645f206fdd89",
"icons/Icon-maskable-512.png": "cfb7ead4abc60e87ef10645f206fdd89",
"icons/loginpage.jpg": "1f439c51499b2133712fa1677f1b7ef6",
"index.html": "2bf8a0c80eff6687439f05b1aceb09f0",
"/": "2bf8a0c80eff6687439f05b1aceb09f0",
"main.dart.js": "2038b44cf52f0369086c879eb2667c47",
"manifest.json": "56750ea81f8fe3b66e9d2e62843f0d56",
"sw.js": "dfad3b63755ca5c75201ec626109a081",
"version.json": "8060230bc203284e8372ed8ce084fe8e"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
