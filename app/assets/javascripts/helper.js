var H = {};

H.createTextarea = function(text){
    var textarea = $(TEMPLATES.textarea);
    textarea.attr("name", "edit_comment_body");
    textarea.val(text);
    return textarea;
};

H.makeDateString = function(range){
  fromDate = moment();
  if (range == 'Today') toDate = moment();
  if (range == 'This week') toDate = moment().weekday(7);
  if (range == 'This month') toDate = moment().endOf("month");
  if (range == 'Next week'){
    fromDate = moment().day(7).weekday(1);
    toDate = moment().day(7).weekday(8);
  }
  
  var from = moment(fromDate).format("DD/MM/YYYY");
  var to = moment(toDate).format("DD/MM/YYYY");
  
  if (range == 'all') to = "";
  return {from: from, to: to};
};
