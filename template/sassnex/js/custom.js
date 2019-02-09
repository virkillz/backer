$(document).ready(function () {
    "use strict";
    //Preloader js
    $(document).ready(function() {
        setTimeout(function(){
            $('body').addClass('loaded');
        }, 3000);
    });  
//=========== Scroll to top 
    jQuery('.to-top').on('click', function(event) {
        jQuery('html,body').animate({
            scrollTop: 0
        }, 1000);
    });
    jQuery(window).scroll(function() {
        if (jQuery(window).scrollTop() > 100) {
            jQuery('.to-top').fadeIn(1000);
        } else {
            jQuery('.to-top').fadeOut(1000);
        };
    });
  
//=============== Mean Menu
    jQuery('.mean_menu').meanmenu({
        meanScreenWidth: "767"
    });

//============== Header Search
    $('a[href="#header-search"]').on("click", function (event) {
        event.preventDefault();
        $("#header-search").addClass("open");
        $('#header-search > form > input[type="search"]').focus();
    });
    $("#header-search, #header-search button.close").on("click keyup", function (
        event
    ) {
        if (
            event.target === this ||
            event.target.className === "close" ||
            event.keyCode === 27
        ) {
            $(this).removeClass("open");
        }
    });
    $("form").on('submit', function (event) {
        event.preventDefault();
        return false;
    });



    // Special Package
    $("#screenshot").owlCarousel({
         navigationText :['<img src="images/icons/down_left.png">', '<img src="images/icons/down_right.png">'],
        items : 4,
        itemsDesktop : [1199, 3],
        itemsDesktopSmall : [980, 2],
        itemsTablet: [768, 1],
        itemsMobile : [479, 1],
        slideSpeed: 1000,
        paginationSpeed: 1500,
        navigation : true,
        pagination : false,
    });


    // team Agency
    $("#testimonial_agency").owlCarousel({
        navigationText :["<i class='flaticon-left-arrow'></i>", "<i class='flaticon-right-arrow'></i>"],
        items : 2,
        itemsDesktop : [1199, 2],
        itemsDesktopSmall : [980, 2],
        itemsTablet: [768, 1],
        itemsMobile : [479, 1],
        slideSpeed: 1000,
        paginationSpeed: 1500,
        navigation : true,
        pagination : false
    });    


     // Testimonial Sass
    $("#testimonial_sass").owlCarousel({
        navigationText :["<i class='flaticon-angle-pointing-to-left'></i>", "<i class='flaticon-angle-arrow-pointing-to-right'></i>"],
        items : 3,
        itemsDesktop : [1199, 3],
        itemsDesktopSmall : [980, 2],
        itemsTablet: [768, 1],
        itemsMobile : [479, 1],
        slideSpeed: 1000,
        paginationSpeed: 1500,
        navigation : true,
        pagination : false
    }); 

 
	//Team Carousel   
    $("#team_01").owlCarousel({
        navigationText :["<i class='flaticon-left-arrow'></i>", "<i class='flaticon-right-arrow'></i>"],
        items :4,
        itemsDesktop : [1199, 3],
        itemsDesktopSmall : [980, 3],
        itemsTablet: [768, 2],
        itemsMobile : [479, 1],
        slideSpeed: 1000,
        paginationSpeed: 1500,
        navigation : true,
        pagination : false
    });

    // Releted Product (Product details page)               
    $(".related_product").owlCarousel({
        navigationText :["<i class='flaticon-right-arrow'></i>", "<i class='flaticon-right-arrow'></i>"],
        items :3,
        itemsDesktop : [1199, 3],
        itemsDesktopSmall : [980, 3],
        itemsTablet: [768, 1],
        itemsMobile : [479, 1],
        slideSpeed: 1000,
        paginationSpeed: 1500,
        navigation : true,
        pagination : false
    });

    // Slick Slider Testimonial
    $('#testimonial').slick({
      dots: true,
      arrows: false,
      infinite: false,
      speed: 500,
      fade: true,
      cssEase: 'linear',
      customPaging: function(slider, i) {
          return '<div class="pager_item" id=' + i + "></div>";
        }
    });
        
    // Marketing Testimonial    
    $('#marketing_testimonial').slick({
        prevArrow: "<a href='#'><i class='flaticon-left-arrow icon_left'></i></a>",
        nextArrow: '<img src="images/icons/angle_right.png">',
        dots: true,
        arrows: true,
        infinite: true,
        speed: 500,
        fade: true,
        cssEase: 'linear',
        customPaging: function(slider, i) {
            return '<div class="pager_item" id=' + i + "></div>";
        }
    });
        

    //Testimonial App Landing
    $('.slider-for').slick({
        slidesToShow: 1,
        slidesToScroll: 1,
        arrows: true,
        prevArrow: "<a href='#'><i class='flaticon-left-arrow icon_left'></i></a>",
        nextArrow: "<a href='#'><i class='flaticon-right-arrow icon_right'></i></a>",
        fade: false,
        asNavFor: '.slider-nav'
    });
    $('.slider-nav').slick({
        fade: true,
        slidesToShow: 1,
        slidesToScroll: 1,
        asNavFor: '.slider-for',
        dots: false,
        centerMode: true,
        focusOnSelect: true,
        variableWidth: false,
        arrows: false
        
    }); 


    //Testimonial Payment
    $('.slider_content').slick({
        slidesToShow: 1,
        slidesToScroll: 1,
        arrows: false,
        fade: true,
        asNavFor: '.slider_img'
    });
    $('.slider_img').slick({
        slidesToShow: 3,
        slidesToScroll: 1,
        asNavFor: '.slider_content',
        dots: false,
        prevArrow: "<a href='#'><i class='flaticon-left-arrow icon_left'></i></a>",
        nextArrow: "<a href='#'><i class='flaticon-right-arrow icon_right'></i></a>",
        centerMode: true,
        focusOnSelect: true,
        variableWidth: false,
        arrows: true,
    });


    //Testimonial Product
    $('.product_pro_content').slick({
        slidesToShow: 1,
        slidesToScroll: 1,
        arrows: false,
        dots: true,
        fade: false,
        asNavFor: '.product_pro_img'
    });
    $('.product_pro_img').slick({
        slidesToShow: 1,
        slidesToScroll: 1,
        asNavFor: '.product_pro_content',
        dots: false,
        arrows: false,
        infinite: false,
        speed: 500,
        fade: true
    });

    // Product Details page ( Product view )
    $('.product_signgle_view').slick({
        slidesToShow: 1,
        slidesToScroll: 1,
        arrows: false,
        fade: true,
        asNavFor: '.product_view_all_items'
    });
    $('.product_view_all_items').slick({
        slidesToShow: 3,
        slidesToScroll: 1,
        asNavFor: '.product_signgle_view',
        dots: false,
        centerMode: true,
        focusOnSelect: true,
        variableWidth: false,
        arrows: false,
        responsive: [
            {
              breakpoint: 991,
              settings: {
                slidesToShow: 5
              }
            },
            {
              breakpoint: 480,
              settings: {
                slidesToShow: 3
              }
            }
        ]
    });


	//WOW Animate
    new WOW().init();
    
    //Video Popup   
    $('.video-iframe').magnificPopup({
        type: 'iframe',
        iframe: {
            markup: '<div class="mfp-iframe-scaler">' +
                '<div class="mfp-close"></div>' +
                '<iframe class="mfp-iframe" frameborder="0" allowfullscreen></iframe>' +
                '</div>',
            patterns: {
                youtube: {
                    index: 'youtube.com/',
                    id: 'v=',
                    src: 'http://www.youtube.com/embed/%id%?autoplay=1'
                }
            },
            srcAction: 'iframe_src'
        }
    }); 


});

