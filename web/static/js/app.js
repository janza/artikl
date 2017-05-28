const btns = document.querySelectorAll('.js-delete-article')
for (let el of btns) {
  el.addEventListener('click', e => {
    e.preventDefault()
    const url = e.target.href
    return window
      .fetch(url, {
        method: 'delete'
      })
      .then(response => window.location.reload())
      .catch(() => {
        window.location.reload()
      })
  })
}
