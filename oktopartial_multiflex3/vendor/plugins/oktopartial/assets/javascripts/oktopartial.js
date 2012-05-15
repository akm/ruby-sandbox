Oktopartial = {
    // URLに対して別名を設定します。
    // サーバー接続時／ローカル実行時のどちらも有効です。
    urlAliases: {},

    // URLに対して別名を設定します。
    // ローカル実行時のみ有効です。
    localAliases: {},

    init: function(){
        //サーバーなしで動かしている場合にはtrueに設定されます。
        Oktopartial.localDevelopmentMode = !!window.location.href.match(/file:\/\//);

        if (Oktopartial.localDevelopmentMode){
            Oktopartial.basePath = window.location.href.match(/^.*?\/public/)[0].replace(/\/$/, '');
            // サーバーなしで動かす時のpublicから開いているページまでのパス
            Oktopartial.localPath = window.location.href.replace(Oktopartial.basePath, '').replace(/[^\/]+?$/, '');
            // Oktopartial.localPathの深さ。 '/' なら 0
            Oktopartial.localPathDepth = Oktopartial.localPath.replace(/[^\/]/g, '').length - 1;
        }
    },

    setup: function(){
        jQuery('.oktopartial_layout').each(function(){
            var element = jQuery(this).get(0);
            var url_param = jQuery('.oktopartial_url:first', element);
            url_param.remove();
            Oktopartial.layoutUpdate(element, jQuery.trim(url_param.text()));
        });
        Oktopartial.update();
    },

    update: function(context){
        if (!!context){
            Oktopartial.updateReplaceEach(context.filter('.oktopartial_replace'));
        }
        Oktopartial.updateReplaceEach(jQuery('.oktopartial_replace', context));
    },

    updateReplaceEach: function(elements){
        elements.each(function(){
            var element = jQuery(this).get(0);
            var url_param = jQuery('.oktopartial_url:first', element);
            var url = jQuery.trim(url_param.text());
            if (url == '')
                url = jQuery.trim(jQuery(element).text());
            Oktopartial.updateReplace(element, url);
        });
    },

    updateReplace: function (element, url){
        Oktopartial.get(url, function(data){
            data = jQuery(data)
            jQuery(element).replaceWith(data);
            Oktopartial.update(data);
        });
    },

    layoutUpdate: function (element, url){
        Oktopartial.get(url, function(data){
            element = jQuery(element);
            data = jQuery(data);
            element.before(data);
            element.remove();
            Oktopartial.update(data);
            var placeholder = jQuery('.oktopartial_content', data);
            placeholder.replaceWith(element.contents());
        })
    },
    
    get: function(url, func){
        if (Oktopartial.localDevelopmentMode){
            url = Oktopartial.localAliases[url] || url;
            url = Oktopartial.urlAliases[url] || url;
            var adjuster = '';
            for(var i=0; i < Oktopartial.localPathDepth; i++){ adjuster = adjuster + '../';}
            url = url.replace(/^\//, adjuster);
            //url = Oktopartial.basePath.replace(/file:\/\//, '') + url;
        } else {
            url = Oktopartial.urlAliases[url] || url;
        }
        jQuery.get(url, func);
    }
}
Oktopartial.init();
jQuery(Oktopartial.setup);
