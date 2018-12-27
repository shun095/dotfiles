<!-- 
{{_expr_:strftime('%Y-%m-%d')}} {{_name_}}.vue
Copyright © {{_expr_:strftime('%Y')}} ishitaku5522
Distributed under terms of the MIT license.
-->

<template>
  {{_cursor_}}<p>{{ greeting }} World!</p>
</template>

<script>
module.exports = {
  data: function () {
    return {
      greeting: 'Hello'
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
