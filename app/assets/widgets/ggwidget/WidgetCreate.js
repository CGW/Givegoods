function WidgetCallback(JSONobject) {
    var wHelloWorld = JSONobject[0];
    var wHTML = "";

    wHTML += ('<a href="' + wURL + '" style="text-decoration:none; color:' + fontColor + '">');
    wHTML += ('<div align="center" class="rounded" id="MyWidget" style="width:' + wWidth + ';Height:' + wHeight + ';min-width:' + minWidth + '; max-width:' + maxWidth + ';background-color:' + backColor + '" >');
    wHTML += ('<img border="0" width="100%" height="" src="' + wPoster_url + '"><br><br>');
    wHTML += ('<div style="margin-bottom: 5px">' + wHelloWorld.text + wMessage +'</div>');
    wHTML += ('<span class="merchant_name">' + wMerchant + '</span>');
    wHTML += ('<div style="clear:both"></div>');
    wHTML += ('<div class="button">' + buttonText + '</div>');
    wHTML += ('<!--<img border="0" width="100%" height="" src="' + wHelloWorld.image_url + '">-->');
    wHTML += ('</div></a>');

    document.getElementById('ggWidget').innerHTML = wHTML;
}
