"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
var _bindings = require("./bindings.js");
Object.keys(_bindings).forEach(function (key) {
  if (key === "default" || key === "__esModule") return;
  if (key in exports && exports[key] === _bindings[key]) return;
  Object.defineProperty(exports, key, {
    enumerable: true,
    get: function () {
      return _bindings[key];
    }
  });
});
var _types = require("./types.js");
Object.keys(_types).forEach(function (key) {
  if (key === "default" || key === "__esModule") return;
  if (key in exports && exports[key] === _types[key]) return;
  Object.defineProperty(exports, key, {
    enumerable: true,
    get: function () {
      return _types[key];
    }
  });
});
//# sourceMappingURL=index.js.map