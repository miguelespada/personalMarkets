var Keen=Keen||{configure:function(e){this._cf=e},addEvent:function(e,t,n,i){this._eq=this._eq||[],this._eq.push([e,t,n,i])},setGlobalProperties:function(e){this._gp=e},onChartsReady:function(e){this._ocrq=this._ocrq||[],this._ocrq.push(e)}};(function(){var e=document.createElement("script");e.type="text/javascript",e.async=!0,e.src=("https:"==document.location.protocol?"https://":"http://")+"dc8na2hxrj29i.cloudfront.net/code/keen-2.1.0-min.js";var t=document.getElementsByTagName("script")[0];t.parentNode.insertBefore(e,t)})();

// Configure the Keen object with your Project ID and (optional) access keys.
Keen.configure({
    projectId: "536c9567d97b852a5700000b",
    writeKey: "322ddf830ccd5bd24db1f05ed627a05f492d507c10ec7c147d3ce7f6896c72058629340159171e23185660bde71836fd4abfeaf038c6137b732c7ac8053cd87750788c9cf12b41c653f325dbb7ee972cea075771617c2000f32e86749fe43528b5800e2740bda7a4ab5954c0e4b7558d", // required for sending events
    readKey: "40df8c885326566c85d46b76e649da10bf2bcad3bd240c467b5a614473627be1bc095e9e2351284ce5121a7b81f1b6d6c7af727c99863a1cfa9126dafa73ef86f7bf9256987eb06fe2aef581ee40a7830f137fd765d5c855b3a03aeda03385a8bf86f07f66b778f918ff07c8d2224b59"    // required for doing analysis
});