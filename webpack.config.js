const resolve = require('path').resolve;
const path = require('path');
const webpack = require('webpack');
const merge = require('webpack-merge');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const autoprefixer = require('autoprefixer');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const StyleLintPlugin = require('stylelint-webpack-plugin');

const TARGET_ENV = process.env.npm_lifecycle_event === 'build' ? 'production' : 'development';
const outputFilename = TARGET_ENV === 'production' ? '[name]-[hash].js' : '[name].js';

const extractVendors = new ExtractTextPlugin('[name]-vendors.css');
const extractLess = new ExtractTextPlugin('styles-[contenthash].css');

const commonConfig = {

  entry: resolve(__dirname, 'src/static/index.js'),

  output: {
    path: resolve(__dirname, 'dist'),
    filename: `static/${outputFilename}`,
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
      },
      {
        test: /\.css$/,
        include: /node_modules/,
        use: extractVendors.extract({
          fallback: 'style-loader',
          use: [
            'css-loader'
          ]
        })

      },
      {
        test: /\.(css|less)$/,
        exclude: /node_modules/,
        use: extractLess.extract({
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
    ]
  },

  plugins: [
    new HtmlWebpackPlugin({
      template: 'src/static/index.html',
      inject: 'body',
      filename: 'index.html'
    }),
    new StyleLintPlugin({
      context: 'src',
      files: '**/*.less'
    }),
    extractVendors,
    extractLess,
    new CopyWebpackPlugin([
      {
        from: 'src/static/images/',
        to: 'images/'
      },
      {
        from: 'src/static/favicon.ico'
      }
    ]),

  ]
};

if (TARGET_ENV === 'development') {
  console.log('Serving locally...');

  module.exports = merge(commonConfig, {

    devServer: {
      historyApiFallback: true,
      contentBase: path.join(__dirname, 'dist'),
      port: 3000,
      host: '0.0.0.0'
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
        }
      ],
    }

  });
}

if (TARGET_ENV === 'production') {
  console.log('Building for prod...');

  module.exports = merge(commonConfig, {
    // devtool: 'source-map',
    module: {
      rules: [
        {
          test: /\.elm$/,
          exclude: [/elm-stuff/, /node_modules/],
          use: [
            'elm-webpack-loader'
          ]
        }
      ]
    },

    plugins: [
      new webpack.optimize.UglifyJsPlugin({
        // sourceMap: true,
        minimize: true,
        compressor: { warnings: false }
        // mangle:  true
      })
    ]

  });
}