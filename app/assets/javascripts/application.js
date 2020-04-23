// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery
//= require activestorage
//= require turbolinks
//= require bootstrap
//= require_tree .

$(document).on('turbolinks:load', function() {

	//header tagをクリックで発火 タグ一覧表示する
	$(function() {
	    $('.tag-toggle').click(function() {
	        $(this).toggleClass('active');

	        if ($(this).hasClass('active')) {
	            $('.tag-menu').addClass('active');
	            $('.search-menu').removeClass('active');
	            $('.search-toggle').removeClass('active');
	        } else {
	            $('.tag-menu').removeClass('active');
	        }
	    });
	});

	//header searchをクリックで発火 検索欄表示
	$(function() {
	    $('.search-toggle').click(function() {
	        $(this).toggleClass('active');

	        if ($(this).hasClass('active')) {
	            $('.search-menu').addClass('active');
	            $('.tag-menu').removeClass('active');
	            $('.tag-toggle').removeClass('active');
	        } else {
	            $('.search-menu').removeClass('active');
	        }
	    });
	});

});