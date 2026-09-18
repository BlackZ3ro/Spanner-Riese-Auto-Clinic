// Please see documentation at https://learn.microsoft.com/aspnet/core/client-side/bundling-and-minification
// for details on configuring this project to bundle and minify static web assets.

// Disable submit buttons right after a form is submitted, site-wide - cheap
// insurance against a double-click firing two requests (e.g. adding the same
// part twice) before the page reloads. setTimeout(0) lets the browser finish
// serializing which button triggered the submit before we disable it.
//
// defaultPrevented skips this when a form's own onsubmit (e.g. Finalize's
// confirm() dialog) cancelled the submission - the 'submit' event still
// bubbles to document even when prevented, so without this check clicking
// Cancel on that dialog permanently disabled the button with no request ever
// sent and no page reload to re-enable it. A review finding, not live testing.
document.addEventListener("submit", function (e) {
    var form = e.target;
    if (!(form instanceof HTMLFormElement)) return;
    if (e.defaultPrevented) return;
    form.querySelectorAll('button[type="submit"], input[type="submit"]').forEach(function (btn) {
        setTimeout(function () { btn.disabled = true; }, 0);
    });
});
