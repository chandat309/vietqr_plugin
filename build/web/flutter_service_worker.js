'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "56a0e681095caffe55964730b217b3e0",
"assets/AssetManifest.bin.json": "377316aea7ae202544564fc3b04d6cc6",
"assets/AssetManifest.json": "f829cb4abf8eb3e2e063c7f4e125ed79",
"assets/assets/images/bg-qr-vqr.png": "cb23b24bb590f7d84dcadf4bb70312b0",
"assets/assets/images/ic-add-bank.png": "be7793220499c0a40b01d79ee1b3bcab",
"assets/assets/images/ic-avatar.png": "40d36a273b69d7c5599bad0323e5250e",
"assets/assets/images/ic-back-white.png": "8ef5ff60a97669865d665af7122b29f4",
"assets/assets/images/ic-back.png": "6a5c06f68dac333f4a3b5a22f1abc978",
"assets/assets/images/ic-copy-blue.png": "149b163438b6a625cd4d0e12ea011cd8",
"assets/assets/images/ic-napas247.png": "f6c557ed224514a70743401191d2325c",
"assets/assets/images/ic-next-blue.png": "78cd2a569cb6227a779b5ffab0d86224",
"assets/assets/images/ic-notice.png": "6241d7bfc1a80c22f88945bcb8df2b4e",
"assets/assets/images/ic-search.png": "fbcf2597618ec1bfc0f5117566221c2a",
"assets/assets/images/ic-viet-qr-small.png": "0ff0e824a892b06d5ea250b2233fe04e",
"assets/assets/images/logo-register-user.png": "a5667e1951b81ac0dae0bb7d6bc4a295",
"assets/assets/images/logo-vietqr-small-hor.png": "92a7fd3f118403f77defe49c12699975",
"assets/assets/images/logo-vietqr.png": "494369372c9c22fe31739d53df3555bb",
"assets/assets/js/main.js": "cbd4b2bdcb5ab24524af24642204c30d",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "aabb75de50a519306a084963158169b0",
"assets/NOTICES": "847670f646af15e0b05041f60dc3eb66",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/packages/fluttertoast/assets/toastify.js": "56e2c9cedd97f10e7e5f1cebd85d53e3",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"audio/0.mp3": "8dc00047eaed61623cd9b708a9132761",
"audio/10.mp3": "345793c27f909817fffbdad057e100b0",
"audio/2.mp3": "abde5e55a060292e8d275ae7e51ae169",
"audio/3.mp3": "0001739188640a343ec2564c24e28417",
"audio/4.mp3": "d6c03d14ca929938cedd3fb04bb6dd29",
"audio/5.mp3": "4d74035c57f054447ad56c8101636786",
"audio/6.mp3": "26c602bca0117d7efb360f2f3b6c8275",
"audio/7.mp3": "1e4da78f514f3f8b1282a20b032f8ca5",
"audio/8.mp3": "7b50737b5dbebbdd7c9774f628f62cc0",
"audio/9.mp3": "a8755471f41fac83479b1518f26ba627",
"audio/dong.mp3": "2d8567bf93409622ee281627aef97359",
"audio/le.mp3": "b0950fb43a94a84229ec5b7316d5693c",
"audio/linh.mp3": "db9c6a2bad444b18424b78272148a977",
"audio/mot.mp3": "82a236fcf9dfea87b4d3d93f2c6905a9",
"audio/muoi.mp3": "8761e95895081104472e9e7d6d5e2be7",
"audio/nghin.mp3": "89fb44c9c553c46a0d10eef9a878a29f",
"audio/tram.mp3": "e7764375ed5a16835b1fcf01ba3fbffe",
"audio/trieu.mp3": "c1f85c2351821f58979243ddd38e0f00",
"audio/ty.mp3": "a7a44e923b43e113d7f2642a4f0979f7",
"background.js": "65d42ef599306b4e2ecdc5371cbd7d46",
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
"content.js": "ea0cef0d430d491c17b8f5d83ca269f2",
"dialog.css": "d9290c4ff9f612d0fb80f97f57db4800",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "f393d3c16b631f36852323de8e583132",
"flutter_bootstrap.js": "862a968ae8618eb785a0a850c78e49ca",
"icons/chromextension128.png": "c02606277c63564cb040e17b6ca39e1e",
"icons/chromextension16.png": "262740b3f3ebdf8afc2cf6fa72e7aebc",
"icons/chromextension32.png": "218aea564706521172c5a599e72473ee",
"icons/chromextension48.png": "d64bb6e34c42e4ab8f85fd45cab07cd0",
"index.html": "9f40c7709d25508ee01a51a5fd08d970",
"/": "9f40c7709d25508ee01a51a5fd08d970",
"main.dart.js": "1c1c004682c6be148eb76dfd7b17eeaf",
"manifest.json": "90de6a30e970db1a390d712dd13bc1c2",
"version.json": "e292c954e4c0c2c4cadd2df9a407b526"};
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
