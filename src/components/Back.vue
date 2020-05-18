<template>
  <q-btn color="red" icon="arrow_back" size="18px" @click="back()"> 返回</q-btn>
</template>
<script>
export default {
  methods: {
    back() {
      history.back(1);
    }
  }
};
</script>
