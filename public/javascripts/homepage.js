jQuery(function($) {
  $("#sticky_header").css("position", "fixed");
  
  // Scroll initially if there's a hash (#something) in the url
  // $('#navigation a').click(function() {
  //   $.scrollTo($(this).attr("href"), {duration: 1000, offset: {top: -164, left: 0}});
  // })
  
  $("#navigation").localScroll({offset: {top: -164}, duration: 2000});
   
  // $.localScroll.hash({
  //   target: '#navigation', // Could be a selector or a jQuery object too.
  //   queue:true,
  //   duration:1500
  // });
  // 
  // /**
  // * NOTE: I use $.localScroll instead of $('#navigation').localScroll() so I
  // * also affect the >> and << links. I want every link in the page to scroll.
  // */
  // $.localScroll({
  //   target: '#navigation', // could be a selector or a jQuery object too.
  //   queue:true,
  //   duration:1000,
  //   hash:true,
  //   onBefore:function( e, anchor, $target ){
  //     // The 'this' is the settings object, can be modified
  //   },
  //   onAfter:function( anchor, settings ){
  //     // The 'this' contains the scrolled element (#content)
  //   }
  // }); 
});