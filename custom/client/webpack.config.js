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
    monatFrontend   :	path.join(__dirname, '/src/monatfrontend'),
    hibachiSrc      : 	path.resolve(__dirname, '../../org/Hibachi/client/src'),
    nodeModeles     :   path.resolve(__dirname, '../../node_modules'),
    templateFile    :   path.join(__dirname, "./template.html")
};


const calculateNumberOfWorkers = () => {
	const cpus = require('os').cpus() || { length: 1 };
	return Math.max(1, cpus.length - 1);
};

const workerPool = {
	workers: calculateNumberOfWorkers(),
	workerParallelJobs: 5,
	poolRespawn: process.env.NODE_ENV !== 'production',
	poolTimeout: process.env.NODE_ENV !== 'production' ? Infinity : 2000
};

if (calculateNumberOfWorkers() > 0) {
	ThreadLoader.warmup(workerPool, ['ts-loader']);
}


let devConfig = { 
    
    mode        : 'development',
    stats       : 'errors-warnings', //detailed, errors-warnings, errors-only
    devtool     : 'source-map',
    context     : PATHS.clientSrc, // The base directory, an absolute path, for resolving entry points
    watch       : true,
    
    performance : {
        hints: false // to ignore annoying bundel-size warnings
    },
    
    entry: { 
        monatFrontend: [ './bootstrap.ts' ] 
    },
                
    output : {
        path:  PATHS.clientDist,
        filename: "[name].[contenthash].bundle.js",
    },
    
    resolve : {
        extensions  : [ '.webpack.js',  '.web.js', '.ts', '.js', '.html' ],
        modules     : [ 
            PATHS.clientSrc, 
            PATHS.hibachiSrc, 
            PATHS.nodeModeles 
        ],
        alias       : { 
            '@Monat': PATHS.monatFrontend, 
            '@Hibachi': PATHS.hibachiSrc 
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
		}
    ]
};

devConfig.optimization = {
    splitChunks : {
        cacheGroups: {
            commons: {
                test: PATHS.nodeModeles,
                name: 'monatFrontendVendor',
                chunks: 'all'
            },
            hibachi: {
                test: PATHS.hibachiSrc,
                name: 'hibachiFrontend',
                chunks: 'all'
            }
        }
    }
};

devConfig.plugins =  [
    
    // TODO update component-definations for base-template-path
	// https://blog.johnnyreilly.com/2016/07/using-webpacks-defineplugin-with-typescript.html
    // new webpack.DefinePlugin({
    //     '__MONAT_FRONTEND_BASE_PATH__': JSON.stringify(PATHS.app),
    //     '__DEBUG_MODE__': JSON.stringify(true)
    // }),


    new webpack.ContextReplacementPlugin(/moment[\/\\]locale$/, /en/),
    new webpack.HashedModuleIdsPlugin(), // so that file hashes don't change unexpectedly
    
    new CleanWebpackPlugin(),
    new HtmlWebpackLinkTypePlugin(),

    new HtmlWebpackPlugin({
        template: PATHS.templateFile,
        filename: "MonatFrontendBundle.cfm",
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
    
    new ForkTsCheckerWebpackPlugin({
        async: false,
        useTypescriptIncrementalApi: true,
        checkSyntacticErrors: true,
        memoryLimit: 4096,
        tsconfig: path.resolve(PATHS.clientRoot, 'tsconfig.json')
    }),
    
    new WebpackBar({
        name: "Monat Frontend",
        reporters: [ 'basic', 'fancy', 'profile', 'stats' ],
        fancy: true,
        profile: false,
        stats: true,
    })

];   

module.exports = devConfig;
