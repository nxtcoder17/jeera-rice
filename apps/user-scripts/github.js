// ==UserScript==
// @name         github wide-screen

// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  make github wide, no container class
// @author       nxtcoder17
// @match        https://github.com/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=github.com
// @grant        none
// ==/UserScript==


function removeContainerClasses() {
  const elems = document.querySelectorAll('[class*="container-"]');
  elems.forEach(item => {
    [...item.classList.values()]
      .filter(cl => cl.startsWith("container-"))
      .forEach(cl => item.classList.remove(cl))
  })
}

const observer = new MutationObserver(removeContainerClasses)

observer.observe(document.body, {
  subtree: true,
  childList: true,
})

return observer;
