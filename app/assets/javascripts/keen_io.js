var Keen=Keen||{configure:function(e){this._cf=e},addEvent:function(e,t,n,i){this._eq=this._eq||[],this._eq.push([e,t,n,i])},setGlobalProperties:function(e){this._gp=e},onChartsReady:function(e){this._ocrq=this._ocrq||[],this._ocrq.push(e)}};(function(){var e=document.createElement("script");e.type="text/javascript",e.async=!0,e.src=("https:"==document.location.protocol?"https://":"http://")+"dc8na2hxrj29i.cloudfront.net/code/keen-2.1.0-min.js";var t=document.getElementsByTagName("script")[0];t.parentNode.insertBefore(e,t)})();

// Configure the Keen object with your Project ID and (optional) access keys.
Keen.configure({
    projectId: "53ac26c433e40627c8000002",
    readKey: "6cde6de4fcdc23cea2fa96d404107ef785dfebeeb3e82108b92646c1ba23fed11afcccc7ea0abdf73b77ef06fe7e6bca63ac39eddf788d64341141359e7e77cdcc201bba65694e6b9dfba9edef6958f04bfcb501dc50aa69b65c8a99862a804af448134caa247b98c59d0bb227deaba0"    // required for doing analysis
});
