$(document).ready(function(){

var headerHeight = $("header").height();

//~ $(function() {
    //~ if (location.hash) {
        //~ var target_position = $(location.hash).offset().top;
        //~ $('body').scrollTop(target_position - headerHeight);
    //~ }
//~ });

$('a').on('click',function (e) {
        e.preventDefault();

		var link = $(this).attr('href');
        $link = $(link);
       
        $('html, body').stop().animate({
           'scrollTop': $link.offset().top - headerHeight
        }, 900, 'swing', function () {
            window.location.hash = link;
        });
	});


});

