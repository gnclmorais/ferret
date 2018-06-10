import Vue from 'vue';

const updatePin = (id, newName) => {
  console.log('Pin > ID:', id);
  console.log('Pin > new name:', newName);

  Vue.http.patch(`/pins/${id}`, {
    pin: { id: id, name: newName, }
  }).then(success => {
    console.log('success', success);
    return;

  }, failure => {
    switch (failure.status) {
      case 409:
        // TODO
        console.log('error 409 while tagging a pin')
        break;
      default:
        // TODO
        console.log('error while tagging a pin')
        break;
    }
  });
};

export { updatePin };
