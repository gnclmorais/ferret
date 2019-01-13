/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb


// // // // // // // // // // // // // // // // // // // // // // // // // // //
// 3rd parties

import fontawesome from '@fortawesome/fontawesome';
import freeSolid from '@fortawesome/fontawesome-free-solid';
import freeRegular from '@fortawesome/fontawesome-free-regular';
import freeBrands from '@fortawesome/fontawesome-free-brands';
fontawesome.library.add(freeSolid);
fontawesome.library.add(freeRegular);
fontawesome.library.add(freeBrands);


// // // // // // // // // // // // // // // // // // // // // // // // // // //
// Stylesheets

// Bulma customisation
import '../../stylesheets/overrides/bulma.scss';
// Project-specific overrides to Bulma
import '../../stylesheets/overrides/card.scss';
import '../../stylesheets/overrides/column.scss';
import '../../stylesheets/overrides/section.scss';
// General project stylesheets
import '../../stylesheets/general.scss';
import '../../stylesheets/utils.scss';
import '../../stylesheets/pages/maps.scss';
// Project specific components
import '../../stylesheets/components/column_panels.scss';


// // // // // // // // // // // // // // // // // // // // // // // // // // //
// JavaScript

import '../store/index.js';
