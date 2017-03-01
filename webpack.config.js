const resolve = require('path').resolve;
const path = require('path');
const webpack = require('webpack');
const merge = require('webpack-merge');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const autoprefixer = require('autoprefixer');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');

console.log('WEBPACK GO!');

// determine build env
const TARGET_ENV = process.env.npm_lifecycle_event === 'build' ? 'production' : 'development';
const outputFilename = TARGET_ENV === 'production' ? '[name]-[hash].js' : '[name].js';

console.log(outputFilename);
// common webpack config
const commonConfig = {

  output: {
    path: resolve(__dirname, 'dist'),
    filename: `/static/${outputFilename}`,
    publicPath: '/'
  },

  resolve: {
    extensions: ['.js', '.elm']
  },

  module: {
    noParse: /\.elm$/,
    rules: [
      {
        test: /\.(eot|ttf|woff|woff2|svg)$/,
        use: [
          {
            loader: 'file-loader'
          }
        ]
      }
    ]
  },

  plugins: [
    new HtmlWebpackPlugin({
      template: 'src/static/index.html',
      inject: 'body',
      filename: 'index.html'
    })
  ],


};

// additional webpack settings for local env (when invoked by 'npm start')
if (TARGET_ENV === 'development') {
  console.log('Serving locally...');

  module.exports = merge(commonConfig, {

    output: {
      path: resolve(__dirname, 'dist'),
      filename: `static/${outputFilename}`,
      // publicPath: '/'
    },

    entry: [
      resolve(__dirname, 'src/static/index.js')
    ],

    devServer: {
      // serve index.html in place of 404 responses
      historyApiFallback: true,
      contentBase: path.join(__dirname, 'dist'),
      port: 8080
    },

    module: {
      rules: [
        {
          test: /\.elm$/,
          exclude: [/elm-stuff/, /node_modules/],
          use: [
            'elm-hot-loader',
            'elm-webpack-loader?verbose=true&warn=true&debug=true'
          ]
        },
        {
          test: /\.(css|less)$/,
          use: ExtractTextPlugin.extract({
            fallback: 'style-loader',
            use: [
              {
                loader: 'css-loader',
                options: {
                  importLoaders: 1
                }
              },
              {
                loader: 'postcss-loader',
                options: {
                  plugins: () => [require('autoprefixer')]
                }
              },
              'less-loader']
          })
        }
      ],
    },
    plugins: [
      new ExtractTextPlugin('style.css'),
      new CopyWebpackPlugin([
        {
          from: 'src/static/images/',
          to: 'images/'
        }
      ])
    ]

  });
}

// additional webpack settings for prod env (when invoked via 'npm run build')
if (TARGET_ENV === 'production') {
  console.log('Building for prod...');

  module.exports = merge(commonConfig, {

    entry: resolve(__dirname, 'src/static/index.js'),

    module: {
      rules: [
        {
          test: /\.elm$/,
          exclude: [/elm-stuff/, /node_modules/],
          use: [
            'elm-webpack-loader'
          ]
        },
        /*{
         test: /\.(css|scss)$/,
         use: ExtractTextPlugin.extract({
         fallback: 'style-loader',
         use: [
         'css-loader',
         'postcss-loader',
         'sass-loader'
         ]
         })
         }*/
      ]
    },

    plugins: [
      new CopyWebpackPlugin([
        {
          from: 'assets/images/',
          to: 'static/img/'
        },
        /*{
         from: 'src/favicon.ico'
         },*/
      ]),

      //new webpack.optimize.OccurenceOrderPlugin(),

      // extract CSS into a separate file
      new ExtractTextPlugin({ filename: 'static/css/[name]-[hash].css', allChunks: true }),

      // minify & mangle JS/CSS
      /*new webpack.optimize.UglifyJsPlugin({
       minimize: true,
       compressor: { warnings: false }
       // mangle:  true
       })*/
    ]

  });
}