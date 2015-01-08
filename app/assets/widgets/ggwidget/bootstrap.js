
document.write('<link rel="stylesheet" type="text/css" href="http://givegoods.org/assets/ggwidget/style.css">');
document.write('<script type="text/javascript" src="http://givegoods.org/assets/ggwidget/WidgetCreate.js"></script>');
var myElement = document.getElementById('ggWidget');
var JavaScriptCode = document.createElement("script");
JavaScriptCode.setAttribute('type', 'text/javascript');
JavaScriptCode.setAttribute("src", 'http://givegoods.org/assets/ggwidget/data.js');
document.getElementById('ggWidget').appendChild(JavaScriptCode);
 