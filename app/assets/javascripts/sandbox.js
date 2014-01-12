$(function(){
    var code = null;
    // switch for plugin type
    function show(type) {
        $('.plugin').hide();
        $('.' + type).show();

        code = code || CodeMirror.fromTextArea(document.getElementById("code"), {
            mode: "text/x-ruby",
            tabMode: "indent",
            matchBrackets: true,
            indentUnit: 2,
            lineNumbers: true
        });
    }
    $('select.plugin-type').bind('change',function(e){
      show(e.target.value);
    });
    show($('select.plugin-type').val());

    // thumbnail plugin test
    var pluginRunner = {
        'thumbnail' : {
            params : function() {
                return  {
                    regexp    : $('.thumbnail input.regexp').val(),
                    thumbnail : $('.thumbnail input.thumbnail').val(),
                };
            },
            url : QuoteIt.thumbnail_sandbox
        },
        'web-clip' : {
            params : function() {
                return {
                    regexp    : $('.web-clip input.regexp').val(),
                    clip      : $('.web-clip input.clip').val(),
                    transform : code.getValue()
                };
            },
            url : QuoteIt.webClip_sandbox
        },
    }

    // test
    $('form').bind('submit', function(e){
        e.stopPropagation();
        e.preventDefault();

        var runner = pluginRunner[$('.plugin-type').val()];
        var params = runner.params();
        params['url'] = $('.url').val();
        $.get(runner.url, params, function(html){
            $('.result').html(html);
        }).error(function(){
            $('.result').html('server error');
        });
    });
});
