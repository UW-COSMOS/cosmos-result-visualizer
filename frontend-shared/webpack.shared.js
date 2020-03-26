let path = require('path');
const { EnvironmentPlugin } = require('webpack');
const HtmlWebpackPlugin = require('html-webpack-plugin');

console.log(process.env)
let assetsDir = path.resolve(__dirname, "dist");
let assetsRoute = path.join(process.env.PUBLIC_URL);

let jsLoader = {
  loader: 'babel-loader',
  options: {
    presets: ['@babel/preset-env', '@babel/preset-react', "@babel/preset-typescript"],
    plugins: [
      "emotion",
      "@babel/plugin-proposal-nullish-coalescing-operator",
      "@babel/plugin-proposal-optional-chaining",
      "@babel/plugin-proposal-class-properties"
    ]
  }
};

let fontLoader = {
  loader: 'file-loader',
  options: {name: "fonts/[name].[ext]"}
};

let stylusLoader = {
  loader: 'stylus-relative-loader'
};

module.exports = {
  module: {
    rules: [
      {test: /\.coffee$/, use: [ jsLoader, "coffee-loader" ]},
      {test: /\.(js|jsx|ts|tsx)$/, use: [ jsLoader ], exclude: /node_modules/ },
      {test: /\.styl$/, use: ["style-loader", "css-loader", stylusLoader]},
      {test: /\.css$/, use: ["style-loader", 'css-loader' ]},
      {test: /\.(eot|svg|ttf|woff|woff2)$/, use: [fontLoader]},
      {test: /\.md$/, use: ["html-loader","markdown-loader"]}
    ]
  },
  devtool: 'source-map',
  resolve: {
    extensions: [".coffee", ".js", ".ts", ".jsx", ".tsx", ".styl",".css",".html",".md"],
    alias: {
      "~": path.resolve(__dirname, "src/"),
      "app": path.resolve(__dirname, "src/"),
    }
  },
  // This will need to be replaced depending on the endpoint
  entry: './src/index.ts',
  output: {
    path: assetsDir,
    publicPath: assetsRoute,
    filename: "[name].js"
  },
  plugins: [
    new HtmlWebpackPlugin({title: "COSMOS"}),
    new EnvironmentPlugin([
      'ENVIRONMENT',
      'DEBUG',
      'PUBLIC_URL',
      'API_BASE_URL',
      'IMAGE_BASE_URL',
      'APPMODE'
    ])
  ]
}
