import Vue from 'vue'
import Vuex from 'vuex'
Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    currentUser: null,
  },
  getters: {
    isLoggedIn() {
      return state.currentUser !== null
    },
  },
  mutations: {
    logIn(state, currentUser) {
      state.currentUser = currentUser
    },
    logOut(state) {
      state.currentUser = null
    },
  },
})
