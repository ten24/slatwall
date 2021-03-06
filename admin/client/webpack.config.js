const path = require('path');
const webpack = require('webpack');
const WebpackBar = require('webpackbar');
const ThreadLoader = require('thread-loader');
const HtmlWebpackPlugin = require("html-webpack-plugin"); // create index template
const CompressionPlugin = require("compression-webpack-plugin");
const NgAnnotateWebPackPlugin = require('ng-annotate-webpack-plugin');
const HtmlWebpackLinkTypePlugin = require('html-webpack-link-type-plugin').HtmlWebpackLinkTypePlugin;
const ForkTsCheckerWebpackPlugin = require('fork-ts-checker-webpack-plugin');

const { CleanWebpackPlugin } = require('clean-webpack-plugin'); // to auto-clean dist-dir

const PATHS = {
	slatwallAdminRoot      :	__dirname ,
    slatwallAdminSrc       :   path.join(__dirname, '/src'),
    slatwallAdminDist      :   path.join(__dirname, '/dist'),
    hibachiSrc             :   path.resolve(__dirname, '../../org/Hibachi/client/src'),
    nodeModeles            :   path.resolve(__dirname, '../../node_modules'),
    templateFile           :   path.join(__dirname, "./template.html")
};

const calculateNumberOfWorkers = () => {
	const cpus = require('os').cpus() || { length: 1 };
	return Math.max(2, cpus.length - 1);
};

const workerPool = {
	workers: calculateNumberOfWorkers(),
	workerParallelJobs: 10,
	poolRespawn: process.env.NODE_ENV !== 'production',
	poolTimeout: process.env.NODE_ENV !== 'production' ? Infinity : 2000
};

if (calculateNumberOfWorkers() > 0) {
	ThreadLoader.warmup(workerPool, ['ts-loader', 'html-loader']);
}


let devConfig = { 
    
    mode        : 'development',
    stats       : 'errors-warnings', //detailed, errors-warnings, errors-only
    devtool     : 'source-map',
    context     : PATHS.slatwallAdminSrc, // The base directory, an absolute path, for resolving entry points
    watch       : true,
    watchOptions: {
        ignored: ['**/bundle.js', 'node_modules/**']
    },
    
    performance : {
        hints: false // to ignore annoying bundle-size warnings
    },
    
    entry: { 
        slatwallAdmin: [ './bootstrap.ts' ] 
    },
                
    output : {
        path:  PATHS.slatwallAdminDist,
        pathinfo: false,
        filename: "[name].[contenthash].bundle.js",
    },
    
    resolve : {
        extensions  : [ '.webpack.js',  '.web.js', '.ts', '.js', '.html' ],
        modules     : [ 
            PATHS.slatwallAdminSrc, 
            PATHS.hibachiSrc, 
            PATHS.nodeModeles 
        ],
        alias       : { 
            '@Hibachi'  : PATHS.hibachiSrc,
            '@Slatwall' : PATHS.slatwallAdminSrc
        }
    },
    
    externals: {
        jquery: "jQuery"
    },
};


devConfig.module = {
    rules: [
        { 
            test: /\.js$/, 
            enforce: 'pre', 
            use: ['source-map-loader'] 
        },
		{
			test: /\.tsx?$/i,
			use: [
				{
					loader: 'cache-loader'
				},
                {
                    loader: 'ts-loader',
                    options: {
                        transpileOnly: true,
                        happyPackMode: true, // IMPORTANT! use happyPackMode mode to speed-up compilation and reduce errors reported to webpack
					    experimentalWatchApi: true
                    }
                }
            ],
            exclude: /node_modules/
		},
		// Load raw HTML files for inlining our templates
        { 
            test: /\.(html)$/, 
            exclude: /index\.html/,
            include: [
                PATHS.slatwallAdminSrc,
                PATHS.hibachiSrc
            ],
            use: [
                {
					loader: 'cache-loader'
				},
                {
                    loader: 'html-loader',
                    options: {
                        attributes: false, // Disables attributes processing
                        esModule: true,
                        minimize: {
                            removeComments: process.env.NODE_ENV === 'production',
                            collapseWhitespace: process.env.NODE_ENV === 'production',
                        },
                    },
                }
            ]
        },
    ]
};

devConfig.optimization = {
    splitChunks : {
        cacheGroups: {
            commons: {
                test: PATHS.nodeModeles,
                name: 'slatwallAdminVendor',
                chunks: 'all'
            },
            hibachi: {
                test: PATHS.hibachiSrc,
                name: 'hibachiAdmin',
                chunks: 'all'
            }
        }
    }
};

//don't need the vendor bundle generated here because we include the vendor bundle already.
devConfig.plugins =  [
    
    // https://blog.johnnyreilly.com/2016/07/using-webpacks-defineplugin-with-typescript.html
    new webpack.DefinePlugin({
        '__DEBUG_MODE__': JSON.stringify( process.env.NODE_ENV === 'development' )
    }),
    
    new webpack.ContextReplacementPlugin(/moment[\/\\]locale$/, /en/),
    new webpack.HashedModuleIdsPlugin(), // so that file hashes don't change unexpectedly
    
    new CleanWebpackPlugin(),
    new HtmlWebpackLinkTypePlugin(),

    new HtmlWebpackPlugin({
        template: PATHS.templateFile,
        filename: "SlatwallAdminBundle.cfm",
        inject: false,
        minify: false,
        cache: false // there's a bug in current versions HTML-plugin (it doesn't generte the template in watch mode)
    }),
    
    new NgAnnotateWebPackPlugin({
        add: true,
    }),
    
    new CompressionPlugin({
      test: /\.(j|c)ss?$/i,
      threshold: 10240,
      filename: '[path].gz[query]',
      deleteOriginalAssets: false
    }),
    
    // HTTPS only
    // https://webpack.js.org/plugins/compression-webpack-plugin/#using-brotli
    // brotli is much smaller
    new CompressionPlugin({
      test: /\.(j|c)ss?$/i,
      filename: '[path].br[query]',
      algorithm: 'brotliCompress',
      threshold: 10240,
      minRatio: 0.8,
      compressionOptions: {
        // zlib’s `level` option matches Brotli’s `BROTLI_PARAM_QUALITY` option.
        level: 11,
      },
      deleteOriginalAssets: false,
    }),
    
    new ForkTsCheckerWebpackPlugin({
        async: false,
        useTypescriptIncrementalApi: true,
        checkSyntacticErrors: true,
        memoryLimit: 4096,
        tsconfig: path.resolve(PATHS.slatwallAdminRoot, 'tsconfig.json')
    }),
    
    new WebpackBar({
        name: "Slatwall Admin",
        
        reporters: [ 'basic', 'fancy', 'profile', 'stats' ],
        fancy: true,
        profile: false,
        stats: true
    })
];   

module.exports = devConfig;

