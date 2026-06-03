var webpack = require('webpack');
var path = require('path');

var BUILD_DIR = path.resolve(__dirname, 'public');
var SRC_DIR = path.resolve(__dirname);
var APP_DIR = path.resolve(__dirname, 'src/app');

module.exports = (env) => {
    const isDev = env == 'development' || env == 'isolated';

    return {
        mode: env,
        entry: {
            'index': __dirname + '/index.js'
        },
        output: {
            path: BUILD_DIR,
            filename: isDev ? 'component.[name].bundle.js' : '[name].[hash].bundle.js',
            sourceMapFilename: '[name].[hash].bundle.map',
            publicPath: "",
            library: 'udcomponent',
            libraryTarget: 'var'
        },
        module: {
            rules: [{
                test: /\.(js|jsx)$/,
                exclude: [/node_modules/, /output/],
                use: ['babel-loader']
            },
            {
                test: /\.css$/,
                use: ['style-loader', 'css-loader']
            },
            {
                test: /\.(eot|ttf|woff2?|otf|svg|png)$/,
                type: 'asset/resource'
            }
            ]
        },
        externals: {
            UniversalDashboard: 'UniversalDashboard',
            $: "$",
            'react': 'react',
            'react-dom': 'reactdom'
        },
        resolve: {
            extensions: ['.json', '.js', '.jsx']
        },
        devtool: 'source-map',
        devServer: {
            disableHostCheck: true,
            historyApiFallback: true,
            port: 10000,
            // hot: true,
            compress: true,
            publicPath: '/',
            stats: "minimal"
        },
        plugins: [
        ]
    };
}