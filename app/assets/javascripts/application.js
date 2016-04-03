// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
// = require jquery
// = require jquery_ujs
// = require turbolinks
// = require_tree .

/*global*/
(function() {
	var container	= ('#ib-container'),
	articles	= container.children('article'),
	timeout;
	articles.on( 'mouseenter', function( event ) {
		var article	= (this);
		clearTimeout( timeout );
		timeout = setTimeout( function() {			
			if( article.hasClass('active') ) return false;			
			articles.not( article.removeClass('blur').addClass('active') )
			.removeClass('active')
			.addClass('blur');			
		}, 65 );		
	});	
	container.on( 'mouseleave', function( event ) {		
		clearTimeout( timeout );
		articles.removeClass('active blur');		
	});
});

(function() {
	('a.nice-link').each(function () {
	  (this).attr('data-text', (this).text());
	});
});

