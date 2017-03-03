(function ($) {
    "use strict";
    //dropdown date picker
    $("#date-dropdown").dateDropdowns();
    //default date & time picker
    $('#datetimepicker').datetimepicker({
        dayOfWeekStart: 1
        , lang: 'en'
        , disabledDates: ['1986/01/08', '1986/01/09', '1986/01/10']
        , startDate: '1986/01/05'
    });
    //only tie picker
    $('#datetimepicker1').datetimepicker({
        datepicker: false
        , format: 'H:i'
        , step: 5
    });
    //disable all weekend
    $('#datetimepicker9').datetimepicker({
        onGenerate: function (ct) {
            $(this).find('.xdsoft_date.xdsoft_weekend').addClass('xdsoft_disabled');
        }
        , weekends: ['01.01.2014', '02.01.2014', '03.01.2014', '04.01.2014', '05.01.2014', '06.01.2014']
        , timepicker: false
    });
    //disable spesific date
    var dateToDisable = new Date();
    dateToDisable.setDate(dateToDisable.getDate() + 2);
    $('#datetimepicker11').datetimepicker({
        beforeShowDay: function (date) {
            if (date.getMonth() == dateToDisable.getMonth() && date.getDate() == dateToDisable.getDate()) {
                return [false, ""]
            }
            return [true, ""];
        }
    });
})(jQuery);
// MASKED INPUT
(function ($) {
    "use strict";
    $("#date").mask("99/99/9999", {
        completed: function () {
            alert("Your birthday was: " + this.val());
        }
    });
    $("#phone").mask("(999) 999-9999");
    $("#money").mask("99.999.9999", {
        placeholder: "*"
    });
    $("#ssn").mask("99--AAA--9999", {
        placeholder: "*"
    });
})(jQuery);