var H = {};

H.createTextarea = function(text){
    var textarea = $(TEMPLATES.textarea);
    textarea.attr("name", "edit_comment_body");
    textarea.val(text);
    return textarea;
};