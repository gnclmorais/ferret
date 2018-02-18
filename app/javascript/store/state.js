export default function (store) {
  const stateEl = document.getElementById('state')
  const currentUser = JSON.parse(stateEl.getAttribute('current_user'))

  store.commit('logIn', currentUser)

  return store
}
