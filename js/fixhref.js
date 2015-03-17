$(document).ready(function(){

var headerHeight = $("header").height();
//var headerHeight = 90;

    $('a[href^="#"]').on('click',function (e) {
        e.preventDefault();

        var target = this.hash,
        $target = $(target);
		//alert(target);
        $('html, body').stop().animate({
            'scrollTop': $target.offset().top - headerHeight
        }, 1200, 'swing', function () {
            window.location.hash = target ;
        });
	});


});
