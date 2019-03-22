var webpack = require("webpack");
const CompressionPlugin = require("compression-webpack-plugin");

var ForceCaseSensitivityPlugin = require("force-case-sensitivity-webpack-plugin");
const CleanWebpackPlugin = require("clean-webpack-plugin"); // clean dist  dir
const HtmlWebpackPlugin = require("html-webpack-plugin"); // create index template
const BundleAnalyzerPlugin = require("webpack-bundle-analyzer")
  .BundleAnalyzerPlugin;
const TerserPlugin = require("terser-webpack-plugin"); //minimizer

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
    frontend: path.join(PATHS.hibachi, "/frontend/bootstrap.ts")
  },
  output: {
    path: PATHS.dist,
    filename: "[name].[contenthash].js",
    chunkFilename: "[name].[contenthash].bundle.js",
    sourceMapFilename: "sourcemaps/[file].map",
    publicPath: "#request.slatwallScope.getBaseURL()#/dist/" 
    //    publicPath: "#request.slatwallScope.getBaseURL()#/admin/client/dist/" //  the url to the output directory resolved relative to the HTML page
  },

  // Turn on sourcemaps
  devtool: 'source-map',
  resolve: {
    extensions: [".webpack.js", ".web.js", ".ts", ".js"]
  },
  externals: {
    // jquery: 'jQuery'
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
        ]
      }
    ]
  },
  plugins: [
    new webpack.HashedModuleIdsPlugin(), // so that file hashes don't change unexpectedly
    new ForceCaseSensitivityPlugin(),
    new webpack.ContextReplacementPlugin(/moment[\/\\]locale$/, /en/),
    new CleanWebpackPlugin(),
    new HtmlWebpackPlugin({
      template: path.join("./template.html"),
      filename: "include-admin.cfm",
      inject: false,
      chunks: ["app"],
      chunkSortMode: "dependency"
    }),
    new HtmlWebpackPlugin({
      template: path.join("./template.html"),
      filename: "include-frontend.cfm",
      inject: false,
      chunks: ["frontend"],
      chunkSortMode: "dependency"
    }),
    new CompressionPlugin({
      asset: "[path].gz[query]",
      algorithm: "gzip",
      test: /\.js$|\.css$|\.html$/,
      threshold: 10240,
      minRatio: 0.8
    }),
    // new BundleAnalyzerPlugin()
  ],
  optimization: {
    usedExports: true,
    // runtimeChunk: {
    //   name: entrypoint => `runtime~${entrypoint.name}`
    // },
    runtimeChunk: 'single',
    splitChunks: {
      chunks: "all",
      maxInitialRequests: Infinity,
      minSize: 30000,
      cacheGroups: {
        // default: false,
        // vendors: false,
        "vendor-angular": {
          reuseExistingChunk: true,
          name: "vendor-angular",
          test: /[\\/]node_modules[\\/]angular.*?[\\/]/,
          chunks: "initial",
          priority: 2
        },
        "vendor-all": {
          reuseExistingChunk: true,
          name: "vendor-all",
          test: /[\\/]node_modules[\\/]/,
          chunks: "initial",
          priority: 1
        }
      }
    },
    mangleWasmImports: true, //  tells webpack to reduce the size of WASM by changing imports to shorter strings. It mangles module and export names.
    minimizer: [
      new TerserPlugin({
        cache: true,
        parallel: true,
        sourceMap: true,
        // extractComments: "all",
        terserOptions: {
          warnings: false,
          parse: {},
          compress: true,
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
