<template lang="haml">
  %p {{ message }}
</template>

<script>
export default {
  data: function () {
    return {
      message: "Hello Vue and goodbye Paloma!"
    }
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
