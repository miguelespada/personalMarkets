var H = {};

H.createTextarea = function(text){
    var textarea = $(TEMPLATES.textarea);
    textarea.attr("name", "edit_comment_body");
    textarea.val(text);
    return textarea;
};

H.makeDateString = function(range){
  fromDate = moment();
  if (range == 'today') toDate = moment();
  if (range == 'thisWeek') toDate = moment().weekday(7);
  if (range == 'thisMonth') toDate = moment().endOf("month");
  if (range == 'nextWeek'){
    fromDate = moment().day(7).weekday(1);
    toDate = moment().day(7).weekday(8);
  }
  
  var from = moment(fromDate).format("DD/MM/YYYY");
  var to = moment(toDate).format("DD/MM/YYYY");
  
  if (range == 'all') to = "";
  return {from: from, to: to};
};
