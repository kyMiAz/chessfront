<template>
<div id="app">
  <Chess/>
</div>
</template>

<script>
import Chess from './components/Chess.vue'
export default {
  name: 'App',
  components: {
    Chess
  }
}

</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  margin-top: 30px;
}
</style>
