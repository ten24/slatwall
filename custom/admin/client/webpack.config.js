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
	clientRoot      :	__dirname ,
    clientSrc       :   path.join(__dirname, '/src'),
    clientDist      :   path.join(__dirname, '/dist'),
    slatwallSrc     : 	path.resolve(__dirname, '../../../admin/client/src'),
    monatAdmin      :	path.join(__dirname, '/src/monatadmin'),
    hibachiSrc      : 	path.resolve(__dirname, '../../../org/Hibachi/client/src'),
    nodeModeles     :   path.resolve(__dirname, '../../../node_modules'),
    templateFile    :   path.join(__dirname, "./template.html")
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
    context     : PATHS.clientSrc, // The base directory, an absolute path, for resolving entry points
    watch       : true,
    
    performance : {
        hints: false // to ignore annoying bundle-size warnings
    },
    
    entry: { 
        monatAdmin: [ './bootstrap.ts' ] 
    },
                
    output : {
        path:  PATHS.clientDist,
        filename: "[name].[contenthash].bundle.js",
    },
    
    resolve : {
        extensions  : [ '.webpack.js',  '.web.js', '.ts', '.js', '.html' ],
        modules     : [ 
            PATHS.clientSrc, 
            PATHS.slatwallSrc,
            PATHS.hibachiSrc, 
            PATHS.nodeModeles 
        ],
        alias       : { 
            '@Monat'    : PATHS.monatAdmin, 
            '@Hibachi'  : PATHS.hibachiSrc,
            '@Slatwall' : PATHS.slatwallSrc
        }
    },
    
    externals: {
        jquery: "jQuery"
    },
};


devConfig.module = {
    rules: [
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
                PATHS.clientSrc,
                PATHS.slatwallSrc,
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
                            removeComments: devConfig.mode === 'production',
                            collapseWhitespace: devConfig.mode === 'production',
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
                name: 'monatAdminVendor',
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
        '__DEBUG_MODE__': JSON.stringify( devConfig.mode === 'development' )
    }),
    
    new webpack.ContextReplacementPlugin(/moment[\/\\]locale$/, /en/),
    new webpack.HashedModuleIdsPlugin(), // so that file hashes don't change unexpectedly
    
    new CleanWebpackPlugin(),
    new HtmlWebpackLinkTypePlugin(),

    new HtmlWebpackPlugin({
        template: PATHS.templateFile,
        filename: "MonatAdminBundle.cfm",
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
        tsconfig: path.resolve(PATHS.clientRoot, 'tsconfig.json')
    }),
    
    new WebpackBar({
        name: "Monat Admin",
        
        reporters: [ 'basic', 'fancy', 'profile', 'stats' ],
        fancy: true,
        profile: false,
        stats: true
    })
];   

module.exports = devConfig;

