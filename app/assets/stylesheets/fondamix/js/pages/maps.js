$(function () {
    "use strict";
    $('#test').gmap3({
        center: [40.705400, -74.258188]
        , zoom: 14
        , styles: [{
            "featureType": "administrative"
            , "elementType": "all"
            , "stylers": [{
                "saturation": "-100"
            }]
        }, {
            "featureType": "administrative.province"
            , "elementType": "all"
            , "stylers": [{
                "visibility": "off"
            }]
        }, {
            "featureType": "landscape"
            , "elementType": "all"
            , "stylers": [{
                "saturation": -100
            }, {
                "lightness": 65
            }, {
                "visibility": "on"
            }]
        }, {
            "featureType": "poi"
            , "elementType": "all"
            , "stylers": [{
                "saturation": -100
            }, {
                "lightness": "50"
            }, {
                "visibility": "simplified"
            }]
        }, {
            "featureType": "road"
            , "elementType": "all"
            , "stylers": [{
                "saturation": "-100"
            }]
        }, {
            "featureType": "road.highway"
            , "elementType": "all"
            , "stylers": [{
                "visibility": "simplified"
            }]
        }, {
            "featureType": "road.arterial"
            , "elementType": "all"
            , "stylers": [{
                "lightness": "30"
            }]
        }, {
            "featureType": "road.local"
            , "elementType": "all"
            , "stylers": [{
                "lightness": "40"
            }]
        }, {
            "featureType": "transit"
            , "elementType": "all"
            , "stylers": [{
                "saturation": -100
            }, {
                "visibility": "simplified"
            }]
        }, {
            "featureType": "water"
            , "elementType": "geometry"
            , "stylers": [{
                "hue": "#ffff00"
            }, {
                "lightness": -25
            }, {
                "saturation": -97
            }]
        }, {
            "featureType": "water"
            , "elementType": "labels"
            , "stylers": [{
                "lightness": -25
            }, {
                "saturation": -100
            }]
        }] //styles
    }).marker([
        {
            position: [40.705311, -74.258188]
        }
        , {
            address: "Yogyakarta, Indonesia"
        }
        , {
            address: "Yogyakarta, Indonesia"
            , icon: "http://maps.google.com/mapfiles/marker_grey.png"
        }
    ]).on('click', function (marker) {
        marker.setIcon('http://maps.google.com/mapfiles/marker_green.png');
    });
});