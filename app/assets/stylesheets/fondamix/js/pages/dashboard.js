  $(function () {
      "use strict";
      $('#test').gmap3({
          center: [-7.39043726, 109.35286072]
          , zoom: 15
          , scrollwheel: false
          , styles: [] //styles
      }).marker([
          {
              position: [-7.39043726, 109.35286072]
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
      //weather icons
      var icons = new Skycons({
              "stroke": 0.06
              , "color": "Gray"
              , "cloudColor": "#666666"
              , "sunColor": "#92cd18"
              , "moonColor": "DodgerBlue"
              , "rainColor": "RoyalBlue"
              , "snowColor": "LightGray"
              , "windColor": "LightSteelBlue"
              , "fogColor": "#65C3DF"
          })
          , list = [
                "clear-day", "clear-night", "partly-cloudy-day"
                , "partly-cloudy-night", "cloudy", "rain", "sleet", "snow", "wind"
                , "fog"
            ]
          , i;
      for (i = list.length; i--;) icons.set(list[i], list[i]);
      icons.play()
          /*
           * LINE CHART
           * ----------
           */
          //LINE randomly generated data
      var line_data1 = [
            [1, 800]
            , [2, 1500]
            , [3, 900]
            , [4, 1900]
            , [5, 4000]
            , [6, 2800]
            , [7, 2500]
            , [8, 700]
            , [9, 1500]
            , [10, 1000]
            , [11, 2000]
            , [12, 4300]
            , [13, 1756]
            , [14, 2000]
            , [15, 1500]
            , [16, 1900]
            , [17, 1200]
            , [18, 2800]
            , [19, 3200]
            , [20, 2190]
        ];
      var line_data2 = [
            [1, 1800]
            , [2, 2900]
            , [3, 1950]
            , [4, 3450]
            , [5, 7000]
            , [6, 5300]
            , [7, 4890]
            , [8, 2300]
            , [9, 3900]
            , [10, 2900]
            , [11, 4500]
            , [12, 2200]
            , [13, 1120]
            , [14, 1459]
            , [15, 1100]
            , [16, 1189]
            , [17, 300]
            , [18, 1250]
            , [19, 1705]
            , [20, 959]

        ];
      $.plot("#line-chart", [line_data1, line_data2], {
          grid: {
              hoverable: true
              , borderColor: "#E2E6EE"
              , borderWidth: 0
              , labelMargin: 20
              , Margin: 1
              , aboveData: false
              , tickColor: "#E2E6EE"
          }
          , series: {
              shadowSize: 0
              , bars: {
                  show: true
                  , lineWidth: 0
                  , barWidth: 0.9
                  , fill: 0.7
                  , zero: true
              }
              , points: {
                  show: false
              }
          }
          , colors: ["#f20556", "#1565C0"]
          , yaxis: {
              show: false
          , }
          , xaxis: {
              show: true
              , position: "top"
          }
      });
      //Initialize tooltip on hover
      $("<div class='tooltip-inner' id='line-chart-tooltip'></div>").css({
          position: "absolute"
          , background: "#333333"
          , padding: "3px 10px"
          , color: "#ffffff"
          , display: "none"
          , opacity: 1
      }).appendTo("body");
      $("#line-chart").bind("plothover", function (event, pos, item) {
          if (item) {
              var x = item.datapoint[0].toFixed(2)
                  , y = item.datapoint[1].toFixed(2);
              $("#line-chart-tooltip").html(item.series.label + " of " + x + " = " + y).css({
                  top: item.pageY + 5
                  , left: item.pageX + 5
              }).fadeIn(200);
          }
          else {
              $("#line-chart-tooltip").hide();
          }
      });
  })(jQuery);