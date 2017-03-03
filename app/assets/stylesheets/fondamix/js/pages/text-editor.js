(function ($) {
    "use strict";
    /** Default editor configuration **/
    $('#wiwiq-editor').trumbowyg();
    // Replace the <textarea id="editor1"> with a CKEditor
    // instance, using default configuration.
    CKEDITOR.replace('edumix-editor');
})(jQuery);