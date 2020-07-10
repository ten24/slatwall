const path = require('path');
const webpack = require('webpack');
const WebpackBar = require('webpackbar');
const ThreadLoader = require('thread-loader');
const CompressionPlugin = require("compression-webpack-plugin");
const NgAnnotateWebPackPlugin = require('ng-annotate-webpack-plugin');
const ForkTsCheckerWebpackPlugin = require('fork-ts-checker-webpack-plugin');

const PATHS = {
	clientRoot      :	__dirname ,
    clientSrc       :   path.join(__dirname, '/src'),
    slatwallSrc     : 	path.resolve(__dirname, '../../../admin/client/src'),
    monatAdmin      :	path.join(__dirname, '/src/monatadmin'),
    hibachiSrc      : 	path.resolve(__dirname, '../../../org/Hibachi/client/src'),
    nodeModeles     :   path.resolve(__dirname, '../../../node_modules')
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
    context     : PATHS.clientSrc,
    watch       : true,
    performance : {
        hints: false // to ignore annoying warnings
    },
    
    entry: { 
        monatAdmin: [ path.join(PATHS.clientSrc, './bootstrap.ts') ] 
    },
                
    output : {
        path:  PATHS.clientSrc,
        filename : '[name].bundle.js'
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
            '@Monat': PATHS.monatAdmin, 
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
    
    new WebpackBar({
        name: "Monat Admin",
        reporters: [ 'basic', 'fancy', 'profile', 'stats' ],
        basic: true,
        fancy: true,
        profile: true,
        stats: true,
    })
];   

module.exports = devConfig;


