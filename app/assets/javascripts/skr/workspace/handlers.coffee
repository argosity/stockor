$( document ).ready ->
  $('.sidebar-toggle').click( ->
    $(document.body).cycleClass(['sidebar-wide', 'sidebar-narrow', 'sidebar-hidden' ]);
  );
#  $('.sidebar-content .navigation > li ul .expand').collapsible({

  $('.sidebar li:not(.disabled) .expand, .sidebar .navigation > li ul .expand').collapsible({
    defaultOpen: 'second-level, third-level',
    cssOpen: 'level-opened',
    cssClose: 'level-closed',
    speed: 150
  });

  $('.toggle-me').click ->
    $('#foo').toggleClass( 'one two three' )
    $('#foo').html $('#foo').attr('class');
