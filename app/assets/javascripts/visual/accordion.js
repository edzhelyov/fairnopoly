

$(function() {
	target = 0;
	if(window.location.hash){
		target = $(window.location.hash).index()-1
	}
	$(".Accordion").accordion({
		header: "a.Accordion-header",
		heightStyle: "content",
		collapsible: true,
		animate: 200,
		active: false
	});
	$(".Accordion--activated").accordion({
		header: "a.Accordion-header",
		heightStyle: "content",
		collapsible: true,
		animate: 200,
		active: target
	});
	$(".Accordion--activated").on("accordionactivate", function(event,ui) { $('.l-ArticleList').masonry() });
	$(".Accordion").removeClass("ui-accordion ui-widget ui-helper-reset");
	$(".Accordion-header").removeClass("ui-accordion-header ui-helper-reset ui-state-default ui-accordion-header-active ui-corner-top ui-accordion-icons ui-state-focus");
	$(".Accordion-header span").removeClass("ui-accordion-header-icon ui-icon ui-icon-triangle-1-s")
});
