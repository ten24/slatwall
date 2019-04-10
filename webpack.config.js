const webpack = require("webpack");

const ForceCaseSensitivityPlugin = require("force-case-sensitivity-webpack-plugin");
const ForkTsCheckerWebpackPlugin = require('fork-ts-checker-webpack-plugin');

const TerserPlugin = require("terser-webpack-plugin"); //minimizer
const CompressionPlugin = require("compression-webpack-plugin");

const LinkTypePlugin = require('html-webpack-link-type-plugin').HtmlWebpackLinkTypePlugin;
const CleanWebpackPlugin = require("clean-webpack-plugin"); // clean dist  dir
const HtmlWebpackPlugin = require("html-webpack-plugin"); // create index template

const BundleAnalyzerPlugin = require("webpack-bundle-analyzer")
  .BundleAnalyzerPlugin;


var path = require("path");
var PATHS = {
  app: path.join(__dirname, "admin/client/src"),
  dist: path.join(__dirname, "/dist"),
  hibachi: path.join(__dirname, "org/Hibachi/client/src")
};

var appConfig = {
  mode: "development",
  // watch: true,
  context: __dirname, //where thi dist/ folder goes
  entry: {
    app: path.join(PATHS.app, "/bootstrap.ts"),
    frontend: path.join(PATHS.hibachi, "/frontend/bootstrap.ts"),
  },
  output: {
    path: PATHS.dist,
    filename: "[name].[contenthash].js",
    chunkFilename: "[name].[contenthash].bundle.js",
    sourceMapFilename: "sourcemaps/[file].map",
    publicPath: "/dist/", // we have to do more work on this one
    pathinfo: false
    // publicPath: "#request.slatwallScope.getBaseURL()#/dist/"
  },

  // Turn on sourcemaps
  // devtool: "source-map",
  resolve: {
    extensions: [".webpack.js", ".web.js", ".ts", ".js"]
  },
  externals: {
    jquery: "jQuery"
  },
  module: {
    rules: [
      {
        test: /\.tsx?$/,
        use: [
          {
            loader: "ts-loader",
            options: {
              transpileOnly: true
            }
          }
        ],
        exclude: /node_modules/
      }
    ]
  },
  plugins: [
    new webpack.HashedModuleIdsPlugin(), // so that file hashes don't change unexpectedly
    new webpack.ContextReplacementPlugin(/moment[\/\\]locale$/, /en/),
    new ForceCaseSensitivityPlugin(),
    new CleanWebpackPlugin(),
    new LinkTypePlugin(),
    new HtmlWebpackPlugin({
      template: path.join("./template.html"),
      filename: "include-admin.cfm",
      inject: false,
      chunks: ["app"],
      chunkSortMode: "dependency",
    }),
    new HtmlWebpackPlugin({
      template: path.join("./template.html"),
      filename: "include-frontend.cfm",
      inject: false,
      chunks: ["frontend"],
      chunkSortMode: "dependency",
    }),
    new CompressionPlugin({
      asset: "[path].gz[query]",
      algorithm: "gzip",
      test: /\.js$|\.css$|\.html$/,
      threshold: 10240,
      minRatio: 0.8
    }),
    // new ForkTsCheckerWebpackPlugin(), //  for typechecking,   were using tsloader to transpile-only to reduce the build time
    // new BundleAnalyzerPlugin()
  ],
  optimization: {
    usedExports: true,
    runtimeChunk: "single",
    splitChunks: {
      chunks: "all",
      maxInitialRequests: Infinity,
      minSize: 3000,
      cacheGroups: {
        "vendor-angular": {
          reuseExistingChunk: true,
          name: "vendor-angular",
          test: /[\\/]node_modules[\\/]angular.*?[\\/]/,
          chunks: "initial",
          priority: 2
        },
        "async": {
          enforce: true,
          chunks: "async",
          priority: 2
        },
      }
    },
    mangleWasmImports: true, //  tells webpack to reduce the size of WASM by changing imports to shorter strings. It mangles module and export names.
    minimizer: [
      new TerserPlugin({
        cache: true,
        parallel: true,
        sourceMap: true,
        terserOptions: {
          warnings: false,
          parse: {},
          compress: {
            drop_console: true,
          },
          mangle: true, // Note `mangle.properties` is `false` by default.
          module: false,
          output: {
            comments: false
          },
          toplevel: false,
          nameCache: null,
          ie8: false,
          keep_classnames: false,
          keep_fnames: false,
          safari10: false
        }
      })
    ]
  }
};

module.exports = appConfig;
