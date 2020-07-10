const webpack = require('webpack');
const path = require('path');

const CompressionPlugin = require("compression-webpack-plugin");
const ForkTsCheckerWebpackPlugin = require('fork-ts-checker-webpack-plugin');
const ProgressBarPlugin = require('progress-bar-webpack-plugin');
const ThreadLoader = require('thread-loader');
const NgAnnotateWebPackPlugin = require('ng-annotate-webpack-plugin');

const PATHS = {
	clientRoot      :	__dirname ,
    clientSrc       :   path.join(__dirname, '/src'),
    monatFrontend   :	path.join(__dirname, '/src/monatfrontend'),
    hibachiSrc      : 	path.resolve(__dirname, '../../org/Hibachi/client/src'),
    nodeModeles     :   path.resolve(__dirname, '../../node_modules')
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
    devtool     : 'source-map',
    context     : PATHS.clientSrc,
    
    entry: { 
        monat: [ path.join(PATHS.clientSrc, './bootstrap.ts') ] 
    },
                
    output : {
        path:  PATHS.clientSrc,
        filename : '[name].bundle.js'
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
    }
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
                name: 'monatCommon',
                chunks: 'all'
            },
            hibachi: {
                test: PATHS.hibachiSrc,
                name: 'hibachi',
                chunks: 'all'
            }
        }
    }
};

//don't need the vendor bundle generated here because we include the vendor bundle already.
devConfig.plugins =  [
    
	// https://blog.johnnyreilly.com/2016/07/using-webpacks-defineplugin-with-typescript.html
    new webpack.DefinePlugin({
        '__MONAT_FRONTEND_BASE_PATH__': JSON.stringify(PATHS.app),
        '__DEBUG_MODE__': JSON.stringify(true)
    }),

    new webpack.ContextReplacementPlugin(/moment[\/\\]locale$/, /en/),
    
    new NgAnnotateWebPackPlugin({
        add: true,
        // other ng-annotate options here
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
    
    new ProgressBarPlugin()
];   

module.exports = devConfig;

