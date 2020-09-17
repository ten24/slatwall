/**
 * Cartzilla | Bootstrap E-Commerce Template
 * Theme core scripts
 * 
 * @author Createx Studio
 * @version 1.1
 */

;(function ($) {
  'use strict';

  const theme = {

    /**
     * Theme's components/functions list
     * Comment out or delete the unnecessary component.
     * Some component have dependencies (plugins).
     * Do not forget to remove component plugin script from src/vendor/js
    */

    init: () => {
      theme.masonryGrid();
      theme.stickyNavbar();
      theme.stuckNavbarMenuToggle();
      theme.passwordVisibilityToggle();
      theme.customFileInput();
      theme.fileDropArea();
      theme.formValidation();
      theme.multilevelDropdown();
      theme.smoothScroll();
      theme.scrollTopButton();
      theme.offcanvasSidebar();
      theme.tooltips();
      theme.popovers();
      theme.toasts();
      theme.disableDropdownAutohide();
      theme.carousel();
      theme.gallery();
      theme.productGallery();
      theme.imageZoom();
      theme.videoPopupBtn();
      theme.ajaxifySubscribeForm();
      theme.rangeSlider();
      theme.filterList();
      theme.dataFilter();
      theme.labelUpdate();
      theme.radioTabs();
      theme.countdown();
      theme.charts();
    },


    /**
     * Cascading (Masonry) grid layout
     * @memberof theme
     * @method masonryGrid
     * @requires https://github.com/desandro/imagesloaded
     * @requires https://github.com/Vestride/Shuffle
    */
    masonryGrid: () => {

      let grid = document.querySelectorAll('.cz-masonry-grid'),
          masonry;

      if (grid === null) return;
      
      for (let i = 0; i < grid.length; i++) {
        masonry = new Shuffle(grid[i], {
          itemSelector: '.grid-item',
          sizer: '.grid-item'
        });

        imagesLoaded(grid[i]).on('progress', () => {
          masonry.layout();
        });
      }
    },
    

    /**
     * Enable sticky behaviour of navigation bar on page scroll
     * @memberof theme
     * @method stickyNavbar
    */
    stickyNavbar: () => {

      let navbar = document.querySelector('.navbar-sticky');

      if (navbar == null) return;

      let navbarH = navbar.offsetHeight,
          scrollOffset = 400;

      window.addEventListener('scroll', (e) => {
        if (e.currentTarget.pageYOffset > scrollOffset) {
          if (! navbar.classList.contains('navbar-transparent')) {
            document.body.style.paddingTop = navbarH + 'px';
          }
          navbar.classList.add('navbar-stuck');
        } else {
          document.body.style.paddingTop = '';
          navbar.classList.remove('navbar-stuck');
        }
      });
    },


    /**
     * Stuck 3 level navbar menu toggle
     * @memberof theme
     * @method stuckNavbarMenuToggle
    */
    stuckNavbarMenuToggle: () => {

      let toggler = document.querySelector('.navbar-stuck-toggler'),
          stuckMenu = document.querySelector('.navbar-stuck-menu');

      if (toggler == null) return;

      toggler.addEventListener('click', function (e) {
        stuckMenu.classList.toggle('show');
        e.preventDefault();
      });

    },


    /**
     * Toggling password visibility in password input
     * @memberof theme
     * @method passwordVisibilityToggle
    */
    passwordVisibilityToggle: () => {

      let elements = document.querySelectorAll('.password-toggle');

      for (let i = 0; i < elements.length; i++) {
        let passInput = elements[i].querySelector('.form-control'),
        passToggle = elements[i].querySelector('.password-toggle-btn');
    
        passToggle.addEventListener('click', (e) => {
          
          if (e.target.type !== 'checkbox') return;
          if (e.target.checked) {
            passInput.type = 'text';
          } else {
            passInput.type = 'password';
          }

        }, false);
      }
    },


    /**
     * Custom file input
     * @memberof theme
     * @method customFileInput
     * @requires https://www.npmjs.com/package/bs-custom-file-input
    */
    customFileInput: () => {

      bsCustomFileInput.init();

    },


    /**
     * Custom file drag and drop area
     * @memberof theme
     * @method fileDropArea
    */
    fileDropArea: () => {

      let fileArea = document.querySelectorAll('.cz-file-drop-area');

      for (let i = 0; i < fileArea.length; i++) {
        let input = fileArea[i].querySelector('.cz-file-drop-input'),
            message = fileArea[i].querySelector('.cz-file-drop-message'),
            icon = fileArea[i].querySelector('.cz-file-drop-icon'),
            button = fileArea[i].querySelector('.cz-file-drop-btn');
        
        button.addEventListener('click', function() {
          input.click();
        });

        input.addEventListener('change', function() {
          if (input.files && input.files[0]) {
            let reader = new FileReader();
            reader.onload = (e) => {
              let fileData = e.target.result;
              let fileName = input.files[0].name;
              message.innerHTML = fileName;

              if (fileData.startsWith('data:image')) {

                let image = new Image();
                image.src = fileData;

                image.onload = function() {
                  icon.className = 'cz-file-drop-preview img-thumbnail rounded';
                  icon.innerHTML = '<img src="' + image.src + '" alt="' + fileName + '">'
                  console.log(this.width);
                }

              } else if (fileData.startsWith('data:video')) {
                icon.innerHTML = '';
                icon.className = '';
                icon.className = 'cz-file-drop-icon czi-video';

              } else {
                icon.innerHTML = '';
                icon.className = '';
                icon.className = 'cz-file-drop-icon czi-document';
              }
            }
            reader.readAsDataURL(input.files[0]);
          }

        });
      }
    },


    /**
     * From validation
     * @memberof theme
     * @method formValidation
    */
    formValidation: () => {

      let selector = 'needs-validation';

      window.addEventListener('load', () => {
        // Fetch all the forms we want to apply custom Bootstrap validation styles to
        let forms = document.getElementsByClassName(selector);
        // Loop over them and prevent submission
        let validation = Array.prototype.filter.call(forms, (form) => {
          form.addEventListener('submit', (e) => {
            if (form.checkValidity() === false) {
              e.preventDefault();
              e.stopPropagation();
            }
            form.classList.add('was-validated');
          }, false);
        });
      }, false);
    },


    /**
     * Multilevel dropdown
     * @memberof theme
     * @method multilevelDropdown
     * @requires https://jquery.com/
     * @requires https://getbootstrap.com
    */
    multilevelDropdown: function () {

      let selector = ".dropdown-menu [data-toggle='dropdown']";

      $(selector).on('click', function (e) {
        e.preventDefault();
        e.stopPropagation();

        $(this).siblings().toggleClass('show');

        if (!$(this).next().hasClass('show')) {
          $(this).parents('.dropdown-menu').first().find('.show').removeClass('show');
        }
        $(this).parents('li.nav-item.dropdown.show').on('hidden.bs.dropdown', function () {
          $('.dropdown-submenu .show').removeClass('show');
        });
      });
    },


    /**
     * Anchor smooth scrolling
     * @memberof theme
     * @method smoothScroll
     * @requires https://github.com/cferdinandi/smooth-scroll/
    */
    smoothScroll: () => {
      
      let selector = '[data-scroll]',
          fixedHeader = '[data-scroll-header]',
          scroll = new SmoothScroll(selector, {
            speed: 800,
            speedAsDuration: true,
            offset: 40,
            header: fixedHeader,
            updateURL: false
          });
    },


    /**
     * Animate scroll to top button in/off view
     * @memberof theme
     * @method scrollTopButton
    */
    scrollTopButton: () => {

      let element = document.querySelector('.btn-scroll-top'),
          scrollOffset = 600;
      
      if (element == null) return;

      let offsetFromTop = parseInt(scrollOffset, 10);
      
      window.addEventListener('scroll', (e) => {
        if (e.currentTarget.pageYOffset > offsetFromTop) {
          element.classList.add('show');
        } else {
          element.classList.remove('show');
        }
      });
    },


    /**
     * Off-canvas sidebar
     * @memberof theme
     * @method offcanvasSidebar
    */
    offcanvasSidebar: () => {

      let openTogglers = document.querySelectorAll('[data-toggle="sidebar"]'),
          closeTogglers = document.querySelectorAll('[data-dismiss="sidebar"]'),
          body = document.querySelector('body');

      for (let i = 0; i < openTogglers.length; i++) {
        openTogglers[i].addEventListener('click', (e) => {
          e.preventDefault();
          let sidebarID = e.currentTarget.getAttribute('href');
          document.querySelector(sidebarID).classList.add('show');
          body.classList.add('offcanvas-open');
        });
      }
      
      for (let i = 0; i < closeTogglers.length; i++) {
        closeTogglers[i].addEventListener('click', (e) => {
          e.currentTarget.closest('.cz-sidebar').classList.remove('show');
          body.classList.remove('offcanvas-open');
        });
      }
    },


    /**
     * Tooltips
     * @memberof theme
     * @method tooltips
     * @requires https://jquery.com/
     * @requires https://getbootstrap.com
     * @requires https://popper.js.org/
    */
    tooltips: () => {

      let selector = $('[data-toggle="tooltip"]');

      selector.tooltip();
    },


    /**
     * Popovers
     * @memberof theme
     * @method popovers
     * @requires https://jquery.com/
     * @requires https://getbootstrap.com
     * @requires https://popper.js.org/
    */
    popovers: () => {

      let selector = $('[data-toggle="popover"]');

      selector.popover();
    },


    /**
     * Toasts
     * @param {string} selector
    */
    toasts: () => {

      let selector = $('[data-toggle="toast"]');

      selector.on('click', function() {
        var target = $(this).data('target');
        $(target).toast('show');
      });
    },


    /**
     * Disable dropdown autohide when select is clicked
     * @memberof theme
     * @method disableDropdownAutohide
    */
    disableDropdownAutohide: () => {

      let elements = document.querySelectorAll('.disable-autohide .custom-select');

      for (let i = 0; i < elements.length; i++) {
        elements[i].addEventListener('click', (e)=> {
          e.stopPropagation();
        });
      }
    },


    /**
     * Content carousel with extensive options to control behaviour and appearance
     * @memberof theme
     * @method carousel
     * @requires https://github.com/ganlanyuan/tiny-slider
    */
    carousel: () => {

      // forEach function
      let forEach = function (array, callback, scope) {
        for (let i = 0; i < array.length; i++) {
          callback.call(scope, i, array[i]); // passes back stuff we need
        }
      };
      
      // Carousel initialisation
      let carousels = document.querySelectorAll('.cz-carousel .cz-carousel-inner');
      forEach(carousels, function (index, value) {
        let defaults = {
          container: value,
          controlsText: ['<i class="czi-arrow-left"></i>', '<i class="czi-arrow-right"></i>'],
          navPosition: 'bottom',
          mouseDrag: true,
          speed: 500,
          autoplayHoverPause: true,
          autoplayButtonOutput: false
        };
        let userOptions;
        if(value.dataset.carouselOptions != undefined) userOptions = JSON.parse(value.dataset.carouselOptions);
        let options = {...defaults, ...userOptions};
        let carousel = tns(options);
      });
    },


    /**
     * Lightbox component for presenting various types of media
     * @memberof theme
     * @method gallery
     * @requires https://github.com/sachinchoolur/lightgallery.js
    */
    gallery: () => {

      let gallery = document.querySelectorAll('.cz-gallery');
      if (gallery.length) {
        for (let i = 0; i < gallery.length; i++) {
          lightGallery(gallery[i], {
            selector: '.gallery-item',
            download: false,
            videojs: true,
            youtubePlayerParams: {
              modestbranding: 1,
              showinfo: 0,
              rel: 0,
              controls: 0
            },
            vimeoPlayerParams: {
              byline: 0,
              portrait: 0,
              color: 'fe696a'
            }
          });
        }
      }
    },


    /**
     * Shop product page gallery with thumbnails
     * @memberof theme
     * @method productGallery
     * @requires https://github.com/sachinchoolur/lightgallery.js
    */
    productGallery: () => {

      let gallery = document.querySelectorAll('.cz-product-gallery');
      if (gallery.length) {

        for (let i = 0; i < gallery.length; i++) {
          
          let thumbnails = gallery[i].querySelectorAll('.cz-thumblist-item:not(.video-item)'),
              previews = gallery[i].querySelectorAll('.cz-preview-item'),
              videos = gallery[i].querySelectorAll('.cz-thumblist-item.video-item');


          for (let n = 0; n < thumbnails.length; n++) {
            thumbnails[n].addEventListener('click', changePreview);
          }

          // Changer preview function
          function changePreview(e) {
            e.preventDefault();
            for (let i = 0; i < thumbnails.length; i++) {
              previews[i].classList.remove('active');
              thumbnails[i].classList.remove('active');
            }
            this.classList.add('active');
            gallery[i].querySelector(this.getAttribute('href')).classList.add('active');
          }

          // Video thumbnail - open video in lightbox
          for (let m = 0; m < videos.length; m++) {
            lightGallery(videos[m], {
              selector: 'this',
              download: false,
              videojs: true,
              youtubePlayerParams: {
                modestbranding: 1,
                showinfo: 0,
                rel: 0,
                controls: 0
              },
              vimeoPlayerParams: {
                byline: 0,
                portrait: 0,
                color: 'fe696a'
              }
            });
          }
        }
      }
    },


    /**
     * Image zoom on hover (used inside Product Gallery)
     * @memberof theme
     * @method imageZoom
     * @requires https://github.com/imgix/drift
    */
    imageZoom: () => {
      
      let images = document.querySelectorAll('.cz-image-zoom');

      for (let i = 0; i < images.length; i++) {
        new Drift(images[i], {
          paneContainer: images[i].parentElement.querySelector('.cz-image-zoom-pane')
        });
      }
    },


    /**
     * Open YouTube / Vimeo video in lightbox
     * @memberof theme
     * @method videoPopupBtn
     * @requires https://github.com/sachinchoolur/lightgallery.js
    */
    videoPopupBtn: () => {

      let button = document.querySelectorAll('.video-popup-btn');
      if (button.length) {
        for (let i = 0; i < button.length; i++) {
          lightGallery(button[i], {
            selector: 'this',
            download: false,
            videojs: true,
            youtubePlayerParams: {
              modestbranding: 1,
              showinfo: 0,
              rel: 0,
              controls: 0
            },
            vimeoPlayerParams: {
              byline: 0,
              portrait: 0,
              color: 'fe696a'
            }
          });
        }
      }
    },


    /**
     * Ajaxify subscription form (MailChimp)
     * @memberof theme
     * @method ajaxifySubscribeForm
     * @requires https://jquery.com/
    */
    ajaxifySubscribeForm: () => {

      let $form = $('#mc-embedded-subscribe-form'),
          $input = $('#mce-EMAIL'),
          $button = $('#mc-embedded-subscribe'),
          $status = $('.subscribe-status'),
          buttonInitText = $button.text(),
          input = $button.text();

      if($form.length) {
        $button.bind('click', function(event) {
          if(event) event.preventDefault();
          register($form);
        });
      }

      function register($form) {
        $button.text('Sending...');
        $.ajax({
          type: $form.attr('method'),
          url: $form.attr('action'),
          data: $form.serialize(),
          cache: false,
          dataType: 'jsonp',
          contentType: 'application/json; charset=utf-8',
          error: function (err) { alert('Could not connect to the registration server. Please try again later.') },
          success: function (data) {
            if(data.result === 'success') {
              $status.removeClass('status-error').addClass('status-success').text('Thank you for subscribing. We have sent you a confirmation email.')
              $button.text(buttonInitText, setTimeout(function() {
                $status.removeClass('status-success').text('');
              }, 5000));
              $input.val('');
            } else {
              $status.removeClass('status-success').addClass('status-error').text(data.msg.substring(4));
              $button.text(buttonInitText, setTimeout(function() {
                $status.removeClass('status-error').text('');
              }, 5000));
            }
          }
        });
      };
    },


    /**
     * Range slider
     * @memberof theme
     * @method rangeSlider
     * @requires https://github.com/leongersen/noUiSlider
    */
    rangeSlider: () => {

      let rangeSliderWidget = document.querySelectorAll('.cz-range-slider');

      for (let i = 0; i < rangeSliderWidget.length; i++) {

        let rangeSlider = rangeSliderWidget[i].querySelector('.cz-range-slider-ui'),
            valueMinInput = rangeSliderWidget[i].querySelector('.cz-range-slider-value-min'),
            valueMaxInput = rangeSliderWidget[i].querySelector('.cz-range-slider-value-max');

        let options = {
          dataStartMin: parseInt(rangeSliderWidget[i].dataset.startMin, 10),
          dataStartMax: parseInt(rangeSliderWidget[i].dataset.startMax, 10),
          dataMin: parseInt(rangeSliderWidget[i].dataset.min, 10),
          dataMax: parseInt(rangeSliderWidget[i].dataset.max, 10),
          dataStep: parseInt(rangeSliderWidget[i].dataset.step, 10)
        }

        noUiSlider.create(rangeSlider, {
          start: [options.dataStartMin, options.dataStartMax],
          connect: true,
          step: options.dataStep,
          pips: {mode: 'count', values: 5},
          tooltips: true,
          range: {
            'min': options.dataMin,
            'max': options.dataMax
          },
          format: {
            to: function (value) {
              return '$' + parseInt(value, 10);
            },
            from: function (value) {
              return Number(value);
            }
          }
        });

        rangeSlider.noUiSlider.on('update', (values, handle) => {
          let value = values[handle];
          value = value.replace(/\D/g,'');
          if (handle) {
            valueMaxInput.value = Math.round(value);
          } else {
            valueMinInput.value = Math.round(value);
          }
        });
        
        valueMinInput.addEventListener('change', function() {
          rangeSlider.noUiSlider.set([this.value, null]);
        });
        
        valueMaxInput.addEventListener('change', function() {
          rangeSlider.noUiSlider.set([null, this.value]);
        });
        
      }

    },


    /**
     * Filter list of items by typing in the search field
     * @memberof theme
     * @method filterList
    */
    filterList: () => {

      let filterListWidget = document.querySelectorAll('.cz-filter')

      for (let i = 0; i < filterListWidget.length; i++) {
        
        let filterInput = filterListWidget[i].querySelector('.cz-filter-search'),
            filterList = filterListWidget[i].querySelector('.cz-filter-list'),
            filterItems = filterList.querySelectorAll('.cz-filter-item');

        filterInput.addEventListener('keyup', filterListFunc);
        
        function filterListFunc() {
          
          let filterValue = filterInput.value.toLowerCase();
          
          for (let i = 0; i < filterItems.length; i++) {

            let filterText = filterItems[i].querySelector('.cz-filter-item-text').innerHTML;

            if(filterText.toLowerCase().indexOf(filterValue) > -1) {
              filterItems[i].classList.remove('d-none');
            } else {
              filterItems[i].classList.add('d-none');
            }

          }
          
        }
      }
    },


    /**
     * Data filtering (Comparison table)
     * @memberof theme
     * @method dataFilter
    */
    dataFilter: () => {

      let trigger = document.querySelector('[data-filter="trigger"]'),
          target = document.querySelectorAll('[data-filter="target"]');

      if (trigger === null) { return; }
      
      trigger.addEventListener('change', function() {
        let selected = this.options[this.selectedIndex].value.toLowerCase();
        if (selected === 'all') {
          for (let i = 0; i < target.length; i++) {
            target[i].classList.remove('d-none');
          }
        } else {
          for (let n = 0; n < target.length; n++) {
            target[n].classList.add('d-none');
          }
          document.querySelector('#' + selected).classList.remove('d-none');
        }
      });
    },


    /**
     * Updated the text of the label when radio button changes (mainly for color options)
     * @memberof theme
     * @method labelUpdate
    */
    labelUpdate: () => {

      let radioBtns = document.querySelectorAll('[data-label]');

      for (let i = 0; i < radioBtns.length; i++ ) {
        radioBtns[i].addEventListener('change', function() {
          let target = this.dataset.label;
          try {
            document.getElementById(target).textContent = this.value;
          }
          catch(err) {
            if (err.message = "Cannot set property 'textContent' of null") {
              console.error('Make sure the [data-label] matches with the id of the target element you want to change text of!');
            }
          }
        });
      }
    },


    /**
     * Change tabs with radio buttons
     * @memberof theme
     * @method radioTabs
    */
    radioTabs: () => {

      let radioBtns = document.querySelectorAll('[data-toggle="radioTab"]');

      for (let i = 0; i < radioBtns.length; i++ ) {
        radioBtns[i].addEventListener('click', function() {
          let target = this.dataset.target,
              parent = document.querySelector(this.dataset.parent),
              children = parent.querySelectorAll('.radio-tab-pane');

          children.forEach(function(element) {
            element.classList.remove('active');
          });

          document.querySelector(target).classList.add('active');
        });
      }
    },


    /**
     * Countdown Timer
     * @memberof theme
     * @method countdown
    */
    countdown: () => {

      let coundown = document.querySelectorAll('.cz-countdown');

      if (coundown == null) return;

      for (let i = 0; i < coundown.length; i++) {

        let endDate = coundown[i].dataset.countdown,
            daysVal = coundown[i].querySelector('.cz-countdown-days .cz-countdown-value'),
            hoursVal = coundown[i].querySelector('.cz-countdown-hours .cz-countdown-value'),
            minutesVal = coundown[i].querySelector('.cz-countdown-minutes .cz-countdown-value'),
            secondsVal = coundown[i].querySelector('.cz-countdown-seconds .cz-countdown-value'),
            days, hours, minutes, seconds;
        
        endDate = new Date(endDate).getTime();

        if (isNaN(endDate)) return;

        setInterval(calculate, 1000);

        function calculate() {
          let startDate = new Date().getTime();
          
          let timeRemaining = parseInt((endDate - startDate) / 1000);
          
          if (timeRemaining >= 0) {
            days = parseInt(timeRemaining / 86400);
            timeRemaining = (timeRemaining % 86400);
            
            hours = parseInt(timeRemaining / 3600);
            timeRemaining = (timeRemaining % 3600);
            
            minutes = parseInt(timeRemaining / 60);
            timeRemaining = (timeRemaining % 60);
            
            seconds = parseInt(timeRemaining);
            
            if (daysVal != null) {
              daysVal.innerHTML = parseInt(days, 10);
            }
            if (hoursVal != null) {
              hoursVal.innerHTML = hours < 10 ? '0' + hours : hours;
            }
            if (minutesVal != null) {
              minutesVal.innerHTML = minutes < 10 ? '0' + minutes : minutes;
            }
            if (secondsVal != null) {
              secondsVal.innerHTML = seconds < 10 ? '0' + seconds : seconds;
            }
            
          } else {
            return;
          }
        }
      }
    },


    /**
     * Charts
     * @memberof theme
     * @method charts
     * @requires https://github.com/gionkunz/chartist-js
    */
    charts: () => {

      let lineChart = document.querySelectorAll('[data-line-chart]'),
          barChart = document.querySelectorAll('[data-bar-chart]'),
          pieChart = document.querySelectorAll('[data-pie-chart]');

      let sum = function(a, b) { return a + b };

      if (lineChart.length === 0 && barChart.length === 0 && pieChart.length === 0) return;

      // Create <style> tag and put it to <head> for changing colors of charts via data attributes
      let head = document.head || document.getElementsByTagName('head')[0],
          style = document.createElement('style'),
          css;
      head.appendChild(style);


      // Line chart
      for (let i = 0; i < lineChart.length; i++) {

        let data = JSON.parse(lineChart[i].dataset.lineChart),
            options = (lineChart[i].dataset.options != undefined) ? JSON.parse(lineChart[i].dataset.options) : '',
            seriesColor = lineChart[i].dataset.seriesColor,
            userColors;
                
        lineChart[i].classList.add('cz-line-chart-' + i);

        if (seriesColor != undefined) {

          userColors = JSON.parse(seriesColor);

          for (let n = 0; n < userColors.colors.length; n++) {
            css = `
              .cz-line-chart-${i} .ct-series:nth-child(${n+1}) .ct-line,
              .cz-line-chart-${i} .ct-series:nth-child(${n+1}) .ct-point {
                stroke: ${userColors.colors[n]} !important;
              }
            `;
            style.appendChild(document.createTextNode(css));
          }
        }
        
        new Chartist.Line(lineChart[i], data, options);
      }


      // Bar chart
      for (let i = 0; i < barChart.length; i++) {

        let data = JSON.parse(barChart[i].dataset.barChart),
            options = (barChart[i].dataset.options != undefined) ? JSON.parse(barChart[i].dataset.options) : '',
            seriesColor = barChart[i].dataset.seriesColor,
            userColors;
        
        barChart[i].classList.add('cz-bar-chart-' + i);

        if (seriesColor != undefined) {

          userColors = JSON.parse(seriesColor);

          for (let n = 0; n < userColors.colors.length; n++) {
            css = `
            .cz-bar-chart-${i} .ct-series:nth-child(${n+1}) .ct-bar {
                stroke: ${userColors.colors[n]} !important;
              }
            `;
            style.appendChild(document.createTextNode(css));
          }
        }
        
        new Chartist.Bar(barChart[i], data, options);
      }


      // Pie chart
      for (let i = 0; i < pieChart.length; i++) {

        let data = JSON.parse(pieChart[i].dataset.pieChart),
            seriesColor = pieChart[i].dataset.seriesColor,
            userColors;
        
        pieChart[i].classList.add('cz-pie-chart-' + i);

        if (seriesColor != undefined) {

          userColors = JSON.parse(seriesColor);

          for (let n = 0; n < userColors.colors.length; n++) {
            css = `
            .cz-pie-chart-${i} .ct-series:nth-child(${n+1}) .ct-slice-pie {
                fill: ${userColors.colors[n]} !important;
              }
            `;
            style.appendChild(document.createTextNode(css));
          }
        }
        
        new Chartist.Pie(pieChart[i], data, {
          labelInterpolationFnc: function(value) {
            return Math.round(value / data.series.reduce(sum) * 100) + '%';
          }
        });
      }
    }

  }

  /**
   * Init theme core
  */
  
  theme.init();

})(jQuery);
