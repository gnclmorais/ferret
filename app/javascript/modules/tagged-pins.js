import Vue from 'vue';

const postTaggedPin = (context, tag_name, pin_id) => {
  console.log('tag:', tag_name);
  console.log('pin:', pin_id);

  Vue.http.post('/tagged_pins', {
    tagged_pin: { tag_name, pin_id },
  }).then(success => {
    const newTag = success.body;
    console.log('new tag:', newTag);

    const i = context.place.tagged_pins.findIndex(tag => tag.name === newTag.name);
    console.log('found tag at ' + i)
    context.$set(context.place.tagged_pins, i, newTag);

    // TODO
    console.log('success tagging a pin', success)
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

const deleteTaggedPin = (id, name) => {
  if (!id) {
    console.log('That’s not right, we need an Id for TaggedPin');
    return;
  }

  Vue.http.delete(`/tagged_pins/${id}`).then(success => {
    // TODO
    console.log('deleted a tag on a pin')
  }, failure => {
    switch (failure.status) {
      case 409:
        // TODO
        console.log('error 409 while deleting a tag on a pin');
        break;
      default:
        // TODO
        console.log('error while deleting a tag on a pin');
        break;
    }
  });
};

export { postTaggedPin, deleteTaggedPin };
