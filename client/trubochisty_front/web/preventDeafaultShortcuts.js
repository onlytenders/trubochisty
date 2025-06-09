
    window.addEventListener('keydown', function(e) {
      // Only prevent if the target is the document body (not input fields)
      if (event.target == document.body) {
        // Prevent going back to the previous page with Backspace
        if (event.key == 'Backspace') {
        event.preventDefault();
        }
      }

    // Prevent specific Ctrl/Cmd combinations used by our app
    if ((event.metaKey || event.ctrlKey) && event.key.toLowerCase() in ['n', 'f', 'd', '=']) {
        event.preventDefault();
      }
    });
