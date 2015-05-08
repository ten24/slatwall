"use strict";
'use strict';
angular.module('slatwalladmin').factory('cryptoService', ['$log', function($log) {
  if (typeof String.prototype.utf8Encode == 'undefined') {
    String.prototype.utf8Encode = function() {
      return unescape(encodeURIComponent(this));
    };
  }
  if (typeof String.prototype.utf8Decode == 'undefined') {
    String.prototype.utf8Decode = function() {
      try {
        return decodeURIComponent(escape(this));
      } catch (e) {
        return this;
      }
    };
  }
  var cryptoService = {
    getSignature: function() {
      $log.debug("Creating a signature");
      var timeUserKey = cryptoService.getSignatureTime() + '_' + cryptoService.getSignatureUser() + '_' + cryptoService.getSecretKey();
      var sha1Text = cryptoService.hash(timeUserKey);
      var upperHash = sha1Text.toUpperCase();
      var signature = btoa(upperHash);
      return signature;
    },
    getSignatureTime: function() {
      return (new Date).getTime();
    },
    getSignatureUser: function() {
      return "4028818d4b05b871014b102d388a00db";
    },
    getSecretKey: function() {
      return "QTFFNEU5NEMtRDJBNi0zNDYyLTIzNUZGRDFFRjMzMzlFMEM=";
    },
    hash: function(msg) {
      msg = msg.utf8Encode();
      var K = [0x5a827999, 0x6ed9eba1, 0x8f1bbcdc, 0xca62c1d6];
      msg += String.fromCharCode(0x80);
      var l = msg.length / 4 + 2;
      var N = Math.ceil(l / 16);
      var M = new Array(N);
      for (var i = 0; i < N; i++) {
        M[i] = new Array(16);
        for (var j = 0; j < 16; j++) {
          M[i][j] = (msg.charCodeAt(i * 64 + j * 4) << 24) | (msg.charCodeAt(i * 64 + j * 4 + 1) << 16) | (msg.charCodeAt(i * 64 + j * 4 + 2) << 8) | (msg.charCodeAt(i * 64 + j * 4 + 3));
        }
      }
      M[N - 1][14] = ((msg.length - 1) * 8) / Math.pow(2, 32);
      M[N - 1][14] = Math.floor(M[N - 1][14]);
      M[N - 1][15] = ((msg.length - 1) * 8) & 0xffffffff;
      var H0 = 0x67452301;
      var H1 = 0xefcdab89;
      var H2 = 0x98badcfe;
      var H3 = 0x10325476;
      var H4 = 0xc3d2e1f0;
      var W = new Array(80);
      var a,
          b,
          c,
          d,
          e;
      for (var i = 0; i < N; i++) {
        for (var t = 0; t < 16; t++)
          W[t] = M[i][t];
        for (var t = 16; t < 80; t++)
          W[t] = cryptoService.ROTL(W[t - 3] ^ W[t - 8] ^ W[t - 14] ^ W[t - 16], 1);
        a = H0;
        b = H1;
        c = H2;
        d = H3;
        e = H4;
        for (var t = 0; t < 80; t++) {
          var s = Math.floor(t / 20);
          var T = (cryptoService.ROTL(a, 5) + cryptoService.f(s, b, c, d) + e + K[s] + W[t]) & 0xffffffff;
          e = d;
          d = c;
          c = cryptoService.ROTL(b, 30);
          b = a;
          a = T;
        }
        H0 = (H0 + a) & 0xffffffff;
        H1 = (H1 + b) & 0xffffffff;
        H2 = (H2 + c) & 0xffffffff;
        H3 = (H3 + d) & 0xffffffff;
        H4 = (H4 + e) & 0xffffffff;
      }
      return cryptoService.toHexStr(H0) + cryptoService.toHexStr(H1) + cryptoService.toHexStr(H2) + cryptoService.toHexStr(H3) + cryptoService.toHexStr(H4);
    },
    f: function(s, x, y, z) {
      switch (s) {
        case 0:
          return (x & y) ^ (~x & z);
        case 1:
          return x ^ y ^ z;
        case 2:
          return (x & y) ^ (x & z) ^ (y & z);
        case 3:
          return x ^ y ^ z;
      }
    },
    ROTL: function(x, n) {
      return (x << n) | (x >>> (32 - n));
    },
    toHexStr: function(n) {
      var s = "",
          v;
      for (var i = 7; i >= 0; i--) {
        v = (n >>> (i * 4)) & 0xf;
        s += v.toString(16);
      }
      return s;
    }
  };
  return cryptoService;
}]);

//# sourceMappingURL=../services/cryptoService.js.map