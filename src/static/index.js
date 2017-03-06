// pull in desired CSS/SASS files
require('purecss/build/pure.css');
require('purecss/build/grids-responsive.css');
require('./less/main.less' );

// inject bundled Elm app into div#main
const Elm = require( '../Main' );
Elm.Main.embed( document.getElementById( 'main' ) );