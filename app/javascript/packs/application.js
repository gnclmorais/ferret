/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application
// logic in a relevant structure within app/javascript and only use these pack
// files to reference that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the
// appropriate layout file, like app/views/layouts/application.html.erb


// // // // // // // // // // // // // // // // // // // // // // // // // // //
// 3rd parties

import { library, dom } from "@fortawesome/fontawesome-svg-core";
import {
  faAngleRight,
  faBars,
  faCompressArrowsAlt,
  faEnvelopeSquare,
  faEye,
  faEyeSlash,
  faHome,
  faMapMarkedAlt,
  faMinusSquare,
  faPenSquare,
  faTimesCircle,
} from "@fortawesome/free-solid-svg-icons";
import {
  faFacebookSquare,
  faInstagram,
  faTwitterSquare,
} from "@fortawesome/free-brands-svg-icons";

library.add(faAngleRight);
library.add(faBars);
library.add(faCompressArrowsAlt);
library.add(faEnvelopeSquare);
library.add(faEye);
library.add(faEyeSlash);
library.add(faHome);
library.add(faMapMarkedAlt);
library.add(faMinusSquare);
library.add(faPenSquare);
library.add(faTimesCircle);

library.add(faFacebookSquare);
library.add(faInstagram);
library.add(faTwitterSquare);

dom.watch();


// // // // // // // // // // // // // // // // // // // // // // // // // // //
// Stylesheets

// Bulma customisation
import '../../stylesheets/overrides/bulma.scss';
// Project-specific overrides to Bulma
import '../../stylesheets/overrides/card.scss';
// General project stylesheets
import '../../stylesheets/general.scss';
import '../../stylesheets/structure.scss';
import '../../stylesheets/utils.scss';
import '../../stylesheets/icons.scss';
import '../../stylesheets/pages/maps.scss';
// Project specific components
import '../../stylesheets/components/column_panels.scss';


// // // // // // // // // // // // // // // // // // // // // // // // // // //
// JavaScript

import '../store/index.js';
