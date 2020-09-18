const path = require('path');
const webpack = require('webpack');
const WebpackBar = require('webpackbar');
const ThreadLoader = require('thread-loader');
const SVGToMiniDataURI = require('mini-svg-data-uri');
const CompressionPlugin = require("compression-webpack-plugin");
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const { CleanWebpackPlugin } = require('clean-webpack-plugin'); // to auto-clean dist-dir


const PATHS = {
	clientRoot      :	__dirname ,
    clientDist      :   path.join(__dirname, '/dist'),
    clientAssets    :   path.join(__dirname, '/assets'),
    nodeModeles     :   path.resolve(__dirname, '/node_modules'),

};


const DEVMODE = process.env.NODE_ENV !== 'production';
const calculateNumberOfWorkers = () => {
	const cpus = require('os').cpus() || { length: 1 };
	return Math.max(1, cpus.length - 1);
};
const workerPool = {
	workers: calculateNumberOfWorkers(),
	workerParallelJobs: 5,
	poolRespawn: !DEVMODE,
	poolTimeout: DEVMODE ? Infinity : 2000
};

if (calculateNumberOfWorkers() > 0) {
	ThreadLoader.warmup(workerPool, ['url-loader', 'responsive-loader', 'sass-loader', 'css-loader']);
}


let devConfig = { 
    
    mode        : 'development',
    stats       : 'errors-warnings', //detailed, errors-warnings, errors-only
    devtool     : 'source-map',
    context     : PATHS.clientAssets, // The base directory, an absolute path, for resolving entry points
    watch       : true,
    watchOptions: {
        ignored: [ 'node_modules/**']
    },
    
    performance : {
        hints: false // to ignore annoying bundle-size warnings
    },
    
    entry: { 
        app: [
            path.join(PATHS.clientAssets, '/index.js'),
            path.join(PATHS.clientAssets, '/scss/app.scss')
        ]
    },
                
    output : {
        path:  PATHS.clientDist,
        pathinfo: false,
        filename: "[name].bundle.js",
    },
    
    resolve : {
        extensions  : [ '.js', '.html', '.scss' ],
        modules     : [ 
            PATHS.clientAssets,
            PATHS.nodeModeles 
        ]
    },
    
    externals: {
        // require("jquery") is external and available
        //  on the global var jQuery
        "jquery": "jQuery"
    }

};


devConfig.module = {
    rules: [
        { 
            test: /\.(j|c)ss?$/i, 
            enforce: 'pre', 
            use: ['source-map-loader'] 
        },
        {
			test: /\.css$/i,
			exclude: /node_modules/,
			use: [
				MiniCssExtractPlugin.loader,
				{
					loader: 'css-loader',
					options: {
						sourceMap: true
					}
				}
			]
		},
        
		{
			test: /\.s[ac]ss$/i,
			exclude: /node_modules/,
			use: [
				MiniCssExtractPlugin.loader,
				{
					loader: 'css-loader',
					options: {
						sourceMap: true
					}
				},
				{
					loader: 'sass-loader',
					options: {
						sourceMap: true,
						implementation: require('sass'),
						sassOptions: {
							fiber: require('fibers'),
							outputStyle: 'compressed'
						}
					}
				}
			]
		},
		{
			test: /\.(woff|woff2|eot|ttf|svg)$/i,
			loader: 'url-loader',
        	options: {
        		limit: 8192,
        		name: 'webfonts/[name].[ext]'
        	}
		},
		{
			test: /\.(png|jpg|jpeg|gif)$/i,
			use: [
                {
    				loader: 'url-loader',
    				options: {
    					limit: 8192,
    					name: 'images/[name].[ext]',
    					fallback: require.resolve('responsive-loader')
    				}
                }
			]
		},
		{
			test: /\.svg$/i,
			use: [
				{
					loader: 'url-loader',
					options: {
						generator: (content) => SVGToMiniDataURI(content.toString())
					}
				}
			]
		}
    ]
};


devConfig.plugins =  [
    
   new MiniCssExtractPlugin({
		filename: "[name].bundle.css",
	}),
	
    new webpack.HashedModuleIdsPlugin(), // so that file hashes don't change unexpectedly
    new CleanWebpackPlugin(),
    
    new CompressionPlugin({
      test: /\.(woff|woff2|eot|ttf|svg|js|css|map)$/i,
      threshold: 10240,
      filename: '[path][base].gz',
      deleteOriginalAssets: false
    }),
    
    // HTTPS only
    // https://webpack.js.org/plugins/compression-webpack-plugin/#using-brotli
    // brotli is much smaller
    new CompressionPlugin({
      test: /\.(woff|woff2|eot|ttf|svg|js|css|map)$/i,
      filename: '[path][base].br',
      algorithm: 'brotliCompress',
      threshold: 10240,
      minRatio: 0.8,
      compressionOptions: {
        // zlib’s `level` option matches Brotli’s `BROTLI_PARAM_QUALITY` option.
        level: 11,
      },
      deleteOriginalAssets: false,
    }),

    new WebpackBar({
        name: "StoneAndBerg Assets",
        
        reporters: [ 'basic', 'fancy', 'profile', 'stats' ],
        fancy: true,
        profile: false,
        stats: true
    })
];   

module.exports = devConfig;

