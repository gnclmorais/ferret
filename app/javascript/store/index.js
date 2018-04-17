import Vue from 'vue'
import Vuex from 'vuex'
Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    currentUser: {},
    id: '',
    loggedIn: false,
  },
  mutations: {
    logIn(state, newCurrentUser) {
      if (!newCurrentUser) return;

      state.id = newCurrentUser.id
      state.currentUser = newCurrentUser

      state.loggedIn = true;
      console.log('loggedIn:', state.loggedIn)
      console.log('loggedIn:', state.loggedIn)
    },
    logOut(state) {
      state.currentUser = null;
    },
  },
  // actions: {
  //   logIn(state, newCurrentUser) {
  //     state.id = newCurrentUser.id
  //     state.currentUser = newCurrentUser
  //     console.log('New user:', state.currentUser)
  //   },
  // },
  getters: {
    id(state) {
      return !!state.currentUser.id
    },
    isLoggedIn(state) {
      return Object.keys(state.currentUser).length > 0
    },
  },
})
